import { useQuery } from '@tanstack/react-query'
import { userService } from '@/services/userService'

export function useRenterDashboard() {
  return useQuery({
    queryKey: ['renterDashboard'],
    queryFn: () => userService.getRenterDashboard(),
  })
}
