import { useQuery } from '@tanstack/react-query'
import { propertyService } from '@/services/propertyService'
import type { PropertyFilters } from '@/types/property'

export function useProperties(filters: PropertyFilters = {}) {
  return useQuery({
    queryKey: ['properties', filters],
    queryFn: () => propertyService.getProperties(filters),
  })
}

export function useRecommendations() {
  return useQuery({
    queryKey: ['recommendations'],
    queryFn: () => propertyService.getRecommendations(),
  })
}
