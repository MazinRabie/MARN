import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { rentalService } from '@/services/rentalService'

export function useContract(id: string | undefined) {
  return useQuery({
    queryKey: ['contract', id],
    queryFn: () => rentalService.getContractById(id!),
    enabled: !!id,
    staleTime: Infinity,
  })
}

/** Mutations-only variant – does NOT fire the booking-requests query. */
export function useBookingMutations() {
  const queryClient = useQueryClient()

  const accept = useMutation({
    mutationFn: (requestId: string) => rentalService.acceptRequest(requestId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bookingRequests'] })
      queryClient.invalidateQueries({ queryKey: ['ownerDashboard'] })
    },
  })

  const reject = useMutation({
    mutationFn: (requestId: string) => rentalService.rejectRequest(requestId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bookingRequests'] })
      queryClient.invalidateQueries({ queryKey: ['ownerDashboard'] })
    },
  })

  return { accept, reject }
}

export function useAddBookingRequest() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (payload: any) => rentalService.addBookingRequest(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bookingRequests'] })
      queryClient.invalidateQueries({ queryKey: ['renterDashboard'] })
    },
  })
}
