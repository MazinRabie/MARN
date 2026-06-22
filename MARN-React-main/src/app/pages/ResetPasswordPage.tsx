import { useState } from 'react'
import { Link, useSearchParams } from 'react-router'
import { motion } from 'motion/react'
import {
  ArrowLeft,
  Lock,
  Eye,
  EyeOff,
  CheckCircle,
  XCircle,
} from 'lucide-react'
import { Button } from '@/app/components/ui/button'
import { Input } from '@/app/components/ui/input'
import { Label } from '@/app/components/ui/label'
import { useMutation } from '@tanstack/react-query'
import { authService } from '@/services/authService'
import { HttpError } from '@/services/httpErrors'
import { useTranslation } from 'react-i18next'

export function ResetPasswordPage() {
  const { t, i18n } = useTranslation('auth')
  const [searchParams] = useSearchParams()
  const email = (searchParams.get('email') ?? '').trim()
  const token = (searchParams.get('token') ?? '').replace(/ /g, '+')

  const missingParams = !email || !token

  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const [localError, setLocalError] = useState('')
  const [serverErrors, setServerErrors] = useState<string[]>([])
  const [isSuccess, setIsSuccess] = useState(false)
  const [formData, setFormData] = useState({
    newPassword: '',
    confirmPassword: '',
  })

  const { mutate: resetPassword, isPending: loading } = useMutation({
    mutationFn: () =>
      authService.resetPassword({
        email,
        token,
        newPassword: formData.newPassword,
        confirmPassword: formData.confirmPassword,
      }),
    onSuccess: () => setIsSuccess(true),
    onError: (error: Error) => {
      if (error instanceof HttpError && error.errors?.length) {
        setServerErrors(error.errors)
      } else {
        setServerErrors([
          error instanceof HttpError
            ? error.message
            : t('resetPassword.somethingWentWrong'),
        ])
      }
    },
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setLocalError('')
    setServerErrors([])

    if (formData.newPassword.length < 8) {
      setLocalError(t('resetPassword.errorMinLength'))
      return
    }

    if (formData.newPassword !== formData.confirmPassword) {
      setLocalError(t('resetPassword.errorMismatch'))
      return
    }

    resetPassword()
  }

  if (isSuccess) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC] to-[#3A6EA5] flex items-center justify-center px-4 py-20">
        <div className="w-full max-w-md">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-[#3A6EA5]/20 text-center"
          >
            <div className="w-20 h-20 rounded-full bg-gradient-to-br from-green-400 to-green-600 flex items-center justify-center mx-auto mb-6">
              <CheckCircle className="w-10 h-10 text-white" />
            </div>
            <h2 className="text-3xl font-bold text-[#1a1a1a] mb-3">
              {t('resetPassword.success.title')}
            </h2>
            <p className="text-[#4a5565] mb-8">
              {t('resetPassword.success.subtitle')}
            </p>
            <Button
              asChild
              size="lg"
              className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6"
            >
              <Link to="/login">{t('resetPassword.success.goToSignIn')}</Link>
            </Button>
          </motion.div>
        </div>
      </div>
    )
  }

  if (missingParams) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC] to-[#3A6EA5] flex items-center justify-center px-4 py-20">
        <div className="w-full max-w-md">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-[#3A6EA5]/20 text-center"
          >
            <div className="w-20 h-20 rounded-full bg-red-100 flex items-center justify-center mx-auto mb-6">
              <XCircle className="w-10 h-10 text-red-500" />
            </div>
            <h2 className="text-2xl font-bold text-[#1a1a1a] mb-3">
              {t('resetPassword.invalidLink.title')}
            </h2>
            <p className="text-[#4a5565] mb-8">
              {t('resetPassword.invalidLink.subtitle')}
            </p>
            <Button
              asChild
              size="lg"
              className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6"
            >
              <Link to="/forgot-password">{t('resetPassword.invalidLink.requestNew')}</Link>
            </Button>
          </motion.div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC] to-[#3A6EA5] flex items-center justify-center px-4 py-20">
      <div className="w-full max-w-lg">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-[#3A6EA5]/20"
        >
          <Link
            to="/login"
            className="inline-flex items-center gap-2 text-[#4a5565] hover:text-[#3A6EA5] transition-colors mb-6"
          >
            <ArrowLeft className={`w-4 h-4 ${i18n.language === 'ar' ? 'rotate-180' : ''}`} />
            {t('resetPassword.backToLogin')}
          </Link>

          <div className="mb-8">
            <h1 className="text-3xl font-bold text-[#1a1a1a] mb-2">
              {t('resetPassword.title')}
            </h1>
            <p className="text-[#4a5565] text-sm">
              {t('resetPassword.resetingFor')} {' '}
              <span className="font-semibold text-[#1a1a1a]">{email}</span>
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            {(localError || serverErrors.length > 0) && (
              <div className="text-sm text-red-500 rounded-xl bg-red-50 px-4 py-3 border border-red-200">
                {localError ? (
                  <p>{localError}</p>
                ) : (
                  <ul className="list-disc list-inside space-y-1">
                    {serverErrors.map((msg) => (
                      <li key={msg}>{msg}</li>
                    ))}
                  </ul>
                )}
              </div>
            )}

            <div>
              <Label
                htmlFor="newPassword"
                className="text-[#1a1a1a] mb-2 block"
              >
                {t('resetPassword.newPasswordLabel')}
              </Label>
              <div className="relative">
                <Lock className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                <Input
                  id="newPassword"
                  type={showPassword ? 'text' : 'password'}
                  value={formData.newPassword}
                  onChange={(e) =>
                    setFormData({ ...formData, newPassword: e.target.value })
                  }
                  required
                  disabled={loading}
                  className={`${i18n.language === 'ar' ? 'pr-12 pl-12' : 'pl-12 pr-12'} py-6 bg-[#F2F4F6] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5]`}
                  placeholder={t('resetPassword.newPasswordPlaceholder')}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((prev) => !prev)}
                  className={`absolute ${i18n.language === 'ar' ? 'left-4' : 'right-4'} top-1/2 -translate-y-1/2 text-[#6a7282] hover:text-[#3A6EA5]`}
                >
                  {showPassword ? (
                    <EyeOff className="w-5 h-5" />
                  ) : (
                    <Eye className="w-5 h-5" />
                  )}
                </button>
              </div>
            </div>

            <div>
              <Label
                htmlFor="confirmPassword"
                className="text-[#1a1a1a] mb-2 block"
              >
                {t('resetPassword.confirmPasswordLabel')}
              </Label>
              <div className="relative">
                <Lock className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                <Input
                  id="confirmPassword"
                  type={showConfirmPassword ? 'text' : 'password'}
                  value={formData.confirmPassword}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      confirmPassword: e.target.value,
                    })
                  }
                  required
                  disabled={loading}
                  className={`${i18n.language === 'ar' ? 'pr-12 pl-12' : 'pl-12 pr-12'} py-6 bg-[#F2F4F6] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5]`}
                  placeholder={t('resetPassword.confirmPasswordPlaceholder')}
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPassword((prev) => !prev)}
                  className={`absolute ${i18n.language === 'ar' ? 'left-4' : 'right-4'} top-1/2 -translate-y-1/2 text-[#6a7282] hover:text-[#3A6EA5]`}
                >
                  {showConfirmPassword ? (
                    <EyeOff className="w-5 h-5" />
                  ) : (
                    <Eye className="w-5 h-5" />
                  )}
                </button>
              </div>
            </div>

            <Button
              type="submit"
              size="lg"
              disabled={loading}
              className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6 shadow-lg shadow-[#3A6EA5]/30 disabled:opacity-50"
            >
              {loading ? t('resetPassword.resetting') : t('resetPassword.resetPassword')}
            </Button>
          </form>
        </motion.div>
      </div>
    </div>
  )
}
