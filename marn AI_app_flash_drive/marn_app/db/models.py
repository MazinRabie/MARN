from sqlalchemy import String, Integer, Float, Boolean, DateTime, ForeignKey, Text, Date, BigInteger, Numeric
from sqlalchemy.orm import DeclarativeBase, mapped_column, Mapped, relationship
from sqlalchemy.dialects.mssql import UNIQUEIDENTIFIER
from datetime import datetime, date
from typing import List, Optional
import uuid

class Base(DeclarativeBase):
    pass

class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(100))
    email: Mapped[str] = mapped_column(String(255), unique=True)
    phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    role: Mapped[str] = mapped_column(String(20)) # 'buyer', 'seller', or 'admin'
    preferred_city: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    preferred_budget: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    language: Mapped[Optional[str]] = mapped_column(String(5), nullable=True) # 'ar' or 'en'
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    listings: Mapped[List["Listing"]] = relationship("Listing", back_populates="owner")
    favorites: Mapped[List["Favorite"]] = relationship("Favorite", back_populates="user")
    bookings: Mapped[List["Booking"]] = relationship("Booking", back_populates="buyer")
    chat_sessions: Mapped[List["ChatSession"]] = relationship("ChatSession", back_populates="user")
    interactions: Mapped[List["UserInteraction"]] = relationship("UserInteraction", back_populates="user")

class Listing(Base):
    __tablename__ = "listings"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, default=uuid.uuid4)
    owner_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"))
    title: Mapped[str] = mapped_column(String(200))
    price: Mapped[int] = mapped_column(Integer)
    area: Mapped[float] = mapped_column(Float)
    bedrooms: Mapped[int] = mapped_column(Integer)
    bathrooms: Mapped[int] = mapped_column(Integer)
    city: Mapped[str] = mapped_column(String(50))
    region: Mapped[str] = mapped_column(String(100))
    property_type: Mapped[str] = mapped_column(String(20))
    furnished: Mapped[bool] = mapped_column(Boolean)
    status: Mapped[str] = mapped_column(String(20), default="active")
    views_count: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    owner: Mapped["User"] = relationship("User", back_populates="listings")
    favorited_by: Mapped[List["Favorite"]] = relationship("Favorite", back_populates="listing")
    bookings: Mapped[List["Booking"]] = relationship("Booking", back_populates="listing")

class Favorite(Base):
    __tablename__ = "favorites"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"))
    listing_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("listings.id"))
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    user: Mapped["User"] = relationship("User", back_populates="favorites")
    listing: Mapped["Listing"] = relationship("Listing", back_populates="favorited_by")

class Booking(Base):
    __tablename__ = "bookings"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, default=uuid.uuid4)
    buyer_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"))
    listing_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("listings.id"))
    preferred_date: Mapped[date] = mapped_column(Date)
    status: Mapped[str] = mapped_column(String(20), default="pending")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    buyer: Mapped["User"] = relationship("User", back_populates="bookings")
    listing: Mapped["Listing"] = relationship("Listing", back_populates="bookings")

class ChatSession(Base):
    __tablename__ = "chat_sessions"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"))
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    last_message_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    user: Mapped["User"] = relationship("User", back_populates="chat_sessions")
    messages: Mapped[List["ChatMessage"]] = relationship("ChatMessage", back_populates="session", cascade="all, delete-orphan")

class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, default=uuid.uuid4)
    session_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("chat_sessions.id"))
    role: Mapped[str] = mapped_column(String(10)) # 'human' or 'ai'
    content: Mapped[str] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    session: Mapped["ChatSession"] = relationship("ChatSession", back_populates="messages")

class UserInteraction(Base):
    __tablename__ = "user_interactions"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"))
    unified_id: Mapped[str] = mapped_column(String(100))         # CSV unified_id
    listing_id: Mapped[Optional[uuid.UUID]] = mapped_column(     # DB listing UUID (nullable)
        ForeignKey("listings.id"), nullable=True
    )
    interaction_type: Mapped[str] = mapped_column(String(20))    # 'view', 'save', 'contact', 'share', 'search', 'rent'
    interaction_metadata: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    user: Mapped["User"] = relationship("User", back_populates="interactions")


class MarnProperty(Base):
    """Read-only mapping to MARN's Properties table."""
    __tablename__ = "Properties"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, name="Id")
    title: Mapped[str] = mapped_column(String(200), name="Title")
    description: Mapped[str] = mapped_column(Text, name="Description")
    type: Mapped[int] = mapped_column(Integer, name="Type")          # PropertyType enum int
    price: Mapped[float] = mapped_column(Numeric(18, 2), name="Price")
    square_meters: Mapped[float] = mapped_column(Float, name="SquareMeters")
    bedrooms: Mapped[int] = mapped_column(Integer, name="Bedrooms")
    beds: Mapped[int] = mapped_column(Integer, name="Beds")
    bathrooms: Mapped[int] = mapped_column(Integer, name="Bathrooms")
    max_occupants: Mapped[int] = mapped_column(Integer, name="MaxOccupants")
    is_shared: Mapped[bool] = mapped_column(Boolean, name="IsShared")
    latitude: Mapped[float] = mapped_column(Float, name="Latitude")
    longitude: Mapped[float] = mapped_column(Float, name="Longitude")
    city: Mapped[Optional[str]] = mapped_column(String(100), name="City", nullable=True)
    state: Mapped[Optional[str]] = mapped_column(String(100), name="State", nullable=True)
    address: Mapped[str] = mapped_column(String(500), name="Address")
    views: Mapped[int] = mapped_column(Integer, name="Views", default=0)
    rental_unit: Mapped[int] = mapped_column(Integer, name="RentalUnit")
    is_active: Mapped[bool] = mapped_column(Boolean, name="IsActive")
    status: Mapped[int] = mapped_column(Integer, name="Status")      # PropertyStatus enum int
    created_at: Mapped[datetime] = mapped_column(DateTime, name="CreatedAt")
    deleted_at: Mapped[Optional[datetime]] = mapped_column(DateTime, name="DeletedAt", nullable=True)
    owner_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, name="OwnerId")


class UserActivity(Base):
    """Read-only mapping to MARN's UserActivities table."""
    __tablename__ = "UserActivities"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, name="Id")
    user_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, name="UserId")
    property_id: Mapped[Optional[int]] = mapped_column(BigInteger, name="PropertyId", nullable=True)
    user_activity_type: Mapped[str] = mapped_column(String(20), name="UserActivityType")
    metadata_json: Mapped[Optional[str]] = mapped_column(Text, name="Metadata", nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, name="CreatedAt")

class AspNetUser(Base):
    """Read-only mapping to the main backend's AspNetUsers table."""
    __tablename__ = "AspNetUsers"

    id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, name="Id")
    first_name: Mapped[Optional[str]] = mapped_column(String(256), name="FirstName", nullable=True)
    last_name: Mapped[Optional[str]] = mapped_column(String(256), name="LastName", nullable=True)
    email: Mapped[Optional[str]] = mapped_column(String(256), name="Email", nullable=True)
    language: Mapped[int] = mapped_column(Integer, name="Language", default=0) # 0=English, 1=Arabic
    gender: Mapped[int] = mapped_column(Integer, name="Gender", default=0) # 0=Unknown, 1=Male, 2=Female
    country: Mapped[int] = mapped_column(Integer, name="Country", default=0)

class AssistantSession(Base):
    """Mapping to the assistantSessions table from main backend."""
    __tablename__ = "assistantSessions"

    session_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, name="SessionId", default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, name="UserId")
    session_name: Mapped[Optional[str]] = mapped_column(String(200), name="SessionName", nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, name="CreatedAt", default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime, name="UpdatedAt", default=datetime.utcnow)

class AssistantMessage(Base):
    """Mapping to the assistantMessages table (reads context, inserts tool calls/responses)."""
    __tablename__ = "assistantMessages"

    message_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, name="MessageId", default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, name="UserId")
    session_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, name="SessionId")
    role: Mapped[str] = mapped_column(String(20), name="Role") # 'user', 'assistant', 'tool'
    tool_only: Mapped[bool] = mapped_column(Boolean, name="ToolOnly", default=False)
    content: Mapped[str] = mapped_column(Text, name="Content")
    created_at: Mapped[datetime] = mapped_column(DateTime, name="CreatedAt", default=datetime.utcnow)

class SavedProperty(Base):
    """Mapping to the main backend's SavedProperties table."""
    __tablename__ = "SavedProperties"

    property_id: Mapped[int] = mapped_column(BigInteger, primary_key=True, name="PropertyId")
    user_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, primary_key=True, name="UserId")

class Contract(Base):
    """Mapping to the main backend's Contracts table."""
    __tablename__ = "Contracts"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, name="Id")
    property_id: Mapped[int] = mapped_column(BigInteger, name="PropertyId")
    renter_id: Mapped[uuid.UUID] = mapped_column(UNIQUEIDENTIFIER, name="RenterId")
    status: Mapped[int] = mapped_column(Integer, name="Status") # 0=Pending, 1=Active, 2=Cancelled, 3=Expired
    created_at: Mapped[datetime] = mapped_column(DateTime, name="CreatedAt")
    payment_frequency: Mapped[int] = mapped_column(Integer, name="PaymentFrequency")
    total_contract_amount: Mapped[float] = mapped_column(Numeric(18, 2), name="TotalContractAmount")
    lease_start_date: Mapped[date] = mapped_column(Date, name="LeaseStartDate")
    lease_end_date: Mapped[date] = mapped_column(Date, name="LeaseEndDate")

class PropertyMedia(Base):
    """Mapping to the main backend's PropertyMedia table."""
    __tablename__ = "PropertyMedia"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, name="Id")
    property_id: Mapped[int] = mapped_column(BigInteger, name="PropertyId")
    path: Mapped[str] = mapped_column(String(500), name="Path")
    is_primary: Mapped[bool] = mapped_column(Boolean, name="IsPrimary", default=False)

