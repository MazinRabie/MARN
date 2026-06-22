import { GoogleLogin } from '@react-oauth/google'
import { useNavigate } from 'react-router'
import { toast } from 'sonner'
import { useGoogleAuth } from '@/hooks/useGoogleLogin'
import { decodeUserFromToken } from '@/utils/tokenUtils'
import type { UserRole } from '@/types/user'

function roleDestination(role: UserRole): string {
  if (role === 'admin') return '/admin-dashboard'
  if (role === 'owner') return '/owner-dashboard'
  return '/tenant-dashboard'
}

interface GoogleAuthButtonProps {
  /** Persist the session to localStorage instead of sessionStorage. */
  remember?: boolean
  /** Label shown inside Google's widget. */
  text?: 'signin_with' | 'signup_with' | 'continue_with'
}

export function GoogleAuthButton({
  remember = false,
  text = 'signin_with',
}: GoogleAuthButtonProps) {
  const navigate = useNavigate()
  const googleAuth = useGoogleAuth({ remember })

  return (
    <GoogleLogin
      text={text}
      width="100%"
      shape="rectangular"
      onSuccess={(credentialResponse) => {
        const idToken = credentialResponse.credential
        if (!idToken) {
          toast.error('Could not read Google credentials. Please try again.')
          return
        }

        googleAuth.mutate(idToken, {
          onSuccess: (result) => {
            if (result.requiresTwoFactor) {
              const { email } = decodeUserFromToken(result.tempToken)
              navigate('/2fa-verification', {
                state: {
                  email,
                  tempToken: result.tempToken,
                  remember,
                },
              })
            } else {
              navigate(roleDestination(result.user.role))
            }
          },
          onError: (err) => {
            const msg =
              err instanceof Error
                ? err.message
                : 'Google sign-in failed. Please try again.'
            toast.error(msg)
          },
        })
      }}
      onError={() => toast.error('Google sign-in was cancelled or failed.')}
    />
  )
}
