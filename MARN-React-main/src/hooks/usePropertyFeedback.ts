import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { propertyFeedbackService } from '@/services/propertyFeedbackService'
import type { CreatePropertyCommentDto, CreatePropertyRatingDto, CreatePropertyFeedbackDto } from '@/types/propertyFeedback'

export const usePropertyFeedback = (propertyId: string | undefined, pageNumber: number = 1, pageSize: number = 20) => {
  return useQuery({
    queryKey: ['propertyFeedback', propertyId, pageNumber, pageSize],
    queryFn: () => propertyFeedbackService.getFeedback(propertyId!, pageNumber, pageSize),
    enabled: !!propertyId,
  })
}

export const useAddPropertyFeedback = () => {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({
      propertyId,
      feedbackData,
    }: {
      propertyId: string
      feedbackData: CreatePropertyFeedbackDto
      _optimistic?: { userId: string; displayName: string; profileImage?: string }
    }) => {
      return await propertyFeedbackService.addFeedback(propertyId, feedbackData)
    },
    onSettled: (_, __, variables) => {
      queryClient.invalidateQueries({
        queryKey: ['propertyFeedback', variables.propertyId],
      })
      queryClient.invalidateQueries({
        queryKey: ['property', variables.propertyId],
      })
    },
  })
}

export const useUpdatePropertyComment = () => {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ propertyId, commentId, payload }: { propertyId: string; commentId: string; payload: CreatePropertyCommentDto }) =>
      propertyFeedbackService.updateComment(propertyId, commentId, payload),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['propertyFeedback', variables.propertyId] })
    },
  })
}

export const useDeletePropertyFeedback = () => {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ propertyId }: { propertyId: string }) => {
      await propertyFeedbackService.deleteFeedback(propertyId)
      return true
    },
    onSettled: (_, __, variables) => {
      queryClient.invalidateQueries({ queryKey: ['propertyFeedback', variables.propertyId] })
      queryClient.invalidateQueries({ queryKey: ['property', variables.propertyId] })
    },
  })
}
