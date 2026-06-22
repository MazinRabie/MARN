import os
import sys

# Add the project root to path
sys.path.append(r"c:\Uni project\Grad project\marn_app")

from db.engine import engine
from sqlalchemy import inspect

def inspect_tables():
    try:
        inspector = inspect(engine)
        for table_name in ["SavedProperties", "Contracts"]:
            print(f"\n=== Schema for {table_name} ===")
            columns = inspector.get_columns(table_name)
            for col in columns:
                print(f"{col['name']}: {col['type']} (nullable={col['nullable']})")
    except Exception as e:
        print(f"Error connecting to database: {e}")

if __name__ == "__main__":
    inspect_tables()
