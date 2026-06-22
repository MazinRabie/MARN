import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { assistantService } from '@/services/assistantService'
import { toast } from 'sonner'
import { useTranslation } from 'react-i18next'

export function useGetSessions() {
  return useQuery({
    queryKey: ['assistant-sessions'],
    queryFn: () => assistantService.getSessions(),
  })
}

export function useGetSessionMessages(sessionId: string | null) {
  return useQuery({
    queryKey: ['assistant-messages', sessionId],
    queryFn: () => assistantService.getSessionMessages(sessionId!),
    enabled: !!sessionId,
  })
}

export function useSendMessage() {
  const queryClient = useQueryClient()
  const { t } = useTranslation('messages')
  return useMutation({
    mutationFn: assistantService.sendMessage,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['assistant-sessions'] })
    },
    onError: () => toast.error(t('chatbot.errorSend')),
  })
}

export function useRenameSession() {
  const queryClient = useQueryClient()
  const { t } = useTranslation('messages')
  return useMutation({
    mutationFn: ({ sessionId, name }: { sessionId: string; name: string }) =>
      assistantService.renameSession(sessionId, { sessionName: name }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['assistant-sessions'] })
    },
    onError: () => toast.error(t('chatbot.errorRename')),
  })
}
