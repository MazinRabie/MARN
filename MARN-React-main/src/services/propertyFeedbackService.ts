import { axiosInstance } from '@/services/apiClient'
import type { ApiResponse } from '@/types/common'
import type {
  PropertyFeedbackDto,
  PropertyFeedbackItemDto,
  CreatePropertyCommentDto,
  CreatePropertyRatingDto,
  CreatePropertyFeedbackDto,
} from '@/types/propertyFeedback'

export const propertyFeedbackService = {
  getFeedback: async (
    propertyId: string,
    pageNumber: number = 1,
    pageSize: number = 20,
  ): Promise<ApiResponse<PropertyFeedbackDto>> => {
    const response = await axiosInstance.get(
      `/api/properties/${propertyId}/feedback`,
      { params: { pageNumber, pageSize } }
    )
    return response.data
  },

  addFeedback: async (
    propertyId: string,
    payload: CreatePropertyFeedbackDto,
  ): Promise<ApiResponse<PropertyFeedbackItemDto>> => {
    const response = await axiosInstance.post(
      `/api/properties/${propertyId}/feedback`,
      payload,
    )
    return response.data
  },

  updateComment: async (
    propertyId: string,
    commentId: string,
    payload: CreatePropertyCommentDto,
  ): Promise<ApiResponse<PropertyFeedbackItemDto>> => {
    const response = await axiosInstance.put(
      `/api/properties/${propertyId}/comments/${commentId}`,
      payload,
    )
    return response.data
  },

  deleteFeedback: async (
    propertyId: string,
  ): Promise<ApiResponse<any>> => {
    const response = await axiosInstance.delete(
      `/api/properties/${propertyId}/feedback/me`,
    )
    return response.data
  },
}
