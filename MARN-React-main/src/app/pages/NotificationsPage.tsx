import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'motion/react'
import { Bell, CheckCircle, Info, MessageSquare, AlertTriangle, Check, Home } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Card } from '../components/ui/card'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '../components/ui/dialog'
import { Skeleton } from '../components/ui/skeleton'
import { Link } from 'react-router'
import { notificationService, AppNotification } from '@/services/notificationService'
import { toast } from 'sonner'
import { contractService } from '@/services/contractService'
import { rentalService } from '@/services/rentalService'
import { useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'

export type NotificationType = 'system' | 'message' | 'alert' | 'success'

export interface NotificationUI {
  id: string
  type: NotificationType
  title: string
  message: string
  time: string
  isRead: boolean
  link?: string
  backendType: string
  actionType: string | null
  actionId: string | null
  data: any
}

export const mapType = (backendType: string, title?: string): NotificationType => {
  if (backendType === 'AccountBanned' || title?.toLowerCase().includes('banned')) return 'alert';
  switch (backendType) {
    case 'NewMessage': return 'message';
    case 'ContractSigned':
    case 'ContractCompleted':
    case 'PaymentArrived':
    case 'PaymentSuccessful':
    case 'PaymentReceived':
    case 'AvailableForWithdrawal':
    case 'ConnectAccountSuccess':
    case 'WithdrawSuccess':
    case 'PropertyAdded':
    case 'PropertyEdited':
      return 'success';
    case 'BookingRequestCanceled':
    case 'BookingRequestRejected':
    case 'ContractCanceled':
    case 'UpcomingPayment':
    case 'DelayedPayment':
    case 'PaymentFailed':
    case 'ConnectAccountFailed':
    case 'WithdrawFailed':
    case 'PropertyDeleted':
      return 'alert';
    case 'General':
    case 'NewBookingRequest':
    case 'NewReview':
    case 'ContractStarted':
    default:
      return 'system';
  }
}

export const getNotificationRoute = (actionType: string | null, actionId: string | null, backendType?: string, title?: string): string | undefined => {
  if (backendType === 'NewBookingRequest') {
    return '/owner-dashboard#pending-requests';
  }
  
  if (
    backendType === 'ContractPendingSignature' || 
    backendType === 'ContractCreated' || 
    backendType === 'NewContract' || 
    backendType === 'ContractStarted' || 
    backendType === 'ContractSigned'
  ) {
    return actionId ? `/contract/${actionId}` : '/tenant-dashboard#contracts';
  }

  if (backendType === 'AccountBanned' || title?.toLowerCase().includes('banned')) {
    return '/contact';
  }

  if (!actionType) return undefined;
  
  switch (actionType) {
    case 'Property':
      return actionId ? `/property/${actionId}` : undefined;
    case 'ChatUser':
      return actionId ? `/messages?user=${actionId}` : '/messages';
    case 'EditProfile':
      return '/settings';
    case 'RenterDashboard':
      return '/tenant-dashboard';
    case 'OwnerDashboard':
      return '/owner-dashboard';
    case 'Contract':
      return actionId ? `/contract/${actionId}` : '/owner-dashboard';
    case 'Payment':
      return '/owner-dashboard';
    default:
      return undefined;
  }
}

export const mapNotification = (appNotif: AppNotification): NotificationUI => {
  return {
    id: String(appNotif.id),
    type: mapType(appNotif.type, appNotif.title),
    title: appNotif.title,
    message: appNotif.body,
    time: new Date(appNotif.createdAt).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' }),
    isRead: appNotif.isRead,
    link: getNotificationRoute(appNotif.actionType, appNotif.actionId, appNotif.type, appNotif.title),
    backendType: appNotif.type,
    actionType: appNotif.actionType,
    actionId: appNotif.actionId,
    data: appNotif.data
  }
}

export const getIcon = (type: NotificationType) => {
  switch (type) {
    case 'message':
      return <MessageSquare className="w-5 h-5 text-blue-500" />
    case 'success':
      return <CheckCircle className="w-5 h-5 text-green-500" />
    case 'alert':
      return <AlertTriangle className="w-5 h-5 text-amber-500" />
    case 'system':
    default:
      return <Info className="w-5 h-5 text-[#3A6EA5]" />
  }
}

export const getBgColor = (type: NotificationType) => {
  switch (type) {
    case 'message':
      return 'bg-blue-50'
    case 'success':
      return 'bg-green-50'
    case 'alert':
      return 'bg-amber-50'
    case 'system':
    default:
      return 'bg-[#3A6EA5]/10'
  }
}

export function NotificationsPage() {
  const [notifications, setNotifications] = useState<NotificationUI[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [activeTab, setActiveTab] = useState<'unread' | 'read'>('unread')
  const [selectedNotification, setSelectedNotification] = useState<NotificationUI | null>(null)
  const [isProcessingAction, setIsProcessingAction] = useState(false)
  const queryClient = useQueryClient()
  const { t, i18n } = useTranslation('pages')

  const handleNotificationClick = async (notification: NotificationUI) => {
    setSelectedNotification(notification)
    if (!notification.isRead) {
      await markAsRead(notification.id)
    }
  }

  const handleActionClick = async (actionType: 'create_contract' | 'sign_contract' | 'accept_booking' | 'decline_booking', id: string) => {
    setIsProcessingAction(true)
    try {
      if (actionType === 'create_contract' || actionType === 'accept_booking') {
        // accepting a booking IS creating the contract
        await rentalService.acceptRequest(id)
        toast.success("Booking request accepted and contract created")
        queryClient.invalidateQueries({ queryKey: ['bookingRequests'] })
        queryClient.invalidateQueries({ queryKey: ['ownerDashboard'] })
      } else if (actionType === 'decline_booking') {
        await rentalService.rejectRequest(id)
        toast.success("Booking request declined")
        queryClient.invalidateQueries({ queryKey: ['bookingRequests'] })
        queryClient.invalidateQueries({ queryKey: ['ownerDashboard'] })
      } else if (actionType === 'sign_contract') {
        await contractService.signContract(Number(id))
        toast.success("Contract signed successfully")
        queryClient.invalidateQueries({ queryKey: ['contracts'] })
        queryClient.invalidateQueries({ queryKey: ['renterDashboard'] })
        queryClient.invalidateQueries({ queryKey: ['ownerDashboard'] })
      }
      setSelectedNotification(null)
    } catch (err: any) {
      toast.error(err?.response?.data?.message || err?.message || "Failed to process action")
    } finally {
      setIsProcessingAction(false)
    }
  }

  useEffect(() => {
    const fetchNotifications = async () => {
      try {
        const data = await notificationService.getNotifications()
        setNotifications(data.map(mapNotification))
      } catch (err) {
        console.error('Failed to fetch notifications', err)
      } finally {
        setIsLoading(false)
      }
    }

    fetchNotifications()

    const handleReceived = (e: Event) => {
      const customEvent = e as CustomEvent<AppNotification>
      setNotifications((prev) => [mapNotification(customEvent.detail), ...prev])
    }

    const handleAllRead = () => {
      setNotifications((prev) => prev.map((n) => ({ ...n, isRead: true })))
    }

    const handleMarkedRead = (e: Event) => {
      const customEvent = e as CustomEvent<string>
      setNotifications((prev) =>
        prev.map((n) => (n.id === customEvent.detail ? { ...n, isRead: true } : n))
      )
    }

    window.addEventListener('notification-received', handleReceived)
    window.addEventListener('notifications-all-read', handleAllRead)
    window.addEventListener('notification-marked-read', handleMarkedRead)

    return () => {
      window.removeEventListener('notification-received', handleReceived)
      window.removeEventListener('notifications-all-read', handleAllRead)
      window.removeEventListener('notification-marked-read', handleMarkedRead)
    }
  }, [])

  const unreadCount = notifications.filter((n) => !n.isRead).length

  const markAllAsRead = async () => {
    const snapshot = notifications
    setNotifications(prev => prev.map((n) => ({ ...n, isRead: true })))
    try {
      await notificationService.markAllAsRead()
    } catch (err) {
      setNotifications(snapshot)
      toast.error(t('notifications.markAllAsReadError'))
    }
  }

  const markAsRead = async (id: string) => {
    const snapshot = notifications
    setNotifications(prev => prev.map((n) => (n.id === id ? { ...n, isRead: true } : n)))
    try {
      await notificationService.markAsRead(id)
    } catch (err) {
      setNotifications(snapshot)
      toast.error(t('notifications.markAsReadError'))
    }
  }

  const displayedNotifications = notifications
    .filter((n) => (activeTab === 'unread' ? !n.isRead : n.isRead))
    // We can sort them here if they aren't already sorted from the backend (usually they are sorted by createdAt desc)
    .sort((a, b) => new Date(b.time).getTime() - new Date(a.time).getTime())

  return (
    <div className="min-h-[calc(100vh-80px)] bg-[#F2F4F6] py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto space-y-8">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <div className="p-3 bg-white rounded-2xl shadow-sm border border-[#3A6EA5]/10">
                <Bell className="w-6 h-6 text-[#3A6EA5]" />
              </div>
              <h1 className="text-3xl font-bold text-[#1a1a1a]">{t('notifications.title')}</h1>
            </div>
            <p className={`text-[#6a7282] ${i18n.language === 'ar' ? 'mr-1' : 'ml-1'}`}>
              {t('notifications.unreadCount', { count: unreadCount })}
            </p>
          </div>

          <div className="flex items-center gap-3">
            {unreadCount > 0 && (
              <Button
                onClick={markAllAsRead}
                variant="outline"
                className="bg-white hover:bg-[#f5f7fa] border-[#3A6EA5]/20 text-[#3A6EA5]"
              >
                <Check className={`w-4 h-4 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
                {t('notifications.markAllAsRead')}
              </Button>
            )}
          </div>
        </div>

        {/* Tabs */}
        <div className="flex items-center gap-2 border-b border-[#3A6EA5]/10 pb-4">
          <button
            onClick={() => setActiveTab('unread')}
            className={`px-4 py-2 rounded-xl text-sm font-semibold transition-all ${
              activeTab === 'unread'
                ? 'bg-[#3A6EA5] text-white shadow-md shadow-[#3A6EA5]/20'
                : 'text-[#6a7282] hover:bg-[#3A6EA5]/5 hover:text-[#3A6EA5]'
            }`}
          >
            {t('notifications.unread')}
          </button>
          <button
            onClick={() => setActiveTab('read')}
            className={`px-4 py-2 rounded-xl text-sm font-semibold transition-all ${
              activeTab === 'read'
                ? 'bg-[#3A6EA5] text-white shadow-md shadow-[#3A6EA5]/20'
                : 'text-[#6a7282] hover:bg-[#3A6EA5]/5 hover:text-[#3A6EA5]'
            }`}
          >
            {t('notifications.read')}
          </button>
        </div>

        {/* Notifications List */}
        <Card className="bg-white rounded-3xl shadow-sm border-[#3A6EA5]/10 overflow-hidden">
          <div className="divide-y divide-[#3A6EA5]/10">
            {isLoading ? (
              <div className="p-6 space-y-6">
                {[1, 2, 3].map((i) => (
                  <div key={i} className="flex items-start gap-4">
                    <Skeleton className="w-12 h-12 rounded-xl" />
                    <div className="flex-1 space-y-2">
                      <Skeleton className="h-5 w-1/3" />
                      <Skeleton className="h-4 w-full" />
                      <Skeleton className="h-4 w-2/3" />
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <AnimatePresence mode="popLayout">
                {displayedNotifications.length === 0 ? (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  className="p-12 text-center"
                >
                  <div className="w-16 h-16 bg-[#f5f7fa] rounded-full flex items-center justify-center mx-auto mb-4">
                    <Bell className="w-8 h-8 text-[#6a7282]/50" />
                  </div>
                  <h3 className="text-lg font-medium text-[#1a1a1a] mb-2">
                    {t('notifications.allCaughtUp')}
                  </h3>
                  <p className="text-[#6a7282] max-w-sm mx-auto">
                    {t('notifications.noNewNotifications')}
                  </p>
                  <Button asChild className="mt-6 bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white">
                    <Link to="/">
                      <Home className={`w-4 h-4 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
                      {t('notifications.backToHome')}
                    </Link>
                  </Button>
                </motion.div>
              ) : (
                displayedNotifications.map((notification) => (
                  <motion.div
                    key={notification.id}
                    layout
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, x: -100 }}
                    onClick={() => handleNotificationClick(notification)}
                    className={`p-6 transition-colors hover:bg-[#f5f7fa] relative group cursor-pointer ${
                      !notification.isRead ? 'bg-blue-50/30' : ''
                    }`}
                  >
                    <div className="flex items-start gap-4">
                      {/* Icon */}
                      <div
                        className={`flex-shrink-0 w-12 h-12 rounded-xl flex items-center justify-center ${getBgColor(
                          notification.type
                        )}`}
                      >
                        {getIcon(notification.type)}
                      </div>

                      {/* Content */}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between gap-4 mb-1">
                          <h4
                            className={`text-base font-semibold ${
                              !notification.isRead ? 'text-[#1a1a1a]' : 'text-[#1a1a1a]/80'
                            }`}
                          >
                            {notification.title}
                          </h4>
                          <span className="text-xs font-medium text-[#6a7282] whitespace-nowrap">
                            {notification.time}
                          </span>
                        </div>
                        <p className="text-sm text-[#6a7282] mb-3 leading-relaxed">
                          {notification.message}
                        </p>

                        <div className="flex items-center gap-3" onClick={(e) => e.stopPropagation()}>
                          {notification.link && (
                            <Button
                              asChild
                              variant="link"
                              className="h-auto p-0 text-[#3A6EA5] font-medium hover:text-[#2a5a8a]"
                              onClick={() => {
                                if (!notification.isRead) markAsRead(notification.id)
                              }}
                            >
                              <Link to={notification.link}>{t('notifications.viewDetails')}</Link>
                            </Button>
                          )}
                        </div>
                      </div>

                      {/* Actions */}
                      <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity" onClick={(e) => e.stopPropagation()}>
                        {!notification.isRead && (
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => markAsRead(notification.id)}
                            className="h-8 w-8 text-[#3A6EA5] hover:bg-[#3A6EA5]/10 hover:text-[#3A6EA5]"
                            title={t('notifications.markAsRead')}
                          >
                            <Check className="w-4 h-4" />
                          </Button>
                        )}
                      </div>
                    </div>

                    {/* Unread Indicator */}
                    {!notification.isRead && (
                      <div className={`absolute ${i18n.language === 'ar' ? 'right-0 rounded-l-full' : 'left-0 rounded-r-full'} top-1/2 -translate-y-1/2 w-1 h-12 bg-[#3A6EA5]`} />
                    )}
                  </motion.div>
                ))
              )}
            </AnimatePresence>
            )}
          </div>
        </Card>
      </div>

      {/* Notification Details Modal */}
      <Dialog open={!!selectedNotification} onOpenChange={(open) => !open && setSelectedNotification(null)}>
        <DialogContent className="sm:max-w-md p-6 bg-white border-[#3A6EA5]/20 rounded-2xl shadow-xl">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-3 text-xl">
              {selectedNotification && (
                <div className={`p-2 rounded-lg flex-shrink-0 ${getBgColor(selectedNotification.type)}`}>
                  {getIcon(selectedNotification.type)}
                </div>
              )}
              {selectedNotification?.title}
            </DialogTitle>
          </DialogHeader>
          <DialogDescription className="text-base text-[#6a7282] mt-4 leading-relaxed whitespace-pre-wrap">
            {selectedNotification?.message}
          </DialogDescription>
          <div className="mt-6 flex justify-end gap-3">
            <Button variant="outline" onClick={() => setSelectedNotification(null)} className="rounded-xl">
              {t('notifications.close')}
            </Button>
            {selectedNotification?.backendType === 'NewBookingRequest' && selectedNotification?.actionId && (
              <div className="flex gap-2 w-full sm:w-auto">
                <Button 
                  onClick={() => handleActionClick('accept_booking', selectedNotification.actionId!)} 
                  disabled={isProcessingAction}
                  className="rounded-xl bg-green-600 hover:bg-green-700 text-white flex-1"
                >
                  {isProcessingAction ? t('notifications.accepting') : t('notifications.acceptRequest')}
                </Button>
                <Button 
                  onClick={() => handleActionClick('decline_booking', selectedNotification.actionId!)} 
                  disabled={isProcessingAction}
                  variant="outline"
                  className="rounded-xl border-red-500 text-red-500 hover:bg-red-50 hover:text-red-600 flex-1"
                >
                  {isProcessingAction ? t('notifications.declining') : t('notifications.decline')}
                </Button>
              </div>
            )}
            {(selectedNotification?.backendType === 'ContractPendingSignature' || selectedNotification?.backendType === 'ContractCreated' || selectedNotification?.backendType === 'NewContract') && selectedNotification?.actionId && selectedNotification?.actionType === 'Contract' && (
              <Button 
                onClick={() => handleActionClick('sign_contract', selectedNotification.actionId!)} 
                disabled={isProcessingAction}
                className="rounded-xl bg-green-600 hover:bg-green-700 text-white"
              >
                {isProcessingAction ? t('notifications.signing') : t('notifications.signContract')}
              </Button>
            )}
            {selectedNotification?.link && (
              <Button asChild className="rounded-xl bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white">
                <Link to={selectedNotification.link}>
                  {selectedNotification.backendType === 'NewMessage' 
                    ? t('notifications.replyToMessage')
                    : (selectedNotification.backendType === 'AccountBanned' || selectedNotification.title.toLowerCase().includes('banned'))
                    ? t('notifications.contactSupport')
                    : t('notifications.viewDetails')}
                </Link>
              </Button>
            )}
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
