import { motion } from 'motion/react'
import { CheckCircle, XCircle, Loader2 } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Link, useNavigate, useSearchParams } from 'react-router'
import { useEffect, useState } from 'react'
import { authService } from '@/services/authService'
import { HttpError } from '@/services/httpErrors'
import { useTranslation } from 'react-i18next'

type Status = 'loading' | 'success' | 'error'

export function ConfirmEmailPage() {
  const { t } = useTranslation('auth')
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()

  const userId = searchParams.get('userId') ?? ''
  const tokenParam = searchParams.get('token') ?? ''

  const [status, setStatus] = useState<Status>(
    !userId || !tokenParam ? 'error' : 'loading',
  )
  const [message, setMessage] = useState(
    !userId || !tokenParam
      ? t('confirmEmail.invalidLink')
      : '',
  )

  useEffect(() => {
    if (!userId || !tokenParam) return

    authService
      .confirmEmail(userId, tokenParam)
      .then((data) => {
        setMessage(data.message)
        setStatus('success')
        setTimeout(() => navigate('/login'), 4000)
      })
      .catch((err: unknown) => {
        setStatus('error')
        if (err instanceof HttpError) {
          setMessage(err.message)
        } else {
          setMessage(t('confirmEmail.somethingWentWrong'))
        }
      })
  }, []) // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="min-h-screen bg-[#F2F4F6] flex items-center justify-center px-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="bg-white rounded-3xl p-10 md:p-14 shadow-2xl shadow-black/10 w-full max-w-md text-center"
      >
        {status === 'loading' && (
          <>
            <div className="flex justify-center mb-6">
              <Loader2 className="w-16 h-16 text-[#3A6EA5] animate-spin" />
            </div>
            <h2 className="text-2xl font-bold text-[#1a1a1a] mb-2">
              {t('confirmEmail.verifying')}
            </h2>
            <p className="text-[#4a5565]">{t('confirmEmail.pleaseWait')}</p>
          </>
        )}

        {status === 'success' && (
          <>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 200, damping: 15 }}
              className="flex justify-center mb-6"
            >
              <CheckCircle className="w-16 h-16 text-green-500" />
            </motion.div>
            <h2 className="text-2xl font-bold text-[#1a1a1a] mb-2">
              {t('confirmEmail.confirmed')}
            </h2>
            <p className="text-[#4a5565] mb-6">
              {message || t('confirmEmail.verifiedSuccessfully')}
            </p>
            <p className="text-sm text-[#6a7282] mb-6">
              {t('confirmEmail.redirecting')}
            </p>
            <Button
              onClick={() => navigate('/login')}
              className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6"
            >
              {t('confirmEmail.goToLogin')}
            </Button>
          </>
        )}

        {status === 'error' && (
          <>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 200, damping: 15 }}
              className="flex justify-center mb-6"
            >
              <XCircle className="w-16 h-16 text-red-500" />
            </motion.div>
            <h2 className="text-2xl font-bold text-[#1a1a1a] mb-2">
              {t('confirmEmail.failed')}
            </h2>
            <p className="text-[#4a5565] mb-8">{message}</p>
            <div className="flex flex-col gap-3">
              <Button
                onClick={() => navigate('/login')}
                className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6"
              >
                {t('confirmEmail.goToLogin')}
              </Button>
              <Link
                to="/signup"
                className="text-sm text-[#3A6EA5] hover:underline"
              >
                {t('confirmEmail.backToSignUp')}
              </Link>
            </div>
          </>
        )}
      </motion.div>
    </div>
  )
}
