import os
import sys

# Add the project root to path
sys.path.append(r"c:\Uni project\Grad project\marn_app")

from db.engine import engine
from sqlalchemy import text

def list_tables():
    try:
        with engine.connect() as conn:
            # Query SQL Server for all tables
            result = conn.execute(text("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'"))
            tables = [row[0] for row in result.fetchall()]
            print("=== DATABASE TABLES ===")
            for t in sorted(tables):
                print(t)
    except Exception as e:
        print(f"Error connecting to database: {e}")

if __name__ == "__main__":
    list_tables()
