from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text
import httpx

from db.engine import get_db
from config.settings import LLM_BASE_URL, LLM_TIMEOUT

router = APIRouter()

@router.get("/health")
async def health_check(db: Session = Depends(get_db)):
    status = {
        "status": "ok",
        "database": "unknown",
        "llm": "unknown"
    }
    
    # Check DB
    try:
        db.execute(text("SELECT 1"))
        status["database"] = "connected"
    except Exception as e:
        status["status"] = "degraded"
        status["database"] = f"error: {str(e)}"
        
    # Check LLM
    try:
        async with httpx.AsyncClient(timeout=2.0) as client:
            response = await client.get(f"{LLM_BASE_URL}/models")
            if response.status_code == 200:
                status["llm"] = "connected"
            else:
                status["status"] = "degraded"
                status["llm"] = f"error: {response.status_code}"
    except Exception as e:
        status["status"] = "degraded"
        status["llm"] = f"error: {str(e)}"
        
    return status
