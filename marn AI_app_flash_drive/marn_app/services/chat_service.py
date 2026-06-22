from sqlalchemy.orm import Session
from langchain_core.messages import HumanMessage, AIMessage, ToolMessage
import uuid
import json
from datetime import datetime

from db.models import AssistantSession, AssistantMessage

def load_chat_context(db: Session, session_id: uuid.UUID):
    """
    1. Validate session exists in assistantSessions.
    2. Query all assistantMessages for the session, ordered by CreatedAt ASC.
    3. Convert to LangChain messages.
    4. Return (messages_list, user_id).
    """
    # Cast session_id to str to avoid pyodbc/Linux UUID matching issues
    session = db.query(AssistantSession).filter(AssistantSession.session_id == str(session_id)).first()
    if not session:
        return None, None

    user_id = session.user_id

    messages = db.query(AssistantMessage).filter(
        AssistantMessage.session_id == str(session_id)
    ).order_by(AssistantMessage.created_at.asc()).all()
    
    history = []
    for msg in messages:
        if msg.role == 'user':
            history.append(HumanMessage(content=msg.content))
        elif msg.role == 'assistant':
            if msg.tool_only:
                try:
                    tool_calls = json.loads(msg.content)
                    if isinstance(tool_calls, list):
                        history.append(AIMessage(content="", tool_calls=tool_calls))
                    else:
                        history.append(AIMessage(content=msg.content))
                except json.JSONDecodeError:
                    history.append(AIMessage(content=msg.content))
            else:
                history.append(AIMessage(content=msg.content))
        elif msg.role == 'tool':
            if msg.tool_only:
                try:
                    data = json.loads(msg.content)
                    tool_call_id = data.get("tool_call_id", "")
                    content = data.get("content", "")
                    name = data.get("name", "")
                    history.append(ToolMessage(content=content, tool_call_id=tool_call_id, name=name))
                except json.JSONDecodeError:
                    history.append(ToolMessage(content=msg.content, tool_call_id=""))

    return history, user_id

def save_tool_message(db: Session, session_id: uuid.UUID, user_id: uuid.UUID, role: str, content: str):
    """Insert a row into assistantMessages with ToolOnly=True. Used for tool calls and tool responses."""
    db_msg = AssistantMessage(
        session_id=session_id,
        user_id=user_id,
        role=role,
        tool_only=True,
        content=content
    )
    
    # Update session updated_at
    chat_session = db.query(AssistantSession).filter(AssistantSession.session_id == session_id).first()
    if chat_session:
        chat_session.updated_at = datetime.utcnow()
        
    db.add(db_msg)
    db.commit()
