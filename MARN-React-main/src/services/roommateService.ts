import { apiClient } from './apiClient'
import type { ApiResponse } from '@/types/common'

// Manually defined interface based on typical user profile and inferred properties.
// The Swagger spec has content?: never for the 200 response of /api/Roommate/matches.
export interface RoommateMatch {
  userId: string
  fullName: string
  profileImage: string | null
  bio: string | null
  compatibilityScore: number
  governorate: string | null
  searchStatus: string | null
  searchStatusDisplayName: string | null
  badge: string | null
  topMatchingTraits: string[]
  mismatchedTraits: string[]
  dealbreakersFound: string[]
}

export const roommateService = {
  getMatches: (limit = 10) =>
    apiClient.get<ApiResponse<RoommateMatch[]>>(
      '/api/Roommate/matches',
      { params: { limit } }
    ),
}
