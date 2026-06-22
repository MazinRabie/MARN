import { useState, useCallback, useEffect } from 'react'
import { useSearchParams } from 'react-router'
import type { PropertyFilters, PropertyType, RentalUnit, SortBy } from '@/types/property'
import { AMENITY_OPTIONS } from '@/types/property'
import { SORT_OPTIONS, PAGE_SIZE } from './constants'

export function useSearchFilters() {
  const [searchParams, setSearchParams] = useSearchParams()
  const initialKeyword = searchParams.get('q') || ''

  // ── search & geo ───────────────────────────────────────────────────────────
  const [keyword, setKeyword] = useState(initialKeyword)
  const [committedKw, setCommittedKw] = useState(initialKeyword)

  useEffect(() => {
    const q = searchParams.get('q') || ''
    setKeyword(q)
    setCommittedKw(q)
  }, [searchParams])

  // ── location enums ─────────────────────────────────────────────────────────
  const [city, setCity] = useState<string>('')
  const [governorate, setGovernorate] = useState<string>('')

  const handleSetGovernorate = useCallback((v: string) => {
    setGovernorate(v)
    setCity('') // clear city when governorate changes
    setPage(1)
  }, [])

  // ── property filters ───────────────────────────────────────────────────────
  const [propertyType, setPropertyType] = useState<PropertyType | ''>('')
  const [rentalUnit, setRentalUnit] = useState<RentalUnit | ''>('')
  const [isShared, setIsShared] = useState<string>('')

  // ── price ──────────────────────────────────────────────────────────────────
  const [priceRange, setPriceRange] = useState([0, 100000])
  const [committedPriceRange, setCommittedPriceRange] = useState([0, 100000])

  // ── rooms ──────────────────────────────────────────────────────────────────
  const [selectedBeds, setSelectedBeds] = useState('Any')
  const [selectedBaths, setSelectedBaths] = useState('Any')

  // ── area ───────────────────────────────────────────────────────────────────
  const [minArea, setMinArea] = useState<string>('')
  const [maxArea, setMaxArea] = useState<string>('')

  // ── rating ─────────────────────────────────────────────────────────────────
  const [minRating, setMinRating] = useState<string>('')

  // ── amenities ──────────────────────────────────────────────────────────────
  const [selectedAmenities, setSelectedAmenities] = useState<string[]>([])

  // ── sorting ────────────────────────────────────────────────────────────────
  const [sortBy, setSortBy] = useState<SortBy>('Newest')
  const [sortAscending, setSortAscending] = useState<boolean>(false)

  // ── pagination & UI ────────────────────────────────────────────────────────
  const [page, setPage] = useState(1)
  const [showMap, setShowMap] = useState(false)
  const [amenitiesExpanded, setAmenitiesExpanded] = useState(false)

  // ── geo-search (postal code / my location) ─────────────────────────────────
  const [userLat, setUserLat] = useState<number | undefined>(undefined)
  const [userLng, setUserLng] = useState<number | undefined>(undefined)
  const [radiusKm, setRadiusKm] = useState(10)
  const [locationLabel, setLocationLabel] = useState('')

  // ── build filters ──────────────────────────────────────────────────────────

  const filters: PropertyFilters = {
    keyword: committedKw || undefined,
    city: city || undefined,
    governorate: governorate || undefined,
    type: (propertyType as PropertyType) || undefined,
    rentalUnit: (rentalUnit as RentalUnit) || undefined,
    isShared: isShared === '' ? undefined : isShared === 'true',
    minPrice: committedPriceRange[0] === 0 ? undefined : committedPriceRange[0],
    maxPrice: committedPriceRange[1] === 100000 ? undefined : committedPriceRange[1],
    minBedrooms:
      selectedBeds !== 'Any'
        ? parseInt(selectedBeds.replace('+', ''))
        : undefined,
    minBathrooms:
      selectedBaths !== 'Any'
        ? parseInt(selectedBaths.replace('+', ''))
        : undefined,
    minSquareMeters: minArea ? parseFloat(minArea) : undefined,
    maxSquareMeters: maxArea ? parseFloat(maxArea) : undefined,
    minRating: minRating ? parseFloat(minRating) : undefined,
    amenities: selectedAmenities.length ? selectedAmenities : undefined,
    sortBy,
    sortAscending,
    // geo-search
    latitude: userLat,
    longitude: userLng,
    radiusKm: userLat !== undefined ? radiusKm : undefined,
    page,
    pageSize: PAGE_SIZE,
  }

  // ── helpers ────────────────────────────────────────────────────────────────
  const toggleAmenity = useCallback((amenity: string) => {
    setSelectedAmenities((prev) =>
      prev.includes(amenity)
        ? prev.filter((a) => a !== amenity)
        : [...prev, amenity],
    )
    setPage(1)
  }, [])

  const resetFilters = useCallback(() => {
    setKeyword('')
    setCommittedKw('')
    setCity('')
    setGovernorate('')
    setPropertyType('')
    setRentalUnit('')
    setIsShared('')
    setPriceRange([0, 100000])
    setCommittedPriceRange([0, 100000])
    setSelectedBeds('Any')
    setSelectedBaths('Any')
    setMinArea('')
    setMaxArea('')
    setMinRating('')
    setSelectedAmenities([])
    setSortBy('Newest')
    setSortAscending(false)
    setPage(1)
    // clear geo
    setUserLat(undefined)
    setUserLng(undefined)
    setRadiusKm(10)
    setLocationLabel('')

    setSearchParams(new URLSearchParams(), { replace: true })
  }, [setSearchParams])

  const setUserLocation = useCallback(
    (lat: number, lng: number, label: string) => {
      setUserLat(lat)
      setUserLng(lng)
      setLocationLabel(label)
      setPage(1)
      // Auto-switch to "Nearest" sort
      setSortBy('Distance')
      setSortAscending(true)
    },
    [],
  )

  const clearUserLocation = useCallback(() => {
    setUserLat(undefined)
    setUserLng(undefined)
    setLocationLabel('')
    setPage(1)
  }, [])

  const commitKeyword = useCallback((kw: string) => {
    setCommittedKw(kw)
    setPage(1)
    
    setSearchParams((prev) => {
      const next = new URLSearchParams(prev)
      if (kw) {
        next.set('q', kw)
      } else {
        next.delete('q')
      }
      return next
    }, { replace: true })
  }, [setSearchParams])

  const activeFilterCount = [
    committedKw,
    city,
    governorate,
    propertyType,
    rentalUnit,
    isShared,
    selectedBeds !== 'Any',
    selectedBaths !== 'Any',
    minArea,
    maxArea,
    minRating,
    (committedPriceRange[0] > 0 || committedPriceRange[1] < 100000),
    ...selectedAmenities,
  ].filter(Boolean).length

  const visibleAmenities = amenitiesExpanded
    ? AMENITY_OPTIONS
    : AMENITY_OPTIONS.slice(0, 6)

  return {
    // State
    keyword,
    setKeyword,
    committedKw,
    city,
    setCity,
    governorate,
    setGovernorate: handleSetGovernorate,
    propertyType,
    setPropertyType,
    rentalUnit,
    setRentalUnit,
    isShared,
    setIsShared,
    priceRange,
    setPriceRange,
    setCommittedPriceRange,
    selectedBeds,
    setSelectedBeds,
    selectedBaths,
    setSelectedBaths,
    minArea,
    setMinArea,
    maxArea,
    setMaxArea,
    minRating,
    setMinRating,
    selectedAmenities,
    setSelectedAmenities,
    sortBy,
    setSortBy,
    sortAscending,
    setSortAscending,
    page,
    setPage,
    showMap,
    setShowMap,
    amenitiesExpanded,
    setAmenitiesExpanded,
    
    // Derived & Actions
    filters,
    activeFilterCount,
    visibleAmenities,
    toggleAmenity,
    resetFilters,
    commitKeyword,
    // Geo-search
    userLat,
    userLng,
    radiusKm,
    setRadiusKm,
    locationLabel,
    setUserLocation,
    clearUserLocation,
  }
}
