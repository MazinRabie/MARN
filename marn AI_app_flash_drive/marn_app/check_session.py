import uuid
from db.engine import SessionLocal
from db.models import ChatSession, AssistantSession

def check_session_exists(session_id_str):
    try:
        session_id = uuid.UUID(session_id_str)
    except ValueError:
        print(f"Invalid UUID format: {session_id_str}")
        return
    
    db = SessionLocal()
    
    try:
        chat_session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
        if chat_session:
            print(f"Session {session_id_str} found in ChatSession table (created at {chat_session.created_at})")
        else:
            print(f"Session {session_id_str} NOT found in ChatSession table")
    except Exception as e:
        print(f"Error querying ChatSession table: {e}")
        db.rollback()

    try:
        assistant_session = db.query(AssistantSession).filter(AssistantSession.session_id == session_id).first()
        if assistant_session:
            print(f"Session {session_id_str} found in AssistantSession table (created at {assistant_session.created_at})")
        else:
            print(f"Session {session_id_str} NOT found in AssistantSession table")
    except Exception as e:
        print(f"Error querying AssistantSession table: {e}")
        db.rollback()
        
    finally:
        db.close()

if __name__ == "__main__":
    target_session_id = "c16d8c0a-8616-4bfd-a81f-0a9842bddd2d"
    print(f"Checking for session ID: {target_session_id}")
    check_session_exists(target_session_id)
