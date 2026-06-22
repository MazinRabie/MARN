import { apiClient } from './apiClient'
import { getImageUrl } from '@/constants/assets'
import type { ApiResponse, SearchPaginatedResponse } from '@/types/common'
import type {
  Property,
  SearchProperty,
  PropertyFilters,
} from '@/types/property'

function buildSearchQuery(filters: PropertyFilters): string {
  const params = new URLSearchParams()

  // text / geo
  if (filters.keyword) params.set('Keyword', filters.keyword)
  if (filters.latitude !== undefined)
    params.set('Latitude', String(filters.latitude))
  if (filters.longitude !== undefined)
    params.set('Longitude', String(filters.longitude))
  if (filters.radiusKm !== undefined)
    params.set('RadiusKm', String(filters.radiusKm))

  // location enums
  if (filters.city) params.set('City', filters.city)
  if (filters.governorate) params.set('Governorate', filters.governorate)

  // property attributes
  if (filters.type) params.set('Type', filters.type)
  if (filters.rentalUnit) params.set('RentalUnit', filters.rentalUnit)
  if (filters.isShared !== undefined)
    params.set('IsShared', String(filters.isShared))

  // price
  if (filters.minPrice !== undefined)
    params.set('MinPrice', String(filters.minPrice))
  if (filters.maxPrice !== undefined)
    params.set('MaxPrice', String(filters.maxPrice))

  // rooms / occupants
  if (filters.minBedrooms !== undefined)
    params.set('MinBedrooms', String(filters.minBedrooms))
  if (filters.minBeds !== undefined)
    params.set('MinBeds', String(filters.minBeds))
  if (filters.minBathrooms !== undefined)
    params.set('MinBathrooms', String(filters.minBathrooms))
  if (filters.minMaxOccupants !== undefined)
    params.set('MinMaxOccupants', String(filters.minMaxOccupants))

  // area
  if (filters.minSquareMeters !== undefined)
    params.set('MinSquareMeters', String(filters.minSquareMeters))
  if (filters.maxSquareMeters !== undefined)
    params.set('MaxSquareMeters', String(filters.maxSquareMeters))

  // rating
  if (filters.minRating !== undefined)
    params.set('MinRating', String(filters.minRating))

  // amenities — repeated param
  if (filters.amenities?.length) {
    filters.amenities.forEach((a) => params.append('Amenities', a))
  }

  // sorting
  if (filters.sortBy) params.set('SortBy', filters.sortBy)
  if (filters.sortAscending !== undefined)
    params.set('SortAscending', String(filters.sortAscending))

  // pagination
  if (filters.page !== undefined) params.set('Page', String(filters.page))
  if (filters.pageSize !== undefined)
    params.set('PageSize', String(filters.pageSize))

  const qs = params.toString()
  return qs ? `?${qs}` : ''
}

export const propertyService = {
  getProperties: (filters: PropertyFilters = {}) =>
    apiClient
      .get<
        ApiResponse<SearchPaginatedResponse<SearchProperty>>
      >(`/api/Property/search${buildSearchQuery(filters)}`)
      .then((res) => {
        if (res.data?.items) {
          res.data.items = res.data.items.map((p: any) => ({
            ...p,
            imagePath: getImageUrl(p.imagePath),
          }))
        }
        return res
      }),

  getRecommendations: () =>
    apiClient
      .get<ApiResponse<SearchPaginatedResponse<SearchProperty>>>(
        '/api/Homepage/recommendations'
      )
      .then((res) => {
        if (res.data?.items) {
          res.data.items = res.data.items.map((p: any) => ({
            ...p,
            imagePath: getImageUrl(p.imagePath),
          }))
        }
        return res
      }),

  getPropertyById: (id: string) =>
    apiClient.get<ApiResponse<Property>>(`/api/Property/${id}`),

  getAdminPropertyById: (id: string) =>
    apiClient.get<ApiResponse<any>>(`/api/Admin/stats/properties/${id}`),

  createProperty: (data: FormData) =>
    apiClient.post<ApiResponse<Property>>('/api/Property/add', data),



  getPropertyForEdit: (id: string) =>
    apiClient.get<ApiResponse<any>>(`/api/Property/edit/${id}`),

  submitPropertyEdit: (id: string, data: FormData) =>
    apiClient.put<ApiResponse<any>>(`/api/Property/edit/${id}`, data),

  deleteProperty: (id: string) =>
    apiClient.delete<ApiResponse<void>>(`/api/Property/delete/${id}`),

  becomeOwner: () =>
    apiClient.post<ApiResponse<string>>('/api/Property/become-owner'),

  toggleSaveProperty: (id: string) =>
    apiClient.post<ApiResponse<void>>(`/api/Property/save/${id}`),

  deactivateProperty: (id: string) =>
    apiClient.put<ApiResponse<void>>(`/api/Property/deactivate/${id}`),
}
