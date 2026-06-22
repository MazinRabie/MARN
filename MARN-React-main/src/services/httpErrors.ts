import type { ApiError } from '@/types/common'

/** Thrown by apiClient for any non-2xx HTTP response. */
export class HttpError extends Error {
  constructor(
    public readonly status: number,
    public readonly code: string,
    message: string,
    public readonly validationErrors?: Record<string, string[]>,
    public readonly errors?: string[],
    public readonly action?: string | null,
  ) {
    super(message)
    this.name = 'HttpError'
  }
}

/** Thrown by apiClient when a request exceeds the timeout. */
export class TimeoutError extends Error {
  constructor() {
    super('Request timed out')
    this.name = 'TimeoutError'
  }
}

/**
 * Converts any caught value into a normalized ApiError.
 * Use this in feature hooks and service functions to unify error handling.
 */
export function normalizeError(err: unknown): ApiError {
  if (err instanceof HttpError) {
    return {
      message: err.message,
      status: err.status,
      code: err.code,
      action: err.action,
      validationErrors: err.validationErrors,
      errors: err.errors,
    }
  }
  if (err instanceof TimeoutError) {
    return { message: err.message, status: 0, code: 'TIMEOUT' }
  }
  if (err instanceof Error) {
    return { message: err.message, status: 0 }
  }
  return { message: 'An unexpected error occurred', status: 0 }
}
