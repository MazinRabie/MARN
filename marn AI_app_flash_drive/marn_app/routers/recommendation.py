from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from typing import Optional, List, Dict, Any
import uuid
import json

from db.engine import get_db
from db.models import User, UserInteraction, Favorite, Booking, Listing, UserActivity, MarnProperty
from agent import get_recommendation_service

router = APIRouter(tags=["recommendations"])

# ─── Requests ───

class RecordInteractionRequest(BaseModel):
    userId: str
    unified_id: str
    listing_id: Optional[str] = None
    interaction_type: str = "view"
    interaction_metadata: Optional[Dict[str, Any]] = None

class RecommendForYouRequest(BaseModel):
    userId: str

class SimilarListingsRequest(BaseModel):
    userId: str
    unified_id: str
    top_k: int = 5

class AddListingRequest(BaseModel):
    propertyId: str  # DB Listing UUID

class RemoveListingRequest(BaseModel):
    propertyId: str  # DB Listing UUID

class UpdateListingRequest(BaseModel):
    propertyId: str  # DB Listing UUID

# ─── Responses ───

class RecommendedApartment(BaseModel):
    unified_id: str
    type: str
    price: float
    area: float
    bedrooms: int
    bathrooms: int
    city: str
    region: str
    furnished: str
    lat: Optional[float] = None
    lng: Optional[float] = None
    score: float

class RecommendationResponse(BaseModel):
    recommendations: List[RecommendedApartment]
    count: int
    source: str

class FiltersResponse(BaseModel):
    cities: List[str]
    types: List[str]

class IndexStatusResponse(BaseModel):
    status: str
    total_listings: int
    index_size: int

# ─── Endpoints ───

@router.post("/recommendations/for-you", response_model=List[str])
async def get_for_you(
    req: RecommendForYouRequest,
    top_k: int = 8,
    history_depth: int = 50,
    db: Session = Depends(get_db)
):
    service = get_recommendation_service()
    
    # Fetch interactions from DB
    interactions_db = db.query(UserInteraction).filter(
        UserInteraction.user_id == req.userId
    ).order_by(UserInteraction.created_at.desc()).limit(history_depth).all()
    
    if not interactions_db:
        return []
        
    interactions = [
        {
            "unified_id": i.unified_id,
            "interaction_type": i.interaction_type,
            "created_at": i.created_at
        } for i in interactions_db 
    ]
    
    # Behavior based
    results = service.recommend_for_user(interactions, top_k=top_k)
        
    return [str(r.get('unified_id', '')) for r in results if r.get('unified_id')]

@router.post("/recommendations/similar", response_model=RecommendationResponse)
async def get_similar(
    req: SimilarListingsRequest,
    db: Session = Depends(get_db)
):
    service = get_recommendation_service()
    results = service.get_similar_listings(req.unified_id, top_k=req.top_k)
    
    # Auto-record view interaction
    try:
        user_uuid = uuid.UUID(req.userId)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid userId format (must be UUID)")

    new_inter = UserInteraction(
        user_id=user_uuid,
        unified_id=req.unified_id,
        interaction_type="view"
    )
    db.add(new_inter)
    db.commit()
    
    formatted = []
    for r in results:
        formatted.append(RecommendedApartment(**r))
        
    return RecommendationResponse(
        recommendations=formatted,
        count=len(formatted),
        source="similar"
    )

@router.post("/interactions")
async def record_interaction(
    req: RecordInteractionRequest,
    db: Session = Depends(get_db)
):
    try:
        user_uuid = uuid.UUID(req.userId)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid userId format (must be UUID)")

    listing_uuid = None
    if req.listing_id:
        try:
            listing_uuid = uuid.UUID(req.listing_id)
        except ValueError:
            pass
            
    interaction = UserInteraction(
        user_id=user_uuid,
        unified_id=req.unified_id,
        listing_id=listing_uuid,
        interaction_type=req.interaction_type,
        interaction_metadata=json.dumps(req.interaction_metadata) if req.interaction_metadata else None
    )
    db.add(interaction)
    db.commit()
    return {"status": "ok", "interaction_id": str(interaction.id)}

@router.get("/recommendations/filters", response_model=FiltersResponse)
async def get_filters():
    from data_loader import get_data_bundle
    bundle = get_data_bundle()
    return FiltersResponse(
        cities=bundle.unique_cities,
        types=bundle.unique_types
    )

def _listing_to_faiss_data(listing: Listing) -> dict:
    """Convert a DB Listing row into the dict format expected by the FAISS engine."""
    return {
        "unified_id": str(listing.id),
        "title": listing.title or "",
        "price": float(listing.price),
        "area": float(listing.area),
        "bedrooms": int(listing.bedrooms),
        "bathrooms": int(listing.bathrooms),
        "lat": 0.0,   # DB Listing model does not store lat/lng; default to 0
        "lng": 0.0,
        "city": listing.city or "",
        "region": listing.region or "",
        "type": listing.property_type or "apartment",
        "furnished": "yes" if listing.furnished else "no",
    }


@router.post("/index/add-listing")
async def add_listing(
    req: AddListingRequest,
    db: Session = Depends(get_db)
):
    """Add a listing to the FAISS index by its database propertyId."""
    try:
        listing_uuid = uuid.UUID(req.propertyId)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid propertyId format (must be UUID)")

    listing = db.query(Listing).filter(Listing.id == listing_uuid).first()
    if not listing:
        raise HTTPException(status_code=404, detail=f"Listing {req.propertyId} not found in database")

    service = get_recommendation_service()
    listing_data = _listing_to_faiss_data(listing)
    faiss_id = service.add_listing(listing_data)

    return {
        "status": "added",
        "propertyId": req.propertyId,
        "faiss_id": faiss_id,
        "index_size": service.faiss_index.ntotal if service.faiss_index else 0
    }


@router.post("/index/remove-listing")
async def remove_listing(
    req: RemoveListingRequest,
):
    """Remove a listing from the FAISS index by its database propertyId."""
    service = get_recommendation_service()
    unified_id = str(req.propertyId)

    removed = service.remove_listing(unified_id)
    if not removed:
        raise HTTPException(
            status_code=404,
            detail=f"Listing {req.propertyId} not found in FAISS index"
        )

    return {
        "status": "removed",
        "propertyId": req.propertyId,
        "index_size": service.faiss_index.ntotal if service.faiss_index else 0
    }


@router.post("/index/update-listing")
async def update_listing(
    req: UpdateListingRequest,
    db: Session = Depends(get_db)
):
    """Update a listing in the FAISS index: remove old vector, re-add with fresh DB data."""
    try:
        listing_uuid = uuid.UUID(req.propertyId)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid propertyId format (must be UUID)")

    listing = db.query(Listing).filter(Listing.id == listing_uuid).first()
    if not listing:
        raise HTTPException(status_code=404, detail=f"Listing {req.propertyId} not found in database")

    service = get_recommendation_service()
    listing_data = _listing_to_faiss_data(listing)
    unified_id = str(req.propertyId)

    try:
        faiss_id = service.update_listing(unified_id, listing_data)
    except ValueError:
        raise HTTPException(
            status_code=404,
            detail=f"Listing {req.propertyId} not found in FAISS index (cannot update)"
        )

    return {
        "status": "updated",
        "propertyId": req.propertyId,
        "faiss_id": faiss_id,
        "index_size": service.faiss_index.ntotal if service.faiss_index else 0
    }


@router.get("/index/status")
async def index_status():
    """Return the current FAISS index status (diagnostic)."""
    service = get_recommendation_service()
    return {
        "status": "ok",
        "total_vectors": service.faiss_index.ntotal if service.faiss_index else 0,
        "total_listings_in_df": len(service.df) if service.df is not None else 0,
        "id_mappings_count": len(service.unified_id_to_faiss_id)
    }


@router.post("/index/rebuild")
async def rebuild_index():
    from data_loader import load_data
    bundle = load_data()
    service = get_recommendation_service()
    service.initialize_from_bundle(bundle)
    return {
        "status": "rebuilt",
        "total_listings": len(service.df) if service.df is not None else 0,
        "index_size": service.faiss_index.ntotal if service.faiss_index else 0
    }

# ─── Ngrok Endpoints for MARN API ───

ngrok_router = APIRouter(tags=["ngrok_endpoints"])

class NgrokRecommendRequest(BaseModel):
    userId: str

class NgrokAddListingRequest(BaseModel):
    propertyId: int

class NgrokUpdateListingRequest(BaseModel):
    propertyId: int

class NgrokRemoveListingRequest(BaseModel):
    propertyId: int

@ngrok_router.post("/recommend", response_model=List[int])
async def ngrok_recommend(req: NgrokRecommendRequest, db: Session = Depends(get_db)):
    service = get_recommendation_service()
    try:
        user_uuid = uuid.UUID(req.userId)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid userId format (must be UUID)")
        
    activities = db.query(UserActivity).filter(
        UserActivity.user_id == user_uuid
    ).order_by(UserActivity.created_at.desc()).limit(50).all()
    
    if not activities:
        return []
        
    results = service.recommend_for_user_activities(activities, top_k=8)
    return results

@ngrok_router.post("/add")
async def ngrok_add(req: NgrokAddListingRequest, db: Session = Depends(get_db)):
    property = db.query(MarnProperty).filter(MarnProperty.id == req.propertyId).first()
    if not property:
        raise HTTPException(status_code=404, detail=f"Listing {req.propertyId} not found in database")
        
    PROPERTY_TYPE_MAP = {0: "apartment", 1: "house", 2: "room", 3: "villa", 4: "studio", 5: "sharedroom"}
    
    listing_data = {
        "unified_id": str(property.id),
        "property_id": property.id,
        "price": float(property.price) if property.price else 0.0,
        "area": float(property.square_meters) if property.square_meters else 0.0,
        "bedrooms": property.bedrooms,
        "bathrooms": property.bathrooms,
        "beds": property.beds,
        "lat": float(property.latitude) if property.latitude else 0.0,
        "lng": float(property.longitude) if property.longitude else 0.0,
        "city": property.city,
        "region": property.state,
        "type": PROPERTY_TYPE_MAP.get(property.type, "apartment"),
        "title": property.title,
        "is_shared": bool(property.is_shared),
        "max_occupants": property.max_occupants
    }
    
    service = get_recommendation_service()
    service.add_listing(listing_data)
    
    return {"status": "added", "propertyId": req.propertyId}

@ngrok_router.post("/update")
async def ngrok_update(req: NgrokUpdateListingRequest, db: Session = Depends(get_db)):
    property = db.query(MarnProperty).filter(MarnProperty.id == req.propertyId).first()
    if not property:
        raise HTTPException(status_code=404, detail=f"Listing {req.propertyId} not found in database")
        
    PROPERTY_TYPE_MAP = {0: "apartment", 1: "house", 2: "room", 3: "villa", 4: "studio", 5: "sharedroom"}
    
    listing_data = {
        "unified_id": str(property.id),
        "property_id": property.id,
        "price": float(property.price) if property.price else 0.0,
        "area": float(property.square_meters) if property.square_meters else 0.0,
        "bedrooms": property.bedrooms,
        "bathrooms": property.bathrooms,
        "beds": property.beds,
        "lat": float(property.latitude) if property.latitude else 0.0,
        "lng": float(property.longitude) if property.longitude else 0.0,
        "city": property.city,
        "region": property.state,
        "type": PROPERTY_TYPE_MAP.get(property.type, "apartment"),
        "title": property.title,
        "is_shared": bool(property.is_shared),
        "max_occupants": property.max_occupants
    }
    
    service = get_recommendation_service()
    try:
        service.update_listing_by_property_id(req.propertyId, listing_data)
    except ValueError:
        raise HTTPException(status_code=404, detail=f"Listing {req.propertyId} not found in FAISS index (cannot update)")
        
    return {"status": "updated", "propertyId": req.propertyId}

@ngrok_router.post("/delete")
async def ngrok_delete(req: NgrokRemoveListingRequest):
    service = get_recommendation_service()
    removed = service.remove_listing_by_property_id(req.propertyId)
    if not removed:
        raise HTTPException(status_code=404, detail=f"Listing {req.propertyId} not found in FAISS index")
        
    return {"status": "deleted", "propertyId": req.propertyId}
