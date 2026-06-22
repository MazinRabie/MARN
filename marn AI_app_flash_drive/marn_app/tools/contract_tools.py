from langchain_core.tools import tool
from langchain_core.runnables.config import RunnableConfig
from sqlalchemy import select

from db.models import Contract, MarnProperty

@tool
def get_my_contracts(config: RunnableConfig) -> str:
    """Get the current user's rental contracts. Use this when the user asks about their contracts."""
    user_id = config.get("configurable", {}).get("user_id")
    db = config.get("configurable", {}).get("db")
    
    if not user_id or not db:
        return "Error: Missing user context or database connection."
        
    contracts = db.execute(
        select(Contract).where(Contract.renter_id == user_id)
    ).scalars().all()
    
    if not contracts:
        return "You have no rental contracts."
        
    status_map = {0: "Pending", 1: "Active", 2: "Cancelled", 3: "Expired"}
    freq_map = {0: "One-Time", 1: "Monthly", 2: "Quarterly", 3: "Yearly"}
    
    result = "Your Contracts:\n"
    for contract in contracts:
        status_str = status_map.get(contract.status, "Unknown")
        freq_str = freq_map.get(contract.payment_frequency, "Unknown")
        
        listing = db.query(MarnProperty).filter(MarnProperty.id == contract.property_id).first()
        listing_title = listing.title if listing else f"Property ID {contract.property_id}"
        
        result += (
            f"- Contract [{contract.id}] for **{listing_title}**\n"
            f"  Status: {status_str} | Frequency: {freq_str} | Amount: {contract.total_contract_amount} EGP\n"
            f"  Duration: {contract.lease_start_date} to {contract.lease_end_date}\n\n"
        )
    return result
