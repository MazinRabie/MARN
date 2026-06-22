"""
tools/__init__.py
─────────────────
Tool registry — exports get_tools_for_role() which returns the tools
appropriate for the user's role.
"""

from __future__ import annotations

from langchain_core.tools import BaseTool

from tools.faq_tools import list_faq_topics, read_faq_files
from tools.recommend_tool import recommend_apartments
from tools.personalized_tool import get_personalized_recommendations

# New tools
from tools.user_tools import update_my_preferences
from tools.buyer_tools import get_my_favorites, add_to_favorites, remove_from_favorites, book_viewing, get_my_bookings
from tools.seller_tools import get_my_listings, get_listing_analytics, update_listing_price
from tools.admin_tools import get_platform_metrics, search_users, flag_listing
from tools.contract_tools import get_my_contracts


def get_all_tools() -> list[BaseTool]:
    """Return the complete list of tools bound to the LangChain agent. Kept for backwards compatibility if needed."""
    return get_tools_for_role("admin") # Admin has the most tools, or just a union of all

def get_tools_for_role(role: str) -> list[BaseTool]:
    """Return the list of tools appropriate for the given user role."""
    # Common tools for all roles
    common_tools = [
        recommend_apartments,
        get_personalized_recommendations,
        list_faq_topics,
        read_faq_files,
        update_my_preferences
    ]
    
    if role == "buyer":
        return common_tools + [
            get_my_favorites,
            add_to_favorites,
            remove_from_favorites,
            book_viewing,
            get_my_bookings,
            get_my_contracts
        ]
    elif role == "seller":
        return common_tools + [
            get_my_listings,
            get_listing_analytics,
            update_listing_price
        ]
    elif role == "admin":
        return common_tools + [
            get_platform_metrics,
            search_users,
            flag_listing
        ]
    elif role == "user":
        return common_tools + [
            get_my_favorites,
            add_to_favorites,
            remove_from_favorites,
            book_viewing,
            get_my_bookings,
            get_my_listings,
            get_listing_analytics,
            update_listing_price,
            get_my_contracts
        ]
        
    # Default fallback
    return common_tools
