"""
agent.py
────────
Builds and returns a LangGraph agent dynamically based on the user's profile.
"""

from __future__ import annotations

from langchain_core.messages import SystemMessage
from langchain_openai import ChatOpenAI
from langgraph.prebuilt import create_react_agent

from data_loader import DataBundle, load_data
from tools import get_tools_for_role
from tools.recommend_tool import set_recommendation_service
from tools.personalized_tool import set_recommendation_service as set_personalized_service
from services.recommendation_service import RecommendationService
from config.settings import LLM_BASE_URL, LLM_MODEL, LLM_TIMEOUT

# Global data load
_bundle: DataBundle | None = None
_recommendation_service: RecommendationService | None = None

def get_data_bundle():
    global _bundle, _recommendation_service
    if _bundle is None:
        _bundle = load_data()
        _recommendation_service = RecommendationService()
        _recommendation_service.initialize_from_bundle(_bundle)
        set_recommendation_service(_recommendation_service)
        set_personalized_service(_recommendation_service)
    return _bundle

def get_recommendation_service() -> RecommendationService:
    get_data_bundle()
    return _recommendation_service

def build_system_prompt(user_profile: dict) -> str:
    name = user_profile.get("name", "User")
    user_id = user_profile.get("id", "unknown")
    lang = user_profile.get("language", "en")

    return f"""You are **MARN (Modern Accommodation Rent Network Finder)** 🏠, a helpful,
friendly Egyptian real-estate chatbot that helps users find rental apartments across Egypt.

## Current User
- Name: {name}
- User ID: {user_id}
- Preferred language: {"Arabic" if lang == "ar" else "English"}

## Access Rules
- You are serving ONLY this user. Never reveal personal information about other users.
- This user can: search apartments, manage their own favorites, book viewings,
  manage their own listings, and view their own analytics.
- All tool operations are scoped to this user's ID. Do not attempt to access
  data belonging to other users.

## Conversation Strategy
1. Greet the user warmly.
2. Present results clearly — the tools return pre-formatted property cards, so present them as-is.
3. Keep responses concise but friendly.
4. Always respond in the same language the user writes in (Arabic or English),
   except for data tables from tools.
5. You must recognize and adapt to languages that use LTR (Left-to-Right) and RTL (Right-to-Left) formatting naturally.
6. **Strict Confinement**: You must strictly confine your responses to the scope of this real estate application (apartments, rent, property features, location). Do NOT discuss or mention other companies, competitors, or any unrelated topics. If asked about unrelated topics, politely decline and steer the conversation back to MARN.
7. **Image Handling**: When recommending properties, the system will automatically attach the relevant property images to your response. **DO NOT** mention or describe the images in your initial response (e.g., do not say "Here are some images of the property"). If the user explicitly asks to see properties or their images, you MUST use the `recommend_apartments` or `get_personalized_recommendations` tool to search for them, as the images are only attached when these tools are called. Do not apologize for not being able to show images; simply use the tools.
8. **Property Cards**: When recommending properties, the tools return pre-formatted property cards with links and images already included. Present these cards to the user as-is. Do NOT reformat the results into tables. Do NOT add extra emojis to the links or images.

## Tools Available
- Search apartments (recommend_apartments)
- Personalized recommendations based on history (get_personalized_recommendations)
- Manage favorites (get_my_favorites, add_to_favorites, remove_from_favorites)
- Manage rental contracts (get_my_contracts)
- View own listings & analytics (if they have listings)
- Update listing prices (for own listings only)
- FAQ knowledge base
"""

def build_agent(user_profile: dict):
    """Build a dynamic LangGraph agent for the specific request context."""
    
    # Ensure data is loaded
    get_data_bundle()

    # 1. Connect to LLM
    llm = ChatOpenAI(
        model=LLM_MODEL,
        base_url=LLM_BASE_URL,
        api_key="lm-studio",       # Ignored by LM Studio
        temperature=0.4,
        max_tokens=2048,
        timeout=LLM_TIMEOUT,
    )

    # 2. Get combined role tools
    tools = get_tools_for_role("user")

    # 3. Build dynamic prompt
    prompt_text = build_system_prompt(user_profile)

    # 4. Create agent
    agent = create_react_agent(
        model=llm,
        tools=tools,
        prompt=SystemMessage(content=prompt_text),
    )

    return agent
