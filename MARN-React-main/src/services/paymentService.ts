import { apiClient } from './apiClient'
import type { ApiResponse } from '@/types/common'

export interface StartPaymentPayload {
  paymentScheduleId: number
}

export interface PaymentResponse {
  url?: string
  clientSecret?: string
  success?: boolean
  message?: string
}

export const paymentService = {
  /**
   * Create a Stripe Payment Intent for a specific payment schedule.
   */
  startPayment: (payload: StartPaymentPayload) =>
    apiClient.post<ApiResponse<PaymentResponse>>(`/api/Payment/start-payment?paymentScheduleId=${payload.paymentScheduleId}`, {}),

  /**
   * Creates a Stripe Connect Express account for the owner (if not already created)
   * and returns an onboarding link.
   */
  connectAccount: () =>
    apiClient.post<ApiResponse<string>>('/api/Payment/connect-account'),

  /**
   * Withdraws all available (non-held) funds to the owner's connected Stripe account.
   */
  withdraw: () =>
    apiClient.post<ApiResponse<any>>('/api/Payment/withdraw'),

  /**
   * [TEST ONLY] Checks the Stripe balance of the platform account and the owner's connected account.
   */
  checkBalance: () =>
    apiClient.get<ApiResponse<any>>('/api/Payment/check-balance'),

  /**
   * [TEST ONLY] Toops up the Stripe platform balance with 100000 USD (Available balance).
   */
  topupTestBalance: () =>
    apiClient.post<ApiResponse<any>>('/api/Payment/topup-test-balance'),
}
