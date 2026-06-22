import { motion } from 'motion/react'
import { ShieldCheck, ArrowLeft } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Link, useNavigate, useLocation } from 'react-router'
import { useState, useRef, useEffect } from 'react'
import { useVerify2fa } from '@/hooks/useVerify2fa'
import { toast } from 'sonner'
import type { UserRole } from '@/types/user'
import { useTranslation } from 'react-i18next'

interface TwoFactorLocationState {
  email: string
  /** Temporary JWT returned by the login endpoint when 2FA is required */
  tempToken: string
  remember: boolean
}

function roleDestination(role: UserRole): string {
  if (role === 'admin') return '/admin-dashboard'
  if (role === 'owner') return '/owner-dashboard'
  return '/tenant-dashboard'
}

export function TwoFactorPage() {
  const { t, i18n } = useTranslation('auth')
  const navigate = useNavigate()
  const location = useLocation()
  const state = location.state as TwoFactorLocationState | null

  // Guard: if accessed directly without the login flow, send back to login
  useEffect(() => {
    if (!state?.email) {
      navigate('/login', { replace: true })
    }
  }, [state, navigate])

  const [otp, setOtp] = useState(['', '', '', '', '', ''])
  const inputRefs = useRef<(HTMLInputElement | null)[]>([])

  const verify = useVerify2fa({
    tempToken: state?.tempToken ?? '',
    remember: state?.remember ?? false,
  })

  const handleChange = (index: number, value: string) => {
    if (value.length > 1) return
    if (!/^\d*$/.test(value)) return

    const newOtp = [...otp]
    newOtp[index] = value
    setOtp(newOtp)

    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus()
    }
  }

  const handleKeyDown = (index: number, e: React.KeyboardEvent) => {
    if (e.key === 'Backspace' && !otp[index] && index > 0) {
      inputRefs.current[index - 1]?.focus()
    }
  }

  const handlePaste = (e: React.ClipboardEvent) => {
    e.preventDefault()
    const pastedData = e.clipboardData
      .getData('text')
      .replace(/\D/g, '')
      .slice(0, 6)
    if (!pastedData) return

    const newOtp = [...otp]
    pastedData.split('').forEach((digit, i) => {
      if (i < 6) newOtp[i] = digit
    })
    setOtp(newOtp)

    const lastIndex = Math.min(pastedData.length, 5)
    inputRefs.current[lastIndex]?.focus()
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    const code = otp.join('')
    if (code.length !== 6 || !state) return

    verify.mutate(
      { email: state.email, code, rememberMe: state.remember },
      {
        onSuccess: ({ user }) => {
          toast.success(t('twoFactor.verified'))
          navigate(roleDestination(user.role))
        },
        onError: (err) => {
          const msg =
            err instanceof Error
              ? err.message
              : t('twoFactor.invalidCode')
          toast.error(msg)
          // Clear OTP inputs on error so the user can re-enter
          setOtp(['', '', '', '', '', ''])
          inputRefs.current[0]?.focus()
        },
      },
    )
  }

  if (!state?.email) return null

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC] to-[#3A6EA5] flex items-center justify-center px-4 py-20">
      <div className="w-full max-w-lg">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-[#3A6EA5]/20">
            {/* Back Button */}
            <Link
              to="/login"
              className="inline-flex items-center gap-2 text-[#4a5565] hover:text-[#3A6EA5] mb-6 transition-colors"
            >
              <ArrowLeft className={`w-4 h-4 ${i18n.language === 'ar' ? 'rotate-180' : ''}`} />
              {t('twoFactor.backToLogin')}
            </Link>

            {/* Icon & Title */}
            <div className="flex flex-col items-center mb-8">
              <div className="w-20 h-20 rounded-3xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center shadow-lg mb-6">
                <ShieldCheck className="w-10 h-10 text-white" />
              </div>
              <h2 className="text-3xl font-bold text-[#1a1a1a] mb-2 text-center">
                {t('twoFactor.title')}
              </h2>
              <p className="text-[#4a5565] text-center">
                {t('twoFactor.subtitle')}
              </p>
              <p className="text-sm text-[#3A6EA5] font-semibold mt-1">
                {state.email}
              </p>
            </div>

            {/* OTP Form */}
            <form onSubmit={handleSubmit} className="space-y-8">
              <div>
                <label className="text-[#1a1a1a] text-sm font-medium mb-3 block text-center">
                  {t('twoFactor.enterCode')}
                </label>
                <div
                  className="flex gap-2 justify-center"
                  onPaste={handlePaste}
                >
                  {otp.map((digit, index) => (
                    <Input
                      key={index}
                      ref={(el) => (inputRefs.current[index] = el)}
                      type="text"
                      inputMode="numeric"
                      maxLength={1}
                      value={digit}
                      onChange={(e) => handleChange(index, e.target.value)}
                      onKeyDown={(e) => handleKeyDown(index, e)}
                      className="w-12 h-14 text-center text-2xl font-bold bg-[#F2F4F6] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5]"
                    />
                  ))}
                </div>
              </div>

              <Button
                type="submit"
                size="lg"
                disabled={otp.join('').length !== 6 || verify.isPending}
                className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6 shadow-lg shadow-[#3A6EA5]/30 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {verify.isPending ? t('twoFactor.verifying') : t('twoFactor.verifyAndSignIn')}
              </Button>
            </form>

            {/* Help text */}
            <div className="mt-8 text-center">
              <p className="text-sm text-[#4a5565]">
                {t('twoFactor.didntReceive')} {' '}
                <Link
                  to="/contact"
                  className="text-[#3A6EA5] hover:underline font-semibold"
                >
                  {t('twoFactor.contactSupport')}
                </Link>
              </p>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  )
}
