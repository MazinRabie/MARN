from langchain_core.tools import tool
from langchain_core.runnables.config import RunnableConfig

@tool
def update_my_preferences(city: str, budget: int, config: RunnableConfig) -> str:
    """Update user preferences for city and budget."""
    return "User preferences are now managed directly in the main application settings. I cannot update them from here."

