import { useState, useMemo, useEffect } from 'react'
import { useNavigate, useParams, Link } from 'react-router'
import {
  Bath,
  Bed,
  Maximize2,
  MapPin,
  Star,
  Heart,
  Share2,
  CheckCircle,
  ChevronLeft,
  ChevronRight,
  MoreVertical,
  Edit,
  Flag,
} from 'lucide-react'
import { Button } from '../components/ui/button'
import { Card, CardContent } from '../components/ui/card'
import { Avatar, AvatarFallback, AvatarImage } from '../components/ui/avatar'
import { Badge } from '../components/ui/badge'
import { Skeleton } from '../components/ui/skeleton'
import { useProperty } from '@/hooks/useProperty'
import { useOwnerDashboard } from '@/hooks/useOwnerDashboard'
import { useBookingMutations } from '@/hooks/useBookingRequests'
import { usePropertyFeedback, useUpdatePropertyComment } from '@/hooks/usePropertyFeedback'
import { ImageWithFallback } from '../components/figma/ImageWithFallback'
import { getImageUrl } from '@/constants/assets'
import { formatDistanceToNow } from 'date-fns'
import { useAuth } from '@/hooks/useAuth'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { userService } from '@/services/userService'
import { propertyService } from '@/services/propertyService'
import { motion } from 'framer-motion'
import { toast } from 'sonner'
import { useTranslation } from 'react-i18next'

export function PropertyByOwnerPage() {
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()
  const [currentImageIndex, setCurrentImageIndex] = useState(0)
  const { t, i18n } = useTranslation('properties')

  const { user } = useAuth()
  const updateComment = useUpdatePropertyComment()
  const reportMutation = useMutation({
    mutationFn: (commentId: string) =>
      userService.submitReport({
        reportableType: 'PropertyComment',
        reportableTargetId: commentId,
        reason: 'Inappropriate content',
      }),
    onSuccess: () => toast.success('Comment reported successfully'),
    onError: () => toast.error('Failed to report comment'),
  })

  const [editingCommentId, setEditingCommentId] = useState<string | null>(null)
  const [editContent, setEditContent] = useState('')
  const [openDropdownId, setOpenDropdownId] = useState<string | null>(null)

  const handleEditSubmit = (commentId: string) => {
    if (!editContent.trim()) return
    updateComment.mutate(
      { propertyId: id!, commentId, payload: { content: editContent } },
      {
        onSuccess: () => {
          setEditingCommentId(null)
          toast.success('Comment updated successfully')
        },
        onError: () => toast.error('Failed to update comment'),
      }
    )
  }

  const { data: propertyData, isLoading: propertyLoading } = useProperty(id)
  const { data: dashboardResponse, isLoading: requestsLoading } = useOwnerDashboard()
  const { accept, reject } = useBookingMutations()

  const { data: feedbackData } = usePropertyFeedback(id)
  const ratingSummary = feedbackData?.data
  const comments = feedbackData?.data?.feedback?.items || []

  const property = propertyData?.data ?? null
  const allRequests = dashboardResponse?.data?.pendingBookingRequests ?? []
  const requests = allRequests.filter((r) => r.propertyId.toString() === id)

  const [showConfirmModal, setShowConfirmModal] = useState(false)
  const queryClient = useQueryClient()

  const toggleActiveMutation = useMutation({
    mutationFn: () => propertyService.deactivateProperty(id!),
    onSuccess: () => {
      toast.success(property?.isActive !== false ? t('propertyByOwner.deactivatedSuccess', 'Property deactivated successfully') : t('propertyByOwner.reactivatedSuccess', 'Property reactivated successfully'))
      queryClient.invalidateQueries({ queryKey: ['property', id] })
      setShowConfirmModal(false)
    },
    onError: () => toast.error(t('propertyByOwner.actionFailed', 'Action failed')),
  })

  const images: string[] = useMemo(() => {
    const p = property as any
    if (p?.media?.length) {
      return p.media.map((m: any) => m.path ?? m.url ?? '').filter(Boolean) as string[]
    }
    if (p?.images?.length) return p.images as string[]
    if (p?.imagePath) return [p.imagePath as string]
    if (p?.image) return [p.image as string]
    return []
  }, [property])

  useEffect(() => {
    if (images.length === 0) return
    const neighbors = [
      images[(currentImageIndex + 1) % images.length],
      images[(currentImageIndex - 1 + images.length) % images.length],
    ].filter(Boolean)
    neighbors.forEach((src) => {
      const img = new Image()
      img.src = getImageUrl(src)
    })
  }, [images, currentImageIndex])

  const nextImage = () =>
    setCurrentImageIndex((prev) => (prev + 1) % Math.max(images.length, 1))
  const prevImage = () =>
    setCurrentImageIndex(
      (prev) =>
        (prev - 1 + Math.max(images.length, 1)) % Math.max(images.length, 1),
    )

  if (propertyLoading) {
    return (
      <div className="min-h-screen py-20">
        <div className="max-w-[1440px] mx-auto px-8 space-y-8">
          <Skeleton className="h-[500px] w-full rounded-3xl" />
          <div className="grid lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2 space-y-4">
              <Skeleton className="h-10 w-3/4 rounded" />
              <Skeleton className="h-6 w-1/2 rounded" />
              <Skeleton className="h-32 w-full rounded" />
            </div>
            <Skeleton className="h-64 rounded-3xl" />
          </div>
        </div>
      </div>
    )
  }

  if (!property) {
    return (
      <div className="min-h-screen py-20 flex items-center justify-center text-[#4a5565]">
        {t('details.propertyNotFound')}
      </div>
    )
  }

  return (
    <div className="min-h-screen py-20">
      <div className="max-w-[1440px] mx-auto px-8">
        {/* Image Gallery */}
        <div className="mb-8 relative rounded-3xl overflow-hidden bg-white shadow-xl shadow-[#3A6EA5]/10 aspect-[21/9]">
          {propertyLoading ? (
            <Skeleton className="w-full h-full" />
          ) : images.length > 0 ? (
            <>
              <ImageWithFallback
                src={getImageUrl(images[currentImageIndex])}
                alt={`Property image ${currentImageIndex + 1}`}
                className="w-full h-full object-cover"
              />
              {images.length > 1 && (
                <>
                  <button
                    onClick={prevImage}
                    className="absolute ltr:left-4 rtl:right-4 top-1/2 -translate-y-1/2 w-12 h-12 rounded-full bg-white/90 backdrop-blur-sm flex items-center justify-center hover:bg-white transition-all shadow-md"
                  >
                    <ChevronLeft className="w-6 h-6 text-[#1a1a1a] rtl:rotate-180" />
                  </button>
                  <button
                    onClick={nextImage}
                    className="absolute ltr:right-4 rtl:left-4 top-1/2 -translate-y-1/2 w-12 h-12 rounded-full bg-white/90 backdrop-blur-sm flex items-center justify-center hover:bg-white transition-all shadow-md"
                  >
                    <ChevronRight className="w-6 h-6 text-[#1a1a1a] rtl:rotate-180" />
                  </button>
                  <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2">
                    {images.map((_, index) => (
                      <button
                        key={index}
                        onClick={() => setCurrentImageIndex(index)}
                        className={`h-2 rounded-full transition-all ${
                          index === currentImageIndex ? 'bg-white w-8' : 'bg-white/50 hover:bg-white/75 w-2'
                        }`}
                      />
                    ))}
                  </div>
                </>
              )}
            </>
          ) : (
            <div className="w-full h-full bg-[#9CBBDC]/20 flex items-center justify-center text-[#4a5565]">
              No images available
            </div>
          )}
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Property Details */}
          <div className="lg:col-span-2 space-y-8">
            {/* Title & Location */}
            <div>
              <div className="flex items-start justify-between mb-2">
                <h1 className="text-4xl font-bold text-[#1a1a1a]">
                  {property.title}
                </h1>
                {(property.rating ?? 0) > 0 && (
                  <div className="flex items-center gap-1">
                    <Star className="w-5 h-5 fill-[#FFB800] text-[#FFB800]" />
                    <span className="font-semibold text-[#1a1a1a]">
                      {Math.round((property.rating ?? 0) * 10) / 10}
                    </span>
                    <span className="text-[#6B7280]">
                      ({property.reviews} {t('details.reviewsCount')})
                    </span>
                  </div>
                )}
              </div>
              <div className="flex items-center gap-2 text-[#6B7280]">
                <MapPin className="w-5 h-5" />
                <span>{property.address ?? property.location}</span>
              </div>
            </div>

            {/* Property Stats */}
            <div className="flex gap-6">
              <div className="flex items-center gap-2">
                <Bed className="w-5 h-5 text-[#3A6EA5]" />
                <span className="text-[#1a1a1a]">{(property as any).bedrooms ?? property.beds} {t('addProperty.detailsStep.beds')}</span>
              </div>
              <div className="flex items-center gap-2">
                <Bath className="w-5 h-5 text-[#3A6EA5]" />
                <span className="text-[#1a1a1a]">
                  {(property as any).bathrooms ?? property.baths} {t('addProperty.detailsStep.baths')}
                </span>
              </div>
              {((property as any).squareMeters ?? (property as any).area) && (
                <div className="flex items-center gap-2">
                  <Maximize2 className="w-5 h-5 text-[#3A6EA5]" />
                  <span className="text-[#1a1a1a]">{(property as any).squareMeters ?? (property as any).area} {t('details.sqm')}</span>
                </div>
              )}
            </div>

            {/* Description */}
            {property.description && (
              <div>
                <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-3">
                  {t('details.description')}
                </h2>
                <p className="text-[#1a1a1a] leading-relaxed">
                  {property.description}
                </p>
              </div>
            )}

            {/* Amenities */}
            {property.amenities.length > 0 && (
              <div>
                <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-4">
                  {t('details.amenities')}
                </h2>
                <div className="grid grid-cols-2 gap-3">
                  {property.amenities.map((amenity: any) => {
                    const key = amenity?.id ?? amenity?.amenity ?? amenity
                    const display = amenity?.amenityDisplayName ?? amenity?.amenity ?? amenity
                    return (
                      <div
                        key={key}
                        className="flex items-center gap-3 p-3 bg-[#E5EBF0] rounded-xl"
                      >
                        <CheckCircle className="w-5 h-5 text-[#3A6EA5]" />
                        <span className="text-[#1a1a1a]">{t(`addProperty.detailsStep.amenitiesList.${display.replace(/[^a-zA-Z]/g, '')}`, { defaultValue: display })}</span>
                      </div>
                    )
                  })}
                </div>
              </div>
            )}

            {/* Rental Requests Section */}
            <div>
              <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-4">
                {t('propertyByOwner.rentalRequests')} ({requestsLoading ? '…' : requests.length})
              </h2>
              {requestsLoading ? (
                <div className="space-y-4">
                  <Skeleton className="h-40 w-full rounded-3xl" />
              <Skeleton className="h-40 w-full rounded-3xl" />
                  <Skeleton className="h-40 w-full rounded-3xl" />
                </div>
              ) : requests.length === 0 ? (
                <p className="text-[#4a5565]">{t('propertyByOwner.noRequests')}</p>
              ) : (
                <div className="space-y-4">
                  {requests.map((request) => (
                    <Card
                      key={request.bookingRequestId}
                      className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 hover:shadow-xl transition-shadow"
                    >
                      <CardContent className="p-6">
                        <div className="flex items-start justify-between mb-4">
                          <div className="flex items-center gap-4">
                            <Avatar className="w-16 h-16">
                              {request.renterProfileImage && (
                                <AvatarImage src={getImageUrl(request.renterProfileImage)} />
                              )}
                              <AvatarFallback>
                                {request.renterName
                                  .split(' ')
                                  .map((n) => n[0])
                                  .join('')}
                              </AvatarFallback>
                            </Avatar>
                            <div>
                              <h3 className="font-semibold text-[#1a1a1a] text-lg">
                                {request.renterName}
                              </h3>
                            </div>
                          </div>
                          <span className="px-3 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-700">
                            {t('propertyByOwner.pending')}
                          </span>
                        </div>

                        <div className="grid grid-cols-2 md:grid-cols-3 gap-4 mb-4">
                          <div className="p-3 bg-white rounded-xl">
                            <p className="text-xs text-[#6B7280] mb-1">
                              {t('details.moveInDate')}
                            </p>
                            <p className="text-sm font-medium text-[#1a1a1a]">
                              {new Date(request.startDate).toLocaleDateString(
                                'en-US',
                                {
                                  month: 'short',
                                  day: 'numeric',
                                  year: 'numeric',
                                },
                              )}
                            </p>
                          </div>
                          <div className="p-3 bg-white rounded-xl">
                            <p className="text-xs text-[#6B7280] mb-1">
                              {t('propertyByOwner.moveOut')}
                            </p>
                            <p className="text-sm font-medium text-[#1a1a1a]">
                              {new Date(request.endDate).toLocaleDateString(
                                'en-US',
                                {
                                  month: 'short',
                                  day: 'numeric',
                                  year: 'numeric',
                                },
                              )}
                            </p>
                          </div>
                          <div className="p-3 bg-white rounded-xl">
                            <p className="text-xs text-[#6B7280] mb-1">
                              {t('propertyByOwner.paymentFrequency')}
                            </p>
                            <p className="text-sm font-bold text-[#3A6EA5]">
                              {request.paymentFrequencyDisplayName}
                            </p>
                          </div>
                        </div>

                        <div className="flex gap-3">
                          <Button
                            size="sm"
                            className="flex-1 bg-green-600 hover:bg-green-700 text-white rounded-xl"
                            disabled={accept.isPending}
                            onClick={() => accept.mutate(request.bookingRequestId.toString())}
                          >
                            {t('propertyByOwner.accept')}
                          </Button>
                          <Button
                            size="sm"
                            variant="outline"
                            className="flex-1 border-red-500 text-red-500 hover:bg-red-500 hover:text-white rounded-xl"
                            disabled={reject.isPending}
                            onClick={() => reject.mutate(request.bookingRequestId.toString())}
                          >
                            {t('propertyByOwner.reject')}
                          </Button>
                          <Button
                            size="sm"
                            onClick={() =>
                              navigate(`/messages/rental-request/${request.bookingRequestId}`)
                            }
                            className="flex-1 bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2C5580] hover:to-[#3A6EA5] text-white rounded-xl"
                          >
                            {t('propertyByOwner.viewChat')}
                          </Button>
                        </div>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              )}
            </div>

            {/* Reviews Section */}
            <div className="p-6 bg-[#E5EBF0] rounded-3xl mt-8 mb-8">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-2xl font-semibold text-[#1a1a1a]">
                  {t('details.reviews')} ({ratingSummary?.ratingsCount || property?.reviews || 0})
                </h2>
                <div className="flex items-center gap-2">
                  <Star className="w-6 h-6 fill-[#FFB800] text-[#FFB800]" />
                  <span className="text-2xl font-bold text-[#1a1a1a]">
                    {Math.round((ratingSummary?.averageRating || property?.rating || 0) * 10) / 10}
                  </span>
                </div>
              </div>

              <div className="space-y-4">
                {comments.length > 0 ? (
                  comments.map((comment: any) => (
                    <div key={comment.commentId || comment.feedbackId} className="p-4 bg-white rounded-2xl relative">
                      <div className="flex items-start gap-4 mb-3">
                        <Link to={`/user/${comment.commenterId || comment.userId}`}>
                          <Avatar className="w-12 h-12 hover:ring-2 hover:ring-[#3A6EA5] transition-all cursor-pointer">
                            {comment.userProfileImage && <AvatarImage src={getImageUrl(comment.userProfileImage)} />}
                            <AvatarFallback>
                              {comment.userDisplayName?.slice(0, 2).toUpperCase() || 'U'}
                            </AvatarFallback>
                          </Avatar>
                        </Link>
                        <div className="flex-1">
                          <div className="flex items-center justify-between mb-1">
                            <Link to={`/user/${comment.commenterId || comment.userId}`} className="hover:underline">
                              <h4 className="font-semibold text-[#1a1a1a]">
                                {comment.userDisplayName || 'Guest'}
                              </h4>
                            </Link>
                            <div className="flex items-center gap-3">
                              <span className="text-sm text-[#4a5565]">
                                {comment.createdAt ? formatDistanceToNow(new Date(comment.createdAt), { addSuffix: true }) : ''}
                              </span>
                              <div className="relative">
                                <Button
                                  variant="ghost"
                                  size="icon"
                                  className="w-8 h-8 rounded-full"
                                  onClick={() => setOpenDropdownId(openDropdownId === (comment.commentId || comment.feedbackId) ? null : (comment.commentId || comment.feedbackId))}
                                >
                                  <MoreVertical className="w-4 h-4 text-[#4a5565]" />
                                </Button>
                                {openDropdownId === (comment.commentId || comment.feedbackId) && (
                                  <div className="absolute right-0 top-full mt-1 w-40 bg-white rounded-xl shadow-lg border border-gray-100 py-1 z-10">
                                    {comment.userId === user?.id && (
                                      <button
                                        onClick={() => {
                                          setEditingCommentId(comment.commentId || comment.feedbackId)
                                          setEditContent(comment.content)
                                          setOpenDropdownId(null)
                                        }}
                                        className="w-full text-left px-4 py-2 text-sm text-[#1a1a1a] hover:bg-gray-50 flex items-center gap-2"
                                      >
                                        <Edit className="w-4 h-4" /> {t('details.editReview')}
                                      </button>
                                    )}
                                    <button
                                      onClick={() => {
                                        reportMutation.mutate(comment.commentId || comment.feedbackId)
                                        setOpenDropdownId(null)
                                      }}
                                      className="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2"
                                    >
                                      <Flag className="w-4 h-4" /> {t('details.reportReview')}
                                    </button>
                                  </div>
                                )}
                              </div>
                            </div>
                          </div>
                          {editingCommentId === (comment.commentId || comment.feedbackId) ? (
                            <div className="mt-2 flex flex-col gap-2">
                              <textarea
                                className="w-full p-2 border border-gray-200 rounded-xl resize-none text-sm focus:outline-none focus:ring-1 focus:ring-[#3A6EA5]"
                                rows={3}
                                value={editContent}
                                onChange={(e) => setEditContent(e.target.value)}
                              />
                              <div className="flex items-center gap-2 justify-end">
                                <Button
                                  variant="outline"
                                  size="sm"
                                  onClick={() => setEditingCommentId(null)}
                                  className="rounded-xl h-8 text-xs"
                                >
                                  {t('details.cancel')}
                                </Button>
                                <Button
                                  size="sm"
                                  onClick={() => handleEditSubmit(comment.commentId || comment.feedbackId)}
                                  disabled={updateComment.isPending}
                                  className="bg-[#3A6EA5] hover:bg-[#2C5580] text-white rounded-xl h-8 text-xs"
                                >
                                  {t('details.save')}
                                </Button>
                              </div>
                            </div>
                          ) : (
                            <p className="text-[#1a1a1a] text-sm leading-relaxed mt-2">
                              {comment.content}
                            </p>
                          )}
                        </div>
                      </div>
                    </div>
                  ))
                ) : (
                  <p className="text-center text-[#4a5565] py-4">
                    {t('details.noReviews')}
                  </p>
                )}
              </div>
            </div>
          </div>

          {/* Sidebar - Owner Actions */}
          <div className="lg:col-span-1">
            <div className="sticky top-24">
              <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
                <CardContent className="p-6 space-y-4">
                  <div className="p-4 bg-white rounded-2xl text-center">
                    <p className="text-sm text-[#6B7280] mb-1">{t('details.monthlyRent')}</p>
                    <p className="text-4xl font-bold text-[#3A6EA5]" dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}>
                      {i18n.language === 'ar' 
                        ? `${property.price.toLocaleString()} ${t('currency', { ns: 'common' })}` 
                        : `${t('currency', { ns: 'common' })} ${property.price.toLocaleString()}`}
                    </p>
                  </div>

                  <Button
                    className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2C5580] hover:to-[#3A6EA5] text-white rounded-xl"
                    onClick={() => navigate(`/edit-property/${id}`)}
                  >
                    {t('propertyByOwner.editProperty')}
                  </Button>

                  <Button
                    variant="outline"
                    className={`w-full rounded-xl ${property.isActive !== false ? 'border-[#FF4D4F] text-[#FF4D4F] hover:bg-[#FF4D4F] hover:text-white' : 'border-[#00A650] text-[#00A650] hover:bg-[#00A650] hover:text-white'}`}
                    onClick={() => setShowConfirmModal(true)}
                  >
                    {property.isActive !== false ? t('propertyByOwner.deactivateProperty', 'Deactivate Property') : t('propertyByOwner.reactivateProperty', 'Reactivate Property')}
                  </Button>

                  <Button
                    variant="outline"
                    className="w-full rounded-xl border-[#3A6EA5]/20"
                    onClick={() => navigate('/owner-dashboard')}
                  >
                    {t('propertyByOwner.backToDashboard')}
                  </Button>

                  <div className="pt-4 border-t border-[#3A6EA5]/20">
                    <h3 className="font-semibold text-[#1a1a1a] mb-3">
                      {t('propertyByOwner.quickStats')}
                    </h3>
                    <div className="space-y-3">
                      <div className="flex items-center justify-between text-sm">
                        <span className="text-[#6B7280]">{t('propertyByOwner.totalRequests')}</span>
                        <span className="font-semibold text-[#1a1a1a]">
                          {requests.length}
                        </span>
                      </div>
                      <div className="flex flex-col">
                        <span className="text-[#6B7280]">{t('propertyByOwner.pending')}</span>
                        <span className="font-semibold text-[#1a1a1a]">
                          {requests.length}
                        </span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </div>

      {/* Confirmation Modal */}
      {showConfirmModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="bg-white rounded-3xl p-8 max-w-md w-full shadow-2xl">
            <h3 className="text-2xl font-bold text-[#1a1a1a] mb-4">{t('confirmModal.title', 'Confirm Action')}</h3>
            <p className="text-[#4a5565] mb-6">
              {property.isActive !== false ? t('propertyByOwner.deactivateWarning', 'Are you sure you want to deactivate this property? It will no longer be searchable or visible to renters.') : t('propertyByOwner.reactivateWarning', 'Are you sure you want to reactivate this property? It will become searchable and visible to renters again.')}
            </p>
            <div className="flex gap-4">
              <Button variant="outline" className="flex-1 rounded-xl border-[#3A6EA5]/20" onClick={() => setShowConfirmModal(false)}>
                {t('confirmModal.cancel', 'Cancel')}
              </Button>
              <Button
                className={`flex-1 text-white rounded-xl ${property.isActive !== false ? 'bg-[#FF4D4F] hover:bg-[#E04343]' : 'bg-[#00A650] hover:bg-[#008A42]'}`} disabled={toggleActiveMutation.isPending} onClick={() => toggleActiveMutation.mutate()}>
                {toggleActiveMutation.isPending ? t('confirmModal.processing', 'Processing...') : t('confirmModal.confirm', 'Confirm')}
              </Button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  )
}
