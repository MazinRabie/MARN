from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.orm import Session
import uuid
import json

from db.engine import get_db
from services.chat_service import load_chat_context, save_tool_message
from services.user_service import get_aspnet_user_profile
from agent import build_agent
from langchain_core.messages import AIMessage, ToolMessage
from tools.image_context import init_image_paths, get_image_paths, clear_image_paths

router = APIRouter()

class AssistantChatRequest(BaseModel):
    sessionId: str

@router.post("/chat")
def chat_endpoint(
    request: AssistantChatRequest,
    db: Session = Depends(get_db)
):
    try:
        session_uuid = uuid.UUID(request.sessionId)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid sessionId format (must be UUID)")

    # 1. Load context and validate session
    history, user_id = load_chat_context(db, session_uuid)
    if history is None:
        raise HTTPException(status_code=404, detail="Session not found")
        
    # 2. Get user profile from AspNetUsers
    user_profile = get_aspnet_user_profile(db, user_id)
    
    # 3. Build Agent
    agent = build_agent(user_profile)
    
    # 4. Invoke Agent
    init_image_paths()
    
    config = {
        "configurable": {
            "session_id": str(session_uuid),
            "user_id": str(user_id),
            "db": db,
        }
    }
    
    
    try:
        response = agent.invoke({"messages": history}, config=config)
    except Exception as e:
        clear_image_paths()
        raise HTTPException(status_code=500, detail=f"Agent error: {str(e)}")
        
    # 5. Extract output and intercept tool calls
    output_messages = response["messages"][len(history):] # Only the new messages generated this turn
    
    final_content = ""
    for msg in output_messages:
        if isinstance(msg, AIMessage):
            if msg.tool_calls:
                # Save as ToolOnly=True
                content_str = json.dumps(msg.tool_calls)
                save_tool_message(db, session_uuid, user_id, "assistant", content_str)
            else:
                # Final assistant message is saved by main backend, NOT us
                final_content = msg.content
        elif isinstance(msg, ToolMessage):
            # Save as ToolOnly=True
            data = {
                "tool_call_id": msg.tool_call_id,
                "content": msg.content,
                "name": msg.name
            }
            content_str = json.dumps(data)
            save_tool_message(db, session_uuid, user_id, "tool", content_str)

    # 6. Collect image paths from tools
    image_paths = get_image_paths()
    clear_image_paths()
            
    if final_content:
        import re
        final_content = re.sub(r'\]\s+\(https?://', '](https://', final_content)
        # Force images to be unindented and separated by blank lines to break them out of lists
        final_content = re.sub(r'^\s*(?:[-*o]|\d+\.)?\s*(!\[.*?\]\(.*?\))', r'\n\n\1\n\n', final_content, flags=re.MULTILINE)
            
    return {"content": final_content, "imagePaths": image_paths}

