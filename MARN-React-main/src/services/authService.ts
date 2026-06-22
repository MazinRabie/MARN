import { apiClient, axiosInstance } from './apiClient'
import type { ApiResponse } from '@/types/common'

export interface LoginPayload {
  email: string
  password: string
}

export interface LoginResult {
  token: string
  expiration: string
  requiresTwoFactor: boolean
  twoFactorProvider: string | null
  isExternalLogin: boolean
  externalProvider: string | null
}

export interface GoogleLoginPayload {
  idToken: string
  rememberMe: boolean
}

export interface TwoFactorPayload {
  email: string
  code: string
  rememberMe: boolean
}

export interface RegisterPayload {
  firstName: string
  lastName: string
  email: string
  dateOfBirth: string
  password: string
  confirmPassword: string
  gender: 'Unknown' | 'Male' | 'Female'
}

export interface RegisterResult {
  message: string
  data: boolean
}

export interface ForgotPasswordPayload {
  email: string
}

export interface ResetPasswordPayload {
  email: string
  token: string
  newPassword: string
  confirmPassword: string
}

export interface ResetPasswordResult {
  message: string
  data: boolean
}

export interface VerifyOtpPayload {
  email: string
  otp: string
}

export const authService = {
  login: (payload: LoginPayload) =>
    apiClient.post<ApiResponse<LoginResult>>('/api/Account/login', payload),

  register: (payload: RegisterPayload) =>
    apiClient.post<RegisterResult>('/api/Account/register', payload),

  googleLogin: (payload: GoogleLoginPayload) =>
    apiClient.post<ApiResponse<LoginResult>>(
      '/api/Account/external/google',
      payload,
    ),

  forgotPassword: (payload: ForgotPasswordPayload) =>
    apiClient.post<ApiResponse<{ message: string }>>(
      '/api/Account/forgot-password',
      payload,
    ),

  resetPassword: (payload: ResetPasswordPayload) =>
    apiClient.put<ResetPasswordResult>('/api/Account/reset-password', payload),

  verifyOtp: (payload: VerifyOtpPayload) =>
    apiClient.post<ApiResponse<{ message: string }>>(
      '/Auth/verify-otp',
      payload,
    ),

  confirmEmail: (userId: string, token: string) =>
    apiClient.get<{ message: string; data: boolean }>(
      `/api/Account/confirm-email?userId=${encodeURIComponent(userId)}&token=${encodeURIComponent(token)}`,
    ),

  /** Verify a 2FA OTP code. Requires the temporary token from the login response. */
  verify2fa: (payload: TwoFactorPayload, tempToken: string) =>
    axiosInstance
      .post<ApiResponse<LoginResult>>('/api/Account/verify-2fa', payload, {
        headers: { Authorization: `Bearer ${tempToken}` },
      })
      .then((r) => r.data),
}
