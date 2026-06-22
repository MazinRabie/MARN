"""
tools/image_context.py
──────────────────────
Request-scoped storage for property image paths.

Tools (recommend_apartments, get_personalized_recommendations) call
add_image_paths() during execution. The chat router reads and clears
the list after the agent finishes.

Uses a module-level list because each /chat request is processed
synchronously (agent.invoke blocks), and FastAPI runs each request
in its own thread via the default thread pool.
"""

from typing import List
import contextvars

_image_paths = contextvars.ContextVar("image_paths")

def init_image_paths() -> None:
    """Initialize the list for this request context."""
    _image_paths.set([])

def add_image_paths(paths: List[str]) -> None:
    """Append image paths collected by a tool during this request."""
    try:
        _image_paths.get().extend(paths)
    except LookupError:
        pass

def get_image_paths() -> List[str]:
    """Return a copy of all collected image paths."""
    try:
        return list(_image_paths.get())
    except LookupError:
        return []

def clear_image_paths() -> None:
    """Reset the image paths list. Call before and after agent invocation."""
    try:
        _image_paths.get().clear()
    except LookupError:
        pass
