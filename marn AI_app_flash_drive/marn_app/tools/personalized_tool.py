from langchain_core.tools import tool
from langchain_core.runnables.config import RunnableConfig
from sqlalchemy.orm import Session

from db.models import UserInteraction, PropertyMedia
from tools.image_context import add_image_paths

_service = None

def set_recommendation_service(service):
    global _service
    _service = service

@tool
def get_personalized_recommendations(
    top_k: int = 8,
    history_depth: int = 50,
    config: RunnableConfig = None
) -> str:
    """Get personalized apartment recommendations based on the user's browsing
    history, saved favorites, and booked viewings.
    
    Use this when the user asks for personal suggestions, says "what do you 
    recommend for me?", "show me apartments I might like", or wants to see
    apartments similar to ones they've interacted with.
    
    Args:
        top_k: Number of recommendations (default 8, max 15).
        history_depth: How many recent interactions to consider (default 50).
                       Lower = fresher preferences, higher = more stable patterns.
    
    Returns:
        A markdown-formatted list of personalized property cards with images and links.
    """
    if _service is None:
        return "⚠️ Recommendation service is not initialized."
        
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    if not user_id or not db:
        return "⚠️ User context or database connection missing."
        
    interactions_db = db.query(UserInteraction).filter(
        UserInteraction.user_id == user_id
    ).order_by(UserInteraction.created_at.desc()).limit(history_depth).all()
    
    interactions = [
        {
            "unified_id": i.unified_id,
            "interaction_type": i.interaction_type
        } for i in reversed(interactions_db)
    ]
    
    if len(interactions) < 3:
        return (
            "Not enough interaction history to provide personalized behavior-based recommendations. "
            "Please use the `recommend_apartments` tool to search by specific criteria instead."
        )
        
    results = _service.recommend_for_user(interactions, top_k=top_k)
    
    if not results:
        return "❌ Could not generate personalized recommendations at this time."
        
    # Format results as property cards
    def _fmt(v):
        """Format a numeric value, handling None and NaN."""
        if v is None:
            return "—"
        try:
            f = float(v)
            if f != f:  # NaN check
                return "—"
            return f"{f:,.0f}"
        except (ValueError, TypeError):
            return "—"

    cards = []

    for i, row in enumerate(results, 1):
        pid = row.get("property_id") or row.get("unified_id")
        title = row.get("title", "Untitled")
        ptype = row.get("type", "—")
        city = row.get("city", "—")
        region = row.get("region", "—")

        price_str = _fmt(row.get("price"))
        area_str = _fmt(row.get("area"))
        beds_str = _fmt(row.get("bedrooms"))
        baths_str = _fmt(row.get("bathrooms"))

        link = f"[View Property](https://marn-six.vercel.app/property/{pid})"

        # Fetch primary image
        image_md = f"![{title}](https://marn.runasp.net/images/properties/default.jpg)"
        if db and pid:
            try:
                pid_int = int(pid)
                media = db.query(PropertyMedia).filter(
                    PropertyMedia.property_id == pid_int,
                    PropertyMedia.is_primary == True
                ).first()
                if not media:
                    media = db.query(PropertyMedia).filter(
                        PropertyMedia.property_id == pid_int
                    ).first()
                if media and media.path:
                    image_md = f"![{title}](https://marn.runasp.net{media.path})"
            except (ValueError, TypeError):
                pass

        card = (
            f"**{i}. {title} — {city}, {region}**\n"
            f"🏠 Type: {ptype} · 💰 Price: {price_str} EGP/mo · 📐 Area: {area_str} m²\n"
            f"🛏️ {beds_str} Beds · 🚿 {baths_str} Baths\n\n"
            f"{image_md}\n\n"
            f"{link}"
        )

        cards.append(card)

    header = f"**Here are {len(results)} personalized recommendations based on your history:**\n\n"
    return header + "\n\n---\n\n".join(cards)
