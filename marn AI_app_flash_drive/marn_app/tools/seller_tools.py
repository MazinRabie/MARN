from langchain_core.tools import tool
from langchain_core.runnables.config import RunnableConfig
from sqlalchemy import select
import uuid

from db.models import MarnProperty

@tool
def get_my_listings(config: RunnableConfig) -> str:
    """Get all property listings owned by the current user."""
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    listings = db.execute(
        select(MarnProperty).where(MarnProperty.owner_id == user_id)
    ).scalars().all()
    
    if not listings:
        return "You have no active listings."
        
    result = "Your Listings:\n"
    for l in listings:
        result += f"- [{l.id}] {l.title} | {l.price} EGP | Status: {l.status}\n"
    return result

@tool
def get_listing_analytics(listing_id: str, config: RunnableConfig) -> str:
    """Get analytics (e.g., view count) for a specific listing."""
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    try:
        listing_int = int(listing_id)
    except ValueError:
        return "Error: Invalid listing ID format."
        
    listing = db.query(MarnProperty).filter(
        MarnProperty.id == listing_int,
        MarnProperty.owner_id == user_id
    ).first()
    
    if not listing:
        return "Error: Listing not found or you don't own it."
        
    return f"Analytics for '{listing.title}':\n- Views: {listing.views}\n- Status: {listing.status}"

@tool
def update_listing_price(listing_id: str, new_price: int, config: RunnableConfig) -> str:
    """Update the rental price for a specific listing."""
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    try:
        listing_int = int(listing_id)
        price_val = float(new_price)
    except ValueError:
        return "Error: Invalid input format."
        
    listing = db.query(MarnProperty).filter(
        MarnProperty.id == listing_int,
        MarnProperty.owner_id == user_id
    ).first()
    
    if not listing:
        return "Error: Listing not found or you don't own it."
        
    old_price = listing.price
    listing.price = price_val
    db.commit()
    return f"Successfully updated price for '{listing.title}' from {old_price} EGP to {price_val} EGP."
