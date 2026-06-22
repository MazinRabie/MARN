import os
import pandas as pd
import numpy as np
import faiss
import threading
import json
from sklearn.preprocessing import MinMaxScaler
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import DBSCAN
from typing import List, Dict, Any, Optional, Tuple
from datetime import datetime

from data_loader import DataBundle

# Center coordinates for all 27 Egyptian governorates.
# Source: OpenStreetMap Nominatim geocoding API.
# Keyed by the exact governorate name used in MARN search metadata.
GOVERNORATE_CENTROIDS: Dict[str, Tuple[float, float]] = {
    "CairoGovernorate": (30.0333, 31.5622),
    "GizaGovernorate": (29.054, 29.4191),
    "AlexandriaGovernorate": (30.9433, 29.7656),
    "QalyubiaGovernorate": (30.2474, 31.4858),
    "PortSaidGovernorate": (31.0775, 32.3146),
    "SuezGovernorate": (29.6016, 32.1915),
    "DakhaliaGovernorate": (31.138, 31.8882),
    "SharkiaGovernorate": (30.6333, 31.7894),
    "GharbiaGovernorate": (30.8392, 31.0016),
    "MonufiaGovernorate": (30.437, 30.7467),
    "BehiraGovernorate": (30.7915, 30.3465),
    "KafrElSheikhGovernorate": (31.3815, 30.8514),
    "DamiettaGovernorate": (31.4113, 31.7557),
    "IsmailiaGovernorate": (30.3672, 32.1565),
    "FaiyumGovernorate": (29.3407, 30.6201),
    "BeniSuefGovernorate": (28.8383, 30.8545),
    "MiniaGovernorate": (28.2125, 30.9124),
    "AsyutGovernorate": (27.2065, 31.55),
    "SohagGovernorate": (26.7625, 32.091),
    "QenaGovernorate": (26.2408, 32.9084),
    "LuxorGovernorate": (25.4928, 32.8804),
    "AswanGovernorate": (23.1046, 32.4239),
    "RedSeaGovernorate": (24.6602, 34.14),
    "NewValleyGovernorate": (23.9803, 27.727),
    "MarsaMatruhGovernorate": (31.354, 27.2365),
    "NorthSinaiGovernorate": (30.5903, 33.7052),
    "SouthSinaiGovernorate": (29.2077, 33.8119),
}

class RecommendationService:
    """
    Unified recommendation engine:
    - FAISS index for fast ANN/exact neighbor search.
    - Behavior-based: DBSCAN clustering + interaction-weighted profiles.
    - Criteria-based: categorical pre-filter + FAISS query.
    - Incremental updates: add new listings without rebuilding.
    """

    def __init__(self):
        self.df: Optional[pd.DataFrame] = None
        self.faiss_index: Optional[faiss.IndexIDMap] = None
        self.scaler: Optional[MinMaxScaler] = None
        self.tfidf: Optional[TfidfVectorizer] = None
        
        self.numeric_cols = ["price", "area", "bedrooms", "bathrooms", "beds", "max_occupants", "lat", "lng"]
        
        # Feature importance weights applied after MinMaxScaler.
        # Higher weight = more influence on similarity.
        # Order matches self.numeric_cols.
        self.feature_weights = np.array([
            0.4,   # price        – reduced influence
            0.6,   # area         – moderate
            0.8,   # bedrooms     – important
            0.7,   # bathrooms    – moderate-high
            0.6,   # beds         – moderate
            0.5,   # max_occupants – moderate
            2.5,   # lat          – dominant
            2.5,   # lng          – dominant
        ], dtype='float32')
        
        # ID mappings
        self.id_to_row: Dict[int, int] = {}              # FAISS int ID -> DataFrame row index
        self.unified_id_to_faiss_id: Dict[str, int] = {} # CSV unified_id -> FAISS int ID
        self.faiss_id_to_unified_id: Dict[int, str] = {} # FAISS int ID -> CSV unified_id
        
        self.property_id_to_faiss_id: Dict[int, int] = {} # DB Property Id -> FAISS int ID
        self.faiss_id_to_property_id: Dict[int, int] = {} # FAISS int ID -> DB Property Id
        
        self._lock = threading.Lock()
        
        # Interaction weights (factory style for extensibility)
        self.interaction_weights = {
            'view': 1.0,
            'save': 3.0,
            'search': 2.0,
            'booking': 5.0,
            'rent': 10.0
        }
        self.recency_decay = 0.95

    def get_interaction_weight(self, interaction_type: str) -> float:
        """Factory pattern for interaction weights."""
        return self.interaction_weights.get(interaction_type.lower(), 1.0)

    def initialize_from_bundle(self, bundle: DataBundle):
        """Load data, build features, create FAISS index. Called once at startup."""
        with self._lock:
            self.df = bundle.df_clean.copy()
            self.scaler = bundle.scaler
            
            # Cache city centroids
            self.city_centroids = {}
            if 'city' in self.df.columns and 'lat' in self.df.columns and 'lng' in self.df.columns:
                city_groups = self.df.groupby(self.df['city'].astype(str).str.strip().str.lower())
                for city, group in city_groups:
                    self.city_centroids[city] = (group['lat'].median(), group['lng'].median())
            
            self.dataset_median_lat = self.df['lat'].median() if 'lat' in self.df.columns else 0.0
            self.dataset_median_lng = self.df['lng'].median() if 'lng' in self.df.columns else 0.0

            
            # TF-IDF on title
            self.tfidf = TfidfVectorizer(max_features=50, stop_words='english')
            titles = self.df.get('title', pd.Series([""] * len(self.df))).fillna("")
            tfidf_matrix = self.tfidf.fit_transform(titles).toarray().astype('float32')
            
            # Numeric features (already scaled in bundle)
            num_matrix = bundle.X_all.astype('float32')
            
            # Apply feature importance weights
            num_matrix = num_matrix * self.feature_weights
            
            # Combine features
            full_matrix = np.hstack((num_matrix, tfidf_matrix))
            
            # Normalize for Inner Product (Cosine Similarity)
            faiss.normalize_L2(full_matrix)
            
            dim = full_matrix.shape[1]
            base_index = faiss.IndexFlatIP(dim)
            self.faiss_index = faiss.IndexIDMap(base_index)
            
            # Generate integer IDs
            n_samples = len(self.df)
            ids = np.arange(1, n_samples + 1, dtype=np.int64)
            
            self.faiss_index.add_with_ids(full_matrix, ids)
            
            # Populate mappings
            for idx, row in self.df.iterrows():
                faiss_id = int(ids[idx])
                uid = str(row['unified_id'])
                self.id_to_row[faiss_id] = idx
                self.unified_id_to_faiss_id[uid] = faiss_id
                self.faiss_id_to_unified_id[faiss_id] = uid
                
                if 'property_id' in row and pd.notna(row['property_id']):
                    pid = int(row['property_id'])
                    self.property_id_to_faiss_id[pid] = faiss_id
                    self.faiss_id_to_property_id[faiss_id] = pid
                
            print(f"FAISS index built: {self.faiss_index.ntotal} vectors, dimension {dim}")

    def compute_feature_vector(self, row_data: pd.Series) -> np.ndarray:
        """Computes the 56-dim feature vector for a listing."""
        # Numeric
        num_vals = []
        for col in self.numeric_cols:
            val = row_data.get(col, 0)
            num_vals.append(val if pd.notna(val) else 0)
            
        num_scaled = self.scaler.transform([num_vals]).astype('float32')
        
        # Apply feature importance weights
        num_scaled = num_scaled * self.feature_weights
        
        # Text
        title = str(row_data.get('title', ''))
        text_scaled = self.tfidf.transform([title]).toarray().astype('float32')
        
        vec = np.hstack((num_scaled, text_scaled))
        faiss.normalize_L2(vec)
        return vec

    def _build_search_vector(self, metadata_json: str) -> Tuple[Optional[np.ndarray], List[float], List[str], List[str]]:
        """
        Parses search metadata JSON and builds a FAISS feature vector.
        Returns: (vector, [lat, lng], searched_cities, searched_types)
        """
        try:
            meta = json.loads(metadata_json)
        except (json.JSONDecodeError, TypeError):
            return None, [], [], []

        # 1. Coordinate logic
        # Priority: explicit lat/lng → governorate centroid → city centroid from index → dataset median
        lat = meta.get('latitude')
        lng = meta.get('longitude')
        searched_cities = []
        
        governorate = meta.get('governorate')  # e.g. "AlexandriaGovernorate"
        city = meta.get('city')
        if not city and governorate and isinstance(governorate, str):
            city = governorate.replace('Governorate', '').strip()
                
        if city:
            city_lower = str(city).strip().lower()
            searched_cities.append(city_lower)

        if lat is None or lng is None:
            # Try governorate centroid first (exact match on the name key)
            if governorate and governorate in GOVERNORATE_CENTROIDS:
                lat, lng = GOVERNORATE_CENTROIDS[governorate]
            # Then try city centroid from indexed data
            elif city and city_lower in self.city_centroids:
                lat, lng = self.city_centroids[city_lower]
            else:
                lat, lng = self.dataset_median_lat, self.dataset_median_lng

        coords = [float(lat), float(lng)]

        # 2. Numeric features
        # Mapping: price, area, bedrooms, bathrooms, beds, max_occupants, lat, lng
        query_raw = {}
        
        # Price
        min_p = meta.get('minPrice')
        max_p = meta.get('maxPrice')
        if min_p is not None and max_p is not None:
            query_raw['price'] = (min_p + max_p) / 2.0
        elif min_p is not None:
            query_raw['price'] = float(min_p)
        elif max_p is not None:
            query_raw['price'] = float(max_p)
            
        # Area
        min_a = meta.get('minSquareMeters')
        max_a = meta.get('maxSquareMeters')
        if min_a is not None and max_a is not None:
            query_raw['area'] = (min_a + max_a) / 2.0
        elif min_a is not None:
            query_raw['area'] = float(min_a)
        elif max_a is not None:
            query_raw['area'] = float(max_a)

        # Other numerics
        if meta.get('minBedrooms') is not None:
            query_raw['bedrooms'] = float(meta.get('minBedrooms'))
        if meta.get('minBathrooms') is not None:
            query_raw['bathrooms'] = float(meta.get('minBathrooms'))
        if meta.get('minBeds') is not None:
            query_raw['beds'] = float(meta.get('minBeds'))
        if meta.get('minMaxOccupants') is not None:
            query_raw['max_occupants'] = float(meta.get('minMaxOccupants'))

        query_raw['lat'] = coords[0]
        query_raw['lng'] = coords[1]

        # Fill missing with median
        num_vals = []
        for col in self.numeric_cols:
            val = query_raw.get(col)
            if val is None and self.df is not None and col in self.df.columns:
                val = self.df[col].median()
            num_vals.append(val if val is not None else 0.0)

        num_scaled = self.scaler.transform([num_vals]).astype('float32')
        
        # Apply feature importance weights
        num_scaled = num_scaled * self.feature_weights


        # 3. Text features
        keyword = str(meta.get('keyword', '')).strip()
        text_scaled = self.tfidf.transform([keyword]).toarray().astype('float32')

        vec = np.hstack((num_scaled, text_scaled))
        faiss.normalize_L2(vec)

        # 4. Filter categories for post-boost
        searched_types = []
        prop_type = meta.get('type')
        if prop_type:
            searched_types.append(str(prop_type).strip().lower())

        return vec, coords, searched_cities, searched_types


    def add_listing(self, listing_data: dict) -> int:
        """Add a single new listing to the index incrementally."""
        with self._lock:
            # Generate new FAISS ID
            new_faiss_id = max(self.faiss_id_to_unified_id.keys()) + 1 if self.faiss_id_to_unified_id else 1
            uid = listing_data.get('unified_id', f"generated_{new_faiss_id}")
            listing_data['unified_id'] = uid
            
            row_series = pd.Series(listing_data)
            vec = self.compute_feature_vector(row_series)
            
            self.faiss_index.add_with_ids(vec, np.array([new_faiss_id], dtype=np.int64))
            
            # Update DataFrame and mappings
            new_idx = len(self.df)
            self.df.loc[new_idx] = row_series
            self.id_to_row[new_faiss_id] = new_idx
            self.unified_id_to_faiss_id[uid] = new_faiss_id
            self.faiss_id_to_unified_id[new_faiss_id] = uid
            
            if 'property_id' in listing_data and listing_data['property_id'] is not None:
                pid = int(listing_data['property_id'])
                self.property_id_to_faiss_id[pid] = new_faiss_id
                self.faiss_id_to_property_id[new_faiss_id] = pid
            
            return new_faiss_id

    def remove_listing(self, unified_id: str) -> bool:
        """Remove a listing from the FAISS index by its unified_id.
        
        Returns True if successfully removed, False if not found.
        """
        with self._lock:
            faiss_id = self.unified_id_to_faiss_id.get(unified_id)
            if faiss_id is None:
                return False

            # Remove from FAISS index
            self.faiss_index.remove_ids(np.array([faiss_id], dtype=np.int64))

            # Clean up mappings
            row_idx = self.id_to_row.pop(faiss_id, None)
            self.unified_id_to_faiss_id.pop(unified_id, None)
            self.faiss_id_to_unified_id.pop(faiss_id, None)

            # Mark row as removed in DataFrame (drop it)
            if row_idx is not None and row_idx in self.df.index:
                self.df.drop(index=row_idx, inplace=True)

            return True

    def update_listing(self, unified_id: str, listing_data: dict) -> int:
        """Update a listing in the FAISS index: remove old vector, add new one.
        
        The listing_data must include all fields needed for feature computation.
        The unified_id is preserved (re-used) so references stay consistent.
        
        Returns the new FAISS integer ID.
        Raises ValueError if the listing is not currently in the index.
        """
        # Remove old entry
        removed = self.remove_listing(unified_id)
        if not removed:
            raise ValueError(f"Listing with unified_id '{unified_id}' not found in index")

        # Re-add with the same unified_id
        listing_data['unified_id'] = unified_id
        return self.add_listing(listing_data)

    def remove_listing_by_property_id(self, property_id: int) -> bool:
        """Remove a listing from the FAISS index by its DB property_id."""
        with self._lock:
            faiss_id = self.property_id_to_faiss_id.get(property_id)
            if faiss_id is None:
                return False

            self.faiss_index.remove_ids(np.array([faiss_id], dtype=np.int64))

            row_idx = self.id_to_row.pop(faiss_id, None)
            uid = self.faiss_id_to_unified_id.pop(faiss_id, None)
            if uid:
                self.unified_id_to_faiss_id.pop(uid, None)
            self.property_id_to_faiss_id.pop(property_id, None)
            self.faiss_id_to_property_id.pop(faiss_id, None)

            if row_idx is not None and row_idx in self.df.index:
                self.df.drop(index=row_idx, inplace=True)

            return True

    def update_listing_by_property_id(self, property_id: int, listing_data: dict) -> int:
        """Update a listing in the FAISS index by its DB property_id."""
        removed = self.remove_listing_by_property_id(property_id)
        if not removed:
            raise ValueError(f"Listing with property_id '{property_id}' not found in index")

        listing_data['property_id'] = property_id
        return self.add_listing(listing_data)

    def recommend_for_user_activities(self, activities: List[Any], top_k: int = 8) -> List[int]:
        """
        Behavior-based recommendation using MARN UserActivities table.
        Returns a list of Property IDs (long/int).
        """
        if not activities or self.faiss_index is None:
            return []
            
        valid_vectors = []
        weights = []
        coords = []
        seen_pids = set()
        
        n_inter = len(activities)
        now = datetime.utcnow()
        
        for i, act in enumerate(activities):
            pid = act.property_id
            vec = None
            coords_val = None
            
            if not pid:
                # Handle search activities
                if act.user_activity_type and act.user_activity_type.lower() == 'search' and act.metadata_json:
                    search_vec, search_coords, s_cities, s_types = self._build_search_vector(act.metadata_json)
                    if search_vec is not None:
                        vec = search_vec[0]
                        coords_val = search_coords
                
                if vec is None:
                    continue
            else:
                faiss_id = self.property_id_to_faiss_id.get(pid)
                if not faiss_id:
                    continue
                    
                idx = self.id_to_row.get(faiss_id)
                if idx is None:
                    continue
                    
                row = self.df.iloc[idx]
                v = self.compute_feature_vector(row)
                vec = v[0]
                coords_val = [row['lat'], row['lng']]
                seen_pids.add(pid)
            
            int_type = act.user_activity_type
            w_type = self.get_interaction_weight(int_type)
            
            created_at = act.created_at
            if created_at:
                age_days = (now - created_at).total_seconds() / (24 * 3600)
                w_final = w_type * (self.recency_decay ** age_days)
            else:
                age = n_inter - 1 - i
                w_final = w_type * (self.recency_decay ** age)
            
            valid_vectors.append(vec)
            weights.append(w_final)
            coords.append(coords_val)
            
        if not valid_vectors:
            return []
            
        # Cluster geographically
        clustering = DBSCAN(eps=0.2, min_samples=1, metric='euclidean').fit(coords)
        labels = clustering.labels_
        unique_labels = set(labels)
        
        all_candidates = []
        
        for label in unique_labels:
            indices = [i for i, x in enumerate(labels) if x == label]
            cluster_vecs = np.array([valid_vectors[i] for i in indices])
            cluster_weights = np.array([weights[i] for i in indices]).reshape(-1, 1)
            
            cluster_score = np.sum(cluster_weights)
            profile_vec = np.sum(cluster_vecs * cluster_weights, axis=0) / cluster_score
            profile_vec = profile_vec.reshape(1, -1).astype('float32')
            faiss.normalize_L2(profile_vec)
            
            # Query FAISS
            D, I = self.faiss_index.search(profile_vec, k=15)
            
            # Gather all searched cities and types from the activities
            all_searched_cities = []
            all_searched_types = []
            for act in activities:
                if act.user_activity_type and act.user_activity_type.lower() == 'search' and act.metadata_json:
                    _, _, s_cities, s_types = self._build_search_vector(act.metadata_json)
                    all_searched_cities.extend(s_cities)
                    all_searched_types.extend(s_types)
            all_searched_cities = set(all_searched_cities)
            all_searched_types = set(all_searched_types)
            
            for rank, (faiss_id, dist) in enumerate(zip(I[0], D[0])):
                if faiss_id == -1:
                    continue
                pid = self.faiss_id_to_property_id.get(faiss_id)
                if not pid or pid in seen_pids:
                    continue
                    
                distance = max(0.0, 1.0 - dist)
                score = cluster_score * (1 / (distance + 0.01))
                
                # Soft boost based on search criteria
                idx = self.id_to_row.get(faiss_id)
                if idx is not None:
                    row = self.df.iloc[idx]
                    candidate_city = str(row.get('city', '')).strip().lower()
                    candidate_type = str(row.get('type', '')).strip().lower()
                    
                    if candidate_city in all_searched_cities:
                        score *= 1.5
                    if candidate_type in all_searched_types:
                        score *= 1.3
                
                all_candidates.append({
                    'pid': pid,
                    'score': score
                })
                
        all_candidates.sort(key=lambda x: x['score'], reverse=True)
        
        results = []
        added_pids = set(seen_pids)
        
        for cand in all_candidates:
            if len(results) >= top_k:
                break
            pid = cand['pid']
            if pid in added_pids:
                continue
                
            results.append(pid)
            added_pids.add(pid)
            
        return results
        """
        Behavior-based recommendation:
        1. Extract vectors and weights for interactions
        2. DBSCAN cluster geographically
        3. Compute profile per cluster and query FAISS
        4. Merge, score, and return top_k
        """
        if not interactions or self.faiss_index is None:
            return []
            
        valid_vectors = []
        weights = []
        coords = []
        seen_uids = set()
        
        n_inter = len(interactions)
        
        now = datetime.utcnow()
        for i, inter in enumerate(interactions):
            uid = inter.get('unified_id')
            faiss_id = self.unified_id_to_faiss_id.get(uid)
            if not faiss_id:
                continue
                
            idx = self.id_to_row.get(faiss_id)
            if idx is None:
                continue
                
            row = self.df.iloc[idx]
            vec = self.compute_feature_vector(row)
            
            int_type = inter.get('interaction_type', inter.get('type', 'view'))
            w_type = self.get_interaction_weight(int_type)
            
            created_at = inter.get('created_at')
            if created_at:
                age_days = (now - created_at).total_seconds() / (24 * 3600)
                w_final = w_type * (self.recency_decay ** age_days)
            else:
                age = n_inter - 1 - i
                w_final = w_type * (self.recency_decay ** age)
            
            valid_vectors.append(vec[0])
            weights.append(w_final)
            coords.append([row['lat'], row['lng']])
            seen_uids.add(uid)
            
        if not valid_vectors:
            return []
            
        # Cluster geographically
        clustering = DBSCAN(eps=0.2, min_samples=1, metric='euclidean').fit(coords)
        labels = clustering.labels_
        unique_labels = set(labels)
        
        all_candidates = []
        
        for label in unique_labels:
            indices = [i for i, x in enumerate(labels) if x == label]
            cluster_vecs = np.array([valid_vectors[i] for i in indices])
            cluster_weights = np.array([weights[i] for i in indices]).reshape(-1, 1)
            
            cluster_score = np.sum(cluster_weights)
            profile_vec = np.sum(cluster_vecs * cluster_weights, axis=0) / cluster_score
            profile_vec = profile_vec.reshape(1, -1).astype('float32')
            faiss.normalize_L2(profile_vec)
            
            # Query FAISS
            D, I = self.faiss_index.search(profile_vec, k=15)
            
            for rank, (faiss_id, dist) in enumerate(zip(I[0], D[0])):
                if faiss_id == -1:
                    continue
                uid = self.faiss_id_to_unified_id.get(faiss_id)
                if uid in seen_uids:
                    continue
                    
                # For inner product, dist is cosine similarity (higher is better)
                # To match POC logic, we treat dist as distance (1 - similarity)
                distance = max(0.0, 1.0 - dist)
                score = cluster_score * (1 / (distance + 0.01))
                
                all_candidates.append({
                    'faiss_id': faiss_id,
                    'score': score,
                    'cluster': label
                })
                
        # Sort and return
        all_candidates.sort(key=lambda x: x['score'], reverse=True)
        
        results = []
        added_uids = set(seen_uids)
        
        for cand in all_candidates:
            if len(results) >= top_k:
                break
            faiss_id = cand['faiss_id']
            uid = self.faiss_id_to_unified_id.get(faiss_id)
            if uid in added_uids:
                continue
                
            idx = self.id_to_row.get(faiss_id)
            row = self.df.iloc[idx].to_dict()
            row['score'] = cand['score']
            results.append(row)
            added_uids.add(uid)
            
        return results

    def search_by_criteria(self, top_k: int = 5, **kwargs) -> List[Dict]:
        """Criteria-based FAISS search on filtered subset."""
        if self.df is None or self.faiss_index is None:
            return []
            
        mask = pd.Series(True, index=self.df.index)
        
        if kwargs.get('city'):
            mask &= self.df['city'].astype(str).str.strip().str.lower() == str(kwargs['city']).strip().lower()
        if kwargs.get('property_type'):
            mask &= self.df['type'].astype(str).str.strip().str.lower() == str(kwargs['property_type']).strip().lower()
            
        subset = self.df[mask]
        if len(subset) == 0:
            return []
            
        # Build query vector
        query_raw = {}
        for col in self.numeric_cols:
            val = kwargs.get(col)
            query_raw[col] = val if val is not None else subset[col].median()
            
        query_series = pd.Series(query_raw)
        query_vec = self.compute_feature_vector(query_series)
        
        # Search global index, filter by subset
        D, I = self.faiss_index.search(query_vec, k=min(top_k * 5, self.faiss_index.ntotal))
        
        results = []
        for faiss_id, dist in zip(I[0], D[0]):
            if faiss_id == -1:
                continue
            idx = self.id_to_row.get(faiss_id)
            if idx in subset.index:
                row = self.df.iloc[idx].to_dict()
                row['score'] = float(dist)
                results.append(row)
                if len(results) >= top_k:
                    break
                    
        return results

    def get_similar_listings(self, unified_id: str, top_k: int = 5) -> List[Dict]:
        faiss_id = self.unified_id_to_faiss_id.get(unified_id)
        if not faiss_id:
            return []
            
        idx = self.id_to_row.get(faiss_id)
        row = self.df.iloc[idx]
        query_vec = self.compute_feature_vector(row)
        
        D, I = self.faiss_index.search(query_vec, k=top_k + 1)
        
        results = []
        for f_id, dist in zip(I[0], D[0]):
            if f_id == -1 or f_id == faiss_id:
                continue
            r_idx = self.id_to_row.get(f_id)
            r = self.df.iloc[r_idx].to_dict()
            r['score'] = float(dist)
            results.append(r)
            if len(results) >= top_k:
                break
        return results
