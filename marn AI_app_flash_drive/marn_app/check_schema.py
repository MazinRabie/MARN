from sqlalchemy import inspect
from db.engine import engine

inspector = inspect(engine)
columns = inspector.get_columns('assistantSessions')
print("Columns in assistantSessions:")
for col in columns:
    print(f"- {col['name']}: {col['type']}")

columns2 = inspector.get_columns('chat_sessions')
print("\nColumns in chat_sessions:")
for col in columns2:
    print(f"- {col['name']}: {col['type']}")
