import { apiClient } from './apiClient'
import type { components } from '@/types/api.generated'

export type ContactSupportRequestDto = components['schemas']['ContactSupportRequestDto']

export const supportService = {
  contactUs: (payload: ContactSupportRequestDto) => apiClient.post('/api/Support/contact-us', payload),
}
