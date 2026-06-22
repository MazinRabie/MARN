import { useQuery } from '@tanstack/react-query'
import { propertyService } from '@/services/propertyService'

export function useAdminPropertyDetails(id: string | undefined) {
  return useQuery({
    queryKey: ['admin-property-details', id],
    queryFn: () => propertyService.getAdminPropertyById(id!),
    enabled: !!id,
  })
}
