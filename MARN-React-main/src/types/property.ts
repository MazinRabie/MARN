export type PropertyStatus = 'available' | 'rented' | 'pending' | 'inactive' | 'Occupied' | 'occupied'

export type PropertyType =
  | 'Apartment'
  | 'House'
  | 'Room'
  | 'SharedRoom'

export type RentalUnit = 'Daily' | 'Monthly' | 'Quarterly' | 'Yearly'

export type SortBy =
  | 'Newest'
  | 'Price'
  | 'Rating'
  | 'Bedrooms'
  | 'Bathrooms'
  | 'SquareMeters'
  | 'Distance'

export const AMENITY_OPTIONS = [
  'Wifi',
  'Parking',
  'AirConditioning',
  'Heating',
  'Tv',
  'Elevator',
  'Pool',
  'Gym',
  'Kitchen',
  'Dishwasher',
  'Microwave',
  'Refrigerator',
  'Washer',
  'Dryer',
  'Balcony',
  'HardwoodFloors',
  'StorageSpace',
  'SecuritySystem',
] as const

export type Amenity = (typeof AMENITY_OPTIONS)[number]

/** Human-readable labels for amenity values */
export const AMENITY_LABELS: Record<Amenity, string> = {
  Wifi: 'WiFi',
  Parking: 'Parking',
  AirConditioning: 'Air Conditioning',
  Heating: 'Heating',
  Tv: 'TV',
  Elevator: 'Elevator',
  Pool: 'Pool',
  Gym: 'Gym',
  Kitchen: 'Kitchen',
  Dishwasher: 'Dishwasher',
  Microwave: 'Microwave',
  Refrigerator: 'Refrigerator',
  Washer: 'Washer',
  Dryer: 'Dryer',
  Balcony: 'Balcony',
  HardwoodFloors: 'Hardwood Floors',
  StorageSpace: 'Storage Space',
  SecuritySystem: 'Security System',
}

export interface Property {
  id: string
  title: string
  description?: string
  type: PropertyType
  typeDisplayName?: string
  status: PropertyStatus
  location: string
  address?: string
  city?: string
  cityDisplayName?: string
  governorate?: string
  governorateDisplayName?: string
  zipCode?: string
  price: number
  beds: number
  bedrooms?: number
  baths: number
  bathrooms?: number
  guests: number
  area?: number
  squareMeters?: number
  images?: string[]
  /** Primary listing image — first entry of images or standalone thumbnail. */
  image?: string
  imagePath?: string
  amenities: any[]
  rules?: any[]
  rating?: number
  averageRating?: number
  reviews?: number
  ratingsCount?: number
  ownerId?: string
  ownerName?: string
  ownerAvatarUrl?: string
  ownerBio?: string
  hostId?: string
  hostName?: string
  hostProfileImage?: string
  hostBio?: string
  hostedBy?: {
    id: string
    fullName: string
    profileImage: string
    averageRating: number
    propertiesCount: number
    bio: string
  }
  propertiesCount?: number
  featured?: boolean
  isShared?: boolean
  rentalUnit?: RentalUnit
  rentalUnitDisplayName?: string
  latitude?: number
  longitude?: number
  createdAt?: string
  updatedAt?: string
  isSaved?: boolean
  maxOccupants?: number
  currentOccupantsCount?: number
  isActive?: boolean
  availability?: boolean
  tenants?: Array<{
    id: string
    fullName: string
    profileImage?: string
  }>
  activeRenters?: Array<{
    id: string
    name: string
    profilePhoto?: string
    matchingPercentage?: number
  }>
  comments?: any[]
  ownerEmail?: string
  hostEmail?: string
}

/** Lightweight shape returned by GET /api/Property/search */
export interface SearchProperty {
  id: number
  imagePath: string
  title: string
  address: string
  latitude?: number
  longitude?: number
  bedrooms: number
  bathrooms: number
  maxOccupants: number
  type: PropertyType
  typeDisplayName?: string
  averageRating: number
  ratings: number
  price: number
  rentalUnit: RentalUnit
  rentalUnitDisplayName?: string
  isSaved: boolean
}

export interface PropertyFilters {
  // text / geo
  keyword?: string
  latitude?: number
  longitude?: number
  radiusKm?: number
  // location enums
  city?: string
  governorate?: string
  // property attributes
  type?: PropertyType
  rentalUnit?: RentalUnit
  isShared?: boolean
  // price
  minPrice?: number
  maxPrice?: number
  // rooms
  minBedrooms?: number
  minBeds?: number
  minBathrooms?: number
  minMaxOccupants?: number
  // area
  minSquareMeters?: number
  maxSquareMeters?: number
  // rating
  minRating?: number
  // amenities (multi-select)
  amenities?: string[]
  // sorting
  sortBy?: SortBy
  sortAscending?: boolean
  // pagination
  page?: number
  pageSize?: number
  // legacy / compat fields kept for other callers
  search?: string
  location?: string
  beds?: number
  baths?: number
  featured?: boolean
}
