import { useMutation } from '@tanstack/react-query'
import { authService } from '@/services/authService'
import { useAuth } from './useAuth'
import { decodeUserFromToken } from '@/utils/tokenUtils'
import type { TwoFactorPayload } from '@/services/authService'

interface UseVerify2faOptions {
  tempToken: string
  remember: boolean
}

export function useVerify2fa({ tempToken, remember }: UseVerify2faOptions) {
  const { login } = useAuth()

  return useMutation({
    mutationFn: async (payload: TwoFactorPayload) => {
      const response = await authService.verify2fa(payload, tempToken)
      const { token } = response.data
      const user = decodeUserFromToken(token)
      return { token, user }
    },
    onSuccess: ({ token, user }) => {
      login(token, user, remember)
    },
  })
}
