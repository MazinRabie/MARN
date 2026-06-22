import { useQuery } from '@tanstack/react-query'
import { userService } from '@/services/userService'

export function useOwnerDashboard() {
  return useQuery({
    queryKey: ['ownerDashboard'],
    queryFn: () => userService.getOwnerDashboard(),
  })
}
