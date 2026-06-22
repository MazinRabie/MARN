from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from contextlib import asynccontextmanager

from db.engine import engine
from db.models import Base
from routers.chat import router as chat_router
from routers.health import router as health_router
from routers.recommendation import router as recommendation_router, ngrok_router
from routers.listings import router as listings_router
from agent import get_data_bundle

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    print("Initializing Database connection...")
    # Base.metadata.create_all(bind=engine) # We use init_db script for this now
    
    print("Loading Data for Recommendation Engine...")
    get_data_bundle()
    
    print("MARN API initialized successfully!")
    yield
    
    # Shutdown
    print("Shutting down MARN API...")
    engine.dispose()

app = FastAPI(
    title="MARN Apartment Finder API",
    description="API endpoint for the MARN chatbot with role-based access control.",
    version="2.0.0",
    lifespan=lifespan
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # For production, restrict to app domains
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount Routers
app.include_router(chat_router, prefix="/api/v1")
app.include_router(health_router, prefix="/api/v1")
app.include_router(recommendation_router, prefix="/api/v1")
app.include_router(listings_router, prefix="/api/v1")
app.include_router(ngrok_router)

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True)
