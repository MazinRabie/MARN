"""
app.py
──────
Streamlit entry point for the Saknny Apartment Finder chatbot.

Run with:
    streamlit run app.py

Requirements:
    • LM Studio running on http://localhost:1234 with a tool-calling model loaded.
    • The unified_rent_apartments.csv file present in the same directory.
    • All dependencies from requirements.txt installed.
"""

from __future__ import annotations

import sys
import os

# Ensure imports resolve correctly when launched from any working directory.
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import streamlit as st
from langchain_core.messages import AIMessage, HumanMessage, SystemMessage

from agent import get_agent

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Page Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

st.set_page_config(
    page_title="MARN – Apartment Finder",
    page_icon="🏠",
    layout="wide",
    initial_sidebar_state="expanded",
)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Custom CSS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

st.markdown(
    """
    <style>
    /* ── Global ── */
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

    html, body, [class*="css"] {
        font-family: 'Inter', sans-serif;
    }

    /* ── Sidebar ── */
    [data-testid="stSidebar"] {
        background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
        border-right: 1px solid #334155;
    }
    [data-testid="stSidebar"] * {
        color: #e2e8f0 !important;
    }
    [data-testid="stSidebar"] h1,
    [data-testid="stSidebar"] h2,
    [data-testid="stSidebar"] h3 {
        color: #f8fafc !important;
    }
    [data-testid="stSidebar"] hr {
        border-color: #334155 !important;
    }

    /* ── Main chat area ── */
    .main .block-container {
        padding-top: 1.5rem;
        padding-bottom: 5rem;
        max-width: 900px;
    }

    /* ── Chat messages ── */
    [data-testid="stChatMessage"] {
        border-radius: 12px;
        padding: 0.25rem 0.5rem;
        margin-bottom: 0.5rem;
    }

    /* User bubble */
    [data-testid="stChatMessage"][data-testid*="user"] {
        background: #1e40af11;
    }

    /* ── Markdown tables in chat ── */
    [data-testid="stChatMessage"] table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.88rem;
        margin-top: 0.5rem;
        border-radius: 8px;
        overflow: hidden;
    }
    [data-testid="stChatMessage"] th {
        background: #1e40af;
        color: #ffffff !important;
        padding: 8px 12px;
        text-align: start;
        font-weight: 600;
        letter-spacing: 0.02em;
    }
    [data-testid="stChatMessage"] td {
        padding: 7px 12px;
        border-bottom: 1px solid rgba(128, 128, 128, 0.2);
    }
    [data-testid="stChatMessage"] tr:nth-child(even) td {
        background: rgba(128, 128, 128, 0.05);
    }
    [data-testid="stChatMessage"] tr:hover td {
        background: rgba(128, 128, 128, 0.1);
        transition: background 0.15s ease;
    }

    /* ── Auto RTL/LTR based on language ── */
    [data-testid="stChatMessage"] .stMarkdown,
    [data-testid="stChatMessage"] .stMarkdown p,
    [data-testid="stChatMessage"] .stMarkdown ul,
    [data-testid="stChatMessage"] .stMarkdown ol,
    [data-testid="stChatMessage"] .stMarkdown li,
    [data-testid="stChatMessage"] .stMarkdown h1,
    [data-testid="stChatMessage"] .stMarkdown h2,
    [data-testid="stChatMessage"] .stMarkdown h3,
    [data-testid="stChatMessage"] .stMarkdown table {
        unicode-bidi: plaintext;
        text-align: start;
    }

    /* ── Chat input ── */
    [data-testid="stChatInput"] textarea {
        border-radius: 12px !important;
        border: 1.5px solid #cbd5e1 !important;
        font-family: 'Inter', sans-serif !important;
        font-size: 0.95rem !important;
    }
    [data-testid="stChatInput"] textarea:focus {
        border-color: #3b82f6 !important;
        box-shadow: 0 0 0 3px #3b82f620 !important;
    }

    /* ── Header ── */
    .saknny-header {
        text-align: center;
        padding: 1.5rem 0 1rem 0;
        border-bottom: 1px solid #e2e8f0;
        margin-bottom: 1.5rem;
    }
    .saknny-header h1 {
        font-size: 2rem;
        font-weight: 700;
        color: #1e40af;
        margin: 0;
        letter-spacing: -0.02em;
    }
    .saknny-header p {
        color: #64748b;
        font-size: 0.95rem;
        margin: 0.25rem 0 0 0;
    }

    /* ── Status badge ── */
    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 500;
    }
    .status-online {
        background: #dcfce7;
        color: #166534;
    }
    .status-offline {
        background: #fee2e2;
        color: #991b1b;
    }

    /* ── Streamlit default overrides ── */
    #MainMenu, footer, header { visibility: hidden; }
    </style>
    """,
    unsafe_allow_html=True,
)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Sidebar
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

with st.sidebar:
    st.markdown("# 🏠 MARN")
    st.markdown("**Modern Accommodation Rent Network Finder**")
    st.markdown("*Egypt's smart rental assistant*")
    st.divider()

    st.markdown("### 🔍 How to use")
    st.markdown(
        """
        Simply describe what you're looking for in plain language:

        - *"2-bedroom in Cairo, 10k EGP budget"*
        - *"Furnished studio in Alexandria"*
        - *"Penthouse in Giza, 3 bedrooms"*

        The AI will search **12,000+ listings** for you.
        """
    )
    st.divider()

    st.markdown("### 📚 Quick topics")
    st.markdown(
        """
        Ask the assistant about:
        - Available cities
        - Apartment types
        - Pricing guidance
        - Furnished vs unfurnished
        """
    )
    st.divider()

    # ── Clear Chat Button ──
    if st.button("🗑️ Clear conversation", use_container_width=True):
        st.session_state.messages = []
        st.session_state.lc_messages = []
        st.rerun()

    st.divider()

    # ── LM Studio status indicator ──
    st.markdown("### ⚙️ Status")
    try:
        import httpx
        r = httpx.get("http://localhost:1234/v1/models", timeout=2.0)
        if r.status_code == 200:
            models = r.json().get("data", [])
            model_name = models[0]["id"] if models else "unknown"
            st.markdown(
                f'<span class="status-badge status-online">🟢 LM Studio online</span>',
                unsafe_allow_html=True,
            )
            st.caption(f"Model: `{model_name}`")
        else:
            raise ConnectionError()
    except Exception:
        st.markdown(
            '<span class="status-badge status-offline">🔴 LM Studio offline</span>',
            unsafe_allow_html=True,
        )
        st.caption("Start LM Studio and load a model to use the chatbot.")

    st.divider()
    st.caption("Saknny · Grad Project 2026")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Page Header
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

st.markdown(
    """
    <div class="saknny-header">
        <h1>🏠 MARN Apartment Finder</h1>
        <p>Tell me what you're looking for and I'll search 12,000+ Egyptian rental listings for you.</p>
    </div>
    """,
    unsafe_allow_html=True,
)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Session State Initialisation
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if "messages" not in st.session_state:
    # Displayed chat messages (list of {"role": ..., "content": ...} dicts)
    st.session_state.messages = []

if "lc_messages" not in st.session_state:
    # LangChain/LangGraph message objects passed directly to the agent
    # LangGraph uses a flat messages list: [HumanMessage, AIMessage, ...]
    st.session_state.lc_messages = []

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Load Agent (cached — runs once)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

agent_executor = get_agent()

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Display Existing Chat History
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Welcome message shown on first load
if not st.session_state.messages:
    with st.chat_message("assistant", avatar="🏠"):
        st.markdown(
            "👋 **مرحباً! Welcome to MARN!**\n\n"
            "I'm your Modern Accommodation Rent Network Finder. Tell me what you're looking for "
            "and I'll search our database of **12,000+ rental listings** across Egypt.\n\n"
            "You can ask me things like:\n"
            "- *\"I need a 2-bedroom apartment in Cairo around 10,000 EGP\"*\n"
            "- *\"Show me furnished studios in Alexandria\"*\n"
            "- *\"What cities do you cover?\"*\n\n"
            "What are you looking for? 🔍"
        )

# Render all previous messages
for msg in st.session_state.messages:
    avatar = "🏠" if msg["role"] == "assistant" else "👤"
    with st.chat_message(msg["role"], avatar=avatar):
        st.markdown(msg["content"])  # ← Native markdown: bold, tables, lists

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Chat Input & Agent Invocation
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if user_input := st.chat_input("Describe the apartment you're looking for…"):

    # ── Show user message immediately ────────────────────────────────────────
    st.session_state.messages.append({"role": "user", "content": user_input})
    with st.chat_message("user", avatar="👤"):
        st.markdown(user_input)

    image_paths = []
    
    db_gen = get_db()
    db_instance = next(db_gen)

    config = {
        "configurable": {
            "session_id": st.session_state.session_id,
            "user_id": "streamlit_user",
            "db": db_instance,
            "image_paths": image_paths
        }
    }

    # ── Keep history to last 40 messages to avoid context window overflow ──
    MAX_HISTORY = 40
    if len(st.session_state.lc_messages) > MAX_HISTORY:
        st.session_state.lc_messages = st.session_state.lc_messages[-MAX_HISTORY:]

    # ── Build input: full history + new user message ───────────────────────
    input_messages = st.session_state.lc_messages + [HumanMessage(content=user_input)]

    # ── Run agent ──────────────────────────────────────────────────────
    with st.chat_message("assistant", avatar="🏠"):
        thinking_placeholder = st.empty()
        thinking_placeholder.markdown("*Thinking…* ⏳")

        try:
            # LangGraph create_react_agent: input is {"messages": [...]}
            result = agent_executor.invoke({"messages": input_messages}, config=config)
            answer: str = result["messages"][-1].content
            
            if answer:
                import re
                answer = re.sub(r'\]\s+\(https?://', '](https://', answer)
                # Force images to be unindented and separated by blank lines to break them out of lists
                answer = re.sub(r'^\s*(?:[-*o]|\d+\.)?\s*(!\[.*?\]\(.*?\))', r'\n\n\1\n\n', answer, flags=re.MULTILINE)
                
        except Exception as exc:
            answer = (
                f"⚠️ **An error occurred while processing your request.**\n\n"
                f"```\n{exc}\n```\n\n"
                "Please make sure **LM Studio** is running on `localhost:1234` "
                "with a tool-calling model loaded, then try again."
            )

        thinking_placeholder.empty()
        st.markdown(answer)  # ← Renders bold text, tables, lists as real markdown

    # ── Persist to session state ──────────────────────────────────────────
    st.session_state.messages.append({"role": "assistant", "content": answer})

    # Append both turns to lc_messages for next invocation
    st.session_state.lc_messages.extend(
        [
            HumanMessage(content=user_input),
            AIMessage(content=answer),
        ]
    )
