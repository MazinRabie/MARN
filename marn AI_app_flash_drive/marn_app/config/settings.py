import os

# Database connection URL for SQL Server
# Remote DB (default)
REMOTE_DATABASE_URL = (
    "mssql+pyodbc://db55989:2Sf%40%3F3FqEc4_@db55989.public.databaseasp.net/db55989"
    "?driver=ODBC+Driver+17+for+SQL+Server&Encrypt=yes&TrustServerCertificate=yes&MultipleActiveResultSets=True"
)

# Local DB
LOCAL_DATABASE_URL = (
    "mssql+pyodbc://@./MarnDB3"
    "?driver=ODBC+Driver+17+for+SQL+Server&Trusted_Connection=yes&TrustServerCertificate=yes"
)

DATABASE_MODE = os.getenv("DATABASE_MODE", "remote")  # "remote" or "local"
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    LOCAL_DATABASE_URL if DATABASE_MODE == "local" else REMOTE_DATABASE_URL
)

# LLM Configuration
LLM_BASE_URL = os.getenv("LLM_BASE_URL", "http://localhost:1234/v1")
LLM_MODEL = os.getenv("LLM_MODEL", "qwen3.5-4b")
LLM_TIMEOUT = int(os.getenv("LLM_TIMEOUT", "600"))
