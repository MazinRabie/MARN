export type RentalStatus = 'pending' | 'accepted' | 'rejected' | 'cancelled'
export type ContractStatus = 'Active' | 'Expired' | 'Pending' | 'Terminated'

export interface BookingRequest {
  id: string
  propertyId: string
  property: string
  tenantId: string
  tenant: string
  tenantAvatarUrl?: string
  requestedDates: string
  moveIn: string
  monthlyRent: number
  status: RentalStatus
  message?: string
  createdAt?: string
}

export interface Contract {
  id: string
  propertyId: string
  propertyName: string
  tenantId: string
  tenantName: string
  ownerId: string
  ownerName?: string
  monthlyRent: number
  startDate: string
  expiryDate: string
  status: ContractStatus
  documentUrl?: string
}

export interface Rental {
  id: string
  propertyId: string
  propertyName: string
  propertyImage?: string
  tenantId: string
  monthlyRent: number
  startDate: string
  endDate: string
  status: ContractStatus
}
