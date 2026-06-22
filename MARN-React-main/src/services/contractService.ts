import { apiClient } from './apiClient'
import type { ApiResponse } from './apiClient'

export const contractService = {
  createContract: (bookingRequestId: number) =>
    apiClient.post<ApiResponse<any>>(`/api/contracts/create/${bookingRequestId}`, {}),

  signContract: (contractId: number) =>
    apiClient.post<ApiResponse<any>>(`/api/contracts/${contractId}/sign`, {})
}
