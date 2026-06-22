import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { Button } from '../components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '../components/ui/avatar'
import {
  Mail,
  Globe,
  Star,
  User as UserIcon,
  CalendarDays,
  Calendar,
  CheckCircle,
  Home,
  CheckCircle2,
  AlertCircle,
  XCircle,
  Users,
  Volume2,
  Briefcase,
  GraduationCap,
  Wallet,
  Settings,
} from 'lucide-react'
import { useNavigate } from 'react-router'
import { useQuery } from '@tanstack/react-query'
import { userService } from '@/services/userService'
import { Skeleton } from '../components/ui/skeleton'
import { useTranslation } from 'react-i18next'
import { getImageUrl } from '@/constants/assets'

export function ProfilePage() {
  const navigate = useNavigate()
  const { t, i18n } = useTranslation('pages')

  const { data: profileResponse, isLoading, isError } = useQuery({
    queryKey: ['personal-profile'],
    queryFn: () => userService.getPublicProfile(),
  })

  const profile = profileResponse?.data

  if (isLoading) {
    return (
      <div className="min-h-screen py-20 flex items-center justify-center bg-[#F2F4F6]">
        <Skeleton className="w-16 h-16 rounded-full" />
      </div>
    )
  }

  if (isError || !profile) {
    return (
      <div className="min-h-screen py-20 flex flex-col items-center justify-center text-[#1a1a1a] bg-[#F2F4F6]">
        <h2 className="text-2xl font-bold mb-4">Profile not found or you are not authenticated</h2>
        <Button onClick={() => navigate('/login')} className="bg-[#3A6EA5] text-white">Login</Button>
      </div>
    )
  }

  return (
    <div className="min-h-screen py-20 bg-[#F2F4F6]">
      <div className="max-w-[1200px] mx-auto px-8">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-3xl font-bold text-[#1a1a1a]">{t('viewUserProfile.myProfile', 'My Profile')}</h1>
          <Button
            onClick={() => navigate('/settings')}
            className="rounded-xl bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white shadow-md"
            dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}
          >
            <Settings className={`w-4 h-4 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
            {t('viewUserProfile.editProfile', 'Edit Profile')}
          </Button>
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Profile Card */}
          <div className="lg:col-span-1">
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardContent className="pt-6 text-center">
                <div className="relative w-40 h-40 mx-auto mb-6">
                  <Avatar className="w-full h-full">
                    {profile.profileImage && <AvatarImage src={getImageUrl(profile.profileImage)} className="object-cover" />}
                    <AvatarFallback className="text-4xl bg-[#E5EBF0] text-[#3A6EA5]">
                      {profile.fullName?.split(' ').map((n) => n[0]).join('') || 'U'}
                    </AvatarFallback>
                  </Avatar>
                  {profile.accountStatus === 'Verified' && (
                    <div className="absolute bottom-2 right-2 w-10 h-10 rounded-full bg-green-500 flex items-center justify-center shadow-lg border-2 border-white">
                      <CheckCircle className="w-6 h-6 text-white" />
                    </div>
                  )}
                </div>
                <h2 className="text-2xl font-bold text-[#1a1a1a] mb-2">
                  {profile.fullName}
                </h2>
                {profile.accountStatus === 'Verified' && (
                  <div className="inline-flex items-center gap-1 px-3 py-1 bg-green-100 rounded-full text-green-700 text-sm font-medium mb-4">
                    <CheckCircle className="w-4 h-4" />
                    Verified User
                  </div>
                )}

                <div className="space-y-3 mt-6 text-left">
                  <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                    <Mail className="w-4 h-4 text-[#3A6EA5]" />
                    <span>{profile.email}</span>
                  </div>
                  {profile.gender && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <UserIcon className="w-4 h-4 text-[#3A6EA5]" />
                      <span>{profile.genderDisplayName || profile.gender}</span>
                    </div>
                  )}
                  {profile.dateOfBirth && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <CalendarDays className="w-4 h-4 text-[#3A6EA5]" />
                      <span>
                        {Math.floor((new Date().getTime() - new Date(profile.dateOfBirth).getTime()) / 3.15576e+10)} {t('viewUserProfile.yearsOld', 'years old')}
                      </span>
                    </div>
                  )}
                  {profile.country && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <Globe className="w-4 h-4 text-[#3A6EA5]" />
                      <span>{profile.countryDisplayName || profile.country}</span>
                    </div>
                  )}
                  {profile.memberSince && (
                    <div className="flex items-center gap-3 text-sm text-[#1a1a1a]">
                      <Calendar className="w-4 h-4 text-[#3A6EA5]" />
                      <span>{t('viewUserProfile.memberSince', 'Joined')} {new Date(profile.memberSince).getFullYear()}</span>
                    </div>
                  )}
                </div>

                {profile.isOwner && (
                  <div className="mt-6 pt-6 border-t border-[#3A6EA5]/20 flex justify-around text-[#1a1a1a]">
                    <div className="text-center">
                      <div className="flex justify-center items-center gap-1 font-bold text-lg">
                        <Star className="w-5 h-5 text-amber-400 fill-amber-400" />
                        {profile.averageRating ? profile.averageRating.toFixed(1) : 'N/A'}
                      </div>
                      <p className="text-xs text-[#6B7280]">
                        {profile.ratingsCount || 0} Ratings
                      </p>
                    </div>
                    <div className="text-center">
                      <div className="flex justify-center items-center gap-1 font-bold text-lg">
                        <Home className="w-5 h-5 text-[#3A6EA5]" />
                        {profile.ownedPropertiesCount || 0}
                      </div>
                      <p className="text-xs text-[#6B7280]">Properties</p>
                    </div>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Profile Details */}
          <div className="lg:col-span-2 space-y-6">
            {/* About */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">{t('viewUserProfile.about', 'About')}</CardTitle>
              </CardHeader>
              <CardContent>
                <p 
                  className={`text-[#1a1a1a] leading-relaxed ${/[a-zA-Z]/.test(profile.bio || '') ? 'text-left' : ''}`}
                  dir={/[a-zA-Z]/.test(profile.bio || '') ? 'ltr' : undefined}
                >
                  {profile.bio || 'No bio provided.'}
                </p>
              </CardContent>
            </Card>

            {/* Roommate Status */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <div className="flex items-center gap-3">
                  <Users className="w-6 h-6 text-[#3A6EA5]" />
                  <CardTitle className="text-2xl text-[#1a1a1a]">
                    {t('viewUserProfile.roommateStatus', 'Roommate Status')}
                  </CardTitle>
                </div>
              </CardHeader>
              <CardContent>
                <div className="flex items-center gap-3 p-4 bg-[#F2F4F6] rounded-2xl">
                  {profile.roommatePreferencesEnabled ? (
                    <>
                      <CheckCircle className="w-6 h-6 text-green-500" />
                      <div>
                        <p className="font-semibold text-[#1a1a1a]">
                          {t('viewUserProfile.acceptsRoommates', 'Looking for Roommates')}
                        </p>
                        <p className="text-sm text-[#6B7280]">
                          {t('viewUserProfile.acceptsRoommatesDesc', 'You are currently open to matching with roommates.')}
                        </p>
                      </div>
                    </>
                  ) : (
                    <>
                      <XCircle className="w-6 h-6 text-red-500" />
                      <div>
                        <p className="font-semibold text-[#1a1a1a]">
                          {t('viewUserProfile.doesNotAcceptRoommates', 'Not Looking for Roommates')}
                        </p>
                        <p className="text-sm text-[#6B7280]">
                          {t('viewUserProfile.doesNotAcceptRoommatesDesc', 'You are not currently looking to match with roommates.')}
                        </p>
                      </div>
                    </>
                  )}
                </div>
              </CardContent>
            </Card>

            {/* Lifestyle & Preferences */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
                <CardHeader>
                  <div className="flex items-center gap-3">
                    <Home className="w-6 h-6 text-[#3A6EA5]" />
                    <CardTitle className="text-2xl text-[#1a1a1a]">
                      {t('viewUserProfile.lifestyle', 'Lifestyle & Preferences')}
                    </CardTitle>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="grid md:grid-cols-2 gap-4">
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <p className="text-sm text-[#6B7280] mb-1">{t('viewUserProfile.lifestyle_fields.smoking', 'Smoking')}</p>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.smoking === null ? t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified') : (profile.smoking ? t('viewUserProfile.lifestyle_fields.yes', 'Yes') : t('viewUserProfile.lifestyle_fields.no', 'No'))}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <p className="text-sm text-[#6B7280] mb-1">{t('viewUserProfile.lifestyle_fields.pets', 'Pets')}</p>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.pets === null ? t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified') : (profile.pets ? t('viewUserProfile.lifestyle_fields.yes', 'Yes') : t('viewUserProfile.lifestyle_fields.no', 'No'))}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <p className="text-sm text-[#6B7280] mb-1">
                        {t('viewUserProfile.lifestyle_fields.sleepSchedule', 'Sleep Schedule')}
                      </p>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.sleepSchedule ? (profile.sleepScheduleDisplayName || profile.sleepSchedule) : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <div className="flex items-center gap-2 mb-1">
                        <Volume2 className="w-4 h-4 text-[#6B7280]" />
                        <p className="text-sm text-[#6B7280]">{t('viewUserProfile.lifestyle_fields.noiseTolerance', 'Noise Tolerance')}</p>
                      </div>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.noiseTolerance !== null ? profile.noiseTolerance + '/5' : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <p className="text-sm text-[#6B7280] mb-1">
                        {t('viewUserProfile.lifestyle_fields.guestsFrequency', 'Guests Frequency')}
                      </p>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.guestsFrequency ? (profile.guestsFrequencyDisplayName || profile.guestsFrequency) : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <div className="flex items-center gap-2 mb-1">
                        <Briefcase className="w-4 h-4 text-[#6B7280]" />
                        <p className="text-sm text-[#6B7280]">{t('viewUserProfile.lifestyle_fields.workSchedule', 'Work Schedule')}</p>
                      </div>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.workSchedule ? (profile.workScheduleDisplayName || profile.workSchedule) : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl md:col-span-2">
                      <p className="text-sm text-[#6B7280] mb-1">{t('viewUserProfile.lifestyle_fields.sharingLevel', 'Sharing Level')}</p>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.sharingLevel ? (profile.sharingLevelDisplayName || profile.sharingLevel) : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl md:col-span-2">
                      <div className="flex items-center gap-2 mb-1">
                        <Wallet className="w-4 h-4 text-[#6B7280]" />
                        <p className="text-sm text-[#6B7280]">{t('viewUserProfile.lifestyle_fields.budgetRange', 'Budget Range')}</p>
                      </div>
                      <p className="font-semibold text-[#1a1a1a]">
                        {(profile.budgetRangeMin !== null && profile.budgetRangeMax !== null)
                          ? `${profile.budgetRangeMin} EGP - ${profile.budgetRangeMax} EGP`
                          : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>

            {/* Education */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
                <CardHeader>
                  <div className="flex items-center gap-3">
                    <GraduationCap className="w-6 h-6 text-[#3A6EA5]" />
                    <CardTitle className="text-2xl text-[#1a1a1a]">
                      {t('viewUserProfile.education', 'Education')}
                    </CardTitle>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="grid md:grid-cols-2 gap-4">
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <p className="text-sm text-[#6B7280] mb-1">
                        {t('viewUserProfile.education_fields.educationLevel', 'Education Level')}
                      </p>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.educationLevel ? (profile.educationLevelDisplayName || profile.educationLevel) : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
                    </div>
                    <div className="p-4 bg-[#F2F4F6] rounded-2xl">
                      <p className="text-sm text-[#6B7280] mb-1">
                        {t('viewUserProfile.education_fields.fieldOfStudy', 'Field of Study')}
                      </p>
                      <p className="font-semibold text-[#1a1a1a]">
                        {profile.fieldOfStudy ? (profile.fieldOfStudyDisplayName || profile.fieldOfStudy) : t('viewUserProfile.lifestyle_fields.unspecified', 'Unspecified')}
                      </p>
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
