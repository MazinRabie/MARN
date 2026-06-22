import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { messageService } from '@/services/messageService'
import type { SendMessagePayload } from '@/services/messageService'

export function useConversations() {
  return useQuery({
    queryKey: ['conversations'],
    queryFn: () => messageService.getConversations(),
  })
}

export function useGlobalUsersSearch(search?: string) {
  return useQuery({
    queryKey: ['globalUsers', search],
    queryFn: () => messageService.searchUsers(search || ''),
    enabled: !!search && search.length >= 2,
  })
}

export function useMessages(conversationId: string | undefined) {
  return useQuery({
    queryKey: ['messages', conversationId],
    queryFn: () => messageService.getMessages(conversationId!),
    enabled: !!conversationId,
    staleTime: 0,
  })
}

export function useSendMessage() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (payload: SendMessagePayload) =>
      messageService.sendMessage(payload),
    onMutate: async (newMsg) => {
      await queryClient.cancelQueries({ queryKey: ['messages', newMsg.conversationId] })
      const previousMessages = queryClient.getQueryData(['messages', newMsg.conversationId])
      const tempId = 'temp_' + Date.now() + Math.random();
      
      queryClient.setQueryData(['messages', newMsg.conversationId], (old: any) => {
        const optimisticMessage = {
          id: tempId,
          conversationId: newMsg.conversationId!,
          senderId: 'me',
          sender: 'me',
          text: newMsg.text,
          time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
          status: 'sending'
        }
        
        if (!old) return { data: [optimisticMessage], total: 1, page: 1, pageSize: 50 }
        return { ...old, data: [...old.data, optimisticMessage], total: old.total + 1 }
      })

      return { previousMessages, tempId }
    },
    onError: (err, newMsg, context: any) => {
      if (context?.tempId) {
        queryClient.setQueryData(['messages', newMsg.conversationId], (old: any) => {
          if (!old) return old;
          return {
            ...old,
            data: old.data.map((m: any) => m.id === context.tempId ? { ...m, status: 'error' } : m)
          }
        })
      }
    },
    onSuccess: (_data, variables) => {
      queryClient.invalidateQueries({
        queryKey: ['messages', variables.conversationId],
      })
      queryClient.invalidateQueries({ queryKey: ['conversations'] })
    },
  })
}

import { userService } from '@/services/userService'

export function useSubmitReport() {
  return useMutation({
    mutationFn: (payload: { reportableType: string; reportableTargetId: string; reason: string }) =>
      userService.submitReport(payload),
  })
}
