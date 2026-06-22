import uuid

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func

from db.engine import get_db
from db.models import User, Listing

router = APIRouter(tags=["exploration"])


@router.get("/listings/count")
def get_listings_count(db: Session = Depends(get_db)):
    """Return the total number of listings in the database."""
    count = db.query(func.count(Listing.id)).scalar()
    return {"count": count}


@router.get("/listings")
def list_listings(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(10, ge=1, le=100, description="Max records to return"),
    db: Session = Depends(get_db),
):
    """List listings with pagination."""
    listings = db.query(Listing).offset(skip).limit(limit).all()
    return [
        {c.name: getattr(row, c.name) for c in Listing.__table__.columns}
        for row in listings
    ]


@router.get("/listings/{listing_id}")
def get_listing(listing_id: uuid.UUID, db: Session = Depends(get_db)):
    """Get a single listing by UUID."""
    listing = db.query(Listing).filter(Listing.id == listing_id).first()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")
    return {c.name: getattr(listing, c.name) for c in Listing.__table__.columns}


@router.get("/users")
def list_users(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(10, ge=1, le=100, description="Max records to return"),
    db: Session = Depends(get_db),
):
    """List users with pagination."""
    users = db.query(User).offset(skip).limit(limit).all()
    return [
        {c.name: getattr(row, c.name) for c in User.__table__.columns}
        for row in users
    ]


@router.get("/users/{user_id}")
def get_user(user_id: uuid.UUID, db: Session = Depends(get_db)):
    """Get a single user by UUID."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {c.name: getattr(user, c.name) for c in User.__table__.columns}
