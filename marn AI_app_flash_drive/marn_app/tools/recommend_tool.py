"""
tools/recommend_tool.py
───────────────────────
LangChain @tool wrapper around the KNN-based apartment recommendation engine.

This replaces the raw OpenAI function-calling schema that was defined manually
in the notebook (the TOOLS list with the hand-written JSON schema).  LangChain
infers the JSON schema automatically from the function signature + docstring.
"""

from __future__ import annotations

import warnings
from typing import Optional

from langchain_core.tools import tool
from langchain_core.runnables.config import RunnableConfig

from db.models import PropertyMedia
from tools.image_context import add_image_paths

# The DataBundle is injected at startup via set_data_bundle(); this pattern
# avoids circular imports and makes the tool unit-testable with mock data.
_service = None

def set_recommendation_service(service) -> None:
    """Call this once at app startup to inject the RecommendationService."""
    global _service
    _service = service


# ---------------------------------------------------------------------------
# Tool
# ---------------------------------------------------------------------------


@tool
def recommend_apartments(
    price: Optional[float] = None,
    area: Optional[float] = None,
    bedrooms: Optional[int] = None,
    bathrooms: Optional[int] = None,
    city: Optional[str] = None,
    property_type: Optional[str] = None,
    top_k: int = 5,
    config: RunnableConfig = None,
) -> str:
    """Search the apartment database and return the most similar rental listings.

    Call this tool whenever the user asks to search, find, or recommend
    apartments. At least ONE of city, price, or property_type must be provided.

    Args:
        price: Desired monthly rent in EGP. Omit or pass null if unknown.
        area: Desired apartment size in square metres. Omit or pass null if unknown.
        bedrooms: Number of bedrooms wanted. Omit or pass null if unknown.
        bathrooms: Number of bathrooms wanted. Omit or pass null if unknown.
        city: City name in lowercase, e.g. 'cairo', 'giza', 'alexandria',
              'red sea', 'port said'. Omit or pass null if unknown.
        property_type: One of 'apartment', 'house', 'room', 'villa', 'studio', 'sharedroom'.
              Omit or pass null if unknown.
        top_k: Number of results to return (default 5, max 10).

    Returns:
        A markdown-formatted list of property cards with images and links,
        plus a short summary line.
    """

    if _service is None:
        return "⚠️ Recommendation engine is not initialised. Please restart the app."

    top_k = max(1, min(top_k, 10))  # clamp 1–10

    results = _service.search_by_criteria(
        price=price, area=area, bedrooms=bedrooms, bathrooms=bathrooms,
        city=city, property_type=property_type,
        top_k=top_k
    )

    if not results:
        return (
            "❌ **No apartments found** matching those filters.\n\n"
            "Try relaxing the city, type, or furnished constraints."
        )

    # ── 4. Format results as property cards ───────────────────────────────────
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

    db = config.get("configurable", {}).get("db") if config else None
    cards = []

    for i, row in enumerate(results, 1):
        pid = row.get("property_id") or row.get("unified_id")
        title = row.get("title", "Untitled")
        ptype = row.get("type", "—")
        city_name = row.get("city", "—")
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
            f"**{i}. {title} — {city_name}, {region}**\n"
            f"🏠 Type: {ptype} · 💰 Price: {price_str} EGP/mo · 📐 Area: {area_str} m²\n"
            f"🛏️ {beds_str} Beds · 🚿 {baths_str} Baths\n\n"
            f"{image_md}\n\n"
            f"{link}"
        )

        cards.append(card)

    header = f"**Found {len(results)} matching apartments:**\n\n"
    return header + "\n\n---\n\n".join(cards)
