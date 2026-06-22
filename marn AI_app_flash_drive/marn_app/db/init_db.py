import sys
from pathlib import Path

# Add marn_app to PYTHONPATH so we can import db module correctly
current_dir = Path(__file__).resolve().parent.parent
if str(current_dir) not in sys.path:
    sys.path.append(str(current_dir))

from db.engine import engine
from db.models import Base

def init_db():
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("Database tables created successfully!")

if __name__ == "__main__":
    init_db()
