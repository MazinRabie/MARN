import { apiClient } from './apiClient'
import type { ApiResponse, PaginatedResponse } from '@/types/common'
import type { Conversation, Message } from '@/types/message'
import { HubConnectionBuilder, HubConnection, LogLevel } from '@microsoft/signalr'

export interface SendMessagePayload {
  conversationId?: string
  recipientId?: string
  propertyId?: string
  propertyName?: string
  ownerName?: string
  text: string
  attachmentUrl?: string
}

let chatConnection: HubConnection | null = null

export const startChatConnection = async () => {
  if (chatConnection?.state === 'Connected') return chatConnection

  const BASE_URL = (import.meta.env.VITE_API_BASE_URL as string | undefined) || (import.meta.env.PROD ? 'https://marn.runasp.net' : '')
  const hubUrl = BASE_URL ? `${BASE_URL}/hubs/chat` : '/hubs/chat'
  
  const token = localStorage.getItem('token') ?? sessionStorage.getItem('token') ?? ''

  chatConnection = new HubConnectionBuilder()
    .withUrl(hubUrl, { accessTokenFactory: () => token })
    .withAutomaticReconnect()
    .configureLogging(LogLevel.Information)
    .build()

  chatConnection.on("UserOnline", (userId) => {
    window.dispatchEvent(new CustomEvent('chat-user-online', { detail: userId }))
  })
  
  chatConnection.on("UserOffline", (userId) => {
    window.dispatchEvent(new CustomEvent('chat-user-offline', { detail: userId }))
  })
  
  chatConnection.on("ReceiveMessage", (message) => {
    window.dispatchEvent(new CustomEvent('chat-message-received', { detail: message }))
  })
  
  chatConnection.on("SendMessage", (message) => {
    window.dispatchEvent(new CustomEvent('chat-message-received', { detail: message }))
  })

  try {
    await chatConnection.start()
  } catch (err) {
    console.error("SignalR connection error: ", err)
  }
  return chatConnection
}

export const stopChatConnection = async () => {
  await chatConnection?.stop()
  chatConnection = null
}

export const messageService = {
  getConversations: async (): Promise<PaginatedResponse<Conversation>> => {
    const response = await apiClient.get<ApiResponse<any[]>>('/api/Chat/users')
    const users = response.data || []
    
    const mapped: Conversation[] = users.map(u => ({
      id: u.id,
      participant: {
        id: u.id,
        name: u.userName || 'User',
        avatarUrl: u.profileImage
      },
      isOnline: u.isOnline ?? false,
      lastMessage: u.lastMessage?.content || '',
      lastMessageTime: u.lastMessage?.timestamp
        ? new Date(u.lastMessage.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        : '',
      unreadCount: u.unreadCount || 0
    }))
    
    return { data: mapped, total: mapped.length, page: 1, pageSize: 50 }
  },

  searchUsers: async (search: string): Promise<PaginatedResponse<Conversation>> => {
    const params = new URLSearchParams()
    if (search) {
      params.append('q', search)
    }
    const response = await apiClient.get<ApiResponse<any[]>>(`/api/Chat/search?${params.toString()}`)
    const users = response.data || []
    
    const mapped: Conversation[] = users.map(u => ({
      id: u.id,
      participant: {
        id: u.id,
        name: u.userName || 'User',
        avatarUrl: u.profileImage
      },
      isOnline: u.isOnline ?? false,
      lastMessage: '',
      lastMessageTime: '',
      unreadCount: 0
    }))
    
    return { data: mapped, total: mapped.length, page: 1, pageSize: 50 }
  },

  getMessages: async (conversationId: string): Promise<PaginatedResponse<Message>> => {
    const response = await apiClient.get<ApiResponse<any[]>>(`/api/Chat/history/${conversationId}`)
    const messages = response.data || []

    const userRaw = localStorage.getItem('user') ?? sessionStorage.getItem('user') ?? '{}'
    const currentUserId = (JSON.parse(userRaw) as { id?: string })?.id

    const mapped: Message[] = messages.map(m => ({
      id: m.id,
      conversationId: conversationId,
      senderId: m.senderId,
      sender: m.senderId === currentUserId ? 'me' : 'them',
      text: m.content || m.text || m.message || '',
      time: m.sentAt ? new Date(m.sentAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '',
      read: m.isRead
    }))
    
    return { data: mapped, total: mapped.length, page: 1, pageSize: 50 }
  },

  sendMessage: async (payload: SendMessagePayload): Promise<ApiResponse<Message>> => {
    const connection = await startChatConnection()
    const receiverId = payload.recipientId || payload.conversationId

    if (!receiverId) {
      throw new Error("No recipient specified for the message")
    }

    if (connection.state !== 'Connected') return Promise.reject(new Error('Chat not connected'))
    await connection.invoke("SendMessage", receiverId, payload.text)

    const newMessage: Message = {
      id: 'msg_' + Date.now(),
      conversationId: receiverId,
      senderId: 'me',
      sender: 'me',
      text: payload.text,
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      read: true
    }
    
    return { data: newMessage, message: 'Sent', success: true }
  },

  markAsRead: async (userId: string) => {
    const connection = await startChatConnection()
    if (connection.state !== 'Connected') return
    await connection.invoke("MarkChatAsRead", userId)
  },

  setChatActive: async (userId: string) => {
    const connection = await startChatConnection()
    if (connection.state !== 'Connected') return
    await connection.invoke("InActiveChatWith", userId)
  },

  setChatInactive: async (userId: string) => {
    const connection = await startChatConnection()
    if (connection.state !== 'Connected') return
    await connection.invoke("LeaveActiveChat", userId)
  }
}
