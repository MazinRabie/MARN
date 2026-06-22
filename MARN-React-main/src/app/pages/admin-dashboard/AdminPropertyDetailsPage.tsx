import { useState, useMemo } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import {
  ChevronLeft,
  ChevronRight,
  MapPin,
  Star,
  Building,
  Bed,
  Bath,
  Maximize2,
  Users,
  Eye,
  CheckCircle,
  ShieldAlert,
  Loader2,
  Mail,
  Phone,
  Calendar,
  FileText
} from 'lucide-react'
import { toast } from 'sonner'
import { Button } from '../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Avatar, AvatarFallback, AvatarImage } from '../../components/ui/avatar'
import { Badge } from '../../components/ui/badge'
import { Skeleton } from '../../components/ui/skeleton'
import { useAdminPropertyDetails } from '@/hooks/useAdminPropertyDetails'
import { getImageUrl } from '@/constants/assets'
import { getStatusBadge } from './utils'
import { ImageWithFallback } from '../../components/figma/ImageWithFallback'

export function AdminPropertyDetailsPage() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { data, isLoading, isError } = useAdminPropertyDetails(id)
  const { t } = useTranslation('admin')
  
  const [currentImageIndex, setCurrentImageIndex] = useState(0)

  const property = data?.data

  const copyToClipboard = (text: string) => {
    if (!text) return
    navigator.clipboard.writeText(text)
    toast.success(t('propertyDetailsPage.copied'))
  }

  const images: any[] = useMemo(() => {
    if (!property?.media?.length) return []
    return property.media.sort((a: any, b: any) => (b.isPrimary ? 1 : 0) - (a.isPrimary ? 1 : 0))
  }, [property])

  const nextImage = () => setCurrentImageIndex((prev) => (prev + 1) % Math.max(images.length, 1))
  const prevImage = () => setCurrentImageIndex((prev) => (prev - 1 + Math.max(images.length, 1)) % Math.max(images.length, 1))

  const locationString = useMemo(() => {
    if (!property) return ''
    const locationParts = [property.address, property.cityDisplayName, property.governorateDisplayName].filter(Boolean)
    // to remove duplicates, like Cairo, Cairo
    const uniqueLocationParts = locationParts.filter((part, index, self) => index === self.findIndex((p) => p?.toLowerCase() === part?.toLowerCase()))
    return uniqueLocationParts.join(', ') + (property.zipCode ? ` ${property.zipCode}` : '')
  }, [property])

  if (isLoading) {
    return (
      <div className="min-h-screen p-8 space-y-8 max-w-[1440px] mx-auto">
        <Skeleton className="h-[400px] w-full rounded-3xl" />
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div className="lg:col-span-2 space-y-8">
            <Skeleton className="h-64 w-full rounded-3xl" />
            <Skeleton className="h-64 w-full rounded-3xl" />
          </div>
          <div className="space-y-8">
            <Skeleton className="h-64 w-full rounded-3xl" />
            <Skeleton className="h-64 w-full rounded-3xl" />
          </div>
        </div>
      </div>
    )
  }

  if (isError || !property) {
    return (
      <div className="min-h-screen flex items-center justify-center flex-col gap-4 text-[#4a5565]">
        <p className="text-xl">{t('propertyDetailsPage.notFound')}</p>
        <Button variant="outline" onClick={() => navigate('/admin-dashboard')}>
          {t('propertyDetailsPage.backToDashboard')}
        </Button>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-[#F2F4F6] pb-20">
      <div className="max-w-[1440px] mx-auto px-4 sm:px-8 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <Button
            variant="ghost"
            onClick={() => navigate('/admin-dashboard')}
            className="flex items-center gap-2 text-[#4a5565] hover:text-[#3A6EA5] hover:bg-[#3A6EA5]/10"
          >
            <ChevronLeft className="w-5 h-5 rtl:rotate-180" />
            {t('propertyDetailsPage.backToDashboard')}
          </Button>
          <div className="flex items-center gap-3">
            {getStatusBadge(property.statusDisplayName)}
            {!property.isActive && (
              <Badge variant="secondary" className="bg-gray-200 text-gray-700">{t('propertyDetailsPage.inactive')}</Badge>
            )}
            {property.isDeleted && (
              <Badge variant="destructive">{t('propertyDetailsPage.deleted')}</Badge>
            )}
          </div>
        </div>

        {/* Image Gallery */}
        <div className="mb-8 relative rounded-3xl overflow-hidden bg-white shadow-xl shadow-[#3A6EA5]/10 aspect-[21/9]">
          {images.length > 0 ? (
            <>
              <ImageWithFallback
                src={getImageUrl(images[currentImageIndex].path)}
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
            <div className="w-full h-full bg-[#9CBBDC]/20 flex items-center justify-center text-[#4a5565] flex-col gap-2">
              <Building className="w-12 h-12 opacity-50" />
              <span>{t('propertyDetailsPage.noImages')}</span>
            </div>
          )}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-8">
            
            {/* Overview Card */}
            <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5 overflow-hidden">
              <CardContent className="p-6 sm:p-8">
                <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4 mb-6">
                  <div>
                    <h1 className="text-3xl font-bold text-[#1a1a1a] mb-2">{property.title}</h1>
                    <div className="flex items-center gap-2 text-[#4a5565] text-sm sm:text-base">
                      <MapPin className="w-4 h-4" />
                      <span>{locationString}</span>
                    </div>
                    <div className="text-xs text-[#6B7280] mt-1 ltr:ml-6 rtl:mr-6">
                      Lat: {property.latitude} | Lng: {property.longitude}
                    </div>
                  </div>
                  <div className="shrink-0 bg-[#F5F7FA] p-4 rounded-2xl text-end">
                    <p className="text-xs text-[#6B7280] uppercase tracking-wider font-semibold mb-1">{t('propertyDetailsPage.price')}</p>
                    <div className="text-2xl font-bold text-[#3A6EA5]">
                      {property.price?.toLocaleString()} <span className="text-sm font-normal text-[#4a5565]">{t('propertyDetailsPage.egp')} / {property.rentalUnitDisplayName}</span>
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 py-6 border-y border-gray-100 mb-6">
                  <div className="flex flex-col items-center justify-center text-center p-3 bg-[#F5F7FA] rounded-xl">
                    <Building className="w-5 h-5 text-[#3A6EA5] mb-2" />
                    <span className="text-sm font-semibold text-[#1a1a1a]">{property.typeDisplayName}</span>
                    <span className="text-xs text-[#6B7280]">{t('propertyDetailsPage.type')}</span>
                  </div>
                  <div className="flex flex-col items-center justify-center text-center p-3 bg-[#F5F7FA] rounded-xl">
                    <Bed className="w-5 h-5 text-[#3A6EA5] mb-2" />
                    <span className="text-sm font-semibold text-[#1a1a1a]">{property.beds} {t('propertyDetailsPage.beds')}</span>
                    <span className="text-xs text-[#6B7280]">{property.bedrooms} {t('propertyDetailsPage.bedrooms')}</span>
                  </div>
                  <div className="flex flex-col items-center justify-center text-center p-3 bg-[#F5F7FA] rounded-xl">
                    <Bath className="w-5 h-5 text-[#3A6EA5] mb-2" />
                    <span className="text-sm font-semibold text-[#1a1a1a]">{property.bathrooms} {t('propertyDetailsPage.baths')}</span>
                  </div>
                  <div className="flex flex-col items-center justify-center text-center p-3 bg-[#F5F7FA] rounded-xl">
                    <Maximize2 className="w-5 h-5 text-[#3A6EA5] mb-2" />
                    <span className="text-sm font-semibold text-[#1a1a1a]">{property.squareMeters} m²</span>
                    <span className="text-xs text-[#6B7280]">{t('propertyDetailsPage.area')}</span>
                  </div>
                </div>

                <div>
                  <h3 className="text-lg font-semibold text-[#1a1a1a] mb-3">{t('propertyDetailsPage.description')}</h3>
                  <p dir="auto" className="text-[#4a5565] leading-relaxed whitespace-pre-wrap">{property.description}</p>
                </div>
              </CardContent>
            </Card>

            {/* Amenities & Rules */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-8">
              <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5">
                <CardHeader>
                  <CardTitle className="text-lg">{t('propertyDetailsPage.amenities')}</CardTitle>
                </CardHeader>
                <CardContent>
                  {property.amenities?.length ? (
                    <div className="flex flex-wrap gap-2">
                      {property.amenities.map((amenity: any) => (
                        <Badge key={amenity.amenityId} variant="secondary" className="bg-[#9CBBDC]/20 text-[#3A6EA5] font-normal px-3 py-1.5 rounded-lg">
                          <CheckCircle className="w-3 h-3 ltr:mr-1.5 rtl:ml-1.5 inline" />
                          {amenity.amenityDisplayName}
                        </Badge>
                      ))}
                    </div>
                  ) : (
                    <p className="text-[#6B7280] text-sm">{t('propertyDetailsPage.noAmenities')}</p>
                  )}
                </CardContent>
              </Card>

              <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5">
                <CardHeader>
                  <CardTitle className="text-lg">{t('propertyDetailsPage.houseRules')}</CardTitle>
                </CardHeader>
                <CardContent>
                  {property.rules?.length ? (
                    <ul className="space-y-3">
                      {property.rules.map((rule: any) => (
                        <li key={rule.ruleId} className="flex items-start gap-2 text-sm text-[#4a5565]">
                          <ShieldAlert className="w-4 h-4 text-[#FFB800] shrink-0 mt-0.5" />
                          <span dir="auto">{rule.text}</span>
                        </li>
                      ))}
                    </ul>
                  ) : (
                    <p className="text-[#6B7280] text-sm">{t('propertyDetailsPage.noRules')}</p>
                  )}
                </CardContent>
              </Card>
            </div>

            {/* Comments & Moderation */}
            <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5">
              <CardHeader>
                <CardTitle className="text-lg flex items-center justify-between">
                  <span>{t('propertyDetailsPage.commentsAndReviews')}</span>
                  <span className="text-sm font-normal text-[#6B7280]">{property.commentsCount} {t('propertyDetailsPage.total')}</span>
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {property.comments?.length > 0 ? (
                  property.comments.map((comment: any) => (
                    <div key={comment.commentId} className={`p-4 rounded-2xl border ${comment.isHiddenByModeration ? 'bg-red-50 border-red-100' : 'bg-white border-gray-100'}`}>
                      <div className="flex justify-between items-start mb-3">
                        <div className="flex items-center gap-3">
                          <Avatar className="w-10 h-10">
                            <AvatarImage src={getImageUrl(comment.userProfileImage)} />
                            <AvatarFallback>{comment.userName?.slice(0, 2).toUpperCase()}</AvatarFallback>
                          </Avatar>
                          <div>
                            <p className="font-semibold text-sm text-[#1a1a1a]">{comment.userName}</p>
                            <p className="text-xs text-[#6B7280]">
                              {new Date(comment.createdAt).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })}
                            </p>
                          </div>
                        </div>
                        {comment.rating && (
                          <div className="flex items-center gap-1 bg-[#FFF9E6] px-2 py-1 rounded-md">
                            <Star className="w-3 h-3 fill-[#FFB800] text-[#FFB800]" />
                            <span className="text-xs font-bold text-[#FFB800]">{comment.rating}</span>
                          </div>
                        )}
                      </div>
                      <p dir="auto" className={`text-sm ${comment.isHiddenByModeration ? 'text-red-900' : 'text-[#4a5565]'}`}>
                        {comment.content}
                      </p>
                      
                      {comment.isHiddenByModeration && (
                        <div className="mt-3 pt-3 border-t border-red-200">
                          <p className="text-xs text-red-700 font-semibold mb-1 flex items-center gap-1">
                            <ShieldAlert className="w-3 h-3" /> {t('propertyDetailsPage.hiddenByModeration')}
                          </p>
                          <p className="text-xs text-red-600">
                            {t('propertyDetailsPage.reason')} {comment.hiddenReason} <br/>
                            {t('propertyDetailsPage.date')} {comment.hiddenAt ? new Date(comment.hiddenAt).toLocaleDateString() : t('propertyDetailsPage.na')}
                          </p>
                        </div>
                      )}
                    </div>
                  ))
                ) : (
                  <p className="text-[#6B7280] text-sm text-center py-4">{t('propertyDetailsPage.noComments')}</p>
                )}
              </CardContent>
            </Card>

            {/* Contracts */}
            <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5">
              <CardHeader>
                <CardTitle className="text-lg">{t('propertyDetailsPage.contracts')}</CardTitle>
              </CardHeader>
              <CardContent>
                {property.contracts?.length > 0 ? (
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm text-left rtl:text-right">
                      <thead className="text-xs text-[#6B7280] uppercase bg-[#F5F7FA] rounded-xl">
                        <tr>
                          <th className="px-4 py-3 ltr:rounded-l-xl rtl:rounded-r-xl">{t('propertyDetailsPage.renter')}</th>
                          <th className="px-4 py-3">{t('propertyDetailsPage.duration')}</th>
                          <th className="px-4 py-3">{t('propertyDetailsPage.amount')}</th>
                          <th className="px-4 py-3">{t('propertyDetailsPage.status')}</th>
                          <th className="px-4 py-3 ltr:rounded-r-xl rtl:rounded-l-xl">{t('propertyDetailsPage.anchoring')}</th>
                        </tr>
                      </thead>
                      <tbody>
                        {property.contracts.map((contract: any) => (
                          <tr key={contract.contractId} className="border-b border-gray-50 last:border-0 hover:bg-gray-50">
                            <td className="px-4 py-3 font-medium text-[#1a1a1a] flex items-center gap-2">
                              <Avatar className="w-6 h-6">
                                <AvatarImage src={getImageUrl(contract.renterProfileImage)} />
                                <AvatarFallback>{contract.renterName?.charAt(0)}</AvatarFallback>
                              </Avatar>
                              {contract.renterName}
                            </td>
                            <td className="px-4 py-3 text-[#4a5565]">
                              {new Date(contract.leaseStartDate).toLocaleDateString()} - {new Date(contract.leaseEndDate).toLocaleDateString()}
                            </td>
                            <td className="px-4 py-3 text-[#1a1a1a] font-semibold">
                              {contract.totalContractAmount?.toLocaleString()} <span className="text-xs text-[#6B7280]">({contract.paymentFrequencyDisplayName})</span>
                            </td>
                            <td className="px-4 py-3">
                              {getStatusBadge(contract.statusDisplayName)}
                            </td>
                            <td className="px-4 py-3">
                              <Badge variant="outline" className="text-xs font-normal">
                                {contract.anchoringStatusDisplayName}
                              </Badge>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                ) : (
                  <p className="text-[#6B7280] text-sm text-center py-4">{t('propertyDetailsPage.noContracts')}</p>
                )}
              </CardContent>
            </Card>

            {/* Booking Requests */}
            <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5">
              <CardHeader>
                <CardTitle className="text-lg flex items-center justify-between">
                  <span>{t('propertyDetailsPage.bookingRequests')}</span>
                  <span className="text-sm font-normal text-[#6B7280]">{property.bookingRequestsCount} {t('propertyDetailsPage.requests')}</span>
                </CardTitle>
              </CardHeader>
              <CardContent>
                {property.bookingRequests?.length > 0 ? (
                  <ul className="space-y-4">
                    {property.bookingRequests.map((req: any) => (
                      <li key={req.requestId} className="p-4 border border-gray-100 rounded-2xl bg-white flex justify-between items-center">
                        <div className="flex flex-col gap-1">
                          <span className="font-semibold text-sm">{req.renterName}</span>
                          <span className="text-xs text-[#6B7280]">{t('propertyDetailsPage.requested')} {new Date(req.createdAt).toLocaleDateString()}</span>
                        </div>
                        {getStatusBadge(req.status)}
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p className="text-[#6B7280] text-sm text-center py-4">{t('propertyDetailsPage.noRequests')}</p>
                )}
              </CardContent>
            </Card>

          </div>

          {/* Sidebar */}
          <div className="space-y-8">
            
            {/* Owner Profile */}
            <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5 bg-gradient-to-b from-white to-[#F5F7FA]">
              <CardHeader className="text-center pb-2">
                <CardTitle className="text-lg text-[#6B7280] uppercase tracking-wider text-xs font-bold">{t('propertyDetailsPage.propertyOwner')}</CardTitle>
              </CardHeader>
              <CardContent className="flex flex-col items-center text-center">
                <Avatar className="w-24 h-24 mb-4 ring-4 ring-white shadow-md">
                  <AvatarImage src={getImageUrl(property.ownerProfileImage)} />
                  <AvatarFallback className="text-2xl">{property.ownerName?.slice(0, 2).toUpperCase()}</AvatarFallback>
                </Avatar>
                <h3 className="text-xl font-bold text-[#1a1a1a] mb-1">{property.ownerName}</h3>
                <div className="flex flex-col gap-2 w-full mt-6">
                  <button onClick={() => copyToClipboard(property.ownerEmail)} className="flex items-center justify-center gap-2 p-3 bg-white rounded-xl shadow-sm hover:shadow-md transition-shadow text-[#4a5565] text-sm w-full cursor-pointer">
                    <Mail className="w-4 h-4 text-[#3A6EA5]" />
                    {property.ownerEmail || t('propertyDetailsPage.emailNotProvided')}
                  </button>
                  <button onClick={() => copyToClipboard(property.ownerPhoneNumber)} className="flex items-center justify-center gap-2 p-3 bg-white rounded-xl shadow-sm hover:shadow-md transition-shadow text-[#4a5565] text-sm w-full cursor-pointer">
                    <Phone className="w-4 h-4 text-[#3A6EA5]" />
                    {property.ownerPhoneNumber || t('propertyDetailsPage.phoneNotProvided')}
                  </button>
                </div>
                <Link to={`/user/${property.ownerId}`} className="w-full mt-4">
                  <Button className="w-full rounded-xl bg-[#3A6EA5] hover:bg-[#2C5580] text-white cursor-pointer">
                    {t('propertyDetailsPage.viewOwnerProfile')}
                  </Button>
                </Link>
              </CardContent>
            </Card>

            {/* Proof of Ownership */}
            <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5">
              <CardHeader>
                <CardTitle className="text-lg flex items-center gap-2">
                  <FileText className="w-5 h-5 text-[#3A6EA5]" /> {t('propertyDetailsPage.proofOfOwnership')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {property.proofOfOwnership ? (
                  <div className="relative rounded-2xl overflow-hidden aspect-[3/4] bg-gray-100 border border-gray-200 group">
                    <ImageWithFallback
                      src={getImageUrl(property.proofOfOwnership)}
                      alt="Proof of Ownership Document"
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                      <a href={getImageUrl(property.proofOfOwnership)} target="_blank" rel="noreferrer">
                        <Button variant="secondary" className="rounded-full shadow-lg">
                          <Eye className="w-4 h-4 ltr:mr-2 rtl:ml-2" /> {t('propertyDetailsPage.viewFull')}
                        </Button>
                      </a>
                    </div>
                  </div>
                ) : (
                  <div className="p-8 text-center bg-[#F5F7FA] rounded-2xl flex flex-col items-center justify-center gap-3">
                    <FileText className="w-8 h-8 text-gray-400" />
                    <p className="text-sm text-gray-500">{t('propertyDetailsPage.noDocument')}</p>
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Statistics Sidebar Widget */}
            <Card className="border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/5">
              <CardContent className="p-6">
                <h3 className="text-sm font-bold text-[#6B7280] uppercase tracking-wider mb-4">{t('propertyDetailsPage.quickStats')}</h3>
                <div className="space-y-4">
                  <div className="flex justify-between items-center">
                    <span className="flex items-center gap-2 text-sm text-[#4a5565]"><Star className="w-4 h-4 text-[#FFB800]" /> {t('propertyDetailsPage.averageRating')}</span>
                    <span className="font-bold text-[#1a1a1a]">{property.averageRating || 'N/A'}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="flex items-center gap-2 text-sm text-[#4a5565]"><Eye className="w-4 h-4 text-[#3A6EA5]" /> {t('propertyDetailsPage.totalViews')}</span>
                    <span className="font-bold text-[#1a1a1a]">{property.viewsCount || 0}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="flex items-center gap-2 text-sm text-[#4a5565]"><Users className="w-4 h-4 text-[#3A6EA5]" /> {t('propertyDetailsPage.savedBy')}</span>
                    <span className="font-bold text-[#1a1a1a]">{property.savedByUsersCount || 0} {t('propertyDetailsPage.users')}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="flex items-center gap-2 text-sm text-[#4a5565]"><Calendar className="w-4 h-4 text-[#3A6EA5]" /> {t('propertyDetailsPage.createdAt')}</span>
                    <span className="font-bold text-[#1a1a1a] text-xs">{new Date(property.createdAt).toLocaleDateString()}</span>
                  </div>
                </div>
              </CardContent>
            </Card>

          </div>
        </div>
      </div>
    </div>
  )
}
