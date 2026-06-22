from langchain_core.tools import tool
from langchain_core.runnables.config import RunnableConfig
from sqlalchemy import select

from db.models import SavedProperty, MarnProperty

@tool
def get_my_favorites(config: RunnableConfig) -> str:
    """Get the current user's saved favorite apartments."""
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    if not user_id or not db:
        return "Error: Missing user context or database connection."
        
    saved_props = db.execute(
        select(SavedProperty).where(SavedProperty.user_id == user_id)
    ).scalars().all()
    
    if not saved_props:
        return "You have no saved properties."
        
    result = "Your Saved Properties:\n"
    for saved in saved_props:
        listing = db.query(MarnProperty).filter(MarnProperty.id == saved.property_id).first()
        if listing:
            result += f"- [{listing.id}] {listing.title} ({listing.price} EGP)\n"
    return result

@tool
def add_to_favorites(listing_id: str, config: RunnableConfig) -> str:
    """Add a specific property to the saved properties of the current user."""
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    try:
        property_int_id = int(listing_id)
    except ValueError:
        return "Error: Invalid property ID format."
        
    # Check if listing exists
    listing = db.query(MarnProperty).filter(MarnProperty.id == property_int_id).first()
    if not listing:
        return "Error: Property not found."
        
    # Check if already saved
    existing = db.query(SavedProperty).filter(
        SavedProperty.user_id == user_id,
        SavedProperty.property_id == property_int_id
    ).first()
    
    if existing:
        return "This property is already in your saved properties."
        
    new_save = SavedProperty(user_id=user_id, property_id=property_int_id)
    db.add(new_save)
    db.commit()
    
    return f"Successfully saved '{listing.title}' to your saved properties."

@tool
def remove_from_favorites(listing_id: str, config: RunnableConfig) -> str:
    """Remove a specific property from the saved properties of the current user."""
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    try:
        property_int_id = int(listing_id)
    except ValueError:
        return "Error: Invalid property ID format."
        
    saved = db.query(SavedProperty).filter(
        SavedProperty.user_id == user_id,
        SavedProperty.property_id == property_int_id
    ).first()
    
    if not saved:
        return "This property is not in your saved properties."
        
    db.delete(saved)
    db.commit()
    return "Successfully removed from saved properties."

@tool
def book_viewing(listing_id: str, preferred_date: str, config: RunnableConfig) -> str:
    """Book a viewing for an apartment on a preferred date (YYYY-MM-DD)."""
    return "Booking viewings is now managed directly through the main application interface. Please use the booking button on the listing page."

@tool
def get_my_bookings(config: RunnableConfig) -> str:
    """Get the current user's booked viewings."""
    return "You can view your bookings directly in the main application interface under 'My Bookings'."

