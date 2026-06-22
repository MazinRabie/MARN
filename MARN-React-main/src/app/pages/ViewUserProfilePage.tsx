import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { Button } from '../components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '../components/ui/avatar'
import {
  Mail,
  Phone,
  MapPin,
  Calendar,
  Users,
  Briefcase,
  GraduationCap,
  Home,
  Volume2,
  Flag,
  CheckCircle,
  XCircle,
  Wallet,
  Globe,
  Star,
  User as UserIcon,
  CalendarDays,
  AlertCircle,
  CheckCircle2,
  MessageSquare,
  ArrowLeft,
  ArrowRight,
} from 'lucide-react'
import { useNavigate, useParams } from 'react-router'
import { useState } from 'react'
import { useUserProfile } from '@/hooks/useProfile'
import { useSubmitReport } from '@/hooks/useConversations'
import { Skeleton } from '../components/ui/skeleton'
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
import { useTranslation } from 'react-i18next'
import { motion } from 'motion/react'

export function ViewUserProfilePage() {
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()
  const { data: profileData, isLoading, isError } = useUserProfile(id)
  const profile = profileData?.data

  const [showReportDialog, setShowReportDialog] = useState(false)
  const [reportReason, setReportReason] = useState('')

  const submitReport = useSubmitReport()
  const { t, i18n } = useTranslation('pages')
  const isRtl = i18n.language === 'ar'

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
          toast.success(t('viewUserProfile.toasts.reportSubmitted'))
          setShowReportDialog(false)
          setReportReason('')
        },
        onError: (error: any) => {
          let msg = t('viewUserProfile.toasts.reportReasonRequired')
          if (error?.data?.errors) {
            msg = Object.values(error.data.errors).flat().join(', ')
          } else if (error?.message) {
            msg = error.message
          }
          toast.error(msg)
        },
      }
    )
  }

  const getLifestyleValue = (value: boolean | null | undefined) => {
    if (value === null || value === undefined) return t('viewUserProfile.lifestyle_fields.unspecified')
    return value ? t('viewUserProfile.lifestyle_fields.yes') : t('viewUserProfile.lifestyle_fields.no')
  }

  if (isLoading) {
    return (
      <div className="min-h-screen py-20">
        <div className="max-w-[1200px] mx-auto px-8">
          <Skeleton className="h-8 w-24 mb-8 rounded-xl" />
          <div className="grid lg:grid-cols-3 gap-8">
            <div className="lg:col-span-1 space-y-4">
              <Skeleton className="h-[480px] rounded-3xl" />
            </div>
            <div className="lg:col-span-2 space-y-6">
              <Skeleton className="h-40 rounded-3xl" />
              <Skeleton className="h-40 rounded-3xl" />
              <Skeleton className="h-72 rounded-3xl" />
            </div>
          </div>
        </div>
      </div>
    )
  }

  if (isError || !profile) {
    return (
      <div className="min-h-screen py-20 flex flex-col items-center justify-center text-[#1a1a1a]">
        <div className="w-20 h-20 rounded-full bg-[#E5EBF0] flex items-center justify-center mb-6">
          <UserIcon className="w-10 h-10 text-[#3A6EA5]" />
        </div>
        <h2 className="text-2xl font-bold mb-4">{t('viewUserProfile.notFound')}</h2>
        <Button onClick={() => navigate(-1)} variant="outline" className="rounded-xl border-[#3A6EA5]/20">
          {t('viewUserProfile.goBack')}
        </Button>
      </div>
    )
  }

  const ageYears = profile.dateOfBirth
    ? Math.floor((new Date().getTime() - new Date(profile.dateOfBirth).getTime()) / 3.15576e10)
    : null

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6 }}
      className="min-h-screen py-20"
    >
      <div className="max-w-[1200px] mx-auto px-8">
        <Button
          variant="ghost"
          onClick={() => navigate(-1)}
          className="mb-6 rounded-xl hover:bg-[#3A6EA5]/10 hover:text-[#3A6EA5]"
        >
          {isRtl ? <ArrowRight className="w-4 h-4" /> : <ArrowLeft className="w-4 h-4" />}
          {t('viewUserProfile.back')}
        </Button>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Profile Card */}
          <div className="lg:col-span-1">
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 overflow-hidden">
              {/* Gradient banner */}
              <div className="h-28 bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] relative">
                <div className="absolute inset-0 opacity-10"
                  style={{ backgroundImage: 'radial-gradient(circle at 30% 50%, white 1px, transparent 1px)', backgroundSize: '20px 20px' }}
                />
              </div>

              <CardContent className="px-6 pb-6 text-center -mt-14">
                {/* Avatar */}
                <div className="relative w-28 h-28 mx-auto mb-4">
                  <div className="w-full h-full rounded-full ring-4 ring-[#E5EBF0] overflow-hidden">
                    <Avatar className="w-full h-full">
                      {profile.profileImage && <AvatarImage src={profile.profileImage} className="object-cover" />}
                      <AvatarFallback className="text-3xl bg-white text-[#3A6EA5] font-bold">
                        {profile.fullName?.split(' ').map((n) => n[0]).join('') || 'U'}
                      </AvatarFallback>
                    </Avatar>
                  </div>
                  {profile.accountStatus === 'Active' && (
                    <div className="absolute bottom-1 right-1 w-8 h-8 rounded-full bg-green-500 flex items-center justify-center shadow-md ring-2 ring-[#E5EBF0]">
                      <CheckCircle className="w-5 h-5 text-white" />
                    </div>
                  )}
                </div>

                <h2 className="text-2xl font-bold text-[#1a1a1a] mb-1">{profile.fullName}</h2>

                {profile.accountStatus === 'Active' && (
                  <div className="inline-flex items-center gap-1.5 px-3 py-1 bg-green-100 rounded-full text-green-700 text-xs font-semibold mb-4">
                    <CheckCircle className="w-3.5 h-3.5" />
                    {t('viewUserProfile.verifiedUser')}
                  </div>
                )}

                {/* Info rows */}
                <div className="space-y-2.5 mt-4 text-left bg-white rounded-2xl p-4">
                  <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                    <Mail className="w-4 h-4 text-[#3A6EA5] shrink-0" />
                    <span className="truncate">{profile.email}</span>
                  </div>
                  {profile.gender && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <UserIcon className="w-4 h-4 text-[#3A6EA5] shrink-0" />
                      <span>{profile.gender}</span>
                    </div>
                  )}
                  {ageYears !== null && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <CalendarDays className="w-4 h-4 text-[#3A6EA5] shrink-0" />
                      <span>{ageYears} {t('viewUserProfile.yearsOld')}</span>
                    </div>
                  )}
                  {profile.country && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <Globe className="w-4 h-4 text-[#3A6EA5] shrink-0" />
                      <span>{profile.country}</span>
                    </div>
                  )}
                  {profile.memberSince && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <Calendar className="w-4 h-4 text-[#3A6EA5] shrink-0" />
                      <span>{t('viewUserProfile.joinedYear', { year: new Date(profile.memberSince).getFullYear() })}</span>
                    </div>
                  )}
                </div>

                {/* Owner stats */}
                {profile.isOwner && (
                  <div className="mt-4 pt-4 border-t border-[#3A6EA5]/20 flex justify-around text-[#1a1a1a]">
                    <div className="text-center">
                      <div className="flex justify-center items-center gap-1 font-bold text-lg">
                        <Star className="w-5 h-5 text-amber-400 fill-amber-400" />
                        {profile.averageRating ? profile.averageRating.toFixed(1) : t('viewUserProfile.notAvailable')}
                      </div>
                      <p className="text-xs text-[#6B7280]">
                        {profile.ratingsCount || 0} {t('viewUserProfile.ratings')}
                      </p>
                    </div>
                    <div className="w-px bg-[#3A6EA5]/20" />
                    <div className="text-center">
                      <div className="flex justify-center items-center gap-1 font-bold text-lg">
                        <Home className="w-5 h-5 text-[#3A6EA5]" />
                        {profile.ownedPropertiesCount || 0}
                      </div>
                      <p className="text-xs text-[#6B7280]">{t('viewUserProfile.properties')}</p>
                    </div>
                  </div>
                )}

                {/* Action buttons */}
                <div className="mt-4 pt-4 border-t border-[#3A6EA5]/20 space-y-2.5">
                  <Button
                    className="w-full rounded-xl bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white shadow-md gap-2"
                    onClick={() => navigate('/messages')}
                  >
                    <MessageSquare className="w-4 h-4" />
                    {t('viewUserProfile.message')}
                  </Button>
                  <Button
                    variant="destructive"
                    className="w-full rounded-xl bg-red-500 hover:bg-red-600 gap-2"
                    onClick={() => setShowReportDialog(true)}
                  >
                    <Flag className="w-4 h-4" />
                    {t('viewUserProfile.reportUser')}
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
                <CardTitle className="text-xl text-[#1a1a1a]">{t('viewUserProfile.about')}</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-[#4a5565] leading-relaxed">
                  {profile.bio || t('viewUserProfile.noBio')}
                </p>
              </CardContent>
            </Card>

            {/* Compatibility Analysis */}
            {profile.matchingPercentage !== undefined && profile.matchingPercentage !== null && (
              <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 overflow-hidden">
                <div className="h-1.5 bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC]" />
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-xl text-[#1a1a1a]">
                      {t('viewUserProfile.compatibility.title')}
                    </CardTitle>
                    <div className="bg-gradient-to-r from-green-500 to-emerald-400 text-white font-bold text-sm px-4 py-1.5 rounded-full shadow-md">
                      {profile.matchingPercentage}% {t('viewUserProfile.compatibility.match')}
                    </div>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="grid md:grid-cols-2 gap-4">
                    {profile.topMatchingTraits && profile.topMatchingTraits.length > 0 && (
                      <div className="bg-white p-4 rounded-2xl border border-green-100">
                        <h4 className="text-sm font-bold text-[#1a1a1a] uppercase tracking-wider mb-3 flex items-center gap-2">
                          <CheckCircle2 className="w-4 h-4 text-green-500" />
                          {t('viewUserProfile.compatibility.topMatches')}
                        </h4>
                        <ul className="space-y-1.5">
                          {profile.topMatchingTraits.map((trait, idx) => {
                            let displayTrait = trait
                            if (trait === 'Both Non-Smokers') displayTrait = "You're both non-smokers"
                            else if (trait.startsWith('Both prefer')) displayTrait = trait.replace('Both prefer', 'You both prefer')
                            else if (trait.startsWith('Both ')) displayTrait = trait.replace('Both ', 'You both are ')
                            return (
                              <li key={idx} className="text-sm text-[#4a5565] flex items-start gap-2">
                                <span className="text-green-500 mt-0.5 shrink-0">•</span>
                                <span>{displayTrait}</span>
                              </li>
                            )
                          })}
                        </ul>
                      </div>
                    )}

                    {profile.mismatchedTraits && profile.mismatchedTraits.length > 0 && (
                      <div className="bg-white p-4 rounded-2xl border border-amber-100">
                        <h4 className="text-sm font-bold text-[#1a1a1a] uppercase tracking-wider mb-3 flex items-center gap-2">
                          <AlertCircle className="w-4 h-4 text-amber-500" />
                          {t('viewUserProfile.compatibility.differences')}
                        </h4>
                        <ul className="space-y-1.5">
                          {profile.mismatchedTraits.map((trait, idx) => (
                            <li key={idx} className="text-sm text-[#4a5565] flex items-start gap-2">
                              <span className="text-amber-500 mt-0.5 shrink-0">•</span>
                              <span>{trait}</span>
                            </li>
                          ))}
                        </ul>
                      </div>
                    )}

                    {profile.dealbreakersFound && profile.dealbreakersFound.length > 0 && (
                      <div className="bg-white p-4 rounded-2xl border border-red-100 md:col-span-2">
                        <h4 className="text-sm font-bold text-[#1a1a1a] uppercase tracking-wider mb-3 flex items-center gap-2">
                          <XCircle className="w-4 h-4 text-red-500" />
                          {t('viewUserProfile.compatibility.dealbreakers')}
                        </h4>
                        <ul className="space-y-1.5">
                          {profile.dealbreakersFound.map((trait, idx) => (
                            <li key={idx} className="text-sm text-red-600 font-medium flex items-start gap-2">
                              <span className="text-red-500 mt-0.5 shrink-0">•</span>
                              <span>{trait}</span>
                            </li>
                          ))}
                        </ul>
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            )}

            {/* Roommate Status */}
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-xl bg-[#3A6EA5]/10 flex items-center justify-center">
                    <Users className="w-5 h-5 text-[#3A6EA5]" />
                  </div>
                  <CardTitle className="text-xl text-[#1a1a1a]">
                    {t('viewUserProfile.roommateStatus')}
                  </CardTitle>
                </div>
              </CardHeader>
              <CardContent>
                <div className={`flex items-center gap-3 p-4 rounded-2xl border ${
                  profile.roommatePreferencesEnabled
                    ? 'bg-green-50 border-green-100'
                    : 'bg-red-50 border-red-100'
                }`}>
                  {profile.roommatePreferencesEnabled ? (
                    <>
                      <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center shrink-0">
                        <CheckCircle className="w-5 h-5 text-green-600" />
                      </div>
                      <div>
                        <p className="font-semibold text-[#1a1a1a]">{t('viewUserProfile.acceptsRoommates')}</p>
                        <p className="text-sm text-[#6B7280]">{t('viewUserProfile.acceptsRoommatesDesc')}</p>
                      </div>
                    </>
                  ) : (
                    <>
                      <div className="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center shrink-0">
                        <XCircle className="w-5 h-5 text-red-500" />
                      </div>
                      <div>
                        <p className="font-semibold text-[#1a1a1a]">{t('viewUserProfile.doesNotAcceptRoommates')}</p>
                        <p className="text-sm text-[#6B7280]">{t('viewUserProfile.doesNotAcceptRoommatesDesc')}</p>
                      </div>
                    </>
                  )}
                </div>
              </CardContent>
            </Card>

            {/* Lifestyle & Preferences */}
            {profile.roommatePreferencesEnabled && (
              <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
                <CardHeader>
                  <div className="flex items-center gap-3">
                    <div className="w-9 h-9 rounded-xl bg-[#3A6EA5]/10 flex items-center justify-center">
                      <Home className="w-5 h-5 text-[#3A6EA5]" />
                    </div>
                    <CardTitle className="text-xl text-[#1a1a1a]">
                      {t('viewUserProfile.lifestyle')}
                    </CardTitle>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="grid md:grid-cols-2 gap-3">
                    {[
                      {
                        label: t('viewUserProfile.lifestyle_fields.smoking'),
                        value: getLifestyleValue(profile.smoking),
                      },
                      {
                        label: t('viewUserProfile.lifestyle_fields.pets'),
                        value: getLifestyleValue(profile.pets),
                      },
                      {
                        label: t('viewUserProfile.lifestyle_fields.sleepSchedule'),
                        value: profile.sleepSchedule
                          ? (profile.sleepScheduleDisplayName || profile.sleepSchedule)
                          : t('viewUserProfile.lifestyle_fields.unspecified'),
                      },
                      {
                        label: t('viewUserProfile.lifestyle_fields.noiseTolerance'),
                        icon: <Volume2 className="w-3.5 h-3.5 text-[#9CBBDC]" />,
                        value: profile.noiseTolerance !== null && profile.noiseTolerance !== undefined
                          ? `${profile.noiseTolerance}/5`
                          : t('viewUserProfile.lifestyle_fields.unspecified'),
                      },
                      {
                        label: t('viewUserProfile.lifestyle_fields.guestsFrequency'),
                        value: profile.guestsFrequency
                          ? (profile.guestsFrequencyDisplayName || profile.guestsFrequency)
                          : t('viewUserProfile.lifestyle_fields.unspecified'),
                      },
                      {
                        label: t('viewUserProfile.lifestyle_fields.workSchedule'),
                        icon: <Briefcase className="w-3.5 h-3.5 text-[#9CBBDC]" />,
                        value: profile.workSchedule
                          ? (profile.workScheduleDisplayName || profile.workSchedule)
                          : t('viewUserProfile.lifestyle_fields.unspecified'),
                      },
                    ].map(({ label, icon, value }) => (
                      <div key={label} className="p-4 bg-white rounded-2xl">
                        <div className="flex items-center gap-1.5 mb-1">
                          {icon}
                          <p className="text-xs text-[#6B7280] font-medium">{label}</p>
                        </div>
                        <p className="font-semibold text-[#1a1a1a] text-sm">{value}</p>
                      </div>
                    ))}

                    <div className="p-4 bg-white rounded-2xl md:col-span-2">
                      <p className="text-xs text-[#6B7280] font-medium mb-1">
                        {t('viewUserProfile.lifestyle_fields.sharingLevel')}
                      </p>
                      <p className="font-semibold text-[#1a1a1a] text-sm">
                        {profile.sharingLevel
                          ? (profile.sharingLevelDisplayName || profile.sharingLevel)
                          : t('viewUserProfile.lifestyle_fields.unspecified')}
                      </p>
                    </div>

                    <div className="p-4 bg-white rounded-2xl md:col-span-2">
                      <div className="flex items-center gap-1.5 mb-1">
                        <Wallet className="w-3.5 h-3.5 text-[#9CBBDC]" />
                        <p className="text-xs text-[#6B7280] font-medium">
                          {t('viewUserProfile.lifestyle_fields.budgetRange')}
                        </p>
                      </div>
                      <p className="font-semibold text-[#1a1a1a] text-sm">
                        {profile.budgetRangeMin !== null && profile.budgetRangeMin !== undefined
                          && profile.budgetRangeMax !== null && profile.budgetRangeMax !== undefined
                          ? t('viewUserProfile.budgetRangeValue', {
                              min: profile.budgetRangeMin,
                              max: profile.budgetRangeMax,
                            })
                          : t('viewUserProfile.lifestyle_fields.unspecified')}
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )}

            {/* Education */}
            {profile.roommatePreferencesEnabled && (
              <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
                <CardHeader>
                  <div className="flex items-center gap-3">
                    <div className="w-9 h-9 rounded-xl bg-[#3A6EA5]/10 flex items-center justify-center">
                      <GraduationCap className="w-5 h-5 text-[#3A6EA5]" />
                    </div>
                    <CardTitle className="text-xl text-[#1a1a1a]">
                      {t('viewUserProfile.education')}
                    </CardTitle>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="grid md:grid-cols-2 gap-3">
                    <div className="p-4 bg-white rounded-2xl">
                      <p className="text-xs text-[#6B7280] font-medium mb-1">
                        {t('viewUserProfile.education_fields.educationLevel')}
                      </p>
                      <p className="font-semibold text-[#1a1a1a] text-sm">
                        {profile.educationLevel
                          ? (profile.educationLevelDisplayName || profile.educationLevel)
                          : t('viewUserProfile.lifestyle_fields.unspecified')}
                      </p>
                    </div>
                    <div className="p-4 bg-white rounded-2xl">
                      <p className="text-xs text-[#6B7280] font-medium mb-1">
                        {t('viewUserProfile.education_fields.fieldOfStudy')}
                      </p>
                      <p className="font-semibold text-[#1a1a1a] text-sm">
                        {profile.fieldOfStudy
                          ? (profile.fieldOfStudyDisplayName || profile.fieldOfStudy)
                          : t('viewUserProfile.lifestyle_fields.unspecified')}
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )}
          </div>
        </div>
      </div>

      {/* Report Dialog */}
      <Dialog open={showReportDialog} onOpenChange={setShowReportDialog}>
        <DialogContent className="bg-white rounded-3xl">
          <DialogHeader>
            <DialogTitle className="text-xl text-[#1a1a1a]">
              {t('viewUserProfile.report.title')}
            </DialogTitle>
            <DialogDescription className="text-[#6B7280]">
              {t('viewUserProfile.reportDialogDesc')}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div>
              <Label htmlFor="report-reason" className="text-[#1a1a1a] mb-2 block text-sm font-medium">
                {t('viewUserProfile.reasonForReporting')}
              </Label>
              <Textarea
                id="report-reason"
                value={reportReason}
                onChange={(e) => setReportReason(e.target.value)}
                placeholder={t('viewUserProfile.report.reasonPlaceholder')}
                className="bg-[#F2F4F6] rounded-xl border-[#3A6EA5]/20 min-h-[120px] resize-none"
              />
              {reportReason.trim().length > 0 && reportReason.trim().length < 5 && (
                <p className="text-xs text-red-500 mt-2">
                  {t('viewUserProfile.report.minChars')} ({reportReason.trim().length}/5)
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
              {t('viewUserProfile.report.cancel')}
            </Button>
            <Button
              onClick={handleReport}
              disabled={reportReason.trim().length < 5 || submitReport.isPending}
              className="bg-red-500 hover:bg-red-600 text-white rounded-xl gap-2"
            >
              {submitReport.isPending && <Loader2 className="w-4 h-4 animate-spin" />}
              {t('viewUserProfile.report.submit')}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </motion.div>
  )
}
