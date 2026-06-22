import { apiClient } from './apiClient'
import type { ApiResponse } from '@/types/common'
import type { components } from '@/types/api.generated'

export interface AssistantSession {
  sessionId: string
  sessionName?: string | null
  createdAt?: string
}

export interface AssistantMessage {
  role: 'user' | 'assistant'
  content: string
  createdAt?: string
}

export interface SendMessageResult {
  sessionId: string
}

type SendMessagePayload = components['schemas']['SendAssistantMessageRequestDto']
type RenameSessionPayload = components['schemas']['RenameAssistantSessionRequestDto']

export const assistantService = {
  getSessions: () =>
    apiClient.get<ApiResponse<AssistantSession[]>>('/api/Assistant/sessions'),

  sendMessage: (payload: SendMessagePayload) =>
    apiClient.post<ApiResponse<SendMessageResult>>('/api/Assistant/messages', payload),

  getSessionMessages: (sessionId: string) =>
    apiClient.get<ApiResponse<AssistantMessage[]>>(
      `/api/Assistant/sessions/${sessionId}/messages`,
    ),

  renameSession: (sessionId: string, payload: RenameSessionPayload) =>
    apiClient.patch(`/api/Assistant/sessions/${sessionId}/name`, payload),
}
