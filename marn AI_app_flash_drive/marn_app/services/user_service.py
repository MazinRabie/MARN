from sqlalchemy.orm import Session
import uuid

from db.models import User, Listing, AspNetUser

def get_user_profile(db: Session, user_id: uuid.UUID) -> dict:
    """Get the user profile, preferences, and extra computed context."""
    user = db.query(User).filter(User.id == str(user_id)).first()
    if not user:
        return {}
        
    profile = {
        "id": str(user.id),
        "name": user.name,
        "email": user.email,
        "role": user.role,
        "preferred_city": user.preferred_city,
        "preferred_budget": user.preferred_budget,
        "language": user.language
    }
    
    if user.role == "seller":
        listing_count = db.query(Listing).filter(Listing.owner_id == user.id).count()
        profile["listing_count"] = listing_count
        
    return profile

def get_aspnet_user_profile(db: Session, user_id: uuid.UUID) -> dict:
    """Look up user in AspNetUsers and return profile dict."""
    user = db.query(AspNetUser).filter(AspNetUser.id == str(user_id)).first()
    if not user:
        return {"id": str(user_id), "name": "User", "language": "en"}

    LANG_MAP = {0: "en", 1: "ar"}
    
    first_name = user.first_name or ""
    last_name = user.last_name or ""
    full_name = f"{first_name} {last_name}".strip()
    
    return {
        "id": str(user.id),
        "name": full_name or "User",
        "language": LANG_MAP.get(user.language, "en"),
    }
