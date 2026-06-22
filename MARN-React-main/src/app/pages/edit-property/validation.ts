import { PropertyFormData } from './types'

export interface ValidationError {
  step: number
  stepName: string
  field: string
  label: string
}

export function validateForm(data: PropertyFormData): ValidationError[] {
  const errors: ValidationError[] = []

  // Step 1: Property Details
  if (!data.title?.trim() || data.title.length < 10 || data.title.length > 100) {
    errors.push({ step: 1, stepName: 'Property Details', field: 'title', label: 'Property Title (10-100 characters)' })
  }
  if (!data.type?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'type', label: 'Property Type' })
  if (!data.address?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'address', label: 'Street Address' })
  if (!data.city?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'city', label: 'City' })
  if (!data.governorate?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'governorate', label: 'Governorate' })
  if (!data.zip?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'zip', label: 'ZIP Code' })
  if (!data.bedrooms?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'bedrooms', label: 'Bedrooms' })
  if (!data.beds?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'beds', label: 'Beds' })
  if (!data.baths?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'baths', label: 'Bathrooms' })
  if (!data.sqm?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'sqm', label: 'Square Meters' })
  if (!data.description?.trim() || data.description.length < 20 || data.description.length > 2000) {
    errors.push({ step: 1, stepName: 'Property Details', field: 'description', label: 'Description (20-2000 characters)' })
  }
  if (!data.numPeople?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'numPeople', label: 'Number of People (Max Occupants)' })
  if (!data.occupancyPreference?.trim()) errors.push({ step: 1, stepName: 'Property Details', field: 'occupancyPreference', label: 'Occupancy Preference (Is Shared)' })

  // Step 3: Photos (PrimaryImage)
  const hasNewPhotos = data.photos && data.photos.length > 0
  const hasExistingPrimary = !!data.existingPrimaryImageUrl
  if (!hasNewPhotos && !hasExistingPrimary) {
    errors.push({ step: 3, stepName: 'Photos', field: 'photos', label: 'Primary Image' })
  }

  // Step 4: Pricing
  const hasRent = !!data.price?.trim()
  if (!hasRent) {
    errors.push({ step: 4, stepName: 'Pricing Configuration', field: 'price', label: 'Rental Price' })
  }

  // Step 6: Legal Docs (ProofOfOwnership)
  const hasNewDocs = data.legalDocs && data.legalDocs.length > 0
  const hasExistingDocs = !!data.existingProofOfOwnershipUrl
  if (!hasNewDocs && !hasExistingDocs) {
    errors.push({ step: 6, stepName: 'Legal Documents', field: 'legalDocs', label: 'Proof of Ownership' })
  }

  return errors
}
