import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ["DATABASE_MODE"] = "remote"
from db.engine import SessionLocal
from db.models import MarnProperty, UserActivity
import uuid
from data_loader import load_data
from services.recommendation_service import RecommendationService
lis = ["12121212-1212-1212-1212-121212121212",
"13131313-1313-1313-1313-131313131313",
"14141414-1414-1414-1414-141414141414",
"15151515-1515-1515-1515-151515151515",
"16161616-1616-1616-1616-161616161616"]
for user_id in lis:
    USER_ID = user_id
    user_uuid = uuid.UUID(USER_ID)
    db = SessionLocal()
    print("=== User's Search Activities ===")
    activities = db.query(UserActivity).filter(
        UserActivity.user_id == user_uuid,
        UserActivity.user_activity_type == 'search'
    ).order_by(UserActivity.created_at.desc()).all()
    for act in activities:
        print(f"Metadata: {act.metadata_json}")
    bundle = load_data()
    service = RecommendationService()
    service.initialize_from_bundle(bundle)
    all_activities = db.query(UserActivity).filter(
        UserActivity.user_id == user_uuid
    ).order_by(UserActivity.created_at.desc()).limit(50).all()
    rec_ids = service.recommend_for_user_activities(all_activities, top_k=8)
    print(f"\n=== Recommended Properties {rec_ids} ===")
    PROPERTY_TYPE_MAP = {0: "Apartment", 1: "House", 2: "Room", 3: "Villa", 4: "Studio", 5: "SharedRoom"}
    for pid in rec_ids:
        prop = db.query(MarnProperty).filter(MarnProperty.id == pid).first()
        if prop:
            ptype = PROPERTY_TYPE_MAP.get(prop.type, "Unknown")
            print(f"ID: {prop.id} | City: {prop.city} | Type: {ptype} | Price: {prop.price} | Beds: {prop.bedrooms} | Area: {prop.square_meters} | Title: {prop.title[:30]}")
db.close()