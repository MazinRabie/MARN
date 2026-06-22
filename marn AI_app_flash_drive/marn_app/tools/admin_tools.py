from langchain_core.tools import tool
from langchain_core.runnables.config import RunnableConfig
from sqlalchemy import select, func
import uuid

from db.models import User, Listing, Booking

@tool
def get_platform_metrics(date_range: str, config: RunnableConfig) -> str:
    """Get aggregated metrics for the platform (total users, listings, bookings)."""
    db = config.get("configurable", {}).get("db")
    role = config.get("configurable", {}).get("role")
    
    if role != "admin":
        return "Error: Unauthorized. Only admins can access platform metrics."
        
    user_count = db.query(func.count(User.id)).scalar()
    listing_count = db.query(func.count(Listing.id)).scalar()
    booking_count = db.query(func.count(Booking.id)).scalar()
    
    return f"Platform Metrics ({date_range}):\n- Total Users: {user_count}\n- Total Listings: {listing_count}\n- Total Bookings: {booking_count}"

@tool
def search_users(query: str, config: RunnableConfig) -> str:
    """Search for users by name or email."""
    db = config.get("configurable", {}).get("db")
    role = config.get("configurable", {}).get("role")
    
    if role != "admin":
        return "Error: Unauthorized."
        
    users = db.query(User).filter(
        (User.name.ilike(f"%{query}%")) | (User.email.ilike(f"%{query}%"))
    ).limit(10).all()
    
    if not users:
        return f"No users found matching '{query}'."
        
    result = "Search Results:\n"
    for u in users:
        result += f"- [{u.id}] {u.name} ({u.email}) | Role: {u.role}\n"
    return result

@tool
def flag_listing(listing_id: str, reason: str, config: RunnableConfig) -> str:
    """Flag a listing and set its status to 'suspended' for terms violation."""
    db = config.get("configurable", {}).get("db")
    role = config.get("configurable", {}).get("role")
    
    if role != "admin":
        return "Error: Unauthorized."
        
    try:
        listing_uuid = uuid.UUID(listing_id)
    except ValueError:
        return "Error: Invalid listing ID format."
        
    listing = db.query(Listing).filter(Listing.id == listing_uuid).first()
    if not listing:
        return "Error: Listing not found."
        
    listing.status = "suspended"
    db.commit()
    return f"Listing '{listing.title}' has been suspended. Reason logged: {reason}."
