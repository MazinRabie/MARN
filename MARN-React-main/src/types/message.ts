export type MessageSender = 'me' | 'them'

export interface Message {
  id: string
  conversationId: string
  senderId: string
  sender: MessageSender
  text: string
  time: string
  attachmentUrl?: string
  read?: boolean
  status?: 'sending' | 'sent' | 'error'
}

export interface ConversationParticipant {
  id: string
  name: string
  avatarUrl?: string
  role?: string
}

export interface Conversation {
  id: string
  participant: ConversationParticipant
  isOnline?: boolean
  property?: {
    id?: string
    name: string
    image?: string
  }
  lastMessage: string
  lastMessageTime: string
  unreadCount: number
}
