export interface PropertyFeedbackItemDto {
  feedbackId: number
  propertyId: number
  userId: string
  userDisplayName: string
  userProfileImage?: string
  rating: number
  content: string
  createdAt: string
  updatedAt?: string
}

export interface PropertyFeedbackItemDtoPagedResult {
  items: PropertyFeedbackItemDto[]
  pageNumber: number
  pageSize: number
  totalCount: number
  totalPages: number
}

export interface PropertyFeedbackDto {
  averageRating: number
  ratingsCount: number
  commentsCount: number
  currentUserFeedback?: PropertyFeedbackItemDto
  feedback: PropertyFeedbackItemDtoPagedResult
}

export interface CreatePropertyRatingDto {
  rating: number
}

export interface CreatePropertyCommentDto {
  content: string
}

export interface CreatePropertyFeedbackDto {
  rating: number
  content: string
}
