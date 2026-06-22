"""
tools/faq_tools.py
──────────────────
Two LangChain tools that give the agent access to the FAQs/ knowledge base:

  1. list_faq_topics  — scans the FAQs/ folder and returns topic names
  2. read_faq_files   — reads one or more FAQ files and returns content
"""

from __future__ import annotations

import os
from typing import List

from langchain_core.tools import tool

# Path to the FAQs directory (resolved relative to this file's location so
# it works no matter what the working directory is when the app starts).
_HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FAQS_DIR = os.path.join(_HERE, "FAQs")

# Supported FAQ file extensions (checked in priority order)
_SUPPORTED_EXTENSIONS = (".txt", ".md")


def _is_faq_file(filename: str) -> bool:
    """Return True if the filename has a supported FAQ extension."""
    return any(filename.lower().endswith(ext) for ext in _SUPPORTED_EXTENSIONS)


def _resolve_faq_path(safe_name: str) -> str | None:
    """Try each supported extension and return the first existing path, or None."""
    for ext in _SUPPORTED_EXTENSIONS:
        path = os.path.join(FAQS_DIR, f"{safe_name}{ext}")
        if os.path.isfile(path):
            return path
    return None


# ---------------------------------------------------------------------------
# Tool 1: list_faq_topics
# ---------------------------------------------------------------------------


@tool
def list_faq_topics() -> str:
    """List all available FAQ topics from the knowledge base.

    Each topic corresponds to a text or markdown file inside the FAQs folder.
    The file name (without the extension) IS the topic name.

    Call this tool when:
    - The user asks what help topics or FAQs are available.
    - You need to discover which documents exist before calling read_faq_files.
    - The user asks a general question and you are unsure which FAQ covers it.

    Returns:
        A markdown bullet list of all available FAQ topic names, or a message
        if the FAQs folder is empty or missing.
    """
    if not os.path.isdir(FAQS_DIR):
        return (
            "⚠️ The FAQs folder does not exist yet. "
            f"Please create it at: `{FAQS_DIR}`"
        )

    topics = [
        os.path.splitext(fname)[0]
        for fname in sorted(os.listdir(FAQS_DIR))
        if _is_faq_file(fname)
    ]

    if not topics:
        return "ℹ️ The FAQs folder exists but contains no FAQ files yet."

    bullet_list = "\n".join(f"- {t}" for t in topics)
    return f"**Available FAQ topics:**\n\n{bullet_list}"


# ---------------------------------------------------------------------------
# Tool 2: read_faq_files
# ---------------------------------------------------------------------------


@tool
def read_faq_files(file_names: List[str]) -> str:
    """Read the content of one or more FAQ files and return their combined text.

    Use this tool when the user asks a question that a FAQ document can answer.
    First call list_faq_topics to see what is available, then call this tool
    with the relevant topic name(s).

    Args:
        file_names: A list of FAQ topic names to read. Each name is the file
                    name WITHOUT the extension, exactly as returned by
                    list_faq_topics. For example:
                      ["Searching for Properties", "Payments"]

    Returns:
        The combined text of all requested FAQ files, each preceded by a
        markdown header with the topic name. If a file is not found, an
        error note is included for that specific topic rather than failing
        the entire call.
    """
    if not file_names:
        return "⚠️ No file names were provided. Please pass at least one topic name."

    if not os.path.isdir(FAQS_DIR):
        return (
            "⚠️ The FAQs folder does not exist. "
            f"Expected location: `{FAQS_DIR}`"
        )

    parts: list[str] = []

    for name in file_names:
        # Sanitise: strip whitespace and reject path-traversal attempts
        safe_name = name.strip().replace("/", "").replace("\\", "").replace("..", "")
        file_path = _resolve_faq_path(safe_name)

        if file_path is None:
            parts.append(
                f"### {name}\n\n"
                f"❌ FAQ topic **'{name}'** was not found. "
                "Use `list_faq_topics` to see available topics."
            )
            continue

        try:
            with open(file_path, encoding="utf-8") as fh:
                content = fh.read().strip()
            parts.append(f"### {name}\n\n{content}")
        except OSError as exc:
            parts.append(f"### {name}\n\n⚠️ Could not read file: {exc}")

    return "\n\n---\n\n".join(parts) if parts else "No FAQ content was retrieved."
