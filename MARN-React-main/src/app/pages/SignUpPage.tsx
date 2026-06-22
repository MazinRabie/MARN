import { useState } from 'react'
import { motion } from 'motion/react'
import { Mail, Lock, User, Eye, EyeOff, Calendar, Users } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Label } from '../components/ui/label'
import { Checkbox } from '../components/ui/checkbox'
import { Link, useNavigate } from 'react-router'
import { useRegister } from '@/hooks/useRegister'
import { GoogleAuthButton } from '../components/figma/GoogleAuthButton'
import { HttpError } from '@/services/httpErrors'
import { useTranslation } from 'react-i18next'

export function SignUpPage() {
  const { t, i18n } = useTranslation('auth')
  const navigate = useNavigate()
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const [successMessage, setSuccessMessage] = useState('')
  const [errorMessage, setErrorMessage] = useState('')
  const [fieldErrors, setFieldErrors] = useState<Record<string, string[]>>({})
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    confirmPassword: '',
    gender: '' as 'Male' | 'Female' | '',
    birthdate: '',
    agreeToTerms: false,
  })

  const fe = (key: string) => fieldErrors[key] ?? []

  const { mutate: register, isPending } = useRegister({
    onSuccess: (data) => {
      setSuccessMessage(data.message)
      setErrorMessage('')
      setFieldErrors({})
      setTimeout(() => navigate('/login'), 3000)
    },
    onError: (error) => {
      if (error instanceof HttpError) {
        const { general: generalErrors, ...fieldValidationErrors } =
          error.validationErrors ?? {}
        setFieldErrors(fieldValidationErrors)
        const flat = error.errors?.join(' ') ?? generalErrors?.join(' ')
        setErrorMessage(
          flat ??
            (Object.keys(fieldValidationErrors).length ? '' : error.message),
        )
      } else {
        setErrorMessage(t('signup.somethingWentWrong'))
      }
    },
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setErrorMessage('')
    setSuccessMessage('')
    setFieldErrors({})
    register({
      firstName: formData.firstName,
      lastName: formData.lastName,
      email: formData.email,
      dateOfBirth: formData.birthdate,
      password: formData.password,
      confirmPassword: formData.confirmPassword,
      gender: formData.gender || 'Unknown',
    })
  }

  return (
    <div className="min-h-screen bg-[#F2F4F6] flex items-center justify-center px-4 py-20">
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
            {t('signup.heading')}
          </h1>
          <p className="text-xl text-[#4a5565] mb-8">
            {t('signup.subtitle')}
          </p>
          <div className="space-y-4">
            {[
              t('signup.features.verifiedProperties'),
              t('signup.features.roommateMatching'),
              t('signup.features.securePayments'),
              t('signup.features.propertyTools'),
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

        {/* Right Side - Signup Form */}
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6 }}
        >
          <div className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-black/10">
            <div className="mb-8">
              <h2 className="text-3xl font-bold text-[#1a1a1a] mb-2">
                {t('signup.title')}
              </h2>
              <p className="text-[#4a5565]">
                {t('signup.alreadyHaveAccount')} {' '}
                <Link
                  to="/login"
                  className="text-[#3A6EA5] hover:underline font-semibold"
                >
                  {t('signup.signIn')}
                </Link>
              </p>
            </div>

            <form onSubmit={handleSubmit} className="space-y-6">
              {/* First Name */}
              <div>
                <Label
                  htmlFor="firstName"
                  className="text-[#1a1a1a] mb-2 block"
                >
                  {t('signup.firstNameLabel')}
                </Label>
                <div className="relative">
                  <User className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                  <Input
                    id="firstName"
                    type="text"
                    required
                    value={formData.firstName}
                    onChange={(e) =>
                      setFormData({ ...formData, firstName: e.target.value })
                    }
                    className={`${i18n.language === 'ar' ? 'pr-12 pl-4' : 'pl-12 pr-4'} py-6 bg-[#f5f7fa] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${fe('FirstName').length ? 'border-red-400 focus:border-red-400' : ''}`}
                    placeholder={t('signup.firstNamePlaceholder')}
                  />
                </div>
                {fe('FirstName').map((msg) => (
                  <p key={msg} className="text-xs text-red-500 mt-1">
                    {msg}
                  </p>
                ))}
              </div>

              {/* Last Name */}
              <div>
                <Label htmlFor="lastName" className="text-[#1a1a1a] mb-2 block">
                  {t('signup.lastNameLabel')}
                </Label>
                <div className="relative">
                  <User className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                  <Input
                    id="lastName"
                    type="text"
                    required
                    value={formData.lastName}
                    onChange={(e) =>
                      setFormData({ ...formData, lastName: e.target.value })
                    }
                    className={`${i18n.language === 'ar' ? 'pr-12 pl-4' : 'pl-12 pr-4'} py-6 bg-[#f5f7fa] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${fe('LastName').length ? 'border-red-400 focus:border-red-400' : ''}`}
                    placeholder={t('signup.lastNamePlaceholder')}
                  />
                </div>
                {fe('LastName').map((msg) => (
                  <p key={msg} className="text-xs text-red-500 mt-1">
                    {msg}
                  </p>
                ))}
              </div>

              {/* Email */}
              <div>
                <Label htmlFor="email" className="text-[#1a1a1a] mb-2 block">
                  {t('signup.emailLabel')}
                </Label>
                <div className="relative">
                  <Mail className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                  <Input
                    id="email"
                    type="email"
                    required
                    value={formData.email}
                    onChange={(e) =>
                      setFormData({ ...formData, email: e.target.value })
                    }
                    className={`${i18n.language === 'ar' ? 'pr-12 pl-4' : 'pl-12 pr-4'} py-6 bg-[#f5f7fa] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${fe('Email').length ? 'border-red-400 focus:border-red-400' : ''}`}
                    placeholder={t('signup.emailPlaceholder')}
                  />
                </div>
                {fe('Email').map((msg) => (
                  <p key={msg} className="text-xs text-red-500 mt-1">
                    {msg}
                  </p>
                ))}
              </div>

              {/* Password */}
              <div>
                <Label htmlFor="password" className="text-[#1a1a1a] mb-2 block">
                  {t('signup.passwordLabel')}
                </Label>
                <div className="relative">
                  <Lock className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                  <Input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    required
                    value={formData.password}
                    onChange={(e) =>
                      setFormData({ ...formData, password: e.target.value })
                    }
                    className={`${i18n.language === 'ar' ? 'pr-12 pl-12' : 'pl-12 pr-12'} py-6 bg-[#f5f7fa] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${fe('Password').length ? 'border-red-400 focus:border-red-400' : ''}`}
                    placeholder={t('signup.passwordPlaceholder')}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className={`absolute ${i18n.language === 'ar' ? 'left-4' : 'right-4'} top-1/2 -translate-y-1/2 text-[#6a7282] hover:text-[#3A6EA5]`}
                  >
                    {showPassword ? (
                      <EyeOff className="w-5 h-5" />
                    ) : (
                      <Eye className="w-5 h-5" />
                    )}
                  </button>
                </div>
                {fe('Password').length ? (
                  fe('Password').map((msg) => (
                    <p key={msg} className="text-xs text-red-500 mt-1">
                      {msg}
                    </p>
                  ))
                ) : (
                  <p className="text-xs text-[#6a7282] mt-2">
                    {t('signup.passwordHint')}
                  </p>
                )}
              </div>

              {/* Confirm Password */}
              <div>
                <Label
                  htmlFor="confirmPassword"
                  className="text-[#1a1a1a] mb-2 block"
                >
                  {t('signup.confirmPasswordLabel')}
                </Label>
                <div className="relative">
                  <Lock className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                  <Input
                    id="confirmPassword"
                    type={showConfirmPassword ? 'text' : 'password'}
                    required
                    value={formData.confirmPassword}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        confirmPassword: e.target.value,
                      })
                    }
                    className={`${i18n.language === 'ar' ? 'pr-12 pl-12' : 'pl-12 pr-12'} py-6 bg-[#f5f7fa] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${fe('ConfirmPassword').length ? 'border-red-400 focus:border-red-400' : ''}`}
                    placeholder={t('signup.confirmPasswordPlaceholder')}
                  />
                  <button
                    type="button"
                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                    className={`absolute ${i18n.language === 'ar' ? 'left-4' : 'right-4'} top-1/2 -translate-y-1/2 text-[#6a7282] hover:text-[#3A6EA5]`}
                  >
                    {showConfirmPassword ? (
                      <EyeOff className="w-5 h-5" />
                    ) : (
                      <Eye className="w-5 h-5" />
                    )}
                  </button>
                </div>
                {fe('ConfirmPassword').length ? (
                  fe('ConfirmPassword').map((msg) => (
                    <p key={msg} className="text-xs text-red-500 mt-1">
                      {msg}
                    </p>
                  ))
                ) : (
                  <p className="text-xs text-[#6a7282] mt-2">
                    {t('signup.confirmPasswordHint')}
                  </p>
                )}
              </div>

              {/* Gender */}
              <div>
                <Label className="text-[#1a1a1a] mb-3 block">{t('signup.genderLabel')}</Label>
                <div className="grid grid-cols-2 gap-4">
                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, gender: 'Male' })}
                    className={`p-6 rounded-2xl border-2 transition-all ${
                      formData.gender === 'Male'
                        ? 'bg-[#3A6EA5] border-[#3A6EA5] text-white shadow-lg shadow-[#3A6EA5]/30'
                        : fe('Gender').length
                          ? 'bg-[#f5f7fa] border-red-300 text-[#1a1a1a] hover:border-red-400'
                          : 'bg-[#f5f7fa] border-[#3A6EA5]/20 text-[#1a1a1a] hover:border-[#3A6EA5]/40'
                    }`}
                  >
                    <div className="flex flex-col items-center gap-2">
                      <Users className="w-6 h-6" />
                      <span className="font-semibold">{t('signup.male')}</span>
                    </div>
                  </button>
                  <button
                    type="button"
                    onClick={() =>
                      setFormData({ ...formData, gender: 'Female' })
                    }
                    className={`p-6 rounded-2xl border-2 transition-all ${
                      formData.gender === 'Female'
                        ? 'bg-[#3A6EA5] border-[#3A6EA5] text-white shadow-lg shadow-[#3A6EA5]/30'
                        : fe('Gender').length
                          ? 'bg-[#f5f7fa] border-red-300 text-[#1a1a1a] hover:border-red-400'
                          : 'bg-[#f5f7fa] border-[#3A6EA5]/20 text-[#1a1a1a] hover:border-[#3A6EA5]/40'
                    }`}
                  >
                    <div className="flex flex-col items-center gap-2">
                      <Users className="w-6 h-6" />
                      <span className="font-semibold">{t('signup.female')}</span>
                    </div>
                  </button>
                </div>
                {fe('Gender').map((msg) => (
                  <p key={msg} className="text-xs text-red-500 mt-2">
                    {msg}
                  </p>
                ))}
              </div>

              {/* Birthdate */}
              <div>
                <Label
                  htmlFor="birthdate"
                  className="text-[#1a1a1a] mb-2 block"
                >
                  {t('signup.birthdateLabel')}
                </Label>
                <div className="relative">
                  <Calendar className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]" />
                  <Input
                    id="birthdate"
                    type="date"
                    required
                    value={formData.birthdate}
                    onChange={(e) =>
                      setFormData({ ...formData, birthdate: e.target.value })
                    }
                    className={`pl-12 pr-4 py-6 bg-[#f5f7fa] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${fe('DateOfBirth').length ? 'border-red-400 focus:border-red-400' : ''}`}
                  />
                </div>
                {fe('DateOfBirth').map((msg) => (
                  <p key={msg} className="text-xs text-red-500 mt-1">
                    {msg}
                  </p>
                ))}
              </div>

              {/* Terms Checkbox */}
              <div className="flex items-start gap-2">
                <Checkbox
                  id="terms"
                  required
                  checked={formData.agreeToTerms}
                  onCheckedChange={(checked) =>
                    setFormData({
                      ...formData,
                      agreeToTerms: checked as boolean,
                    })
                  }
                  className="border-[#3A6EA5] data-[state=checked]:bg-[#3A6EA5] mt-1"
                />
                <label
                  htmlFor="terms"
                  className="text-sm text-[#4a5565] cursor-pointer"
                >
                  {t('signup.termsAgree')} {' '}
                  <Link to="/terms" className="text-[#3A6EA5] hover:underline">
                    {t('signup.termsOfService')}
                  </Link>{' '}
                  {t('signup.and')} {' '}
                  <Link
                    to="/privacy"
                    className="text-[#3A6EA5] hover:underline"
                  >
                    {t('signup.privacyPolicy')}
                  </Link>
                </label>
              </div>

              {errorMessage && (
                <p className="text-sm text-red-600 bg-red-50 border border-red-200 rounded-xl px-4 py-3">
                  {errorMessage}
                </p>
              )}

              {successMessage && (
                <p className="text-sm text-green-700 bg-green-50 border border-green-200 rounded-xl px-4 py-3">
                  {successMessage}
                </p>
              )}

              {/* Submit Button */}
              <Button
                type="submit"
                size="lg"
                disabled={isPending}
                className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl py-6 shadow-lg shadow-[#3A6EA5]/30 disabled:opacity-60"
              >
                {isPending ? t('signup.creatingAccount') : t('signup.createAccount')}
              </Button>
            </form>

            {/* Divider */}
            <div className="relative my-8">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-[#3A6EA5]/20"></div>
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-4 bg-white text-[#6a7282]">
                  {t('signup.orSignUpWith')}
                </span>
              </div>
            </div>

            {/* Social Signup */}
            <div className="flex justify-center">
              <GoogleAuthButton text="signup_with" />
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  )
}
