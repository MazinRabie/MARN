import { apiClient, axiosInstance } from './apiClient'
import type { ApiResponse, PaginatedResponse } from '@/types/common'
import type { BookingRequest, Contract } from '@/types/rental'

export const rentalService = {

  acceptRequest: (requestId: string) =>
    apiClient.post<ApiResponse<any>>(
      `/api/contracts/create/${requestId}`,
      {}
    ),

  rejectRequest: (requestId: string) =>
    apiClient.delete<ApiResponse<any>>(
      `/api/BookingRequest/cancel/${requestId}`,
    ),


  getContractById: (id: string) =>
    apiClient.get<ApiResponse<Contract>>(`/api/contracts/${id}`),

  signContract: (id: string) =>
    apiClient.post<ApiResponse<any>>(`/api/contracts/${id}/sign`, {}),

  downloadContract: (id: string) =>
    axiosInstance.get(`/api/contracts/${id}/download`, { responseType: 'blob' }),

  downloadOTS: (id: string) =>
    axiosInstance.get(`/api/contracts/${id}/proof`, { responseType: 'blob' }),

  verifyContract: (formData: FormData) =>
    axiosInstance.post(`/api/contracts/verify`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }),

  addBookingRequest: (payload: any) =>
    apiClient.post<ApiResponse<any>>('/api/BookingRequest/add', payload),
}
