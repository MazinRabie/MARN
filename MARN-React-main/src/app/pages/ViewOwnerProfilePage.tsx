import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { Button } from '../components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '../components/ui/avatar'
import {
  Mail,
  Phone,
  MapPin,
  Calendar,
  Home,
  Star,
  Flag,
  MessageCircle,
  CheckCircle,
  Building2,
} from 'lucide-react'
import { useNavigate, useParams } from 'react-router'
import { useState } from 'react'
import { useSubmitReport } from '@/hooks/useConversations'
import { Loader2 } from 'lucide-react'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '../components/ui/dialog'
import { Label } from '../components/ui/label'
import { Textarea } from '../components/ui/textarea'
import { toast } from 'sonner'
import { getImageUrl } from '@/constants/assets'

import { useUserProfile } from '@/hooks/useProfile'
import { useTranslation } from 'react-i18next'

export function ViewOwnerProfilePage() {
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()
  const [showReportDialog, setShowReportDialog] = useState(false)
  const [reportReason, setReportReason] = useState('')
  const [visibleCount, setVisibleCount] = useState(6)
  const submitReport = useSubmitReport()
  const { t, i18n } = useTranslation('pages')

  const { data: profileData, isLoading, isError } = useUserProfile(id)
  const profile = profileData?.data

  const handleReport = () => {
    if (!id || reportReason.trim().length < 5) {
      toast.error(t('viewUserProfile.toasts.reportReasonRequired'))
      return
    }

    submitReport.mutate(
      {
        reportableType: 'User',
        reportableTargetId: id,
        reason: reportReason.trim(),
      },
      {
        onSuccess: () => {
          toast.success(t('viewOwnerProfile.toasts.reportSubmitted'))
          setShowReportDialog(false)
          setReportReason('')
        },
        onError: () => {
          toast.error(t('viewOwnerProfile.toasts.reportFailed'))
        }
      }
    )
  }

  const handleChatClick = () => {
    navigate('/messages')
    toast.success(t('viewOwnerProfile.toasts.openingChat'))
  }

  if (isLoading) {
    return (
      <div className="min-h-screen py-20 flex items-center justify-center">
        <Loader2 className="w-10 h-10 animate-spin text-[#3A6EA5]" />
      </div>
    )
  }

  if (isError || !profile) {
    return (
      <div className="min-h-screen py-20 flex flex-col items-center justify-center text-[#1a1a1a]">
        <h2 className="text-2xl font-bold mb-4">{t('viewOwnerProfile.notFound')}</h2>
        <Button onClick={() => navigate(-1)} variant="outline">{t('viewOwnerProfile.goBack')}</Button>
      </div>
    )
  }

  const properties = profile.ownedProperties || []

  return (
    <div className="min-h-screen py-20">
      <div className="max-w-[1200px] mx-auto px-8">
        <Button
          variant="ghost"
          onClick={() => navigate(-1)}
          className="mb-6 rounded-xl hover:bg-[#3A6EA5]/10 hover:text-[#3A6EA5]"
        >
          <span className={i18n.language === 'ar' ? 'ml-2' : 'mr-2'}>
            {i18n.language === 'ar' ? '→' : '←'}
          </span>
          {t('viewOwnerProfile.back')}
        </Button>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Profile Card */}
          <div className="lg:col-span-1">
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardContent className="pt-6 text-center">
                <div className="relative w-40 h-40 mx-auto mb-6">
                  <Avatar className="w-full h-full">
                    {profile.profileImage && <AvatarImage src={profile.profileImage} />}
                    <AvatarFallback className="text-4xl">
                      {profile.fullName?.split(' ').map((n) => n[0]).join('') || 'O'}
                    </AvatarFallback>
                  </Avatar>
                  {profile.accountStatus === 'Active' && (
                    <div className="absolute bottom-2 right-2 w-10 h-10 rounded-full bg-green-500 flex items-center justify-center shadow-lg">
                      <CheckCircle className="w-6 h-6 text-white" />
                    </div>
                  )}
                </div>
                <h2 className="text-2xl font-bold text-[#1a1a1a] mb-2">
                  {profile.fullName}
                </h2>
                <p className="text-sm text-[#6B7280] mb-4">{t('viewOwnerProfile.propertyOwner')}</p>

                {profile.accountStatus === 'Active' && (
                  <div className="inline-flex items-center gap-1 px-3 py-1 bg-green-100 rounded-full text-green-700 text-sm font-medium mb-4">
                    <CheckCircle className="w-4 h-4" />
                    {t('viewOwnerProfile.verifiedOwner')}
                  </div>
                )}

                {/* Rating */}
                <div className="flex items-center justify-center gap-2 mb-6">
                  <div className="flex items-center gap-1">
                    <Star className="w-5 h-5 fill-[#FFB800] text-[#FFB800]" />
                    <span className="font-bold text-[#1a1a1a]">
                      {profile.averageRating?.toFixed(1) || t('viewOwnerProfile.new')}
                    </span>
                  </div>
                  <span className="text-sm text-[#6B7280]">
                    ({profile.ratingsCount || 0} {t('viewOwnerProfile.reviews')})
                  </span>
                </div>

                <div className="space-y-3 text-left">
                  <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                    <Mail className="w-4 h-4 text-[#3A6EA5]" />
                    <span className="truncate">{profile.email}</span>
                  </div>
                  {profile.country && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <MapPin className="w-4 h-4 text-[#3A6EA5]" />
                      <span>{profile.country}</span>
                    </div>
                  )}
                  {profile.memberSince && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <Calendar className="w-4 h-4 text-[#3A6EA5]" />
                      <span>{t('viewOwnerProfile.joinDate')} {profile.memberSince}</span>
                    </div>
                  )}
                  <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                    <Building2 className="w-4 h-4 text-[#3A6EA5]" />
                    <span>{properties.length} {t('viewOwnerProfile.properties')}</span>
                  </div>
                </div>

                <div className="mt-6 pt-6 border-t border-[#3A6EA5]/20 space-y-3">
                  <Button
                    className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2C5580] hover:to-[#3A6EA5] text-white rounded-xl"
                    onClick={handleChatClick}
                  >
                    <MessageCircle className={`w-4 h-4 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
                    {t('viewOwnerProfile.chatWithOwner')}
                  </Button>
                  <Button
                    variant="destructive"
                    className="w-full rounded-xl bg-red-500 hover:bg-red-600"
                    onClick={() => setShowReportDialog(true)}
                  >
                    <Flag className={`w-4 h-4 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
                    {t('viewOwnerProfile.reportOwner')}
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Profile Details */}
          <div className="lg:col-span-2 space-y-6">
            {/* About */}
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">{t('viewOwnerProfile.about')}</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-[#1a1a1a] leading-relaxed">
                  {profile.bio || t('viewOwnerProfile.noBio')}
                </p>
              </CardContent>
            </Card>

            {/* Owner Stats */}
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('viewOwnerProfile.ownerStatistics')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-white rounded-2xl text-center">
                    <p className="text-3xl font-bold text-[#3A6EA5] mb-1">
                      {properties.length}
                    </p>
                    <p className="text-sm text-[#6B7280]">{t('viewOwnerProfile.totalProperties')}</p>
                  </div>
                  <div className="p-4 bg-white rounded-2xl text-center">
                    <div className="flex items-center justify-center gap-1 mb-1">
                      <Star className="w-5 h-5 fill-[#FFB800] text-[#FFB800]" />
                      <p className="text-3xl font-bold text-[#3A6EA5]">
                        {profile.averageRating?.toFixed(1) || t('viewOwnerProfile.new')}
                      </p>
                    </div>
                    <p className="text-sm text-[#6B7280]">{t('viewOwnerProfile.averageRating')}</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Properties */}
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <div className="flex items-center gap-3">
                  <Home className="w-6 h-6 text-[#3A6EA5]" />
                  <CardTitle className="text-2xl text-[#1a1a1a]">
                    {t('viewOwnerProfile.properties')} ({properties.length})
                  </CardTitle>
                </div>
              </CardHeader>
              <CardContent>
                <div className="grid md:grid-cols-2 gap-4">
                  {properties.slice(0, visibleCount).map((property) => (
                    <div
                      key={property.id}
                      className="bg-white rounded-2xl overflow-hidden hover:shadow-lg transition-shadow cursor-pointer flex flex-col"
                      onClick={() => navigate(`/property/${property.id}`)}
                    >
                      <img
                        src={getImageUrl(property.imagePath) || 'https://via.placeholder.com/400x300?text=No+Image'}
                        alt={property.title}
                        className="w-full h-48 object-cover"
                      />
                      <div className="p-4">
                        <h3 className="font-semibold text-[#1a1a1a] mb-1 truncate">
                          {property.title}
                        </h3>
                        <div className="flex items-center gap-2 text-sm text-[#6B7280] mb-2 truncate">
                          <MapPin className="w-3 h-3 flex-shrink-0" />
                          <span className="truncate">{property.address}</span>
                        </div>
                        <div className="flex items-center justify-between">
                          <p className="text-lg font-bold text-[#3A6EA5]">
                            {t('viewOwnerProfile.egp')} {property.price?.toLocaleString()}/{property.rentalUnitDisplayName || property.rentalUnit}
                          </p>
                          <div className="flex items-center gap-1">
                            <Star className="w-4 h-4 fill-[#FFB800] text-[#FFB800]" />
                            <span className="text-sm font-medium text-[#1a1a1a]">
                              {property.averageRating?.toFixed(1) || t('viewOwnerProfile.new')}
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  ))}
                  {properties.length === 0 && (
                    <div className="col-span-2 py-8 text-center text-[#6B7280]">
                      {t('viewOwnerProfile.noProperties')}
                    </div>
                  )}
                </div>

                {visibleCount < properties.length && (
                  <div className="mt-6 flex items-center justify-center gap-4">
                    <Button
                      variant="outline"
                      className="rounded-xl border-[#3A6EA5]/20 hover:bg-[#3A6EA5]/5"
                      onClick={() => setVisibleCount((prev) => prev + 10)}
                    >
                      {t('viewOwnerProfile.showMore')}
                    </Button>
                    <Button
                      variant="ghost"
                      className="rounded-xl text-[#3A6EA5] hover:bg-[#3A6EA5]/5"
                      onClick={() => setVisibleCount(properties.length)}
                    >
                      {t('viewOwnerProfile.showAll')}
                    </Button>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>
        </div>
      </div>

      {/* Report Dialog */}
      <Dialog open={showReportDialog} onOpenChange={setShowReportDialog}>
        <DialogContent className="bg-white rounded-3xl">
          <DialogHeader>
            <DialogTitle className="text-2xl text-[#1a1a1a]">
              {t('viewOwnerProfile.report.title')}
            </DialogTitle>
            <DialogDescription className="text-[#6B7280]">
              {t('viewOwnerProfile.reportDialogDesc')}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div>
              <Label
                htmlFor="report-reason"
                className="text-[#1a1a1a] mb-2 block"
              >
                {t('viewOwnerProfile.report.reasonForReporting')}
              </Label>
              <Textarea
                id="report-reason"
                value={reportReason}
                onChange={(e) => setReportReason(e.target.value)}
                placeholder={t('viewOwnerProfile.report.reasonPlaceholder')}
                className="bg-[#F2F4F6] rounded-xl border-[#3A6EA5]/20 min-h-[120px]"
              />
              {reportReason.trim().length > 0 && reportReason.trim().length < 5 && (
                <p className="text-xs text-red-500 mt-2">
                  {t('viewOwnerProfile.report.minCharsWithCount', { current: reportReason.trim().length })}
                </p>
              )}
            </div>
          </div>
          <div className="flex gap-3 justify-end">
            <Button
              variant="outline"
              onClick={() => {
                setShowReportDialog(false)
                setReportReason('')
              }}
              className="rounded-xl border-[#3A6EA5]/20"
            >
              {t('viewOwnerProfile.report.cancel')}
            </Button>
            <Button
              onClick={handleReport}
              disabled={reportReason.trim().length < 5 || submitReport.isPending}
              className="bg-red-500 hover:bg-red-600 text-white rounded-xl"
            >
              {submitReport.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : null}
              {t('viewOwnerProfile.report.submit')}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
