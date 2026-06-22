import axios, { AxiosRequestConfig } from 'axios'
import i18n from '@/i18n/config'
import { HttpError, TimeoutError } from './httpErrors'

// In dev with no VITE_API_BASE_URL set, use '' so requests go to localhost
// and are forwarded by the Vite proxy — this avoids CORS preflight issues.
const BASE_URL = (import.meta.env.VITE_API_BASE_URL as string | undefined) || (import.meta.env.PROD ? 'https://marn.runasp.net' : '')

export const axiosInstance = axios.create({
  baseURL: BASE_URL,
  timeout: 15_000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Attach auth token to every request
axiosInstance.interceptors.request.use((config) => {
  const isFormData =
    typeof FormData !== 'undefined' && config.data instanceof FormData

  if (isFormData) {
    delete (config.headers as Record<string, string>)['Content-Type']
  }

  config.headers['Accept-Language'] = i18n.language?.split('-')[0] || 'en'

  const token = localStorage.getItem('token') ?? sessionStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Normalize errors into HttpError / TimeoutError
axiosInstance.interceptors.response.use(
  (response) => response,
  (error: unknown) => {
    if (axios.isAxiosError(error)) {
      if (error.code === 'ECONNABORTED' || error.code === 'ERR_CANCELED') {
        throw new TimeoutError()
      }

      const status = error.response?.status ?? 0

      // Auto-logout on 401 Unauthorized
      if (status === 401) {
        localStorage.removeItem('token')
        sessionStorage.removeItem('token')
        localStorage.removeItem('user')
        sessionStorage.removeItem('user')
        window.dispatchEvent(new CustomEvent('auth-unauthorized'))
      }

      const body = error.response?.data as
        | {
            message?: string
            title?: string
            detail?: string
            errors?: unknown
            action?: unknown
          }
        | undefined

      // Prefer ASP.NET `detail`, fall back to `title`, then custom `message`, then axios message
      const serverMessage = body?.detail ?? body?.title ?? body?.message ?? error.message

      // `errors` is either a string[] (business logic) or Record<string,string[]> (field validation)
      const rawErrors = body?.errors
      const errors = Array.isArray(rawErrors)
        ? (rawErrors as string[])
        : undefined
      const validationErrors =
        rawErrors && !Array.isArray(rawErrors)
          ? (rawErrors as Record<string, string[]>)
          : undefined
      const rawAction = body?.action
      const action =
        typeof rawAction === 'string' || rawAction === null
          ? rawAction
          : undefined

      throw new HttpError(
        status,
        String(status),
        serverMessage,
        validationErrors,
        errors,
        action,
      )
    }

    throw error
  },
)

export const apiClient = {
  get: <T>(path: string, config?: AxiosRequestConfig) => 
    axiosInstance.get<T>(path, config).then((r) => r.data),

  post: <T>(path: string, body?: unknown, config?: AxiosRequestConfig) =>
    axiosInstance.post<T>(path, body, config).then((r) => r.data),

  put: <T>(path: string, body?: unknown, config?: AxiosRequestConfig) =>
    axiosInstance.put<T>(path, body, config).then((r) => r.data),

  patch: <T>(path: string, body?: unknown, config?: AxiosRequestConfig) =>
    axiosInstance.patch<T>(path, body, config).then((r) => r.data),

  delete: <T>(path: string, config?: AxiosRequestConfig) =>
    axiosInstance.delete<T>(path, config).then((r) => r.data),
}
