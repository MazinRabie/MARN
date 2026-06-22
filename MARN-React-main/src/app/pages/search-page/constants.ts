import type { SortBy, PropertyType, RentalUnit } from '@/types/property'

export const PAGE_SIZE = 9

export type SortOption = {
  label: string
  key: string
  sortBy: SortBy
  sortAscending: boolean
}

export const SORT_OPTIONS: SortOption[] = [
  { label: 'Newest First', key: 'newestFirst', sortBy: 'Newest', sortAscending: false },
  { label: 'Price: Low to High', key: 'priceAsc', sortBy: 'Price', sortAscending: true },
  { label: 'Price: High to Low', key: 'priceDesc', sortBy: 'Price', sortAscending: false },
  { label: 'Highest Rated', key: 'highestRated', sortBy: 'Rating', sortAscending: false },
  { label: 'Most Bedrooms', key: 'mostBedrooms', sortBy: 'Bedrooms', sortAscending: false },
  { label: 'Most Bathrooms', key: 'mostBathrooms', sortBy: 'Bathrooms', sortAscending: false },
  { label: 'Largest Area', key: 'largestArea', sortBy: 'SquareMeters', sortAscending: false },
  { label: 'Nearest', key: 'nearest', sortBy: 'Distance', sortAscending: true },
]

export const PROPERTY_TYPES: PropertyType[] = [
  'Apartment',
  'House',
  'Room',
  'SharedRoom',
]

export const RENTAL_UNITS: { label: string; value: RentalUnit }[] = [
  { label: 'Daily', value: 'Daily' },
  { label: 'Monthly', value: 'Monthly' },
  { label: 'Yearly', value: 'Yearly' },
]

export const BED_OPTIONS = ['Any', '1', '2', '3', '4+']
export const BATH_OPTIONS = ['Any', '1', '2', '3+']
export const SHARED_OPTIONS = [
  { label: 'Any', value: '' },
  { label: 'Private', value: 'false' },
  { label: 'Shared', value: 'true' },
]
