import { useState, useEffect, startTransition } from 'react'
import { User, Mail, Phone, Camera } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { Textarea } from '../../components/ui/textarea'
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from '../../components/ui/card'
import { Skeleton } from '../../components/ui/skeleton'
import { toast } from 'sonner'
import { getImageUrl } from '@/constants/assets'
import { useProfile } from '@/hooks/useProfile'
import { EnumSelect } from '../../components/EnumSelect'
import { HttpError } from '@/services/httpErrors'
import { useTranslation } from 'react-i18next'

export function ProfileTab() {
  const { t } = useTranslation('profile')
  const { data: profileResponse, isLoading, update } = useProfile()
  const apiProfile = profileResponse?.data

  const [avatarFile, setAvatarFile] = useState<File | null>(null)
  const [avatarPreview, setAvatarPreview] = useState<string | null>(null)
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({})
  const [profileData, setProfileData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    country: '',
    gender: '',
    language: '',
    dateOfBirth: '',
    bio: '',
  })

  useEffect(() => {
    if (apiProfile) {
      startTransition(() => {
        setProfileData({
          firstName: apiProfile.firstName ?? '',
          lastName: apiProfile.lastName ?? '',
          email: apiProfile.email ?? '',
          phone: apiProfile.phoneNumber ?? '',
          country: apiProfile.country ?? '',
          gender: apiProfile.gender ?? '',
          language: apiProfile.language ?? '',
          dateOfBirth: apiProfile.dateOfBirth
            ? apiProfile.dateOfBirth.split('T')[0]
            : '',
          bio: apiProfile.bio ?? '',
        })
      })
    }
  }, [apiProfile])

  const clearFieldError = (key: string) =>
    setFieldErrors((prev) => {
      if (!prev[key]) return prev
      const { [key]: _, ...rest } = prev
      return rest
    })

  return (
    <div className="grid lg:grid-cols-3 gap-8">
      {/* Profile Photo */}
      <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 lg:col-span-1">
        <CardContent className="pt-6 text-center">
          <div className="relative w-40 h-40 mx-auto mb-6">
            {isLoading ? (
              <Skeleton className="w-full h-full rounded-full" />
            ) : (
              <img
                src={avatarPreview ?? getImageUrl(apiProfile?.profileImage)}
                alt="Profile"
                className="w-full h-full rounded-full object-cover shadow-lg"
              />
            )}
          </div>
          <h3 className="text-xl font-semibold text-[#1a1a1a] mb-2">
            {profileData.firstName} {profileData.lastName}
          </h3>
          <p className="text-[#4a5565] mb-6">{profileData.email}</p>
          <label className="cursor-pointer">
            <input
              type="file"
              accept="image/*"
              className="hidden"
              onChange={(e) => {
                const file = e.target.files?.[0]
                if (file) {
                  setAvatarFile(file)
                  setAvatarPreview(URL.createObjectURL(file))
                }
              }}
            />
            <Button
              variant="outline"
              className="w-full rounded-xl border-[#3A6EA5]/20 hover:bg-[#3A6EA5]/8 hover:border-[#3A6EA5]/40 hover:text-[#3A6EA5] transition-colors"
              asChild
            >
              <span>{avatarFile ? avatarFile.name : t('profileTab.uploadPhoto')}</span>
            </Button>
          </label>
        </CardContent>
      </Card>

      {/* Profile Information */}
      <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 lg:col-span-2">
        <CardHeader>
          <CardTitle className="text-2xl text-[#1a1a1a]">
            {t('profileTab.cardTitle')}
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <Label htmlFor="firstName" className="text-[#1a1a1a] mb-2 block">
                {t('profileTab.firstName')}
              </Label>
              <div className="relative">
                <User className="absolute start-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]" />
                <Input
                  id="firstName"
                  value={profileData.firstName}
                  onChange={(e) => {
                    setProfileData({
                      ...profileData,
                      firstName: e.target.value,
                    })
                    clearFieldError('FirstName')
                  }}
                  className={`ps-12 bg-white rounded-xl border-[#3A6EA5]/20 ${fieldErrors.FirstName ? 'border-red-400' : ''}`}
                />
              </div>
              {fieldErrors.FirstName && (
                <p className="text-xs text-red-500 mt-1">
                  {fieldErrors.FirstName}
                </p>
              )}
            </div>

            <div>
              <Label htmlFor="lastName" className="text-[#1a1a1a] mb-2 block">
                {t('profileTab.lastName')}
              </Label>
              <div className="relative">
                <User className="absolute start-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]" />
                <Input
                  id="lastName"
                  value={profileData.lastName}
                  onChange={(e) => {
                    setProfileData({ ...profileData, lastName: e.target.value })
                    clearFieldError('LastName')
                  }}
                  className={`ps-12 bg-white rounded-xl border-[#3A6EA5]/20 ${fieldErrors.LastName ? 'border-red-400' : ''}`}
                />
              </div>
              {fieldErrors.LastName && (
                <p className="text-xs text-red-500 mt-1">
                  {fieldErrors.LastName}
                </p>
              )}
            </div>

            <div>
              <Label htmlFor="email" className="text-[#1a1a1a] mb-2 block">
                {t('profileTab.emailAddress')}
              </Label>
              <div className="relative">
                <Mail className="absolute start-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]" />
                <Input
                  id="email"
                  type="email"
                  value={profileData.email}
                  disabled
                  className="ps-12 bg-[#9CBBDC]/20 rounded-xl border-[#3A6EA5]/20 cursor-not-allowed"
                />
              </div>
              <p className="text-xs text-[#4a5565] mt-1">
                {t('profileTab.emailCannotChange')}
              </p>
            </div>

            <div>
              <Label htmlFor="phone" className="text-[#1a1a1a] mb-2 block">
                {t('profileTab.phoneNumber')}
              </Label>
              <div className="relative">
                <Phone className="absolute start-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]" />
                <Input
                  id="phone"
                  value={profileData.phone}
                  onChange={(e) => {
                    setProfileData({ ...profileData, phone: e.target.value })
                    clearFieldError('PhoneNumber')
                  }}
                  className={`ps-12 bg-white rounded-xl border-[#3A6EA5]/20 ${fieldErrors.PhoneNumber ? 'border-red-400' : ''}`}
                />
              </div>
              {fieldErrors.PhoneNumber && (
                <p className="text-xs text-red-500 mt-1">
                  {fieldErrors.PhoneNumber}
                </p>
              )}
            </div>

            <div>
              <Label
                htmlFor="dateOfBirth"
                className="text-[#1a1a1a] mb-2 block"
              >
                {t('profileTab.dateOfBirth')}
              </Label>
              <Input
                id="dateOfBirth"
                type="date"
                value={profileData.dateOfBirth}
                onChange={(e) => {
                  setProfileData({
                    ...profileData,
                    dateOfBirth: e.target.value,
                  })
                  clearFieldError('DateOfBirth')
                }}
                className={`bg-white rounded-xl border-[#3A6EA5]/20 ${fieldErrors.DateOfBirth ? 'border-red-400' : ''}`}
              />
              {fieldErrors.DateOfBirth && (
                <p className="text-xs text-red-500 mt-1">
                  {fieldErrors.DateOfBirth}
                </p>
              )}
            </div>

            <div>
              <EnumSelect
                id="country"
                label={t('profileTab.country')}
                endpoint="countries"
                value={profileData.country}
                onChange={(value) => {
                  setProfileData({ ...profileData, country: value })
                  clearFieldError('Country')
                }}
              />
              {fieldErrors.Country && (
                <p className="text-xs text-red-500 mt-1">
                  {fieldErrors.Country}
                </p>
              )}
            </div>

            <div>
              <EnumSelect
                id="gender"
                label={t('profileTab.gender')}
                endpoint="genders"
                value={profileData.gender}
                onChange={(value) => {
                  setProfileData({ ...profileData, gender: value })
                  clearFieldError('Gender')
                }}
              />
              {fieldErrors.Gender && (
                <p className="text-xs text-red-500 mt-1">
                  {fieldErrors.Gender}
                </p>
              )}
            </div>

            <div>
              <EnumSelect
                id="language"
                label={t('profileTab.language')}
                endpoint="languages"
                value={profileData.language}
                onChange={(value) => {
                  setProfileData({ ...profileData, language: value })
                  clearFieldError('Language')
                }}
              />
              {fieldErrors.Language && (
                <p className="text-xs text-red-500 mt-1">
                  {fieldErrors.Language}
                </p>
              )}
            </div>
          </div>

          <div>
            <Label htmlFor="bio" className="text-[#1a1a1a] mb-2 block">
              {t('profileTab.bio')}
            </Label>
            <Textarea
              id="bio"
              value={profileData.bio}
              onChange={(e) => {
                setProfileData({ ...profileData, bio: e.target.value })
                clearFieldError('Bio')
              }}
              className={`bg-white rounded-xl border-[#3A6EA5]/20 min-h-[120px] ${fieldErrors.Bio ? 'border-red-400' : ''}`}
              placeholder={t('profileTab.bioPlaceholder')}
            />
            {fieldErrors.Bio && (
              <p className="text-xs text-red-500 mt-1">{fieldErrors.Bio}</p>
            )}
          </div>

          <div className="flex gap-4 justify-end">
            <Button
              variant="outline"
              className="rounded-xl border-[#3A6EA5]/20"
            >
              {t('profileTab.cancel')}
            </Button>
            <Button
              disabled={update.isPending}
              onClick={() => {
                update.mutate(
                  {
                    id: apiProfile!.id,
                    firstName: profileData.firstName,
                    lastName: profileData.lastName,
                    phoneNumber: profileData.phone,
                    country: profileData.country,
                    gender: profileData.gender,
                    language: profileData.language,
                    dateOfBirth: profileData.dateOfBirth,
                    bio: profileData.bio,
                    profileImage: avatarFile ?? undefined,
                  },
                  {
                    onSuccess: () => {
                      setFieldErrors({})
                      toast.success('Profile updated successfully!')
                    },
                    onError: (err) => {
                      if (err instanceof HttpError && err.validationErrors) {
                        const flat: Record<string, string> = {}
                        for (const [key, msgs] of Object.entries(
                          err.validationErrors,
                        )) {
                          flat[key] = msgs[0]
                        }
                        setFieldErrors(flat)
                      } else {
                        toast.error(t('profileTab.toasts.failed'))
                      }
                    },
                  },
                )
              }}
              className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl"
            >
              {update.isPending ? t('profileTab.saveChanges') : t('profileTab.saveChanges')}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
