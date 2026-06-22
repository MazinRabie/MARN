export interface FileData {
  name: string
  dataUrl: string
  type: string
  size: number
  file?: File
}

export interface ExistingMedia {
  id: number
  path: string
}

export interface ExistingRule {
  id: number
  ruleDisplayName: string
  rule: string
}

export interface ExistingAmenity {
  id: number
  amenityDisplayName: string
  amenity: string
}

export interface PropertyFormData {
  // Step 1: Property Details
  title: string
  type: string
  address: string
  city: string
  governorate: string
  zip: string
  bedrooms: string
  beds: string
  baths: string
  sqm: string
  description: string
  numPeople: string
  occupancyPreference: string
  mapLocation: { lat: number; lng: number }

  // Step 2: Amenities
  selectedAmenities: string[]
  additionalAmenities: string[]

  // Step 3: Photos
  photos: FileData[]

  // Step 4: Pricing
  price: string
  deposit: string
  utilities: string[]

  // Step 5: Availability
  availableFrom: string
  leaseDuration: string
  tenantPreferences: string[]
  customPreferences: string[]

  // Step 6: Legal Docs
  legalDocs: FileData[]

  // Edit State
  existingPhotos?: ExistingMedia[]
  removedMediaIds?: number[]
  existingRules?: ExistingRule[]
  removedRuleIds?: number[]
  existingAmenities?: ExistingAmenity[]
  removedAmenityIds?: number[]
  existingPrimaryImageUrl?: string
  existingProofOfOwnershipUrl?: string
}

export type TouchedFields = Partial<Record<keyof PropertyFormData | 'rent', boolean>>
