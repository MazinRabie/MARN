import { useQuery } from '@tanstack/react-query'
import { roommateService } from '@/services/roommateService'

export function useRoommateMatches(limit = 10, enabled = true) {
  return useQuery({
    queryKey: ['roommateMatches', limit],
    queryFn: () => roommateService.getMatches(limit),
    enabled,
  })
}
