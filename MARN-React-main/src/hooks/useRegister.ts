import { useMutation } from '@tanstack/react-query'
import { authService } from '@/services/authService'
import type { RegisterPayload, RegisterResult } from '@/services/authService'

export function useRegister(options?: {
  onSuccess?: (data: RegisterResult) => void
  onError?: (error: Error) => void
}) {
  return useMutation({
    mutationFn: (payload: RegisterPayload) => authService.register(payload),
    onSuccess: options?.onSuccess,
    onError: options?.onError,
  })
}
