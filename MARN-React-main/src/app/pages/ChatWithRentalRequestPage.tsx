import { useState, useEffect, useRef, useMemo } from 'react'
import {
  Send,
  Paperclip,
  MoreVertical,
  ChevronLeft,
  Calendar,
  MapPin,
  Users,
} from 'lucide-react'
import { Input } from '../components/ui/input'
import { Button } from '../components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '../components/ui/avatar'
import { Card } from '../components/ui/card'
import { Skeleton } from '../components/ui/skeleton'
import { useNavigate, useParams } from 'react-router'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '../components/ui/dropdown-menu'
import { useMessages, useSendMessage } from '@/hooks/useConversations'

const RENTAL_REQUEST = {
  apartment: {
    name: 'Modern Downtown Apartment',
    image: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
    location: 'New Damietta, Egypt',
    price: 28000,
  },
  requestedPeriod: {
    from: '2026-04-01',
    to: '2026-10-01',
  },
  tenant: {
    name: 'Fatima Al-Masri',
    avatar:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
  },
  numberOfPeople: 2,
  totalPrice: 168000,
}

export function ChatWithRentalRequestPage() {
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()
  const [newMessage, setNewMessage] = useState('')
  const messagesEndRef = useRef<HTMLDivElement>(null)

  const { data: messagesData, isLoading: messagesLoading } = useMessages(id)
  const messages = useMemo(() => messagesData?.data ?? [], [messagesData])
  const sendMessage = useSendMessage()

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages])

  const handleSendMessage = () => {
    if (!newMessage.trim() || !id) return
    sendMessage.mutate(
      { conversationId: id, text: newMessage },
      { onSuccess: () => setNewMessage('') },
    )
  }

  const handleEditMessage = (_id: string) => {
    // Edit not yet supported by API
  }

  const handleDeleteMessage = (_id: string) => {
    // Delete not yet supported by API
  }

  return (
    <div className="min-h-screen">
      <div className="max-w-[1440px] mx-auto px-8 py-8">
        <div className="mb-6 flex items-center gap-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => navigate('/messages')}
            className="rounded-xl hover:bg-[#F2F4F6]/50"
          >
            <ChevronLeft className="w-6 h-6 text-[#1a1a1a]" />
          </Button>
          <div>
            <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
              Rental Request Chat
            </h1>
            <p className="text-[#6B7280]">
              Review request and communicate with tenant
            </p>
          </div>
        </div>

        <div className="grid lg:grid-cols-3 gap-6">
          {/* Rental Request Info Card */}
          <div className="lg:col-span-1">
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 p-6">
              <h2 className="text-xl font-semibold text-[#1a1a1a] mb-4">
                Rental Request Details
              </h2>

              {/* Apartment Info */}
              <div className="mb-6">
                <img
                  src={RENTAL_REQUEST.apartment.image}
                  alt={RENTAL_REQUEST.apartment.name}
                  className="w-full h-48 rounded-2xl object-cover mb-4"
                />
                <h3 className="font-semibold text-[#1a1a1a] mb-1">
                  {RENTAL_REQUEST.apartment.name}
                </h3>
                <div className="flex items-center gap-2 text-sm text-[#6B7280] mb-2">
                  <MapPin className="w-4 h-4" />
                  {RENTAL_REQUEST.apartment.location}
                </div>
                <p className="text-2xl font-bold text-[#3A6EA5]">
                  EGP {RENTAL_REQUEST.apartment.price.toLocaleString()}/month
                </p>
              </div>

              {/* Requested Period */}
              <div className="mb-6 p-4 bg-white rounded-2xl">
                <div className="flex items-center gap-2 mb-3">
                  <Calendar className="w-5 h-5 text-[#3A6EA5]" />
                  <h4 className="font-semibold text-[#1a1a1a]">
                    Requested Period
                  </h4>
                </div>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <p className="text-[#6B7280] mb-1">From</p>
                    <p className="font-medium text-[#1a1a1a]">
                      {new Date(
                        RENTAL_REQUEST.requestedPeriod.from,
                      ).toLocaleDateString('en-US', {
                        month: 'short',
                        day: 'numeric',
                        year: 'numeric',
                      })}
                    </p>
                  </div>
                  <div>
                    <p className="text-[#6B7280] mb-1">To</p>
                    <p className="font-medium text-[#1a1a1a]">
                      {new Date(
                        RENTAL_REQUEST.requestedPeriod.to,
                      ).toLocaleDateString('en-US', {
                        month: 'short',
                        day: 'numeric',
                        year: 'numeric',
                      })}
                    </p>
                  </div>
                </div>
              </div>

              {/* Booking Details */}
              <div className="mb-6 p-4 bg-white rounded-2xl">
                <h4 className="font-semibold text-[#1a1a1a] mb-3">
                  Booking Details
                </h4>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between">
                    <span className="text-[#6B7280]">Number of People:</span>
                    <span className="font-medium text-[#1a1a1a] flex items-center gap-1">
                      <Users className="w-4 h-4" />
                      {RENTAL_REQUEST.numberOfPeople}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-[#6B7280]">Duration:</span>
                    <span className="font-medium text-[#1a1a1a]">6 months</span>
                  </div>
                  <div className="border-t border-[#3A6EA5]/20 pt-2 mt-2 flex justify-between">
                    <span className="font-semibold text-[#1a1a1a]">Total:</span>
                    <span className="font-bold text-[#3A6EA5]">
                      EGP {RENTAL_REQUEST.totalPrice.toLocaleString()}
                    </span>
                  </div>
                </div>
              </div>

              {/* Action Buttons */}
              <div className="space-y-3">
                <Button className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2C5580] hover:to-[#3A6EA5] text-white rounded-xl">
                  Start Contract
                </Button>
                <Button
                  variant="outline"
                  className="w-full rounded-xl border-red-400 text-red-600 hover:bg-red-50"
                >
                  Reject Request
                </Button>
              </div>
            </Card>
          </div>

          {/* Chat Area */}
          <div className="lg:col-span-2">
            <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 overflow-hidden h-[800px] flex flex-col">
              {/* Chat Header */}
              <div className="p-4 border-b border-[#3A6EA5]/20 bg-white">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <Avatar className="w-10 h-10">
                      <AvatarImage src={RENTAL_REQUEST.tenant.avatar} />
                      <AvatarFallback>
                        {RENTAL_REQUEST.tenant.name.charAt(0)}
                      </AvatarFallback>
                    </Avatar>
                    <div>
                      <h3 className="font-semibold text-[#1a1a1a]">
                        {RENTAL_REQUEST.tenant.name}
                      </h3>
                      <p className="text-sm text-[#6B7280]">Potential Tenant</p>
                    </div>
                  </div>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="rounded-xl hover:bg-[#E5EBF0]/50"
                  >
                    <MoreVertical className="w-5 h-5 text-[#1a1a1a]" />
                  </Button>
                </div>
              </div>

              {/* Messages */}
              <div className="flex-1 overflow-y-auto p-4 space-y-4">
                {messagesLoading ? (
                  Array.from({ length: 4 }).map((_, i) => (
                    <div
                      key={i}
                      className={`flex ${i % 2 === 0 ? 'justify-start' : 'justify-end'}`}
                    >
                      <Skeleton className="h-14 w-48 rounded-2xl" />
                    </div>
                  ))
                ) : messages.length === 0 ? (
                  <div className="flex items-center justify-center h-full text-[#6B7280]">
                    No messages yet. Start the conversation!
                  </div>
                ) : (
                  messages.map((message) => (
                    <div
                      key={message.id}
                      className={`flex ${
                        message.sender === 'me'
                          ? 'justify-end'
                          : 'justify-start'
                      }`}
                    >
                      <div className="relative group">
                        <div
                          className={`max-w-[70%] ${
                            message.sender === 'me'
                              ? 'bg-[#3A6EA5] text-white'
                              : 'bg-white text-[#1a1a1a]'
                          } rounded-2xl px-4 py-3`}
                        >
                          <div className="flex items-start justify-between gap-2">
                            <p className="text-sm mb-1">{message.text}</p>
                            <DropdownMenu>
                              <DropdownMenuTrigger asChild>
                                <button
                                  className={`opacity-0 group-hover:opacity-100 transition-opacity ${
                                    message.sender === 'me'
                                      ? 'text-white/70 hover:text-white'
                                      : 'text-[#6B7280] hover:text-[#1a1a1a]'
                                  }`}
                                >
                                  <MoreVertical className="w-4 h-4" />
                                </button>
                              </DropdownMenuTrigger>
                              <DropdownMenuContent
                                align="end"
                                className="bg-white rounded-xl"
                              >
                                <DropdownMenuItem
                                  onClick={() => handleEditMessage(message.id)}
                                >
                                  Edit
                                </DropdownMenuItem>
                                <DropdownMenuItem
                                  onClick={() =>
                                    handleDeleteMessage(message.id)
                                  }
                                  className="text-red-600"
                                >
                                  Delete
                                </DropdownMenuItem>
                              </DropdownMenuContent>
                            </DropdownMenu>
                          </div>
                          <p
                            className={`text-xs ${
                              message.sender === 'me'
                                ? 'text-white/70'
                                : 'text-[#6B7280]'
                            }`}
                          >
                            {message.time}
                          </p>
                        </div>
                      </div>
                    </div>
                  ))
                )}
                <div ref={messagesEndRef} />
              </div>

              {/* Message Input */}
              <div className="p-4 border-t border-[#3A6EA5]/20 bg-white">
                <div className="flex items-end gap-3">
                  <Button
                    variant="ghost"
                    size="icon"
                    className="rounded-xl hover:bg-[#E5EBF0]/50 flex-shrink-0"
                  >
                    <Paperclip className="w-5 h-5 text-[#1a1a1a]" />
                  </Button>
                  <div className="flex-1 relative">
                    <Input
                      value={newMessage}
                      onChange={(e) => setNewMessage(e.target.value)}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter' && !e.shiftKey) {
                          e.preventDefault()
                          handleSendMessage()
                        }
                      }}
                      placeholder="Type a message..."
                      className="rounded-2xl bg-[#E5EBF0] border-[#3A6EA5]/20 pr-12"
                      disabled={sendMessage.isPending}
                    />
                  </div>
                  <Button
                    onClick={handleSendMessage}
                    disabled={!newMessage.trim() || sendMessage.isPending}
                    className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2C5580] hover:to-[#3A6EA5] text-white rounded-xl shadow-lg shadow-[#3A6EA5]/30 flex-shrink-0"
                  >
                    <Send className="w-5 h-5" />
                  </Button>
                </div>
              </div>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}
