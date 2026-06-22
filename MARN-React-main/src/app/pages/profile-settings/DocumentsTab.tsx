import { useState, useEffect, startTransition } from 'react'
import { IdCard } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from '../../components/ui/card'
import { FileUpload } from '../../components/ui/file-upload'
import { toast } from 'sonner'
import { useProfile } from '@/hooks/useProfile'
import { HttpError } from '@/services/httpErrors'
import { getImageUrl } from '@/constants/assets'
import { useTranslation } from 'react-i18next'

export function DocumentsTab() {
  const { t } = useTranslation('profile')
  const { data: profileResponse, updateLegal } = useProfile()
  const apiProfile = profileResponse?.data

  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({})
  const [identityVerification, setIdentityVerification] = useState({
    frontIdCard: null as File | null,
    backIdCard: null as File | null,
    nameArabic: '',
    addressArabic: '',
    nationalIdNumber: '',
  })

  useEffect(() => {
    if (!apiProfile) return

    startTransition(() => {
      setIdentityVerification((prev) => ({
        ...prev,
        nameArabic: apiProfile.arabicFullName ?? '',
        addressArabic: apiProfile.arabicAddress ?? '',
        nationalIdNumber: apiProfile.nationalIDNumber ?? '',
      }))
    })

    const fetchAsFile = async (path: string): Promise<File | null> => {
      try {
        const res = await fetch(getImageUrl(path))
        const blob = await res.blob()
        const filename = path.split('/').pop() ?? 'image.jpg'
        return new File([blob], filename, { type: blob.type })
      } catch {
        return null
      }
    }

    if (apiProfile.frontIdPhoto) {
      fetchAsFile(apiProfile.frontIdPhoto).then(
        (file) =>
          file &&
          setIdentityVerification((prev) => ({ ...prev, frontIdCard: file })),
      )
    }
    if (apiProfile.backIdPhoto) {
      fetchAsFile(apiProfile.backIdPhoto).then(
        (file) =>
          file &&
          setIdentityVerification((prev) => ({ ...prev, backIdCard: file })),
      )
    }
  }, [apiProfile])

  const clearFieldError = (key: string) =>
    setFieldErrors((prev) => {
      if (!prev[key]) return prev
      const { [key]: _, ...rest } = prev
      return rest
    })

  const handleSubmit = () => {
    if (!apiProfile?.id) return
    updateLegal.mutate(
      {
        id: apiProfile.id,
        arabicFullName: identityVerification.nameArabic,
        arabicAddress: identityVerification.addressArabic,
        nationalIDNumber: identityVerification.nationalIdNumber,
        frontIdPhoto: identityVerification.frontIdCard ?? undefined,
        backIdPhoto: identityVerification.backIdCard ?? undefined,
      },
      {
        onSuccess: () => {
          setFieldErrors({})
          toast.success(t('documentsTab.toasts.submitted'))
        },
        onError: (err) => {
          if (err instanceof HttpError && err.validationErrors) {
            const flat: Record<string, string> = {}
            for (const [key, msgs] of Object.entries(err.validationErrors)) {
              flat[key] = msgs[0]
            }
            setFieldErrors(flat)
          } else {
            toast.error(
              err instanceof HttpError
                ? err.message
                : t('documentsTab.toasts.failed'),
            )
          }
        },
      },
    )
  }

  return (
    <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
      <CardHeader>
        <div className="flex items-center gap-3">
          <IdCard className="w-6 h-6 text-[#3A6EA5]" />
          <div>
            <CardTitle className="text-2xl text-[#1a1a1a]">
              {t('documentsTab.title')}
            </CardTitle>
            <p className="text-sm text-[#4a5565] mt-1">
              {t('documentsTab.subtitle')}
            </p>
          </div>
        </div>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="grid md:grid-cols-2 gap-6">
          <div>
            <Label className="text-[#1a1a1a] mb-2 block">
              {t('documentsTab.frontId')}
            </Label>
            <FileUpload
              id="frontIdCard"
              value={identityVerification.frontIdCard}
              initialUrl={
                apiProfile?.frontIdPhoto
                  ? getImageUrl(apiProfile.frontIdPhoto)
                  : null
              }
              onChange={(file) =>
                setIdentityVerification({
                  ...identityVerification,
                  frontIdCard: file,
                })
              }
              onClear={() =>
                setIdentityVerification({
                  ...identityVerification,
                  frontIdCard: null,
                })
              }
            />
          </div>

          <div>
            <Label className="text-[#1a1a1a] mb-2 block">
              {t('documentsTab.backId')}
            </Label>
            <FileUpload
              id="backIdCard"
              value={identityVerification.backIdCard}
              initialUrl={
                apiProfile?.backIdPhoto
                  ? getImageUrl(apiProfile.backIdPhoto)
                  : null
              }
              onChange={(file) =>
                setIdentityVerification({
                  ...identityVerification,
                  backIdCard: file,
                })
              }
              onClear={() =>
                setIdentityVerification({
                  ...identityVerification,
                  backIdCard: null,
                })
              }
            />
          </div>

          <div>
            <Label htmlFor="nameArabic" className="text-[#1a1a1a] mb-2 block">
              {t('documentsTab.nameInArabic')}
            </Label>
            <Input
              id="nameArabic"
              value={identityVerification.nameArabic}
              onChange={(e) => {
                setIdentityVerification({
                  ...identityVerification,
                  nameArabic: e.target.value,
                })
                clearFieldError('ArabicFullName')
              }}
              className={`bg-white rounded-xl border-[#3A6EA5]/20 ${fieldErrors.ArabicFullName ? 'border-red-400' : ''}`}
              placeholder={t('documentsTab.nameInArabicPlaceholder')}
              dir="rtl"
            />
            {fieldErrors.ArabicFullName && (
              <p className="text-xs text-red-500 mt-1">
                {fieldErrors.ArabicFullName}
              </p>
            )}
          </div>

          <div>
            <Label
              htmlFor="addressArabic"
              className="text-[#1a1a1a] mb-2 block"
            >
              {t('documentsTab.addressInArabic')}
            </Label>
            <Input
              id="addressArabic"
              value={identityVerification.addressArabic}
              onChange={(e) => {
                setIdentityVerification({
                  ...identityVerification,
                  addressArabic: e.target.value,
                })
                clearFieldError('ArabicAddress')
              }}
              className={`bg-white rounded-xl border-[#3A6EA5]/20 ${fieldErrors.ArabicAddress ? 'border-red-400' : ''}`}
              placeholder={t('documentsTab.addressInArabicPlaceholder')}
              dir="rtl"
            />
            {fieldErrors.ArabicAddress && (
              <p className="text-xs text-red-500 mt-1">
                {fieldErrors.ArabicAddress}
              </p>
            )}
          </div>

          <div className="md:col-span-2">
            <Label
              htmlFor="nationalIdNumber"
              className="text-[#1a1a1a] mb-2 block"
            >
              {t('documentsTab.nationalId')}
            </Label>
            <Input
              id="nationalIdNumber"
              value={identityVerification.nationalIdNumber}
              onChange={(e) => {
                setIdentityVerification({
                  ...identityVerification,
                  nationalIdNumber: e.target.value,
                })
                clearFieldError('NationalIDNumber')
              }}
              className={`bg-white rounded-xl border-[#3A6EA5]/20 ${fieldErrors.NationalIDNumber ? 'border-red-400' : ''}`}
              placeholder={t('documentsTab.nationalIdPlaceholder')}
            />
            {fieldErrors.NationalIDNumber && (
              <p className="text-xs text-red-500 mt-1">
                {fieldErrors.NationalIDNumber}
              </p>
            )}
          </div>
        </div>

        <div className="flex gap-4 justify-end pt-4">
          <Button variant="outline" className="rounded-xl border-[#3A6EA5]/20">
            {t('documentsTab.cancel')}
          </Button>
          <Button
            disabled={updateLegal.isPending}
            onClick={handleSubmit}
            className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl"
          >
            {updateLegal.isPending ? t('documentsTab.submitting') : t('documentsTab.submit')}
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
