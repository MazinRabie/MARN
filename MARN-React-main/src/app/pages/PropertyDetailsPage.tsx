import { useState, useEffect, useMemo } from 'react'
import { Link, useParams, useNavigate } from 'react-router'
import { useTranslation } from 'react-i18next'
import { motion } from 'motion/react'
import {
  Star,
  MapPin,
  Share2,
  Heart,
  Wifi,
  Car,
  Wind,
  Flame,
  Shirt,
  Dumbbell,
  Waves,
  Dog,
  ChevronLeft,
  ChevronRight,
  Calendar,
  Users,
  MessageSquare,
  Check,
  Tv,
  Utensils,
  Maximize,
  ShieldCheck,
  Thermometer,
  Loader2,
  ShieldAlert,
  MoreVertical,
  Edit,
  Mail,
} from 'lucide-react'
import { Button } from '../components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '../components/ui/avatar'
import { Calendar as CalendarComponent } from '../components/ui/calendar'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '../components/ui/popover'
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '../components/ui/tooltip'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from '../components/ui/dialog'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '../components/ui/dropdown-menu'
import { Skeleton } from '../components/ui/skeleton'
import { format, formatDistanceToNow, addDays, addMonths, addYears } from 'date-fns'
import { Textarea } from '../components/ui/textarea'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '../components/ui/select'
import { useAuth } from '@/hooks/useAuth'
import {
  usePropertyFeedback,
  useAddPropertyFeedback,
  useUpdatePropertyComment,
  useDeletePropertyFeedback,
} from '@/hooks/usePropertyFeedback'
import { useSubmitReport } from '@/hooks/useConversations'
import { useAddBookingRequest } from '@/hooks/useBookingRequests'
import { ImageWithFallback } from '../components/figma/ImageWithFallback'
import { useProperty } from '@/hooks/useProperty'
import { getImageUrl } from '@/constants/assets'
import { useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { propertyService } from '@/services/propertyService'

const AMENITY_ICONS: Record<string, React.ElementType> = {
  WiFi: Wifi,
  Parking: Car,
  'Air Conditioning': Wind,
  Heating: Flame,
  'Washer/Dryer': Shirt,
  Washer: Shirt,
  Dryer: Wind,
  Gym: Dumbbell,
  Pool: Waves,
  'Pet Friendly': Dog,
  TV: Tv,
  Kitchen: Utensils,
  Dishwasher: Utensils,
  Microwave: Utensils,
  Refrigerator: Thermometer,
  Balcony: Maximize,
  Elevator: Maximize,
  'Security System': ShieldCheck,
  'Storage Space': Maximize,
}

export function PropertyDetailsPage() {
  const { t } = useTranslation()
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { data, isLoading, isError } = useProperty(id)

  const [currentImageIndex, setCurrentImageIndex] = useState(0)
  const [isFavorite, setIsFavorite] = useState(false)
  const [checkIn, setCheckIn] = useState<Date>()
  const [duration, setDuration] = useState<string>('1')

  const property = data?.data

  const { isAuthenticated, user } = useAuth()

  useEffect(() => {
    if (property && user) {
      const hostedBy = (property as any)?.hostedBy;
      const effectiveOwnerId = hostedBy?.id || property?.hostId || property?.ownerId || (property as any)?.userId || `owner-${id}`;
      if (user.id === effectiveOwnerId) {
        navigate(`/property-by-owner/${id}`, { replace: true });
      }
    }
  }, [property, user, id, navigate]);
  const { data: feedbackData } = usePropertyFeedback(id)
  const ratingSummary = feedbackData?.data

  const rawComments = feedbackData?.data?.feedback?.items || property?.comments || []
  const displayComments = useMemo(() => {
    return [...rawComments].sort((a, b) => {
      const isAUser = (a.commenterId || a.userId) === user?.id;
      const isBUser = (b.commenterId || b.userId) === user?.id;
      if (isAUser && !isBUser) return -1;
      if (!isAUser && isBUser) return 1;
      return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    });
  }, [rawComments, user?.id]);

  const addFeedbackMutation = useAddPropertyFeedback()
  const updateComment = useUpdatePropertyComment()
  const deleteFeedback = useDeletePropertyFeedback()

  const [deleteCommentId, setDeleteCommentId] = useState<number | null>(null)

  const [showExistingReviewModal, setShowExistingReviewModal] = useState(false)
  const [existingUserComment, setExistingUserComment] = useState<any>(null)

  const userExistingComment = useMemo(() => {
    if (!user?.id) return null
    return displayComments.find(
      (c: any) => (c.commenterId || c.userId) === user.id
    ) || null
  }, [displayComments, user?.id])

  const [editingCommentId, setEditingCommentId] = useState<number | null>(null)
  const [editContent, setEditContent] = useState('')

  const handleEditSubmit = (commentId: number) => {
    if (!editContent.trim()) return
    updateComment.mutate(
      { propertyId: id!, commentId: commentId.toString(), payload: { content: editContent } },
      {
        onSuccess: () => {
          setEditingCommentId(null)
          toast.success(t('details.commentUpdatedSuccess', { ns: 'properties' }))
        },
        onError: () => toast.error(t('details.failedToUpdateComment', { ns: 'properties' })),
      }
    )
  }

  const bookMutation = useAddBookingRequest()
  const submitReport = useSubmitReport()

  const [newCommentText, setNewCommentText] = useState('')
  const [newCommentRating, setNewCommentRating] = useState(0)
  const [isSubmittingComment, setIsSubmittingComment] = useState(false)
  const [isReportModalOpen, setIsReportModalOpen] = useState(false)
  const [reportReason, setReportReason] = useState('')

  const [isReviewReportModalOpen, setIsReviewReportModalOpen] = useState(false)
  const [selectedReviewToReport, setSelectedReviewToReport] = useState<any>(null)
  const [reviewReportReason, setReviewReportReason] = useState('')

  const [isTenantModalOpen, setIsTenantModalOpen] = useState(false)
  const [selectedTenant, setSelectedTenant] = useState<any>(null)

  const handleTenantClick = (tenant: any) => {
    setSelectedTenant(tenant)
    setIsTenantModalOpen(true)
  }

  const executeSubmitComment = () => {
    setIsSubmittingComment(true)
    const finalRating = newCommentRating;
    
    addFeedbackMutation.mutate({
      propertyId: id!,
      feedbackData: { rating: finalRating, content: newCommentText },
      _optimistic: {
        userId: user!.id,
        displayName: (user as any)?.fullName || (user as any)?.displayName || user!.email || 'You',
        profileImage: (user as any)?.profileImage || (user as any)?.profilePhoto,
      },
    }, {
      onSuccess: () => {
        setNewCommentText('')
        setNewCommentRating(0)
        setIsSubmittingComment(false)
        toast.success(t('details.reviewAddedSuccess', { ns: 'properties' }))
      },
      onError: (error: any) => {
        setIsSubmittingComment(false)
        const msg = error?.message || t('details.failedToSubmitReport', { ns: 'properties' })
        toast.error(msg)
      }
    })
  }

  const handleSubmitComment = () => {
    if (!newCommentText.trim() || newCommentRating === 0 || !id) return

    // Check if user already has a review locally
    if (userExistingComment) {
      setExistingUserComment(userExistingComment)
      setShowExistingReviewModal(true)
      return
    }

    executeSubmitComment()
  }

  const handleReportSubmit = () => {
    if (!id || !reportReason.trim()) return

    submitReport.mutate(
      {
        reportableType: 'Property',
        reportableTargetId: id,
        reason: reportReason.trim(),
      },
      {
        onSuccess: () => {
          toast.success(t('details.propertyReportedSuccess', { ns: 'properties' }))
          setIsReportModalOpen(false)
          setReportReason('')
        },
        onError: () => {
          toast.error(t('details.failedToSubmitReport', { ns: 'properties' }))
        }
      }
    )
  }

  const handleReviewReportSubmit = () => {
    if (!selectedReviewToReport || !reviewReportReason.trim()) return

    const commentTargetId = selectedReviewToReport.commentId || selectedReviewToReport.id || ''
    const targetUserId = selectedReviewToReport.userId || selectedReviewToReport.authorId || '';

    submitReport.mutate(
      {
        reportableType: 'PropertyComment',
        reportableTargetId: commentTargetId.toString(),
        reason: reviewReportReason.trim(),
      },
      {
        onSuccess: () => {
          toast.success(t('details.reviewReportedSuccess', { ns: 'properties' }))
          setIsReviewReportModalOpen(false)
          setReviewReportReason('')
          setSelectedReviewToReport(null)
        },
        onError: () => {
          toast.error(t('details.failedToSubmitReport', { ns: 'properties' }))
        }
      }
    )
  }

  const isShared = property?.isShared || property?.type === 'SharedRoom' || property?.type === 'Room'
  const maxOccupants = property?.maxOccupants || property?.guests || 1
  const currentOccupantsCount = property?.currentOccupantsCount || property?.activeRenters?.length || 0
  const hasSpace = currentOccupantsCount < maxOccupants
  const isAvailable = property?.status === 'available' || property?.availability === true
  const isInactive = property?.status === 'inactive' || property?.isActive === false
  const canBook = isAvailable || (isShared && hasSpace && !isInactive)

  let unavailableText = t('details.unavailable', { ns: 'properties' })
  const isOccupied = property?.status === 'rented' || property?.status === 'Occupied' || property?.status === 'occupied' || (isShared && !hasSpace) || property?.availability === false
  if (isOccupied) {
    if (isShared && currentOccupantsCount > 0 && maxOccupants > 1) {
      unavailableText = t('details.occupiedCount', { ns: 'properties', count: currentOccupantsCount, max: maxOccupants })
    } else {
      unavailableText = t('details.full', { ns: 'properties' })
    }
  }

  const calculatedCheckOut = useMemo(() => {
    if (!checkIn) return undefined;
    const num = parseInt(duration, 10) || 1;
    const unit = property?.rentalUnit || 'Monthly';

    if (unit === 'Daily') {
      return addDays(checkIn, num);
    } else if (unit === 'Yearly') {
      return addYears(checkIn, num);
    } else {
      return addMonths(checkIn, num);
    }
  }, [checkIn, duration, property?.rentalUnit]);

  const formatDateToUTC = (d: Date) => {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}T00:00:00.000Z`;
  };

  const handleBookNow = () => {
    if (!isAuthenticated) {
      toast.error(t('details.loginToBook', { ns: 'properties' }))
      navigate('/login')
      return
    }
    if (!checkIn || !calculatedCheckOut) {
      toast.error(t('details.selectDateAndDuration', { ns: 'properties' }))
      return
    }

    let paymentFrequency = 'Monthly';
    if (property?.rentalUnit === 'Daily') paymentFrequency = 'OneTime';
    if (property?.rentalUnit === 'Quarterly') paymentFrequency = 'Quarterly';
    if (property?.rentalUnit === 'Yearly') paymentFrequency = 'Yearly';

    bookMutation.mutate({
      propertyId: Number(id),
      startDate: formatDateToUTC(checkIn),
      endDate: formatDateToUTC(calculatedCheckOut),
      paymentFrequency,
    }, {
      onSuccess: () => {
        toast.success(t('details.bookingRequestSent', { ns: 'properties' }))
        navigate('/tenant-dashboard')
      },
      onError: (error: any) => {
        const code = error?.response?.data?.code || error?.code;
        if (code === 'START_AND_END_DATE_MUST_ALIGN_WITH_THE_RENTAL_DURATION_UNIT_E_G_COMPLETE_MONTHS_YEARS') {
          toast.error(t('details.bookingDurationError', { ns: 'properties' }))
        } else if (code === 'PROPERTY_IS_NOT_AVAILABLE_AS_IT_IS_ALREADY_OCCUPIED') {
          toast.error(t('details.propertyOccupiedError', { ns: 'properties' }))
        } else {
          toast.error(error?.message || t('details.failedToSendBookingRequest', { ns: 'properties' }))
        }
      }
    })
  }

  useEffect(() => {
    if (property?.isSaved !== undefined) {
      setIsFavorite(property.isSaved)
    }
  }, [property?.isSaved])

  const handleToggleFavorite = () => {
    if (!id) return
    const wasFavorite = isFavorite
    setIsFavorite(!wasFavorite)

    toast.promise(
      propertyService.toggleSaveProperty(id).then(() => {
        queryClient.invalidateQueries({ queryKey: ['property', id] })
        queryClient.invalidateQueries({ queryKey: ['renterDashboard'] })
      }),
      {
        loading: wasFavorite ? t('details.removingFromSaved', { ns: 'properties' }) : t('details.addingToSaved', { ns: 'properties' }),
        success: wasFavorite ? t('details.removedFromSaved', { ns: 'properties' }) : t('details.addedToSaved', { ns: 'properties' }),
        error: () => {
          setIsFavorite(wasFavorite)
          return t('details.failedToUpdateSaved', { ns: 'properties' })
        },
      }
    )
  }

  const handleShare = () => {
    navigator.clipboard.writeText(window.location.href)
    toast.success(t('details.linkCopied', { ns: 'properties' }))
  }

  const hostedBy = (property as any)?.hostedBy;
  const effectiveOwnerId = hostedBy?.id || property?.hostId || property?.ownerId || (property as any)?.userId || `owner-${id}`
  const effectiveOwnerName = hostedBy?.fullName || property?.hostName || property?.ownerName || (property as any)?.userFullName || 'Property Owner'
  const effectiveOwnerAvatar = hostedBy?.profileImage ? getImageUrl(hostedBy.profileImage) : (property?.hostProfileImage || property?.ownerAvatarUrl)
  const effectiveOwnerRating = hostedBy?.averageRating || property?.rating || 4.9
  const effectiveOwnerPropertiesCount = hostedBy?.propertiesCount || property?.propertiesCount || 1
  const effectiveOwnerBio = hostedBy?.bio || property?.ownerBio || property?.hostBio || 'Experienced property manager committed to providing excellent service and ensuring tenant satisfaction.'
  const effectiveOwnerEmail = hostedBy?.email || property?.ownerEmail || property?.hostEmail || (property as any)?.email

  const copyToClipboard = (text: string) => {
    if (!text) return
    navigator.clipboard.writeText(text)
    toast.success(t('copied', { ns: 'properties' }))
  }

  const handleScheduleTour = () => {
    const message = `Hi ${effectiveOwnerName}, I'm interested in "${property?.title || 'this property'}" and would love to schedule a tour.`

    const params = new URLSearchParams({
      autoSend: 'true',
      recipientId: effectiveOwnerId,
      ownerName: effectiveOwnerName,
      avatarUrl: effectiveOwnerAvatar || '',
      text: message
    })

    navigate(`/messages?${params.toString()}`)
  }
  const images: string[] = useMemo(() => {
    const p = property as any
    // API returns a `media` array of { path, isPrimary } objects
    if (p?.media?.length) {
      return p.media.map((m: any) => m.path ?? m.url ?? '')
        .filter(Boolean) as string[]
    }
    if (p?.images?.length) return p.images as string[]
    if (p?.imagePath) return [p.imagePath as string]
    if (p?.image) return [p.image as string]
    return []
  }, [property])

  // Preload only adjacent images (not all) to avoid network/decode burst
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

  if (isError) {
    return (
      <div className="min-h-screen flex items-center justify-center text-[#4a5565]">
        {t('details.notFound', { ns: 'properties' })}{' '}
        <Link to="/search" className="text-[#3A6EA5] hover:underline ml-1">
          {t('details.backToSearch', { ns: 'properties' })}
        </Link>
      </div>
    )
  }

  return (
    <div className="min-h-screen pb-20">
      <div className="max-w-[1440px] mx-auto px-8 py-8">
        {/* Header Actions */}
        <div className="flex items-center justify-between mb-6">
          <Link
            to="/search"
            className="flex items-center gap-2 text-[#4a5565] hover:text-[#3A6EA5] transition-colors"
          >
            <ChevronLeft className="w-5 h-5 rtl:rotate-180" />
            {t('details.backToSearch', { ns: 'properties' })}
          </Link>
          <div className="flex gap-3">
            <Button
              variant="outline"
              size="icon"
              className="rounded-xl border-[#3A6EA5]/20 hover:bg-[#9CBBDC]/20"
              onClick={handleShare}
            >
              <Share2 className="w-5 h-5" />
            </Button>
            <Button
              variant="outline"
              size="icon"
              className="rounded-xl border-[#3A6EA5]/20 hover:bg-[#9CBBDC]/20"
              onClick={handleToggleFavorite}
            >
              <Heart
                className={`w-5 h-5 ${isFavorite ? 'fill-[#3A6EA5] text-[#3A6EA5]' : ''}`}
              />
            </Button>
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button
                  variant="outline"
                  size="icon"
                  className="rounded-xl border-[#3A6EA5]/20 hover:bg-[#9CBBDC]/20"
                >
                  <MoreVertical className="w-5 h-5 text-[#4a5565]" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="rounded-xl">
                <DropdownMenuItem
                  className="text-red-600 focus:text-red-600 focus:bg-red-50 cursor-pointer"
                  onClick={() => setIsReportModalOpen(true)}
                >
                  <ShieldAlert className="w-4 h-4 mr-2 rtl:ml-2 rtl:mr-0" />
                  {t('details.reportProperty', { ns: 'properties' })}
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>

        {/* Image Gallery */}
        <div className="mb-8 relative rounded-3xl overflow-hidden bg-white shadow-xl shadow-[#3A6EA5]/10 aspect-[21/9]">
          {isLoading ? (
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
              {t('details.noImages', { ns: 'properties' })}
            </div>
          )}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2">
            {/* Title & Rating */}
            <div className="mb-6">
              {isLoading ? (
                <div className="space-y-3">
                  <Skeleton className="h-10 w-3/4" />
                  <Skeleton className="h-5 w-1/2" />
                  <Skeleton className="h-5 w-1/3" />
                </div>
              ) : (
                <>
                  <div className="flex items-start justify-between mb-3">
                    <div>
                      <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
                        {property?.title}
                      </h1>
                      <div className="flex items-center gap-2 text-[#4a5565]">
                        <MapPin className="w-5 h-5" />
                        <span>{property?.address ?? property?.location}</span>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center gap-4 flex-wrap">
                    {property?.rating !== undefined && (
                      <>
                        <div className="flex items-center gap-1">
                          <Star className="w-5 h-5 fill-[#3A6EA5] text-[#3A6EA5]" />
                          <span className="font-semibold text-[#1a1a1a]">
                            {Math.round(property.rating * 10) / 10}
                          </span>
                          {property.reviews !== undefined && (
                            <span className="text-[#4a5565]">
                              ({property.reviews} {t('details.reviews', { ns: 'properties' })})
                            </span>
                          )}
                        </div>
                        <span className="text-[#4a5565]">•</span>
                      </>
                    )}
                    <span className="px-3 py-1 bg-[#9CBBDC]/20 rounded-full text-sm text-[#1a1a1a]">
                      {property?.type}
                    </span>
                    <span className="text-[#4a5565]">•</span>
                    <span className="text-[#1a1a1a]">
                      {(property as any)?.bedrooms ?? property?.beds} {((property as any)?.bedrooms ?? property?.beds) === 1 ? t('details.bed', { ns: 'properties' }) : t('details.beds', { ns: 'properties' })} • {(property as any)?.bathrooms ?? property?.baths} {((property as any)?.bathrooms ?? property?.baths) === 1 ? t('details.bath', { ns: 'properties' }) : t('details.baths', { ns: 'properties' })}
                      {property?.area ? ` • ${property.area} ${t('details.sqft', { ns: 'properties' })}` : ''}
                    </span>
                  </div>
                </>
              )}
            </div>

            {/* Description */}
            {isLoading ? (
              <div className="mb-8 p-6 bg-[#f5f7fa] rounded-3xl space-y-3">
                <Skeleton className="h-6 w-1/3" />
                <Skeleton className="h-4 w-full" />
                <Skeleton className="h-4 w-5/6" />
                <Skeleton className="h-4 w-4/5" />
              </div>
            ) : property?.description ? (
              <div className="mb-8 p-6 bg-[#f5f7fa] rounded-3xl">
                <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-4">
                  {t('details.aboutProperty', { ns: 'properties' })}
                </h2>
                <p dir="auto" className="text-[#1a1a1a] leading-relaxed">
                  {property.description}
                </p>
              </div>
            ) : null}

            {/* Amenities */}
            {!isLoading && property?.amenities?.length ? (
              <div className="mb-8 p-6 bg-[#f5f7fa] rounded-3xl">
                <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-6">
                  {t('details.amenities', { ns: 'properties' })}
                </h2>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  {property.amenities.map((amenityItem: any) => {
                    const name = typeof amenityItem === 'string'
                      ? amenityItem
                      : (amenityItem.amenityDisplayName || amenityItem.amenity)
                    const key = typeof amenityItem === 'string' ? amenityItem : (amenityItem.id || name)
                    const Icon = AMENITY_ICONS[name]
                    return (
                      <div
                        key={key}
                        className="flex flex-col items-center gap-2 p-4 bg-white rounded-2xl"
                      >
                        <div className="w-12 h-12 rounded-xl bg-[#9CBBDC]/20 flex items-center justify-center">
                          {Icon ? (
                            <Icon className="w-6 h-6 text-[#3A6EA5]" />
                          ) : (
                            <Check className="w-6 h-6 text-[#3A6EA5]" />
                          )}
                        </div>
                        <span className="text-sm text-[#1a1a1a] text-center">
                          {name}
                        </span>
                      </div>
                    )
                  })}
                </div>
              </div>
            ) : null}

            {/* Current Tenants */}
            {!isLoading && property?.activeRenters && property.activeRenters.length > 0 && (
              <div className="p-6 bg-[#f5f7fa] rounded-3xl mb-8">
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-2xl font-semibold text-[#1a1a1a]">
                    {t('details.currentTenants', { ns: 'properties' })}
                  </h2>
                  {isShared && (
                    <span className="px-3 py-1 bg-[#3A6EA5]/10 text-[#3A6EA5] rounded-full text-sm font-medium">
                      {currentOccupantsCount} / {maxOccupants} {t('details.occupied', { ns: 'properties' })}
                    </span>
                  )}
                </div>
                <div className="flex items-center gap-3">
                  {property.activeRenters.map((tenant: any) => (
                    <Avatar
                      key={tenant.id}
                      className="w-14 h-14 border-2 border-white shadow-sm cursor-pointer hover:ring-2 hover:ring-[#3A6EA5] transition-all"
                      onClick={() => handleTenantClick(tenant)}
                    >
                      <AvatarImage src={tenant.profilePhoto ? getImageUrl(tenant.profilePhoto) : undefined} className="object-cover" />
                      <AvatarFallback>{tenant.name?.slice(0, 2).toUpperCase() || 'T'}</AvatarFallback>
                    </Avatar>
                  ))}
                </div>
                {isShared && hasSpace && (
                  <div className="mt-4 p-4 bg-green-50 border border-green-200 rounded-xl flex items-start gap-3">
                    <Check className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
                    <p className="text-sm text-green-800">
                      {t('details.sharedSpaceAvailable', { ns: 'properties' })}
                    </p>
                  </div>
                )}
                {isShared && !hasSpace && (
                  <div className="mt-4 p-4 bg-red-50 border border-red-200 rounded-xl flex items-start gap-3">
                    <ShieldAlert className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                    <p className="text-sm text-red-800">
                      {t('details.sharedSpaceFull', { ns: 'properties' })}
                    </p>
                  </div>
                )}
              </div>
            )}

            {/* Owner Profile */}
            {!isLoading && (
              <div className="p-6 bg-[#f5f7fa] rounded-3xl mb-8">
                <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-6">
                  {t('details.hostedBy', { ns: 'properties' })}
                </h2>
                <div className="flex items-center gap-4 mb-4">
                  <Avatar className="w-16 h-16">
                    {effectiveOwnerAvatar && (
                      <AvatarImage src={effectiveOwnerAvatar} />
                    )}
                    <AvatarFallback>
                      {effectiveOwnerName ? effectiveOwnerName.slice(0, 2).toUpperCase() : 'JD'}
                    </AvatarFallback>
                  </Avatar>
                  <div className="flex-1">
                    <Link to={`/owner/${effectiveOwnerId}`} className="hover:underline">
                      <h3 className="font-semibold text-lg text-[#1a1a1a]">
                        {effectiveOwnerName}
                      </h3>
                    </Link>
                    <div className="flex items-center gap-2 text-sm text-[#4a5565]">
                      <Star className="w-4 h-4 fill-[#3A6EA5] text-[#3A6EA5]" />
                      <span>{Math.round(effectiveOwnerRating * 10) / 10} {t('details.rating', { ns: 'properties' })} • {effectiveOwnerPropertiesCount} {t('details.properties', { ns: 'properties' })}</span>
                    </div>
                  </div>
                  <div className="flex flex-col gap-2">
                    <Button
                      variant="outline"
                      className="rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white"
                      onClick={() => {
                        const params = new URLSearchParams({
                          recipientId: effectiveOwnerId,
                          ownerName: effectiveOwnerName,
                          avatarUrl: effectiveOwnerAvatar || '',
                        })
                        navigate(`/messages?${params.toString()}`)
                      }}
                    >
                      <MessageSquare className="w-4 h-4 mr-2 rtl:ml-2 rtl:mr-0" />
                      {t('details.message', { ns: 'properties' })}
                    </Button>
                    {effectiveOwnerEmail && (
                      <button
                        onClick={() => copyToClipboard(effectiveOwnerEmail)}
                        className="flex items-center justify-center gap-2 px-4 py-2 cursor-pointer w-full hover:bg-[#f0f4f8] transition-colors rounded-xl text-sm font-medium text-[#3A6EA5] border border-transparent hover:border-[#3A6EA5]/20"
                      >
                        <Mail className="w-4 h-4 text-[#3A6EA5]" />
                        {effectiveOwnerEmail}
                      </button>
                    )}
                  </div>
                </div>
                <p dir="auto" className="text-[#1a1a1a] mt-4">
                  {effectiveOwnerBio}
                </p>
              </div>
            )}

            {/* Reviews Section */}
            <div className="p-6 bg-[#f5f7fa] rounded-3xl mt-8 mb-8">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-2xl font-semibold text-[#1a1a1a]">
                  {t('details.reviews', { ns: 'properties' })} ({ratingSummary?.ratingsCount || property?.reviews || 0})
                </h2>
                <div className="flex items-center gap-2">
                  <Star className="w-6 h-6 fill-[#FFB800] text-[#FFB800]" />
                  <span className="text-2xl font-bold text-[#1a1a1a]">
                    {Math.round((ratingSummary?.averageRating || property?.rating || 0) * 10) / 10}
                  </span>
                </div>
              </div>

              {/* Add Review Form */}
              {isAuthenticated ? (
                <div className="p-4 bg-white rounded-2xl mb-6">
                  <h4 className="font-semibold text-[#1a1a1a] mb-3">{t('details.leaveReview', { ns: 'properties' })}</h4>
                  <div className="flex items-center gap-2 mb-3">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <button
                        key={star}
                        onClick={() => setNewCommentRating(star)}
                        className="hover:scale-110 transition-transform"
                      >
                        <Star
                          className={`w-6 h-6 ${star <= newCommentRating
                            ? 'fill-[#FFB800] text-[#FFB800]'
                            : 'text-[#4a5565]/30'
                            }`}
                        />
                      </button>
                    ))}
                  </div>
                  <Textarea
                    placeholder={t('details.shareExperience', { ns: 'properties' })}
                    value={newCommentText}
                    onChange={(e) => setNewCommentText(e.target.value)}
                    className="mb-3 resize-none bg-[#f5f7fa] border-none"
                    rows={3}
                  />
                  <TooltipProvider delayDuration={1000}>
                    <Tooltip delayDuration={1000}>
                      <TooltipTrigger asChild>
                        <span className="inline-block w-full">
                          <Button
                            onClick={handleSubmitComment}
                            disabled={isSubmittingComment || !newCommentText.trim() || newCommentRating === 0}
                            className="bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white w-full disabled:pointer-events-auto"
                          >
                            {isSubmittingComment ? t('details.submitting', { ns: 'properties' }) : t('details.postReview', { ns: 'properties' })}
                          </Button>
                        </span>
                      </TooltipTrigger>
                      {(!newCommentText.trim() || newCommentRating === 0) && (
                        <TooltipContent>
                          <p>{t('details.selectRatingAndComment', { ns: 'properties' })}</p>
                        </TooltipContent>
                      )}
                    </Tooltip>
                  </TooltipProvider>
                </div>
              ) : (
                <div className="p-4 bg-white rounded-2xl mb-6 flex flex-col items-center justify-center text-center">
                  <p className="text-[#4a5565] mb-4">{t('details.loginToReview', { ns: 'properties' })}</p>
                  <Button onClick={() => navigate('/login')} className="bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white">
                    {t('details.login', { ns: 'common', defaultValue: 'Login' })}
                  </Button>
                </div>
              )}

              <div className="space-y-4">
                {displayComments.length > 0 ? (
                  displayComments.map((comment: any) => {
                    const isCurrentUser = (comment.commenterId || comment.userId) === user?.id;
                    const profileImage = comment.commenterProfileImage || comment.userProfileImage;
                    const displayName = comment.commenterFullName || comment.userDisplayName || 'Guest';
                    const commentRating = isCurrentUser ? (comment.rating || ratingSummary?.currentUserFeedback?.rating) : comment.rating;

                    return (
                    <div key={comment.commentId || comment.feedbackId} className="p-4 bg-white rounded-2xl">
                      <div className="flex items-start gap-4 mb-3">
                        <Link to={`/user/${comment.commenterId || comment.userId}`}>
                          <Avatar className="w-12 h-12 hover:ring-2 hover:ring-[#3A6EA5] transition-all cursor-pointer">
                            {profileImage && <AvatarImage src={getImageUrl(profileImage)} />}
                            <AvatarFallback>
                              {displayName?.slice(0, 2).toUpperCase() || 'U'}
                            </AvatarFallback>
                          </Avatar>
                        </Link>
                        <div className="flex-1">
                          <div className="flex items-center justify-between mb-1">
                            <div className="flex flex-col gap-1">
                              <Link to={`/user/${comment.commenterId || comment.userId}`} className="hover:underline">
                                <h4 className="font-semibold text-[#1a1a1a] flex items-center gap-2">
                                  {displayName}
                                  {isCurrentUser && (
                                    <span className="text-xs bg-[#3A6EA5]/10 text-[#3A6EA5] px-2 py-0.5 rounded-full font-medium no-underline">
                                      {t('details.yourReview', { ns: 'properties' })}
                                    </span>
                                  )}
                                </h4>
                              </Link>
                              {commentRating !== undefined && commentRating > 0 && (
                                <div className="flex items-center gap-0.5">
                                  {Array.from({ length: 5 }).map((_, i) => (
                                    <Star
                                      key={i}
                                      className={`w-3.5 h-3.5 ${
                                        i < commentRating
                                          ? 'fill-[#f59e0b] text-[#f59e0b]'
                                          : 'fill-gray-200 text-gray-200'
                                      }`}
                                    />
                                  ))}
                                </div>
                              )}
                            </div>
                            <div className="flex items-center gap-3">
                              <span className="text-sm text-[#4a5565]">
                                {formatDistanceToNow(new Date(comment.createdAt), { addSuffix: true })}
                              </span>
                              {isAuthenticated && (
                                <DropdownMenu>
                                  <DropdownMenuTrigger asChild>
                                    <Button variant="ghost" size="icon" className="h-8 w-8 text-[#4a5565] hover:bg-[#F2F4F6]">
                                      <MoreVertical className="w-4 h-4" />
                                    </Button>
                                  </DropdownMenuTrigger>
                                  <DropdownMenuContent align="end" className="rounded-xl">
                                    {isCurrentUser ? (
                                      <>
                                        <DropdownMenuItem
                                          className="text-[#1a1a1a] focus:bg-gray-50 cursor-pointer"
                                          onClick={() => {
                                            setEditingCommentId(comment.feedbackId)
                                            setEditContent(comment.content)
                                          }}
                                        >
                                          <Edit className="w-4 h-4 mr-2 rtl:ml-2 rtl:mr-0" />
                                          {t('details.editReview', { ns: 'properties' })}
                                        </DropdownMenuItem>
                                        <DropdownMenuItem
                                          className="text-red-600 focus:text-red-600 focus:bg-red-50 cursor-pointer"
                                          onClick={() => setDeleteCommentId(comment.feedbackId)}
                                          disabled={deleteFeedback.isPending}
                                        >
                                          <ShieldAlert className="w-4 h-4 mr-2 rtl:ml-2 rtl:mr-0" />
                                          {t('details.deleteReview', { ns: 'properties' })}
                                        </DropdownMenuItem>
                                      </>
                                    ) : (
                                      <DropdownMenuItem
                                        className="text-red-600 focus:text-red-600 focus:bg-red-50 cursor-pointer"
                                        onClick={() => {
                                          setSelectedReviewToReport(comment)
                                          setIsReviewReportModalOpen(true)
                                        }}
                                      >
                                        <ShieldAlert className="w-4 h-4 mr-2 rtl:ml-2 rtl:mr-0" />
                                        {t('details.reportReview', { ns: 'properties' })}
                                      </DropdownMenuItem>
                                    )}
                                  </DropdownMenuContent>
                                </DropdownMenu>
                              )}
                            </div>
                          </div>
                          {editingCommentId === comment.feedbackId ? (
                            <div className="mt-2 flex flex-col gap-2">
                              <Textarea
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
                                  {t('details.cancel', { ns: 'common', defaultValue: 'Cancel' })}
                                </Button>
                                <Button
                                  size="sm"
                                  onClick={() => handleEditSubmit(comment.feedbackId)}
                                  disabled={updateComment.isPending}
                                  className="bg-[#3A6EA5] hover:bg-[#2C5580] text-white rounded-xl h-8 text-xs"
                                >
                                  {t('details.save', { ns: 'common', defaultValue: 'Save' })}
                                </Button>
                              </div>
                            </div>
                          ) : (
                            <p dir="auto" className="text-[#1a1a1a] text-sm leading-relaxed mt-2">
                              {comment.content}
                            </p>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                  })
                ) : (
                  <p className="text-center text-[#4a5565] py-4">
                    {t('details.noReviews', { ns: 'properties' })}
                  </p>
                )}
              </div>
            </div>
          </div>

          {/* Booking Widget */}
          <div className="lg:col-span-1">
            <div className="sticky top-24">
              <div className="bg-[#f5f7fa] rounded-3xl p-6 shadow-2xl shadow-[#3A6EA5]/20">
                {isLoading ? (
                  <div className="space-y-4">
                    <Skeleton className="h-10 w-2/3" />
                    <Skeleton className="h-10 w-full" />
                    <Skeleton className="h-10 w-full" />
                    <Skeleton className="h-12 w-full" />
                  </div>
                ) : (
                  <>
                    <div className="mb-6">
                      <div className="flex items-baseline gap-2 mb-1">
                        <span className="text-4xl font-bold text-[#3A6EA5]">
                          {property?.price?.toLocaleString()} {t('egp', { ns: 'properties' })}
                        </span>
                        <span className="text-[#4a5565]">/ {t('details.month', { ns: 'properties' })}</span>
                      </div>
                      {property?.rating !== undefined && (
                        <div className="flex items-center gap-1 text-sm">
                          <Star className="w-4 h-4 fill-[#3A6EA5] text-[#3A6EA5]" />
                          <span className="text-[#1a1a1a]">
                            {property.rating}{' '}
                            {property.reviews !== undefined &&
                              `(${property.reviews} ${t('details.reviews', { ns: 'properties' })})`}
                          </span>
                        </div>
                      )}
                    </div>

                    {/* Date Selectors */}
                    <div className="space-y-4 mb-6">
                      <div>
                        <label className="text-sm text-[#1a1a1a] mb-2 block">
                          {t('details.moveInDate', { ns: 'properties' })}
                        </label>
                        <Popover>
                          <PopoverTrigger asChild>
                            <Button
                              variant="outline"
                              className="w-full justify-start text-start rounded-xl border-[#3A6EA5]/20 hover:bg-white"
                            >
                              <Calendar className="mr-2 h-4 w-4 text-[#3A6EA5]" />
                              {checkIn ? format(checkIn, 'PPP') : t('details.selectDate', { ns: 'properties' })}
                            </Button>
                          </PopoverTrigger>
                          <PopoverContent className="w-auto p-0" align="start">
                            <CalendarComponent
                              mode="single"
                              selected={checkIn}
                              onSelect={setCheckIn}
                              initialFocus
                            />
                          </PopoverContent>
                        </Popover>
                      </div>
                      <div>
                        <label className="text-sm text-[#1a1a1a] mb-2 block">
                          {t('details.duration', { ns: 'properties' })}
                        </label>
                        <Select value={duration} onValueChange={setDuration}>
                          <SelectTrigger className="w-full rounded-xl border-[#3A6EA5]/20 bg-white">
                            <SelectValue placeholder={t('details.selectDuration', { ns: 'properties' })} />
                          </SelectTrigger>
                          <SelectContent>
                            {Array.from(
                              { length: property?.rentalUnit === 'Daily' ? 30 : property?.rentalUnit === 'Yearly' ? 5 : 12 },
                              (_, i) => i + 1
                            ).map((num) => {
                              const unitLabel = property?.rentalUnit === 'Daily' 
                                ? t('details.days', { count: num, ns: 'properties' })
                                : property?.rentalUnit === 'Yearly'
                                ? t('details.years', { count: num, ns: 'properties' })
                                : t('details.months', { count: num, ns: 'properties' });
                              return (
                                <SelectItem key={num} value={num.toString()}>
                                  {num} {unitLabel}
                                </SelectItem>
                              );
                            })}
                          </SelectContent>
                        </Select>
                      </div>
                    </div>


                    {/* Price Summary */}
                    <div className="space-y-3 mb-6 p-4 bg-white rounded-2xl">
                      <div className="flex justify-between text-[#1a1a1a]">
                        <span>{t('details.monthlyRent', { ns: 'properties' })}</span>
                        <span>{property?.price?.toLocaleString()} {t('egp', { ns: 'properties' })}</span>
                      </div>
                      <div className="flex justify-between text-[#1a1a1a]">
                        <span>{t('details.securityDeposit', { ns: 'properties' })}</span>
                        <span>{property?.price?.toLocaleString()} {t('egp', { ns: 'properties' })}</span>
                      </div>
                      <div className="flex justify-between text-[#1a1a1a]">
                        <span>{t('details.serviceFee', { ns: 'properties' })}</span>
                        <span>
                          {Math.round(
                            (property?.price ?? 0) * 0.05,
                          ).toLocaleString()}{' '}
                          {t('egp', { ns: 'properties' })}
                        </span>
                      </div>
                      <div className="border-t border-[#3A6EA5]/20 pt-3 flex justify-between font-semibold text-[#1a1a1a]">
                        <span>{t('details.totalFirstMonth', { ns: 'properties' })}</span>
                        <span className="text-[#3A6EA5]">
                          {Math.round(
                            (property?.price ?? 0) * 2.05,
                          ).toLocaleString()}{' '}
                          {t('egp', { ns: 'properties' })}
                        </span>
                      </div>
                    </div>

                    <Button
                      size="lg"
                      disabled={bookMutation.isPending || !canBook}
                      onClick={handleBookNow}
                      className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl shadow-lg shadow-[#3A6EA5]/30 mb-3 disabled:opacity-50"
                    >
                      {bookMutation.isPending ? (
                        <>
                          <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                          {t('details.sendingRequest', { ns: 'properties' })}
                        </>
                      ) : !canBook ? (
                        unavailableText
                      ) : (
                        t('details.bookNow', { ns: 'properties' })
                      )}
                    </Button>

                    <Button
                      variant="outline"
                      size="lg"
                      className="w-full rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white"
                      onClick={handleScheduleTour}
                    >
                      {t('details.scheduleTour', { ns: 'properties' })}
                    </Button>

                    <p className="text-xs text-center text-[#4a5565] mt-4">
                      {t('details.wontBeChargedYet', { ns: 'properties' })}
                    </p>
                  </>
                )}
              </div>

              {/* Additional Info */}
              <div className="mt-6 p-4 bg-[#9CBBDC]/20 rounded-2xl">
                <div className="flex items-start gap-3">
                  <Users className="w-5 h-5 text-[#3A6EA5] flex-shrink-0 mt-1" />
                  <div>
                    <h4 className="font-semibold text-[#1a1a1a] mb-1">
                      {t('details.lookingForRoommates', { ns: 'properties' })}
                    </h4>
                    <Link to="/roommate-matching" className="text-sm text-[#3A6EA5] hover:underline font-medium">
                      {t('details.roommateFeature', { ns: 'properties' })}
                    </Link>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Dialog open={isReportModalOpen} onOpenChange={(open) => {
        setIsReportModalOpen(open)
        if (!open) setReportReason('')
      }}>
        <DialogContent className="sm:max-w-[425px] rounded-2xl">
          <DialogHeader>
            <DialogTitle>{t('details.reportProperty', { ns: 'properties' })}</DialogTitle>
          </DialogHeader>
          <div className="py-4">
            <p className="text-sm text-[#4a5565] mb-4">
              {t('details.reportPropertyReason', { ns: 'properties' })}
            </p>
            <Textarea
              placeholder={t('details.reasonForReport', { ns: 'properties' })}
              value={reportReason}
              onChange={(e) => setReportReason(e.target.value)}
              className="min-h-[100px] rounded-xl resize-none"
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsReportModalOpen(false)} className="rounded-xl">
              {t('details.cancel', { ns: 'common', defaultValue: 'Cancel' })}
            </Button>
            <Button
              onClick={handleReportSubmit}
              disabled={!reportReason.trim() || submitReport.isPending}
              className="bg-red-600 hover:bg-red-700 text-white rounded-xl"
            >
              {submitReport.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : null}
              {t('details.submitReport', { ns: 'properties' })}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isReviewReportModalOpen} onOpenChange={(open) => {
        setIsReviewReportModalOpen(open)
        if (!open) {
          setReviewReportReason('')
          setSelectedReviewToReport(null)
        }
      }}>
        <DialogContent className="sm:max-w-[425px] rounded-2xl">
          <DialogHeader>
            <DialogTitle>{t('details.reportReview', { ns: 'properties' })}</DialogTitle>
          </DialogHeader>
          <div className="py-4">
            <p className="text-sm text-[#4a5565] mb-4">
              {t('details.reportReviewReason', { ns: 'properties' })}
            </p>
            <Textarea
              placeholder={t('details.reasonForReport', { ns: 'properties' })}
              value={reviewReportReason}
              onChange={(e) => setReviewReportReason(e.target.value)}
              className="min-h-[100px] rounded-xl resize-none"
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsReviewReportModalOpen(false)} className="rounded-xl">
              {t('details.cancel', { ns: 'common', defaultValue: 'Cancel' })}
            </Button>
            <Button
              onClick={handleReviewReportSubmit}
              disabled={!reviewReportReason.trim() || submitReport.isPending}
              className="bg-red-600 hover:bg-red-700 text-white rounded-xl"
            >
              {submitReport.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : null}
              {t('details.submitReport', { ns: 'properties' })}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isTenantModalOpen} onOpenChange={setIsTenantModalOpen}>
        <DialogContent className="sm:max-w-[425px] rounded-2xl">
          <DialogHeader>
            <DialogTitle>{t('details.tenantProfile', { ns: 'properties' })}</DialogTitle>
          </DialogHeader>
          <div className="flex flex-col items-center py-4">
            <Link to={`/user/${selectedTenant?.userId || selectedTenant?.id}`} className="flex flex-col items-center hover:opacity-80 transition-opacity">
              <Avatar className="w-24 h-24 mb-4 border-2 border-transparent hover:border-[#3A6EA5]/20">
                <AvatarImage src={selectedTenant?.profilePhoto ? getImageUrl(selectedTenant.profilePhoto) : undefined} className="object-cover" />
                <AvatarFallback>{selectedTenant?.name?.slice(0, 2).toUpperCase() || 'T'}</AvatarFallback>
              </Avatar>
              <h3 className="text-lg font-semibold text-[#1a1a1a] mb-2 hover:underline hover:text-[#3A6EA5] transition-colors">{selectedTenant?.name}</h3>
            </Link>
            {selectedTenant?.matchingPercentage !== undefined && selectedTenant?.matchingPercentage !== null ? (
              <div className="px-4 py-2 bg-[#9CBBDC]/20 text-[#3A6EA5] rounded-full text-sm font-medium">
                {t('details.matchRate', { ns: 'properties' })}: {selectedTenant.matchingPercentage}%
              </div>
            ) : (
              <div className="px-4 py-2 bg-gray-100 text-gray-500 rounded-full text-sm">
                {t('details.matchRateHidden', { ns: 'properties' })}
              </div>
            )}
          </div>
        </DialogContent>
      </Dialog>

      {/* Delete Review Confirmation Modal */}
      {deleteCommentId && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-3xl p-8 max-w-md w-full shadow-2xl"
          >
            <h3 className="text-2xl font-bold text-[#1a1a1a] mb-4">
              {t('details.deleteReview', { ns: 'properties' })}
            </h3>
            <p className="text-[#4a5565] mb-6">
              {t('details.confirmDeleteReview', { ns: 'properties' })}
            </p>
            <div className="flex gap-4">
              <Button
                variant="outline"
                className="flex-1 rounded-xl border-[#3A6EA5]/20"
                onClick={() => setDeleteCommentId(null)}
              >
                {t('details.cancel', { ns: 'common', defaultValue: 'Cancel' })}
              </Button>
              <Button
                className="flex-1 bg-[#FF4D4F] hover:bg-[#E04343] text-white rounded-xl"
                disabled={deleteFeedback.isPending}
                onClick={() => {
                  deleteFeedback.mutate({ propertyId: id! }, {
                    onSuccess: () => {
                      setDeleteCommentId(null)
                      toast.success(t('details.reviewDeletedSuccess', { ns: 'properties' }))
                    },
                    onError: () => {
                      setDeleteCommentId(null)
                      toast.error(t('details.failedToDeleteReview', { ns: 'properties' }))
                    },
                  })
                }}
              >
                {deleteFeedback.isPending ? t('details.sendingRequest', { ns: 'properties' }) : t('details.deleteReview', { ns: 'properties' })}
              </Button>
            </div>
          </motion.div>
        </div>
      )}

      {/* Existing Review Prompt Modal */}
      {showExistingReviewModal && existingUserComment && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-3xl p-8 max-w-md w-full shadow-2xl"
          >
            <h3 className="text-2xl font-bold text-[#1a1a1a] mb-4">
              {t('details.existingReview', { ns: 'properties' })}
            </h3>
            <p className="text-[#4a5565] mb-4">
              {t('details.existingReviewMessage', { ns: 'properties' })}
            </p>

            {/* Show existing review details */}
            <div className="p-4 bg-[#f5f7fa] rounded-2xl mb-6">
              <div className="flex items-center gap-0.5 mb-2">
                {Array.from({ length: 5 }).map((_, i) => {
                  const existingRating = existingUserComment.rating || ratingSummary?.currentUserFeedback?.rating || 0;
                  return (
                    <Star
                      key={i}
                      className={`w-4 h-4 ${
                        i < existingRating
                          ? 'fill-[#f59e0b] text-[#f59e0b]'
                          : 'fill-gray-200 text-gray-200'
                      }`}
                    />
                  );
                })}
              </div>
              <p dir="auto" className="text-[#1a1a1a] text-sm leading-relaxed">
                {existingUserComment.content}
              </p>
            </div>

            <div className="flex gap-4">
              <Button
                variant="outline"
                className="flex-1 rounded-xl border-[#3A6EA5]/20"
                onClick={() => {
                  setShowExistingReviewModal(false)
                  setExistingUserComment(null)
                }}
              >
                {t('details.cancel', { ns: 'common', defaultValue: 'Cancel' })}
              </Button>
              <Button
                className="flex-1 bg-[#FF4D4F] hover:bg-[#E04343] text-white rounded-xl"
                disabled={deleteFeedback.isPending}
                onClick={() => {
                  deleteFeedback.mutate(
                    { propertyId: id! },
                    {
                      onSuccess: () => {
                        setShowExistingReviewModal(false)
                        setExistingUserComment(null)
                        toast.success(t('details.previousReviewDeleted', { ns: 'properties' }))
                        executeSubmitComment()
                      },
                      onError: () => {
                        setShowExistingReviewModal(false)
                        setExistingUserComment(null)
                        toast.error(t('details.failedToDeleteReview', { ns: 'properties' }))
                      },
                    }
                  )
                }}
              >
                {deleteFeedback.isPending
                  ? t('details.sendingRequest', { ns: 'properties' })
                  : t('details.deleteReview', { ns: 'properties' })}
              </Button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  )
}
