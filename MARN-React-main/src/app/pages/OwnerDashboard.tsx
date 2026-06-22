import {
  Plus,
  Home,
  DollarSign,
  Users,
  Eye,
  Calendar,
  MoreVertical,
  MessageSquare,
  Download,
  CheckCircle,
  XCircle,
  Star,
  AlertTriangle,
  Clock,
} from 'lucide-react'
import { Alert, AlertDescription, AlertTitle } from '../components/ui/alert'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { Button } from '../components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '../components/ui/avatar'
import { Badge } from '../components/ui/badge'
import { Skeleton } from '../components/ui/skeleton'
import { Link, useNavigate } from 'react-router'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts'
import { toast } from 'sonner'
import { useState, useEffect } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { useOwnerDashboard } from '@/hooks/useOwnerDashboard'
import { useBookingMutations } from '@/hooks/useBookingRequests'
import { paymentService } from '@/services/paymentService'
import { useTranslation } from 'react-i18next'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '../components/ui/dialog'
import { NotificationUI, mapNotification, getIcon, getBgColor } from './NotificationsPage'
import { notificationService } from '@/services/notificationService'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '../components/ui/dropdown-menu'

const getContractStatusBadge = (status: string) => {
  const styles: Record<string, string> = {
    Active: 'bg-green-100 text-green-700 hover:bg-green-100',
    Expired: 'bg-red-100 text-red-700 hover:bg-red-100',
    Pending: 'bg-yellow-100 text-yellow-700 hover:bg-yellow-100',
  }
  return styles[status] ?? 'bg-gray-100 text-gray-700 hover:bg-gray-100'
}

const formatDate = (iso: string) =>
  new Date(iso).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })

function timeAgo(iso: string | undefined | null) {
  if (!iso) return '—'
  const diff = Date.now() - new Date(iso).getTime()
  const mins = Math.floor(diff / 60_000)
  if (mins < 60) return `${mins}m ago`
  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs}h ago`
  return `${Math.floor(hrs / 24)}d ago`
}

export function OwnerDashboard() {
  const { t, i18n } = useTranslation('dashboard')
  const [view, setView] = useState<'monthly' | 'yearly'>('monthly')
  const [isWithdrawing, setIsWithdrawing] = useState(false)
  const [selectedNotification, setSelectedNotification] = useState<NotificationUI | null>(null)
  const [showAllNotifications, setShowAllNotifications] = useState(false)
  const [requestsLimit, setRequestsLimit] = useState(3)
  const [propertiesLimit, setPropertiesLimit] = useState(3)
  const [paymentsLimit, setPaymentsLimit] = useState(5)
  const [contractsLimit, setContractsLimit] = useState(4)

  const queryClient = useQueryClient()
  const navigate = useNavigate()

  const { data: dashboardResponse, isLoading, refetch } = useOwnerDashboard()

  // Keep booking-request mutations (accept / reject) from the dedicated hook
  const { accept, reject } = useBookingMutations()

  const [isConnectingAccount, setIsConnectingAccount] = useState(false)

  const dashboard = dashboardResponse?.data

  // ── Derived values ────────────────────────────────────────────────────────
  useEffect(() => {
    if (!isLoading && window.location.hash) {
      const id = window.location.hash.replace('#', '')
      const element = document.getElementById(id)
      if (element) {
        setTimeout(() => element.scrollIntoView({ behavior: 'smooth' }), 100)
      }
    }
  }, [isLoading])
  const totalProperties = dashboard?.propertiesCount ?? 0
  const occupiedCount = dashboard?.occupiedPlaces ?? 0
  const vacantCount = dashboard?.vacantPlaces ?? 0

  const occupancyData = [
    { name: t('owner.occupancy.occupied'), value: occupiedCount, color: '#3A6EA5' },
    { name: t('owner.occupancy.vacant'), value: vacantCount, color: '#9CBBDC' },
  ]

  const getMonthName = (monthNumber: number) => {
    const date = new Date(2000, monthNumber - 1, 1)
    return date.toLocaleString(i18n.language, { month: 'short' })
  }

  const monthlyChartData = (dashboard?.monthlyEarning ?? []).map((e) => ({
    month: getMonthName(e.month),
    earnings: e.total,
  }))

  const yearlyChartData = (dashboard?.yearlyEarning ?? []).map((e) => ({
    month: e.year.toString(),
    earnings: e.total,
  }))

  const chartData = view === 'monthly' ? monthlyChartData : yearlyChartData

  const pendingRequests = dashboard?.pendingBookingRequests ?? []
  const contracts = dashboard?.allContracts ?? []
  
  const allNotifications = dashboard?.notifications ?? []
  const unreadNotifications = allNotifications.filter((n: any) => !n.isRead)
  const displayNotifications = showAllNotifications ? allNotifications : unreadNotifications.slice(0, 3)
  
  const myProperties = dashboard?.properties ?? []
  const receivedPayments = dashboard?.receivedPayments ?? []

  // ── Handlers ──────────────────────────────────────────────────────────────
  const handleAcceptRequest = (id: number) => {
    accept.mutate(id.toString(), {
      onSuccess: () => toast.success('Contract generated and sent to the tenant, awaiting signature.'),
      onError: (err: any) => toast.error(err?.message || 'Failed to accept request'),
    })
  }

  const handleDeclineRequest = (id: number) => {
    reject.mutate(id.toString(), {
      onSuccess: () => toast.success('Booking request declined'),
      onError: () => toast.error('Failed to decline request'),
    })
  }

  const handleDownloadContract = (contractId: string) => {
    toast.success(`Downloading contract ${contractId}`)
  }

  const handleConnectAccount = async () => {
    try {
      setIsConnectingAccount(true)
      const res = await paymentService.connectAccount()
      const url = typeof res.data === 'string' ? res.data : (res.data as any)?.url
      if (url) {
        window.location.href = url
      } else {
        toast.error('Failed to get onboarding link')
      }
    } catch (error) {
      toast.error('Error connecting Stripe account')
    } finally {
      setIsConnectingAccount(false)
    }
  }

  const handleWithdraw = async () => {
    try {
      setIsWithdrawing(true)
      await paymentService.withdraw()
      toast.success('Transfer initiated successfully')
      
      // Optimistically update the dashboard data so the balance instantly drops to 0
      queryClient.setQueryData(['ownerDashboard'], (oldData: any) => {
        if (!oldData || !oldData.data) return oldData
        return {
          ...oldData,
          data: {
            ...oldData.data,
            withdrawableEarnings: 0
          }
        }
      })
      refetch()
    } catch (error: any) {
      toast.error(error?.message || 'Failed to initiate transfer')
    } finally {
      setIsWithdrawing(false)
    }
  }

  const handleNotificationClick = async (n: any) => {
    const mapped = mapNotification(n)
    setSelectedNotification(mapped)
    if (!mapped.isRead) {
      try {
        await notificationService.markAsRead(mapped.id)
        refetch()
      } catch (err) {
        console.error('Failed to mark as read', err)
      }
    }
  }

  const renderPaginationButtons = (
    currentLimit: number,
    setLimit: React.Dispatch<React.SetStateAction<number>>,
    totalItems: number,
    baseLimit: number
  ) => {
    if (totalItems <= baseLimit) return null;
    
    if (currentLimit < totalItems) {
      return (
        <div className="flex justify-center gap-3 mt-4">
          <Button variant="outline" size="sm" onClick={() => setLimit(prev => prev + baseLimit)} className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white">
            {t('owner.properties.showMore')}
          </Button>
          <Button variant="outline" size="sm" onClick={() => setLimit(totalItems)} className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white">
            {t('owner.properties.showAll')}
          </Button>
        </div>
      );
    }
    
    return (
      <div className="flex justify-center mt-4">
        <Button variant="outline" size="sm" onClick={() => setLimit(baseLimit)} className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white">
          {t('owner.properties.showLess')}
        </Button>
      </div>
    );
  };

  return (
    <div className="min-h-screen pb-20">
      <div className="max-w-[1440px] mx-auto px-8 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
              {t('owner.title')}
            </h1>
            <p className="text-[#4a5565]">
              {t('owner.subtitle')}
            </p>
          </div>
          <Button
            size="lg"
            className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl shadow-lg shadow-[#3A6EA5]/30"
            asChild
          >
            <Link to="/add-property">
              <Plus className="w-5 h-5 mr-2" />
              {t('owner.addNewProperty')}
            </Link>
          </Button>
        </div>

        {/* Account Status Alert */}
        {dashboard?.accountStatus && dashboard.accountStatus !== 'Active' && dashboard.accountStatus !== 'Verified' && (
          <Alert variant={dashboard.accountStatus === 'Pending' ? 'default' : 'destructive'} className={`mb-8 ${dashboard.accountStatus === 'Pending' ? 'border-yellow-200 bg-yellow-50 text-yellow-800' : 'border-red-200 bg-red-50 text-red-800'}`}>
            <AlertTriangle className={`h-5 w-5 ${dashboard.accountStatus === 'Pending' ? 'text-yellow-600' : 'text-red-600'}`} />
            <AlertTitle className={`${dashboard.accountStatus === 'Pending' ? 'text-yellow-800' : 'text-red-800'} font-semibold text-lg`}>Account {dashboard.accountStatusDisplayName}</AlertTitle>
            <AlertDescription className={`${dashboard.accountStatus === 'Pending' ? 'text-yellow-700' : 'text-red-700'} mt-1`}>
              Your account status is currently <strong>{dashboard.accountStatusDisplayName}</strong>. Some features might be restricted. Please contact support if you believe this is an error.
            </AlertDescription>
          </Alert>
        )}

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {/* Total Properties */}
          <Card className="bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] border-none text-white rounded-3xl shadow-lg shadow-[#3A6EA5]/20">
            <CardHeader className="pb-3">
              <CardTitle className="flex items-center gap-2 text-white/90">
                <Home className="w-5 h-5" />
                {t('owner.cards.totalProperties')}
              </CardTitle>
            </CardHeader>
            <CardContent>
              {isLoading ? (
                <Skeleton className="h-10 w-16 bg-white/30" />
              ) : (
                <>
                  <div className="text-4xl font-bold mb-1">
                    {totalProperties}
                  </div>
                  <p className="text-white/80 text-sm">
                    {t('owner.cards.occupiedVacant', { occupied: occupiedCount, vacant: vacantCount })}
                  </p>
                </>
              )}
            </CardContent>
          </Card>

          {/* Withdrawable Earnings */}
          <Card className="bg-[#f5f7fa] border-none rounded-3xl shadow-lg shadow-black/5">
            <CardHeader className="pb-3">
              <CardTitle className="flex items-center gap-2 text-[#1a1a1a]">
                <DollarSign className="w-5 h-5 text-[#3A6EA5]" />
                {t('owner.cards.monthlyRevenue')}
              </CardTitle>
            </CardHeader>
            <CardContent>
              {isLoading ? (
                <Skeleton className="h-10 w-32" />
              ) : (
                <>
                  <div className="text-4xl font-bold text-[#3A6EA5] mb-1">
                    {i18n.language === 'ar' ? `${(monthlyChartData[monthlyChartData.length - 1]?.earnings ?? 0).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(monthlyChartData[monthlyChartData.length - 1]?.earnings ?? 0).toLocaleString()}`}
                  </div>
                  <p className="text-[#4a5565] text-sm">
                    {t('owner.cards.totalViews', { count: dashboard?.totalViews ?? 0 })}
                  </p>
                </>
              )}
            </CardContent>
          </Card>

          {/* Withdrawable Earnings */}
          <Card className="bg-[#f5f7fa] border-none rounded-3xl shadow-lg shadow-black/5">
            <CardHeader className="pb-3">
              <CardTitle className="flex items-center gap-2 text-[#1a1a1a]">
                <DollarSign className="w-5 h-5 text-[#3A6EA5]" />
                {t('owner.cards.withdrawableEarnings')}
              </CardTitle>
            </CardHeader>
            <CardContent>
              {isLoading ? (
                <Skeleton className="h-10 w-32" />
              ) : (
                <>
                  <div className="text-4xl font-bold text-[#3A6EA5] mb-1">
                    {i18n.language === 'ar' ? `${(dashboard?.withdrawableEarnings ?? 0).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(dashboard?.withdrawableEarnings ?? 0).toLocaleString()}`}
                  </div>
                  <p className="text-[#4a5565] text-sm mb-1">
                    {t('owner.cards.onHold')}{' '}
                    <span className="font-medium text-[#1a1a1a]">
                      {i18n.language === 'ar' ? `${(dashboard?.onHoldEarnings ?? 0).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(dashboard?.onHoldEarnings ?? 0).toLocaleString()}`}
                    </span>
                  </p>
                  {!dashboard?.stripeAccountEnabled ? (
                    <Button
                      size="sm"
                      className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl mt-2"
                      onClick={handleConnectAccount}
                      disabled={isConnectingAccount}
                    >
                      {isConnectingAccount ? t('owner.cards.connecting') : t('owner.cards.connectStripe')}
                    </Button>
                  ) : (
                    <Button
                      size="sm"
                      className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl mt-2"
                      onClick={handleWithdraw}
                      disabled={isWithdrawing || (dashboard?.withdrawableEarnings ?? 0) <= 0}
                    >
                      {isWithdrawing ? t('owner.cards.withdrawing') : t('owner.cards.withdraw')}
                    </Button>
                  )}
                </>
              )}
            </CardContent>
          </Card>

          {/* Pending Requests */}
          <Card className="bg-[#f5f7fa] border-none rounded-3xl shadow-lg shadow-black/5">
            <CardHeader className="pb-3">
              <CardTitle className="flex items-center gap-2 text-[#1a1a1a]">
                <Users className="w-5 h-5 text-[#3A6EA5]" />
                {t('owner.cards.pendingRequests')}
              </CardTitle>
            </CardHeader>
            <CardContent>
              {isLoading ? (
                <Skeleton className="h-10 w-12" />
              ) : (
                <>
                  <div className="text-4xl font-bold text-[#3A6EA5] mb-1">
                    {dashboard?.pendingBookingRequestsCount ?? 0}
                  </div>
                  <p className="text-[#4a5565] text-sm">
                    {t('owner.cards.awaitingResponse')}
                  </p>
                </>
              )}
            </CardContent>
          </Card>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-8">
            {/* Earnings Chart */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('owner.chart.earningsOverview')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {isLoading ? (
                  <Skeleton className="h-[300px] w-full rounded-2xl" />
                ) : chartData.length === 0 ? (
                  <p className="text-[#4a5565] text-center py-16">
                    No earning data available yet.
                  </p>
                ) : (
                  <div dir="ltr">
                    <ResponsiveContainer width="100%" height={300}>
                      <LineChart data={chartData}>
                        <CartesianGrid
                          strokeDasharray="3 3"
                          stroke="#3A6EA5"
                          opacity={0.1}
                        />
                        <XAxis 
                          dataKey="month" 
                          stroke="#4a5565" 
                          tickFormatter={(label: string) => {
                            const monthMap: Record<string, string> = {
                              'Jan': 'يناير', 'Feb': 'فبراير', 'Mar': 'مارس', 'Apr': 'أبريل', 'May': 'مايو', 'Jun': 'يونيو',
                              'Jul': 'يوليو', 'Aug': 'أغسطس', 'Sep': 'سبتمبر', 'Oct': 'أكتوبر', 'Nov': 'نوفمبر', 'Dec': 'ديسمبر'
                            }
                            return i18n.language === 'ar' ? (monthMap[label] || label) : label
                          }}
                        />
                        <YAxis stroke="#4a5565" />
                        <Tooltip
                          contentStyle={{
                            backgroundColor: '#FFFFFF',
                            border: '1px solid #3A6EA5',
                            borderRadius: '12px',
                          }}
                          formatter={(value: number) => 
                            [`${value.toLocaleString()} ${t('currency', { ns: 'common' })}`, t('owner.chart.earnings', { defaultValue: 'Earnings' })]
                          }
                          labelFormatter={(label: string) => {
                            const monthMap: Record<string, string> = {
                              'Jan': 'يناير', 'Feb': 'فبراير', 'Mar': 'مارس', 'Apr': 'أبريل', 'May': 'مايو', 'Jun': 'يونيو',
                              'Jul': 'يوليو', 'Aug': 'أغسطس', 'Sep': 'سبتمبر', 'Oct': 'أكتوبر', 'Nov': 'نوفمبر', 'Dec': 'ديسمبر'
                            }
                            return i18n.language === 'ar' ? (monthMap[label] || label) : label
                          }}
                        />
                        <Line
                          name={t('owner.chart.earnings', { defaultValue: 'Earnings' })}
                          type="monotone"
                          dataKey="earnings"
                          stroke="#3A6EA5"
                          strokeWidth={3}
                          dot={{ fill: '#3A6EA5', r: 6 }}
                        />
                      </LineChart>
                    </ResponsiveContainer>
                  </div>
                )}
                <div className="flex justify-center gap-3 mt-4">
                  {(['monthly', 'yearly'] as const).map((v) => (
                    <Button
                      key={v}
                      size="sm"
                      variant={view === v ? 'default' : 'outline'}
                      className={`rounded-xl ${view === v
                          ? 'bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white'
                          : 'bg-[#f5f7fa] hover:bg-[#3A6EA5]/10 text-[#1a1a1a] border border-[#3A6EA5]/20'
                        }`}
                      onClick={() => setView(v)}
                    >
                      {t(`owner.chart.${v}`)}
                    </Button>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Booking Requests */}
            <Card id="pending-requests" className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="text-2xl text-[#1a1a1a]">
                    {t('owner.pendingRequests.bookingRequests')}
                  </CardTitle>
                  {(dashboard?.pendingBookingRequestsCount ?? 0) > 0 && (
                    <Badge className="bg-[#3A6EA5] text-white hover:bg-[#3A6EA5]">
                      {dashboard?.pendingBookingRequestsCount} {t('owner.pendingRequests.new')}
                    </Badge>
                  )}
                </div>
              </CardHeader>
              <CardContent className="space-y-4">
                {isLoading ? (
                  Array.from({ length: 3 }).map((_, i) => (
                    <Skeleton key={i} className="h-32 w-full rounded-2xl" />
                  ))
                ) : pendingRequests.length === 0 ? (
                  <p className="text-[#4a5565] text-center py-8">
                    {t('owner.pendingRequests.noPending')}
                  </p>
                ) : (
                  <>
                  {pendingRequests.slice(0, requestsLimit).map((request) => (
                    <div
                      key={request.bookingRequestId}
                      className="bg-[#f5f7fa] rounded-2xl p-6 hover:shadow-lg transition-shadow border border-[#3A6EA5]/10"
                    >
                      <div className="flex flex-col gap-4">
                        <div className="flex items-center gap-4">
                          <Avatar className="w-14 h-14">
                            {request.renterProfileImage && (
                              <AvatarImage src={request.renterProfileImage} />
                            )}
                            <AvatarFallback>
                              {request.renterName.charAt(0)}
                            </AvatarFallback>
                          </Avatar>
                          <div className="flex-1">
                            <h3 className="font-semibold text-lg text-[#1a1a1a] mb-1">
                              {request.renterName}
                            </h3>
                            <p className="text-sm text-[#4a5565] mb-2">
                              {request.propertyTitle}
                            </p>
                            <div className="flex flex-col gap-1 text-sm">
                              <div className="flex items-center gap-1 text-[#6a7282]">
                                <Calendar className="w-4 h-4" />
                                {formatDate(request.startDate)} - {formatDate(request.endDate)}
                              </div>
                              <div className="flex items-center gap-1 text-[#6a7282]">
                                <DollarSign className="w-4 h-4" />
                                {t('owner.pendingRequests.paymentFrequency')}: {request.paymentFrequencyDisplayName}
                              </div>
                            </div>
                          </div>
                        </div>
                        <div className="flex gap-2">
                          <Button
                            size="sm"
                            disabled={accept.isPending}
                            onClick={() => handleAcceptRequest(request.bookingRequestId)}
                            className="flex-1 bg-green-600 hover:bg-green-700 text-white rounded-xl"
                          >
                            <CheckCircle className="w-4 h-4 mr-1" />
                            {t('owner.pendingRequests.accept')}
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            disabled={reject.isPending}
                            onClick={() => handleDeclineRequest(request.bookingRequestId)}
                            className="flex-1 rounded-xl border-red-500 text-red-500 hover:bg-red-500 hover:text-white"
                          >
                            <XCircle className="w-4 h-4 mr-1" />
                            {t('owner.pendingRequests.decline')}
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            asChild
                            className="rounded-xl border-[#3A6EA5]/20"
                          >
                            <Link to="/messages">
                              <MessageSquare className="w-4 h-4 mr-1" />
                              {t('owner.pendingRequests.message')}
                            </Link>
                          </Button>
                        </div>
                      </div>
                    </div>
                  ))}
                  {renderPaginationButtons(requestsLimit, setRequestsLimit, pendingRequests.length, 3)}
                  </>
                )}
              </CardContent>
            </Card>

            {/* Contracts History */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('owner.contracts.title')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {isLoading ? (
                  <Skeleton className="h-48 w-full rounded-2xl" />
                ) : (
                  <>
                  <div className="overflow-x-auto">
                    <table className="w-full">
                      <thead>
                        <tr className="border-b border-[#3A6EA5]/20">
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.contracts.contractId')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.contracts.property')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.contracts.tenant')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.contracts.status')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.contracts.expiry')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.contracts.anchoring')}
                          </th>
                          <th className="text-end py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.contracts.actions')}
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        {contracts.length === 0 ? (
                          <tr>
                            <td
                              colSpan={6}
                              className="text-center py-8 text-[#4a5565]"
                            >
                              {t('owner.contracts.noContracts')}
                            </td>
                          </tr>
                        ) : (
                          contracts.slice(0, contractsLimit).map((contract) => (
                            <tr
                              key={contract.contractId}
                              className="border-b border-[#3A6EA5]/10 hover:bg-[#f5f7fa] transition-colors"
                            >
                              <td className="py-4 px-4 font-medium">
                                <Link to={`/contract/${contract.contractId}`} className="text-[#3A6EA5] hover:underline">
                                  {contract.contractId}
                                </Link>
                              </td>
                              <td className="py-4 px-4 text-[#4a5565]">
                                {contract.propertyTitle}
                              </td>
                              <td className="py-4 px-4 text-[#4a5565]">
                                {contract.renterName}
                              </td>
                              <td className="py-4 px-4">
                                <Badge
                                  className={getContractStatusBadge(
                                    contract.contractStatus,
                                  )}
                                >
                                  {contract.contractStatusDisplayName}
                                </Badge>
                              </td>
                              <td className="py-4 px-4 text-[#4a5565]">
                                {formatDate(contract.expiryDate)}
                              </td>
                              <td className="py-4 px-4 text-[#4a5565]">
                                {contract.anchoringStatusDisplayName}
                              </td>
                              <td className="py-4 px-4 text-end">
                                <Button
                                  size="sm"
                                  variant="outline"
                                  onClick={() =>
                                    handleDownloadContract(contract.contractId.toString())
                                  }
                                  className="rounded-xl border-[#3A6EA5]/20"
                                >
                                  <Download className="w-4 h-4 mr-1" />
                                  {t('owner.contracts.download')}
                                </Button>
                              </td>
                            </tr>
                          ))
                        )}
                      </tbody>
                    </table>
                  </div>
                  {contracts.length > 0 && renderPaginationButtons(contractsLimit, setContractsLimit, contracts.length, 4)}
                  </>
                )}
              </CardContent>
            </Card>

            {/* Received Payments History */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('owner.receivedPayments.title')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {isLoading ? (
                  <Skeleton className="h-48 w-full rounded-2xl" />
                ) : (
                  <>
                  <div className="overflow-x-auto">
                    <table className="w-full">
                      <thead>
                        <tr className="border-b border-[#3A6EA5]/20">
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.receivedPayments.date')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.receivedPayments.amount')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.receivedPayments.contractId')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.receivedPayments.availableAt')}
                          </th>
                          <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">
                            {t('owner.receivedPayments.status')}
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        {receivedPayments.length === 0 ? (
                          <tr>
                            <td
                              colSpan={5}
                              className="text-center py-8 text-[#4a5565]"
                            >
                              {t('owner.receivedPayments.none')}
                            </td>
                          </tr>
                        ) : (
                          receivedPayments.slice(0, paymentsLimit).map((payment, idx) => (
                            <tr
                              key={idx}
                              className="border-b border-[#3A6EA5]/10 hover:bg-[#f5f7fa] transition-colors"
                            >
                              <td className="py-4 px-4 text-[#4a5565]">
                                {formatDate(payment.paidAt)}
                              </td>
                              <td className="py-4 px-4 text-[#1a1a1a] font-medium">
                                {i18n.language === 'ar' ? `${(payment.amountReceived).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(payment.amountReceived).toLocaleString()}`}
                              </td>
                              <td className="py-4 px-4 text-[#4a5565]">
                                {payment.contractId}
                              </td>
                              <td className="py-4 px-4 text-[#4a5565]">
                                {formatDate(payment.availableAt)}
                              </td>
                              <td className="py-4 px-4">
                                <Badge
                                  className={
                                    payment.status === 'Completed' || payment.status === 'Paid' || payment.status === 'Available'
                                      ? 'bg-green-100 text-green-700 hover:bg-green-100'
                                      : payment.status === 'Pending'
                                      ? 'bg-yellow-100 text-yellow-700 hover:bg-yellow-100'
                                      : 'bg-gray-100 text-gray-700 hover:bg-gray-100'
                                  }
                                >
                                  {payment.statusDisplayName}
                                </Badge>
                              </td>
                            </tr>
                          ))
                        )}
                      </tbody>
                    </table>
                  </div>
                  {receivedPayments.length > 0 && renderPaginationButtons(paymentsLimit, setPaymentsLimit, receivedPayments.length, 5)}
                  </>
                )}
              </CardContent>
            </Card>

            {/* Property Listings */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('owner.properties.title')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {isLoading ? (
                  <div className="space-y-4">
                    {Array.from({ length: 3 }).map((_, i) => (
                      <Skeleton key={i} className="h-36 w-full rounded-2xl" />
                    ))}
                  </div>
                ) : myProperties.length === 0 ? (
                  <p className="text-[#4a5565] text-center py-8">
                    {t('owner.properties.none')}{' '}
                    <Link
                      to="/add-property"
                      className="text-[#3A6EA5] hover:underline"
                    >
                      {t('owner.properties.addFirst')}
                    </Link>
                  </p>
                ) : (
                  <>
                  <div className="space-y-4">
                    {myProperties.slice(0, propertiesLimit).map((property) => {
                      const isFull = property.occupiedPlaces === property.totalPlaces || (property.type !== 'SharedRoom' && property.type !== 'Shared House' && property.occupiedPlaces > 0);
                      const occupancyLabel = isFull ? t('owner.properties.full') : property.occupiedPlaces > 0 ? t('owner.properties.occupiedCount', { occupied: property.occupiedPlaces, total: property.totalPlaces }) : t('owner.properties.vacant');
                      const badgeClass = isFull ? 'bg-green-100 text-green-700 hover:bg-green-100' : property.occupiedPlaces > 0 ? 'bg-blue-100 text-blue-700 hover:bg-blue-100' : 'bg-orange-100 text-orange-700 hover:bg-orange-100';

                      return (
                      <div
                        key={property.id}
                        onClick={() => navigate(`/property/${property.id}`)}
                        className="bg-[#f5f7fa] rounded-2xl p-6 hover:shadow-lg transition-shadow cursor-pointer"
                      >
                        <div className="flex gap-4">
                          <img
                            src={property.imagePath ?? ''}
                            alt={property.title}
                            className="w-32 h-32 rounded-xl object-cover"
                          />
                          <div className="flex-1">
                            <div className="flex items-start justify-between mb-2">
                              <div>
                                <h3 className="font-semibold text-lg text-[#1a1a1a] mb-1">
                                  {property.title}
                                </h3>
                                <p className="text-sm text-[#4a5565] mb-2">
                                  {property.address} • {property.typeDisplayName}
                                </p>
                              </div>
                              <Badge className={badgeClass}>
                                {occupancyLabel}
                              </Badge>
                            </div>
                            <div className="grid grid-cols-3 gap-4 mb-4">
                              <div>
                                <p className="text-xs text-[#6a7282] mb-1">
                                  {property.rentalUnitDisplayName} {t('owner.properties.monthlyRent')}
                                </p>
                                <p className="font-semibold text-[#3A6EA5]">
                                  {i18n.language === 'ar' ? `${property.price.toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${property.price.toLocaleString()}`}
                                </p>
                              </div>
                              <div>
                                <p className="text-xs text-[#6a7282] mb-1">
                                  {t('owner.properties.rating')}
                                </p>
                                <p className="text-sm text-[#1a1a1a] flex items-center gap-1">
                                  <Star className="w-4 h-4 fill-[#3A6EA5] text-[#3A6EA5]" />
                                  {property.averageRating ? property.averageRating.toFixed(1) : 'N/A'}
                                </p>
                              </div>
                              <div className="flex flex-col items-end">
                                <p className="text-xs text-[#6a7282] mb-1">
                                  <Eye className="w-3 h-3 inline mr-1" />
                                  {t('owner.properties.views', { count: property.views || 0 })}
                                </p>
                              </div>
                            </div>
                            <div className="flex justify-end gap-2" onClick={(e) => e.stopPropagation()}>
                              <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                  <Button
                                    variant="ghost"
                                    size="icon"
                                    className="rounded-xl hover:bg-[#3A6EA5]/10"
                                  >
                                    <MoreVertical className="w-4 h-4" />
                                  </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent align="end" className="w-48">
                                  <DropdownMenuItem asChild>
                                    <Link to={`/property/${property.id}`} className="w-full cursor-pointer">
                                      {t('owner.properties.viewDetails')}
                                    </Link>
                                  </DropdownMenuItem>
                                  <DropdownMenuItem asChild>
                                    <Link to={`/edit-property/${property.id}`} className="w-full cursor-pointer">
                                      {t('owner.properties.edit')}
                                    </Link>
                                  </DropdownMenuItem>
                                </DropdownMenuContent>
                              </DropdownMenu>
                            </div>
                          </div>
                        </div>
                      </div>
                    );
                    })}
                  </div>
                  {myProperties.length > 0 && renderPaginationButtons(propertiesLimit, setPropertiesLimit, myProperties.length, 3)}
                  </>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Quick Actions */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <CardTitle className="text-xl text-[#1a1a1a]">
                  {t('owner.quickActions.title')}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                <Button
                  className="w-full justify-start bg-[#f5f7fa] hover:bg-[#3A6EA5]/10 text-[#1a1a1a] rounded-xl border border-[#3A6EA5]/20"
                  variant="outline"
                  asChild
                >
                  <Link to="/messages">
                    <MessageSquare className="w-5 h-5 mr-2 text-[#3A6EA5]" />
                    {t('owner.quickActions.messages')}
                  </Link>
                </Button>
                <Button
                  className="w-full justify-start bg-[#f5f7fa] hover:bg-[#3A6EA5]/10 text-[#1a1a1a] rounded-xl border border-[#3A6EA5]/20"
                  variant="outline"
                  asChild
                >
                  <Link to="/add-property">
                    <Plus className="w-5 h-5 mr-2 text-[#3A6EA5]" />
                    {t('owner.quickActions.addProperty')}
                  </Link>
                </Button>
              </CardContent>
            </Card>

            {/* Notifications */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="text-xl text-[#1a1a1a]">
                    {t('owner.notifications.title')}
                  </CardTitle>
                  {(dashboard?.unreadNotificationsCount ?? 0) > 0 && (
                    <Badge className="bg-[#3A6EA5] text-white hover:bg-[#3A6EA5]">
                      {t('owner.notifications.unread', { count: dashboard?.unreadNotificationsCount })}
                    </Badge>
                  )}
                </div>
              </CardHeader>
              <CardContent className="space-y-3">
                {isLoading ? (
                  Array.from({ length: 4 }).map((_, i) => (
                    <Skeleton key={i} className="h-16 w-full rounded-xl" />
                  ))
                ) : !displayNotifications.length ? (
                  <p className="text-sm text-[#6a7282] text-center py-6">
                    {t('owner.notifications.none')}
                  </p>
                ) : (
                  <>
                    {displayNotifications.map((notification: any) => (
                      <div
                        key={notification.id}
                        onClick={() => handleNotificationClick(notification)}
                        className={`p-4 rounded-2xl transition-colors cursor-pointer hover:bg-[#e8eef5] ${!notification.isRead
                            ? 'bg-[#3A6EA5]/5 border border-[#3A6EA5]/20'
                            : 'bg-[#f5f7fa]'
                          }`}
                      >
                        <div className="flex items-start gap-3">
                          <div
                            className={`w-2 h-2 rounded-full mt-2 flex-shrink-0 ${!notification.isRead ? 'bg-[#3A6EA5]' : 'bg-[#6a7282]'}`}
                          />
                          <div className="flex-1 min-w-0">
                            <p className="text-sm text-[#1a1a1a] mb-1 leading-snug">
                              {notification.title}
                            </p>
                            <p className="text-xs text-[#6a7282] flex items-center gap-1">
                              <Clock className="w-3 h-3" />
                              {timeAgo(notification.createdAt)}
                            </p>
                          </div>
                        </div>
                      </div>
                    ))}
                    {(allNotifications.length > 3 || showAllNotifications) && (
                      <Button
                        variant="outline"
                        className="w-full rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white mt-2 cursor-pointer"
                        onClick={() => setShowAllNotifications(!showAllNotifications)}
                      >
                        {showAllNotifications ? t('owner.notifications.showLess') : t('owner.notifications.showAll')}
                      </Button>
                    )}
                  </>
                )}
              </CardContent>
            </Card>

            {/* Occupancy Rate */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <CardTitle className="text-xl text-[#1a1a1a]">
                  {t('owner.occupancy.title')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {isLoading ? (
                  <Skeleton className="h-48 w-full rounded-2xl" />
                ) : (
                  <>
                    <ResponsiveContainer width="100%" height={200}>
                      <PieChart>
                        <Pie
                          data={occupancyData}
                          cx="50%"
                          cy="50%"
                          innerRadius={60}
                          outerRadius={80}
                          paddingAngle={5}
                          dataKey="value"
                        >
                          {occupancyData.map((entry, index) => (
                            <Cell key={`cell-${index}`} fill={entry.color} />
                          ))}
                        </Pie>
                        <Tooltip />
                      </PieChart>
                    </ResponsiveContainer>
                    <div className="space-y-2 mt-4">
                      {occupancyData.map((item) => (
                        <div
                          key={item.name}
                          className="flex items-center justify-between"
                        >
                          <div className="flex items-center gap-2">
                            <div
                              className="w-3 h-3 rounded-full"
                              style={{ backgroundColor: item.color }}
                            />
                            <span className="text-sm text-[#1a1a1a]">
                              {item.name}
                            </span>
                          </div>
                          <span className="text-sm font-semibold text-[#1a1a1a]">
                            {item.value}
                            {totalProperties > 0 &&
                              ` (${((item.value / totalProperties) * 100).toFixed(0)}%)`}
                          </span>
                        </div>
                      ))}
                    </div>
                  </>
                )}
              </CardContent>
            </Card>

            {/* Quick Stats */}
            <Card className="bg-white border-none rounded-3xl shadow-lg shadow-black/5">
              <CardHeader>
                <CardTitle className="text-xl text-[#1a1a1a]">
                  {t('owner.quickStats.title')}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="bg-[#f5f7fa] rounded-2xl p-4">
                  <p className="text-sm text-[#6a7282] mb-1">
                    {t('owner.quickStats.totalProperties')}
                  </p>
                  <div className="text-2xl font-bold text-[#3A6EA5]">
                    {isLoading ? (
                      <Skeleton className="h-8 w-12 inline-block" />
                    ) : (
                      totalProperties
                    )}
                  </div>
                </div>
                <div className="bg-[#f5f7fa] rounded-2xl p-4">
                  <p className="text-sm text-[#6a7282] mb-1">
                    {t('owner.quickStats.pendingRequests')}
                  </p>
                  <div className="text-2xl font-bold text-[#3A6EA5]">
                    {isLoading ? (
                      <Skeleton className="h-8 w-12 inline-block" />
                    ) : (
                      (dashboard?.pendingBookingRequestsCount ?? 0)
                    )}
                  </div>
                </div>
                <div className="bg-[#f5f7fa] rounded-2xl p-4">
                  <p className="text-sm text-[#6a7282] mb-1">
                    {t('owner.quickStats.activeContracts')}
                  </p>
                  <div className="text-2xl font-bold text-[#3A6EA5] flex items-center gap-2">
                    {isLoading ? (
                      <Skeleton className="h-8 w-12 inline-block" />
                    ) : (
                      <>
                        {contracts.filter((c) => c.contractStatus === 'Active').length}
                        <Eye className="w-5 h-5" />
                      </>
                    )}
                  </div>
                </div>
                <div className="bg-[#f5f7fa] rounded-2xl p-4">
                  <p className="text-sm text-[#6a7282] mb-1">{t('owner.quickStats.averageRating')}</p>
                  <div className="text-2xl font-bold text-[#3A6EA5] flex items-center gap-2">
                    {isLoading ? (
                      <Skeleton className="h-8 w-12 inline-block" />
                    ) : (
                      <>
                        {(dashboard?.averageRating ?? 0).toFixed(1)}
                        <Star className="w-5 h-5 fill-[#3A6EA5]" />
                      </>
                    )}
                  </div>
                  <p className="text-xs text-[#6a7282] mt-1">
                    {t('owner.quickStats.reviews', { count: dashboard?.ratingsCount ?? 0 })}
                  </p>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
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
              Close
            </Button>
            {selectedNotification?.link && (
              <Button asChild className="rounded-xl bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white">
                <Link to={selectedNotification.link}>View Details</Link>
              </Button>
            )}
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
