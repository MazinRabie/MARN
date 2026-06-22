"""
data_loader.py
──────────────
Loads, cleans, normalises, and fits the KNN model on the apartment dataset.
This module is imported by the tool layer and cached by Streamlit so that
the heavy work (reading a 3.5 MB CSV + fitting KNN) happens only once per
app session.
"""

from __future__ import annotations

import os
from dataclasses import dataclass

import numpy as np
import pandas as pd
import streamlit as st
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import MinMaxScaler

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

# Resolve the CSV path relative to THIS file so the app works regardless of
# the working directory it is launched from.
_HERE = os.path.dirname(os.path.abspath(__file__))
DATA_PATH = os.path.join(_HERE, "data", "unified_rent_apartments.csv")

NUMERIC_FEATURES: list[str] = ["price", "area", "bedrooms", "bathrooms", "beds", "max_occupants", "lat", "lng"]

CATEGORICAL_COLS: list[str] = ["type", "city", "region"]

# ---------------------------------------------------------------------------
# Data container
# ---------------------------------------------------------------------------


@dataclass
class DataBundle:
    """Holds every artifact produced during data loading so tools can share
    them without module-level global variables."""

    df_clean: pd.DataFrame
    scaler: MinMaxScaler
    X_all: np.ndarray  # normalised feature matrix, shape (n_rows, 8)
    knn_global: NearestNeighbors
    numeric_features: list[str]
    unique_cities: list[str]
    unique_types: list[str]


# ---------------------------------------------------------------------------
# Loading logic (heavy — called once then cached)
# ---------------------------------------------------------------------------

def _load_from_db() -> pd.DataFrame:
    from db.engine import SessionLocal
    from db.models import MarnProperty
    
    with SessionLocal() as db:
        # Get active properties: IsActive=True, Status=1, DeletedAt=None
        properties = db.query(MarnProperty).filter(
            MarnProperty.is_active == True,
            MarnProperty.status == 1,
            MarnProperty.deleted_at.is_(None)
        ).all()
        
        PROPERTY_TYPE_MAP = {0: "apartment", 1: "house", 2: "room", 3: "villa", 4: "studio", 5: "sharedroom"}
        
        data = []
        for p in properties:
            data.append({
                "unified_id": str(p.id),
                "property_id": p.id,
                "price": float(p.price) if p.price else 0.0,
                "area": float(p.square_meters) if p.square_meters else 0.0,
                "bedrooms": p.bedrooms,
                "bathrooms": p.bathrooms,
                "beds": p.beds,
                "lat": float(p.latitude) if p.latitude else 0.0,
                "lng": float(p.longitude) if p.longitude else 0.0,
                "city": p.city,
                "region": p.state,
                "type": PROPERTY_TYPE_MAP.get(p.type, "apartment"),
                "title": p.title,
                "is_shared": bool(p.is_shared),
                "max_occupants": p.max_occupants
            })
            
        return pd.DataFrame(data)

def _load_and_clean() -> DataBundle:
    """Internal: load CSV or DB → clean → normalise → fit KNN."""

    if os.getenv("DATA_SOURCE") == "csv":
        df = pd.read_csv(DATA_PATH)
        df_clean = df.drop_duplicates(subset=["unified_id"]).copy()
        df_clean = df_clean.dropna(subset=["price", "lat", "lng", "area"])
        
        for col in ["bedrooms", "bathrooms"]:
            df_clean[col] = pd.to_numeric(df_clean[col], errors="coerce")
            df_clean[col] = df_clean[col].fillna(df_clean[col].median())
            
        for col in ["beds", "max_occupants"]:
            if col not in df_clean.columns:
                df_clean[col] = df_clean["bedrooms"] if col == "beds" else 2
                
        if "is_shared" not in df_clean.columns:
            df_clean["is_shared"] = False
            
        if "property_id" not in df_clean.columns:
            # mock property IDs from unified_id if possible
            df_clean["property_id"] = pd.to_numeric(df_clean["unified_id"], errors="coerce").fillna(0).astype(int)
    else:
        df_clean = _load_from_db()
        df_clean = df_clean.dropna(subset=["price", "lat", "lng", "area"])

    # ── 5. Normalise categorical columns ─────────────────────────────────────
    for col in CATEGORICAL_COLS:
        if col in df_clean.columns:
            df_clean[col] = df_clean[col].astype(str).str.strip().str.lower()

    # ── 6. Reset index so positional iloc stays consistent ───────────────────
    df_clean = df_clean.reset_index(drop=True)

    # ── 7. Build normalised feature matrix ───────────────────────────────────
    scaler = MinMaxScaler()
    X_all: np.ndarray = scaler.fit_transform(df_clean[NUMERIC_FEATURES])

    # ── 8. Fit global KNN (Ball-Tree; fast for sub-setting at query time) ─────
    knn_global = NearestNeighbors(
        n_neighbors=20, algorithm="ball_tree", metric="euclidean"
    )
    knn_global.fit(X_all)

    unique_cities = sorted([str(c) for c in df_clean["city"].unique() if str(c) != "nan"]) if "city" in df_clean.columns else []
    unique_types = sorted([str(t) for t in df_clean["type"].unique() if str(t) != "nan"]) if "type" in df_clean.columns else []

    return DataBundle(
        df_clean=df_clean,
        scaler=scaler,
        X_all=X_all,
        knn_global=knn_global,
        numeric_features=NUMERIC_FEATURES,
        unique_cities=unique_cities,
        unique_types=unique_types,
    )


# ---------------------------------------------------------------------------
# Public API — cached for Streamlit; safe to call from plain Python too
# ---------------------------------------------------------------------------


import functools

# Simple singleton cache (replaces @st.cache_resource for FastAPI compatibility)
_cached_bundle: DataBundle | None = None

def load_data() -> DataBundle:
    """Return the shared DataBundle. Load it if not already loaded.
    
    This replaces the Streamlit-specific cache so it works smoothly in FastAPI.
    """
    global _cached_bundle
    if _cached_bundle is None:
        _cached_bundle = _load_and_clean()
    return _cached_bundle
