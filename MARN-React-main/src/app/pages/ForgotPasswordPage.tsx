import { motion } from 'motion/react'
import { Mail, ArrowLeft, CheckCircle } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Label } from '../components/ui/label'
import { Link } from 'react-router'
import { useState } from 'react'
import { useMutation } from '@tanstack/react-query'
import { authService } from '@/services/authService'
import { useTranslation } from 'react-i18next'

export function ForgotPasswordPage() {
  const { t, i18n } = useTranslation('auth')
  const [email, setEmail] = useState('')
  const [isSubmitted, setIsSubmitted] = useState(false)
  const [error, setError] = useState('')

  const { mutate: sendReset, isPending: isLoading } = useMutation({
    mutationFn: () => authService.forgotPassword({ email }),
    onSuccess: () => setIsSubmitted(true),
    onError: (err) => {
      setError(
        err instanceof Error
          ? err.message
          : t('forgotPassword.somethingWentWrong'),
      )
    },
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    sendReset()
  }

  const validateEmail = (email: string) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return re.test(email)
  }

  const isEmailValid = validateEmail(email)

  if (isSubmitted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC] to-[#3A6EA5] flex items-center justify-center px-4 py-20">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.5 }}
          className="w-full max-w-md"
        >
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-[#3A6EA5]/20 text-center">
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.2, type: 'spring', stiffness: 200 }}
              className="w-20 h-20 rounded-full bg-gradient-to-br from-green-400 to-green-600 flex items-center justify-center mx-auto mb-6"
            >
              <CheckCircle className="w-10 h-10 text-white" />
            </motion.div>

            <h2 className="text-3xl font-bold text-[#1a1a1a] mb-4">
              {t('forgotPassword.success.title')}
            </h2>
            <p className="text-[#4a5565] mb-2">
              {t('forgotPassword.success.sentTo')}
            </p>
            <p className="text-[#3A6EA5] font-semibold mb-6">{email}</p>
            <p className="text-sm text-[#4a5565] mb-8">
              {t('forgotPassword.success.didntReceive')} {' '}
              <button
                onClick={() => setIsSubmitted(false)}
                className="text-[#3A6EA5] hover:underline font-semibold"
              >
                {t('forgotPassword.success.tryAgain')}
              </button>
            </p>

            <Button
              size="lg"
              className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6"
              asChild
            >
              <Link to="/login">{t('forgotPassword.backToLogin')}</Link>
            </Button>
          </div>
        </motion.div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC] to-[#3A6EA5] flex items-center justify-center px-4 py-20">
      <div className="w-full max-w-6xl grid lg:grid-cols-2 gap-12 items-center">
        {/* Left Side - Branding */}
        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6 }}
          className="hidden lg:block"
        >
          <div className="flex items-center gap-3 mb-8">
            <Link to="/" className="flex items-center gap-2">
              <img src="/Logo-Signup.svg" alt={t('logoAlt', { defaultValue: 'MARN Logo' })} className="h-16 w-auto" />
            </Link>
          </div>
          <h1 className="text-5xl font-bold text-[#1a1a1a] mb-6">
            {t('forgotPassword.heading')}
          </h1>
          <p className="text-xl text-[#4a5565] mb-8">
            {t('forgotPassword.subtitle')}
          </p>
          <div className="space-y-4">
            {[
              t('forgotPassword.features.linkValid'),
              t('forgotPassword.features.secureRecovery'),
              t('forgotPassword.features.accessRestored'),
            ].map((feature, index) => (
              <motion.div
                key={feature}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.2 + index * 0.1, duration: 0.5 }}
                className="flex items-center gap-3"
              >
                <div className="w-2 h-2 rounded-full bg-[#3A6EA5]"></div>
                <span className="text-[#4a5565]">{feature}</span>
              </motion.div>
            ))}
          </div>
        </motion.div>

        {/* Right Side - Reset Form */}
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6 }}
        >
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-[#3A6EA5]/20">
            {/* Back to Login Link */}
            <Link
              to="/login"
              className="inline-flex items-center gap-2 text-[#4a5565] hover:text-[#3A6EA5] transition-colors mb-6"
            >
              <ArrowLeft className={`w-4 h-4 ${i18n.language === 'ar' ? 'rotate-180' : ''}`} />
              <span>{t('forgotPassword.backToLogin')}</span>
            </Link>

            <div className="mb-8">
              <h2 className="text-3xl font-bold text-[#1a1a1a] mb-2">
                {t('forgotPassword.formTitle')}
              </h2>
              <p className="text-[#4a5565]">
                {t('forgotPassword.formSubtitle')}
              </p>
            </div>

            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Email Input */}
              <div>
                <Label htmlFor="email" className="text-[#1a1a1a] mb-2 block">
                  {t('forgotPassword.emailLabel')}
                </Label>
                <div className="relative">
                  <Mail className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]`} />
                  <Input
                    id="email"
                    type="email"
                    required
                    value={email}
                    onChange={(e) => {
                      setEmail(e.target.value)
                      setError('')
                    }}
                    className={`${i18n.language === 'ar' ? 'pr-12 pl-4' : 'pl-12 pr-4'} py-6 bg-[#F2F4F6] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${
                      error ? 'border-red-500 focus:border-red-500' : ''
                    }`}
                    placeholder={t('forgotPassword.emailPlaceholder')}
                    disabled={isLoading}
                  />
                </div>
                {error && <p className="text-sm text-red-500 mt-2">{error}</p>}
              </div>

              {/* Submit Button */}
              <Button
                type="submit"
                size="lg"
                disabled={!email || !isEmailValid || isLoading}
                className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6 shadow-lg shadow-[#3A6EA5]/30 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isLoading ? (
                  <div className="flex items-center gap-2">
                    <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    {t('forgotPassword.sending')}
                  </div>
                ) : (
                  t('forgotPassword.sendResetLink')
                )}
              </Button>
            </form>

            {/* Help Text */}
            <div className="mt-8 p-4 bg-[#F2F4F6] rounded-2xl border border-[#3A6EA5]/20">
              <p className="text-sm text-[#4a5565] text-center">
                {t('forgotPassword.rememberPassword')} {' '}
                <Link
                  to="/login"
                  className="text-[#3A6EA5] hover:underline font-semibold"
                >
                  {t('forgotPassword.signIn')}
                </Link>
              </p>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  )
}
