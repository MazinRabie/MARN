import { useQuery } from '@tanstack/react-query'
import { propertyService } from '@/services/propertyService'

export function useProperty(id: string | undefined) {
  return useQuery({
    queryKey: ['property', id],
    queryFn: () => propertyService.getPropertyById(id!),
    enabled: !!id,
    staleTime: Infinity,
  })
}
