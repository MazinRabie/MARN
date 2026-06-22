import { useMutation } from '@tanstack/react-query'
import { authService } from '@/services/authService'
import { useAuth } from './useAuth'
import type { LoginPayload } from '@/services/authService'
import { decodeUserFromToken } from '@/utils/tokenUtils'
import type { User } from '@/types/user'

interface UseLoginOptions {
  remember?: boolean
  onSuccess?: () => void
}

/** Discriminated union returned from the login mutation */
export type LoginMutationResult =
  | {
      requiresTwoFactor: true
      /** Temporary JWT used to authorize the verify-2fa call */
      tempToken: string
      twoFactorProvider: string
    }
  | {
      requiresTwoFactor: false
      token: string
      user: User
    }

export function useLogin({
  remember = false,
  onSuccess,
}: UseLoginOptions = {}) {
  const { login } = useAuth()

  return useMutation({
    mutationFn: async (payload: LoginPayload): Promise<LoginMutationResult> => {
      const response = await authService.login(payload)
      const { token, requiresTwoFactor, twoFactorProvider } = response.data

      if (requiresTwoFactor) {
        return {
          requiresTwoFactor: true,
          tempToken: token,
          twoFactorProvider: twoFactorProvider ?? 'Email',
        }
      }

      const user = decodeUserFromToken(token)
      return { requiresTwoFactor: false, token, user }
    },
    onSuccess: (result) => {
      // Only persist the session immediately when 2FA is NOT required.
      // The 2FA branch is handled by the page (navigate to verify page).
      if (!result.requiresTwoFactor) {
        login(result.token, result.user, remember)
        onSuccess?.()
      }
    },
  })
}
