import { motion } from 'motion/react'
import { ArrowLeft, Send, Bot, User, PanelLeft, Plus, Pencil, Lock } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Link } from 'react-router'
import { useState, useRef, useEffect } from 'react'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { useQueryClient } from '@tanstack/react-query'
import {
  useGetSessionMessages,
  useSendMessage,
  useGetSessions,
  useRenameSession,
} from '@/hooks/useAssistant'
import type { AssistantMessage, AssistantSession } from '@/services/assistantService'
import { useAuth } from '@/hooks/useAuth'
import { getImageUrl } from '@/constants/assets'

export function ChatbotPage() {
  const { t } = useTranslation('messages')
  const { token, user } = useAuth()

  const [currentSessionId, setCurrentSessionId] = useState<string | null>(null)
  const [inputText, setInputText] = useState('')
  const [isTyping, setIsTyping] = useState(false)
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [editingSessionId, setEditingSessionId] = useState<string | null>(null)
  const [renameValue, setRenameValue] = useState('')
  const [optimisticMessages, setOptimisticMessages] = useState<AssistantMessage[]>([])
  const messagesEndRef = useRef<HTMLDivElement>(null)
  const queryClient = useQueryClient()

  const { data: messagesData } = useGetSessionMessages(currentSessionId)
  const { data: sessionsData } = useGetSessions()
  const sendMessage = useSendMessage()
  const renameSession = useRenameSession()

  const serverMessages: AssistantMessage[] = messagesData?.data ?? []
  const sessions: AssistantSession[] = sessionsData?.data ?? []

  const messages = optimisticMessages.length > 0 ? optimisticMessages : serverMessages

  useEffect(() => {
    if (serverMessages.length > 0) {
      setOptimisticMessages([])
    }
  }, [serverMessages])

  const scrollToBottom = () => {
    if (messagesEndRef.current) {
      const container = messagesEndRef.current.closest('.overflow-y-auto')
      if (container) {
        container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' })
      }
    }
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages, isTyping])

  const handleSend = async (textOverride?: string) => {
    const text = typeof textOverride === 'string' ? textOverride : inputText
    if (!text.trim() || isTyping) return

    if (typeof textOverride !== 'string') {
      setInputText('')
    }
    
    setIsTyping(true)
    setOptimisticMessages([
      ...serverMessages,
      { role: 'user', content: text, createdAt: new Date().toISOString() },
    ])

    try {
      const result = await sendMessage.mutateAsync({
        sessionId: currentSessionId,
        content: text,
      })

      const sessionId = result.data?.sessionId ?? currentSessionId
      if (sessionId && sessionId !== currentSessionId) {
        setCurrentSessionId(sessionId)
      } else if (sessionId) {
        queryClient.invalidateQueries({ queryKey: ['assistant-messages', sessionId] })
      }
    } finally {
      setIsTyping(false)
    }
  }

  const handleNewChat = () => {
    setCurrentSessionId(null)
    setSidebarOpen(false)
  }

  const handleSelectSession = (sessionId: string) => {
    setCurrentSessionId(sessionId)
    setSidebarOpen(false)
  }

  const startRename = (session: AssistantSession, e: React.MouseEvent) => {
    e.stopPropagation()
    setEditingSessionId(session.sessionId)
    setRenameValue(session.sessionName ?? '')
  }

  const commitRename = () => {
    if (editingSessionId && renameValue.trim()) {
      renameSession.mutate({ sessionId: editingSessionId, name: renameValue.trim() })
    }
    setEditingSessionId(null)
  }

  const formatTime = (dateStr?: string) => {
    const date = dateStr ? new Date(dateStr) : new Date()
    return date.toLocaleTimeString('en-US', {
      hour: 'numeric',
      minute: '2-digit',
      hour12: true,
    })
  }

  const formatSessionDate = (dateStr?: string) => {
    if (!dateStr) return ''
    return new Date(dateStr).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    })
  }

  const quickActions = [
    t('chatbot.suggestions.findProperties'),
    t('chatbot.suggestions.whatCanYouDo'),
    t('chatbot.suggestions.gettingStarted'),
  ]

  const SessionsPanel = (
    <div className="w-72 max-w-[85vw] flex-shrink-0 bg-white border-r border-[#3A6EA5]/20 flex flex-col h-full">
      <div className="p-4 border-b border-[#3A6EA5]/10">
        <button
          onClick={handleNewChat}
          className="w-full flex items-center gap-2 px-4 py-2.5 bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] text-white rounded-xl hover:from-[#2a5a8a] hover:to-[#3A6EA5] transition-all shadow-sm"
        >
          <Plus className="w-4 h-4" />
          <span className="font-medium text-sm">{t('chatbot.newChat')}</span>
        </button>
      </div>

      <div className="flex-1 overflow-y-auto py-2">
        {sessions.length === 0 && (
          <p className="text-xs text-[#4a5565] text-center mt-6 px-4">
            {t('chatbot.noSessions')}
          </p>
        )}
        {sessions.map((session) => {
          const isActive = session.sessionId === currentSessionId
          const isEditing = editingSessionId === session.sessionId

          return (
            <div
              key={session.sessionId}
              onClick={() => handleSelectSession(session.sessionId)}
              className={`group relative mx-2 mb-1 rounded-xl px-3 py-2.5 cursor-pointer transition-all ${
                isActive
                  ? 'bg-[#3A6EA5]/10 border border-[#3A6EA5]/20'
                  : 'hover:bg-[#F2F4F6]'
              }`}
            >
              {isActive && (
                <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-6 bg-[#3A6EA5] rounded-r-full" />
              )}

              {isEditing ? (
                <input
                  autoFocus
                  value={renameValue}
                  onChange={(e) => setRenameValue(e.target.value)}
                  onBlur={commitRename}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') commitRename()
                    if (e.key === 'Escape') setEditingSessionId(null)
                  }}
                  onClick={(e) => e.stopPropagation()}
                  className="w-full text-sm text-[#1a1a1a] bg-white border border-[#3A6EA5]/40 rounded-lg px-2 py-0.5 outline-none focus:border-[#3A6EA5]"
                />
              ) : (
                <div className="flex items-center justify-between gap-2">
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-medium text-[#1a1a1a] truncate">
                      {session.sessionName === session.sessionId
                        ? t('chatbot.newChat')
                        : session.sessionName || t('chatbot.newChat')}
                    </p>
                    <p className="text-xs text-[#4a5565]">
                      {formatSessionDate(session.createdAt)}
                    </p>
                  </div>
                  <button
                    onClick={(e) => startRename(session, e)}
                    className="opacity-0 group-hover:opacity-100 p-1 rounded-lg hover:bg-[#3A6EA5]/10 transition-all flex-shrink-0"
                  >
                    <Pencil className="w-3.5 h-3.5 text-[#4a5565]" />
                  </button>
                </div>
              )}
            </div>
          )
        })}
      </div>
    </div>
  )

  if (!token) {
    return (
      <div className="h-screen flex flex-col bg-gradient-to-br from-[#F2F4F6] to-[#9CBBDC]">
        <div className="bg-white border-b border-[#3A6EA5]/20 px-4 py-4 shadow-sm flex-shrink-0">
          <div className="max-w-full mx-auto flex items-center gap-4">
            <Link
              to="/"
              className="w-10 h-10 rounded-xl hover:bg-[#F2F4F6] flex items-center justify-center transition-colors"
            >
              <ArrowLeft className="w-5 h-5 text-[#4a5565]" />
            </Link>
            <div className="flex items-center gap-3 flex-1">
              <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center shadow-lg">
                <Bot className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-bold text-[#1a1a1a]">{t('chatbot.title')}</h1>
                <p className="text-sm text-[#4a5565]">{t('chatbot.alwaysHere')}</p>
              </div>
            </div>
          </div>
        </div>

        <div className="flex-1 flex items-center justify-center px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="text-center max-w-sm"
          >
            <div className="w-20 h-20 rounded-full bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center mx-auto mb-6 shadow-lg">
              <Lock className="w-9 h-9 text-white" />
            </div>
            <h2 className="text-2xl font-bold text-[#1a1a1a] mb-3">
              {t('chatbot.loginRequired')}
            </h2>
            <p className="text-[#4a5565] mb-8">
              {t('chatbot.loginRequiredDescription')}
            </p>
            <Button
              asChild
              className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] text-white rounded-2xl px-8 py-3 text-base font-medium shadow-lg"
            >
              <Link to="/login">{t('chatbot.loginButton')}</Link>
            </Button>
          </motion.div>
        </div>
      </div>
    )
  }

  return (
    <div className="h-screen flex flex-col bg-gradient-to-br from-[#F2F4F6] to-[#9CBBDC]">
      {/* Header */}
      <div className="bg-white border-b border-[#3A6EA5]/20 px-4 py-4 shadow-sm flex-shrink-0">
        <div className="max-w-full mx-auto flex items-center gap-4">
          <Link
            to="/"
            className="w-10 h-10 rounded-xl hover:bg-[#F2F4F6] flex items-center justify-center transition-colors"
          >
            <ArrowLeft className="w-5 h-5 text-[#4a5565]" />
          </Link>

          {/* Mobile sidebar toggle */}
          <button
            className="md:hidden w-10 h-10 rounded-xl hover:bg-[#F2F4F6] flex items-center justify-center transition-colors"
            onClick={() => setSidebarOpen((o) => !o)}
          >
            <PanelLeft className="w-5 h-5 text-[#4a5565]" />
          </button>

          <div className="flex items-center gap-3 flex-1">
            <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center shadow-lg">
              <Bot className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold text-[#1a1a1a]">
                {t('chatbot.title')}
              </h1>
              <p className="text-sm text-[#4a5565]">{t('chatbot.alwaysHere')}</p>
            </div>
          </div>
          <div className="w-3 h-3 rounded-full bg-green-500 animate-pulse"></div>
        </div>
      </div>

      {/* Body: sidebar + chat */}
      <div className="flex flex-1 overflow-hidden relative">
        {/* Desktop sidebar — always visible */}
        <div className="hidden md:flex">
          {SessionsPanel}
        </div>

        {/* Mobile backdrop */}
        {sidebarOpen && (
          <div
            className="absolute inset-0 bg-black/30 z-20 md:hidden"
            onClick={() => setSidebarOpen(false)}
          />
        )}

        {/* Mobile sidebar — slides in from left, stays below header */}
        <div
          className={`absolute left-0 top-0 bottom-0 z-30 md:hidden transition-transform duration-300 ease-in-out ${
            sidebarOpen ? 'translate-x-0' : '-translate-x-full'
          }`}
        >
          {SessionsPanel}
        </div>

        {/* Chat area */}
        <div className="flex-1 flex flex-col overflow-hidden">
          {/* Messages */}
          <div className="flex-1 overflow-y-auto px-4 py-6">
            <div className="max-w-4xl mx-auto space-y-4">
              {messages.length === 0 && (
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  className="text-center py-8"
                >
                  <div className="w-20 h-20 rounded-full bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center mx-auto mb-4 shadow-lg">
                    <Bot className="w-10 h-10 text-white" />
                  </div>
                  <h2 className="text-2xl font-bold text-[#1a1a1a] mb-2">
                    {t('chatbot.howCanIHelp')}
                  </h2>
                  <p className="text-[#4a5565] mb-6">
                    {t('chatbot.helpDescription')}
                  </p>
                  <div className="flex flex-wrap gap-2 justify-center">
                    {quickActions.map((action) => (
                      <button
                        key={action}
                        onClick={() => handleSend(action)}
                        className="px-4 py-2 bg-white rounded-xl border border-[#3A6EA5]/20 text-[#4a5565] hover:border-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white transition-all"
                      >
                        {action}
                      </button>
                    ))}
                  </div>
                </motion.div>
              )}

              {messages.map((message, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.05 }}
                  className={`flex gap-3 ${message.role === 'user' ? 'flex-row-reverse' : 'flex-row'}`}
                >
                  <div
                    className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 overflow-hidden ${
                      message.role === 'assistant'
                        ? 'bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC]'
                        : 'bg-[#F2F4F6]'
                    }`}
                  >
                    {message.role === 'assistant' ? (
                      <Bot className="w-5 h-5 text-white" />
                    ) : user?.avatarUrl ? (
                      <img src={getImageUrl(user.avatarUrl)} alt="User" className="w-full h-full object-cover" />
                    ) : (
                      <User className="w-5 h-5 text-[#4a5565]" />
                    )}
                  </div>

                  <div
                    className={`max-w-[70%] ${message.role === 'user' ? 'items-end' : 'items-start'} flex flex-col`}
                  >
                    <div
                      className={`rounded-2xl px-4 py-3 ${
                        message.role === 'assistant'
                          ? 'bg-white shadow-md'
                          : 'bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] text-white'
                      }`}
                    >
                      {message.role === 'assistant' ? (
                        <div className="prose prose-sm max-w-none text-[#1a1a1a] prose-headings:text-[#1a1a1a] prose-strong:text-[#1a1a1a] prose-a:text-[#3A6EA5] prose-li:marker:text-[#3A6EA5]">
                          <ReactMarkdown remarkPlugins={[remarkGfm]}>
                            {message.content}
                          </ReactMarkdown>
                        </div>
                      ) : (
                        <p className="text-white">{message.content}</p>
                      )}
                    </div>
                    <span className="text-xs text-[#4a5565] mt-1 px-2">
                      {formatTime(message.createdAt)}
                    </span>
                  </div>
                </motion.div>
              ))}

              {isTyping && (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="flex gap-3"
                >
                  <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center">
                    <Bot className="w-5 h-5 text-white" />
                  </div>
                  <div className="bg-white rounded-2xl px-4 py-3 shadow-md">
                    <div className="flex gap-1">
                      <div className="w-2 h-2 rounded-full bg-[#3A6EA5] animate-bounce" style={{ animationDelay: '0ms' }} />
                      <div className="w-2 h-2 rounded-full bg-[#3A6EA5] animate-bounce" style={{ animationDelay: '150ms' }} />
                      <div className="w-2 h-2 rounded-full bg-[#3A6EA5] animate-bounce" style={{ animationDelay: '300ms' }} />
                    </div>
                  </div>
                </motion.div>
              )}

              <div ref={messagesEndRef} />
            </div>
          </div>

          {/* Input */}
          <div className="bg-white border-t border-[#3A6EA5]/20 px-4 py-4 shadow-lg">
            <div className="max-w-4xl mx-auto">
              <div className="flex gap-3">
                <Input
                  value={inputText}
                  onChange={(e) => setInputText(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && handleSend()}
                  placeholder={t('chatbot.typeYourMessage')}
                  className="flex-1 bg-[#F2F4F6] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5]"
                />
                <Button
                  onClick={() => handleSend()}
                  disabled={!inputText.trim() || isTyping}
                  className="w-12 h-12 bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl shadow-lg disabled:opacity-50 flex-shrink-0"
                >
                  <Send className="w-5 h-5" />
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
