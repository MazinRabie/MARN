import {
  CreditCard,
  Heart,
  Bell,
  Home,
  MessageSquare,
  Clock,
  FileText,
  CheckCircle,
  AlertCircle,
  Calendar,
  Download,
  PenTool,
} from 'lucide-react'
import { toast } from 'sonner'
import { contractService } from '@/services/contractService'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { Button } from '../components/ui/button'
import { PropertyCard } from '../components/PropertyCard'
import { Badge } from '../components/ui/badge'
import { Skeleton } from '../components/ui/skeleton'
import { Link } from 'react-router'
import { useAuth } from '@/hooks/useAuth'
import { useRenterDashboard } from '@/hooks/useRenterDashboard'
import { useProperties } from '@/hooks/useProperties'
import { useProfile } from '@/hooks/useProfile'
import { useQuery } from '@tanstack/react-query'
import { notificationService } from '@/services/notificationService'
import { paymentService } from '@/services/paymentService'
import { getImageUrl } from '@/constants/assets'
import { useState, useEffect } from 'react'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '../components/ui/dialog'
import { NotificationUI, mapNotification, getIcon, getBgColor } from './NotificationsPage'
import { useTranslation } from 'react-i18next'
import { PaymentModal } from '@/components/PaymentModal'

function formatDate(iso: string | undefined | null) {
  if (!iso) return '—'
  return new Date(iso).toLocaleDateString('en-EG', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

function timeAgo(iso: string | undefined | null) {
  if (!iso) return '—'
  const diff = Date.now() - new Date(iso).getTime()
  const mins = Math.floor(diff / 60_000)
  if (mins < 60) return `${mins}m ago`
  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs}h ago`
  return `${Math.floor(hrs / 24)}d ago`
}

export function TenantDashboard() {
  const { t, i18n } = useTranslation('dashboard')
  const { user } = useAuth()
  const { data: dashboardRes, isLoading: dashboardLoading, refetch: refetchDashboard } =
    useRenterDashboard()
  const { data: recommendedData, isLoading: recommendedLoading } =
    useProperties({ pageSize: 2 })
  const { data: profileRes, isLoading: profileLoading } = useProfile()
  const dashboard = dashboardRes?.data
  const unreadNotifications = dashboard?.notifications?.filter((n: any) => !n.isRead) || []

  const [contractsLimit, setContractsLimit] = useState(4)
  const [paymentsLimit, setPaymentsLimit] = useState(5)
  const [pendingLimit, setPendingLimit] = useState(3)
  const [recommendedLimit, setRecommendedLimit] = useState(4)
  const [notificationsLimit, setNotificationsLimit] = useState(5)
  const [selectedNotification, setSelectedNotification] = useState<NotificationUI | null>(null)
  const [payingScheduleId, setPayingScheduleId] = useState<number | null>(null)
  const [paymentClientSecret, setPaymentClientSecret] = useState<string | null>(null)

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
            {t('tenant.showMore', { defaultValue: 'Show More' })}
          </Button>
          <Button variant="outline" size="sm" onClick={() => setLimit(totalItems)} className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white">
            {t('tenant.showAll', { defaultValue: 'Show All' })}
          </Button>
        </div>
      );
    }
    
    return (
      <div className="flex justify-center mt-4">
        <Button variant="outline" size="sm" onClick={() => setLimit(baseLimit)} className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white">
          {t('tenant.showLess', { defaultValue: 'Show Less' })}
        </Button>
      </div>
    );
  };

  useEffect(() => {
    if (!dashboardLoading && window.location.hash) {
      const id = window.location.hash.replace('#', '')
      const element = document.getElementById(id)
      if (element) {
        setTimeout(() => element.scrollIntoView({ behavior: 'smooth' }), 100)
      }
    }
  }, [dashboardLoading])

  const [signingContractId, setSigningContractId] = useState<number | string | null>(null)

  const handlePayRent = async (scheduleId?: number) => {
    if (!scheduleId) {
      toast.error('No pending payment found for this rental')
      return
    }
    try {
      setPayingScheduleId(scheduleId)
      const res = await paymentService.startPayment({ paymentScheduleId: scheduleId })
      if (res.data?.url) {
        window.location.href = res.data.url
      } else if (typeof res.data === 'string' && res.data.includes('_secret_')) {
        setPaymentClientSecret(res.data)
      } else {
        toast.success('Payment started successfully!')
      }
    } catch (error: any) {
      toast.error(error?.message || 'Failed to start payment')
    } finally {
      setPayingScheduleId(null)
    }
  }

  const handleSignContract = async (contractId: number | string) => {
    try {
      setSigningContractId(contractId)
      await contractService.signContract(Number(contractId))
      toast.success('Contract signed successfully')
      refetchDashboard?.()
    } catch (error) {
      toast.error('Failed to sign contract')
    } finally {
      setSigningContractId(null)
    }
  }

  const handleNotificationClick = async (n: any) => {
    const mapped = mapNotification(n)
    setSelectedNotification(mapped)
    if (!mapped.isRead) {
      try {
        await notificationService.markAsRead(mapped.id)
        refetchDashboard?.()
      } catch (err) {
        console.error('Failed to mark as read', err)
      }
    }
  }

  const recommendedProperties = recommendedData?.data?.items ?? []

  const activeRental = dashboard?.activeRentals?.[0] ?? null

  return (
    <div className="min-h-screen pb-20">
      <div className="max-w-[1440px] mx-auto px-8 py-12">
        {/* Header */}
        <div className="flex items-center justify-between mb-12">
          <div>
            {profileLoading || dashboardLoading ? (
              <div className="space-y-3">
                <Skeleton className="h-10 w-64" />
                <Skeleton className="h-5 w-48" />
              </div>
            ) : (
              <>
                <h1 className="text-4xl font-bold text-[#1a1a1a]">{t('tenant.title')}</h1>
                <p className="text-[#4a5565] mt-2">
                  {t('tenant.welcome', { name: profileRes?.data?.firstName || user?.firstName || 'there' })}
                </p>
              </>
            )}
            {dashboard?.accountStatus && !dashboardLoading && (
              <Badge
                className={`mt-2 ${dashboard.accountStatus === 'Verified'
                  ? 'bg-green-100 text-green-700 border-green-200'
                  : 'bg-amber-100 text-amber-700 border-amber-200'
                  }`}
                variant="outline"
              >
                {dashboard.accountStatus === 'Verified' ? (
                  <CheckCircle className="w-3 h-3 mr-1" />
                ) : (
                  <AlertCircle className="w-3 h-3 mr-1" />
                )}
                {dashboard.accountStatusDisplayName ?? dashboard.accountStatus}
              </Badge>
            )}
          </div>
          <Button
            className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl"
            asChild
          >
            <Link to="/search">{t('tenant.findProperties')}</Link>
          </Button>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
          {/* Current Rent / Next Payment */}
          <Card className="bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] border-none text-white rounded-3xl shadow-lg shadow-[#3A6EA5]/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-white/80 mb-1">
                    {dashboard?.nextPayment?.date && new Date(dashboard.nextPayment.date).getFullYear() > 1970
                      ? t('tenant.cards.nextPaymentDue')
                      : t('tenant.cards.currentRent')}
                  </p>
                  {dashboardLoading ? (
                    <Skeleton className="h-8 w-28 bg-white/30" />
                  ) : (
                    <>
                      <p className="text-3xl font-bold">
                        {dashboard?.nextPayment?.date && new Date(dashboard.nextPayment.date).getFullYear() > 1970
                          ? formatDate(dashboard.nextPayment.date)
                          : dashboard?.nextPayment?.amount
                            ? i18n.language === 'ar' ? `${(dashboard.nextPayment.amount).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(dashboard.nextPayment.amount).toLocaleString()}`
                            : t('tenant.cards.noActiveRental')}
                      </p>
                      {dashboard?.nextPayment?.date && new Date(dashboard.nextPayment.date).getFullYear() > 1970 && (
                        <p className="text-sm text-white/70 mt-1">
                          {i18n.language === 'ar' ? `${(dashboard.nextPayment.amount ?? 0).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(dashboard.nextPayment.amount ?? 0).toLocaleString()}`} for {dashboard.nextPayment.propertyTitle || 'Property'}
                        </p>
                      )}
                    </>
                  )}
                </div>
                <CreditCard className="w-12 h-12 opacity-80" />
              </div>
            </CardContent>
          </Card>

          {/* Active Rentals */}
          <Card className="rounded-3xl shadow-lg hover:shadow-xl transition-shadow">
            <CardContent className="p-6">
              <CardTitle className="flex items-center gap-2 text-[#1a1a1a]">
                <Home className="w-5 h-5 text-[#3A6EA5]" />
                <span className="text-base">{t('tenant.cards.activeRentals')}</span>
              </CardTitle>
              <p className="text-3xl font-bold text-[#3A6EA5] mt-2">
                {dashboardLoading ? '…' : (dashboard?.activeRentalsCount ?? 0)}
              </p>
            </CardContent>
          </Card>

          {/* Saved Properties */}
          <Card className="rounded-3xl shadow-lg hover:shadow-xl transition-shadow">
            <CardContent className="p-6">
              <Link to="/saved" className="block w-full h-full">
                <CardTitle className="flex items-center gap-2 text-[#1a1a1a]">
                  <Heart className="w-5 h-5 text-[#3A6EA5]" />
                  <span className="text-base">{t('tenant.cards.savedProperties')}</span>
                </CardTitle>
                <p className="text-3xl font-bold text-[#3A6EA5] mt-2">
                  {dashboardLoading
                    ? '…'
                    : (dashboard?.savedPropertiesCount ?? 0)}
                </p>
              </Link>
            </CardContent>
          </Card>

          {/* Unread Notifications */}
          <Card className="rounded-3xl shadow-lg hover:shadow-xl transition-shadow">
            <CardContent className="p-6">
              <CardTitle className="flex items-center gap-2 text-[#1a1a1a]">
                <Bell className="w-5 h-5 text-[#3A6EA5]" />
                <span className="text-base">{t('tenant.cards.notifications')}</span>
              </CardTitle>
              <p className="text-3xl font-bold text-[#3A6EA5] mt-2">
                {dashboardLoading
                  ? '…'
                  : (dashboard?.unreadNotificationsCount ?? 0)}
              </p>
            </CardContent>
          </Card>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-8">
            {/* Active Rentals */}
            <Card className="rounded-3xl shadow-lg">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('tenant.activeRentals.title')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {dashboardLoading ? (
                  <Skeleton className="h-36 w-full rounded-2xl" />
                ) : !activeRental ? (
                  <div className="text-center py-8 text-[#4a5565]">
                    {t('tenant.activeRentals.none')}{' '}
                    <Link
                      to="/search"
                      className="text-[#3A6EA5] hover:underline"
                    >
                      {t('tenant.activeRentals.findProperty')}
                    </Link>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {dashboard!.activeRentals.map((rental, i) => {
                      const contract = dashboard!.allContracts?.find(c => c.contractId === rental.contractId)
                      const propertyId = rental.propertyId || rental.id || contract?.propertyId

                      return (
                        <div
                          key={rental.contractId || propertyId || i}
                          className="bg-[#f5f7fa] rounded-2xl p-5 flex flex-col md:flex-row gap-5"
                        >
                          {/* Image */}
                          <div className="flex-shrink-0">
                            <img
                              src={getImageUrl(rental.propertyImageUrl || '') || 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=300&auto=format&fit=crop'}
                              alt={rental.propertyTitle || rental.propertyName}
                              className="w-full md:w-36 h-48 md:h-36 object-cover rounded-xl"
                            />
                          </div>

                          {/* Content */}
                          <div className="flex-1 flex flex-col justify-between">
                            <div className="flex items-start justify-between">
                              <div>
                                <Link
                                  to={`/property/${propertyId}`}
                                  className="font-semibold text-lg text-[#1a1a1a] hover:text-[#3A6EA5] transition-colors"
                                >
                                  {rental.propertyTitle || rental.propertyName}
                                </Link>
                                <p className="text-sm text-[#6a7282] mt-1">
                                  {rental.propertyAddress || 'New Damietta, Egypt'}
                                </p>
                              </div>
                              <div className="flex gap-2">
                                <Badge className="bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white rounded-full px-3 py-0.5">
                                  {rental.contractStatusDisplayName || rental.contractStatus || 'Active'}
                                </Badge>
                                {rental.isAnchoredToBlockChain && (
                                  <Badge variant="outline" className="text-emerald-700 border-emerald-300 bg-emerald-50 rounded-full px-3 py-0.5">
                                    {rental.anchoringStatusDisplayName || rental.anchoringStatus || 'Anchored'}
                                  </Badge>
                                )}
                              </div>
                            </div>

                            <div className="flex flex-wrap md:flex-nowrap justify-between gap-y-4 mt-4 w-full">
                              <div className="flex gap-x-12">
                                <div>
                                  <p className="text-xs text-[#6a7282] mb-1">Move In</p>
                                  <p className="text-sm font-medium text-[#1a1a1a]">{formatDate(rental.startDate)}</p>
                                </div>
                                <div>
                                  <p className="text-xs text-[#6a7282] mb-1">Move Out</p>
                                  <p className="text-sm font-medium text-[#1a1a1a]">{formatDate(rental.endDate || rental.expiryDate)}</p>
                                </div>
                              </div>
                              {rental.nextPaymentScheduleDate && (
                                <div className="flex gap-x-12">
                                  <div>
                                    <p className="text-xs text-[#6a7282] mb-1">Next Payment</p>
                                    <p className="text-sm font-medium text-[#1a1a1a]">{formatDate(rental.nextPaymentScheduleDate)}</p>
                                  </div>
                                  <div>
                                    <p className="text-xs text-[#6a7282] mb-1">Status</p>
                                    <p className={`text-sm font-medium ${rental.nextPaymentScheduleStatus === 'Overdue' ? 'text-red-600' : 'text-amber-600'}`}>
                                      {rental.nextPaymentScheduleStatusDisplayName || rental.nextPaymentScheduleStatus || 'Pending'}
                                    </p>
                                  </div>
                                </div>
                              )}
                            </div>

                            <div className="flex items-end justify-between mt-4">
                              <div>
                                <p className="text-xs text-[#6a7282] mb-1">
                                  {rental.paymentFrequencyDisplayName || rental.paymentFrequency || 'Monthly'} Rent
                                </p>
                                <p className="text-xl font-bold text-[#3A6EA5]">
                                  {i18n.language === 'ar' ? `${(rental.rentAmount ?? rental.monthlyRent ?? rental.price ?? 50000).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(rental.rentAmount ?? rental.monthlyRent ?? rental.price ?? 50000).toLocaleString()}`}
                                </p>
                              </div>
                              <div className="flex gap-2">
                                <Button
                                  variant="outline"
                                  disabled={payingScheduleId === rental.nextPaymentScheduleId}
                                  onClick={() => handlePayRent(rental.nextPaymentScheduleId)}
                                  className="rounded-full border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white px-5 h-9"
                                >
                                  {payingScheduleId === rental.nextPaymentScheduleId ? t('tenant.activeRentals.processing') : t('tenant.activeRentals.payRent')}
                                </Button>
                                <Button
                                  variant="outline"
                                  size="icon"
                                  className="rounded-full border-[#d1d5db] text-[#4a5565] hover:bg-gray-100 h-9 w-9"
                                  asChild
                                >
                                  <Link to="/messages">
                                    <MessageSquare className="w-4 h-4" />
                                  </Link>
                                </Button>
                              </div>
                            </div>
                          </div>
                        </div>
                      )
                    })}
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Pending Booking Requests */}
            {(dashboardLoading ||
              (dashboard?.pendingBookingRequests?.length ?? 0) > 0) && (
                <Card className="rounded-3xl shadow-lg">
                  <CardHeader>
                    <CardTitle className="text-2xl text-[#1a1a1a]">
                      {t('tenant.pendingRequests.title')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    {dashboardLoading ? (
                      <Skeleton className="h-24 w-full rounded-2xl" />
                    ) : (
                      <div className="space-y-3">
                        {dashboard!.pendingBookingRequests.slice(0, pendingLimit).map((req, i) => (
                          <div
                            key={req.bookingRequestId || req.id || req.propertyId || i}
                            className="bg-amber-50 border border-amber-200 rounded-2xl p-4 flex items-center justify-between"
                          >
                            <div>
                              {req.ownerName && (
                                <div className="flex items-center gap-2 mb-1.5">
                                  {req.ownerProfileImage && (
                                    <img src={getImageUrl(req.ownerProfileImage)} alt={req.ownerName} className="w-5 h-5 rounded-full object-cover" />
                                  )}
                                  <span className="text-sm font-medium text-[#1a1a1a]">{req.ownerName}</span>
                                </div>
                              )}
                              <p className="font-semibold text-[#1a1a1a]">
                                {req.propertyTitle || req.propertyName}
                              </p>
                              <p className="text-xs text-[#6a7282] flex items-center gap-1 mt-1">
                                <Calendar className="w-3 h-3" />
                                {req.startDate && req.endDate
                                  ? `${formatDate(req.startDate)} - ${formatDate(req.endDate)}`
                                  : req.requestedDate
                                    ? formatDate(req.requestedDate)
                                    : '—'}
                              </p>
                              {req.paymentFrequencyDisplayName && (
                                <p className="text-xs text-[#6a7282] flex items-center gap-1 mt-1">
                                  <Clock className="w-3 h-3" />
                                  {req.paymentFrequencyDisplayName}
                                </p>
                              )}
                            </div>
                            <Badge
                              variant="outline"
                              className="text-amber-700 border-amber-300 bg-amber-100"
                            >
                              {req.status || 'Pending'}
                            </Badge>
                          </div>
                        ))}
                        {renderPaginationButtons(pendingLimit, setPendingLimit, dashboard!.pendingBookingRequests.length, 3)}
                      </div>
                    )}
                  </CardContent>
                </Card>
              )}

            {/* Recommended Properties */}
            <Card className="rounded-3xl shadow-lg">
              <CardHeader>
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('tenant.recommended.title')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {recommendedLoading ? (
                  <div className="space-y-4">
                    <Skeleton className="h-48 w-full rounded-2xl" />
                    <Skeleton className="h-48 w-full rounded-2xl" />
                  </div>
                ) : recommendedProperties.length === 0 ? (
                  <p className="text-[#4a5565] text-center py-8">
                    {t('tenant.recommended.none')}
                  </p>
                ) : (
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {recommendedProperties.slice(0, recommendedLimit).map((property, i) => (
                      <PropertyCard
                        key={property.id || i}
                        id={property.id.toString()}
                        image={getImageUrl(property.imagePath)}
                        title={property.title}
                        location={property.address}
                        price={property.price}
                        rating={property.averageRating ?? 0}
                        reviews={property.ratings ?? 0}
                        type={property.type}
                        beds={property.bedrooms}
                        baths={property.bathrooms}
                        guests={property.maxOccupants}
                        rentalUnitDisplayName={property.rentalUnitDisplayName}
                        rentalUnit={(property as any).rentalUnit}
                      />
                    ))}
                  </div>
                )}
                {!recommendedLoading && recommendedProperties.length > 0 && 
                  renderPaginationButtons(recommendedLimit, setRecommendedLimit, recommendedProperties.length, 4)
                }
              </CardContent>
            </Card>
          </div>

          {/* Sidebar */}
          <div className="space-y-8">
            {/* Notifications */}
            <Card className="rounded-3xl shadow-lg">
              <CardHeader>
                <CardTitle className="text-xl text-[#1a1a1a]">
                  {t('tenant.recentNotifications.title')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {dashboardLoading ? (
                  <div className="space-y-3">
                    <Skeleton className="h-16 w-full rounded-2xl" />
                    <Skeleton className="h-16 w-full rounded-2xl" />
                  </div>
                ) : !unreadNotifications.length ? (
                  <p className="text-sm text-[#6a7282] text-center py-6">
                    {t('tenant.recentNotifications.none')}
                  </p>
                ) : (
                  <div className="space-y-3">
                    {unreadNotifications.slice(0, notificationsLimit).map((n, i) => (
                      <div
                        key={n.id || i}
                        onClick={() => handleNotificationClick(n)}
                        className={`p-4 rounded-2xl transition-colors cursor-pointer hover:bg-[#e8eef5] ${!n.isRead
                          ? 'bg-[#3A6EA5]/5 border border-[#3A6EA5]/20'
                          : 'bg-[#f5f7fa]'
                          }`}
                      >
                        <div className="flex items-start gap-3">
                          <div
                            className={`w-2 h-2 rounded-full mt-2 flex-shrink-0 ${!n.isRead ? 'bg-[#3A6EA5]' : 'bg-[#6a7282]'
                              }`}
                          />
                          <div className="flex-1 min-w-0">
                            <p className="text-sm text-[#1a1a1a] mb-1 leading-snug">
                              {n.title}
                            </p>
                            <p className="text-xs text-[#6a7282] flex items-center gap-1">
                              <Clock className="w-3 h-3" />
                              {timeAgo(n.createdAt)}
                            </p>
                          </div>
                        </div>
                      </div>
                    ))}
                    {renderPaginationButtons(notificationsLimit, setNotificationsLimit, unreadNotifications.length, 5)}
                  </div>
                )}
              </CardContent>
            </Card>

            {/* All Contracts */}
            {(dashboardLoading ||
              (dashboard?.allContracts?.length ?? 0) > 0) && (
                <Card id="contracts" className="rounded-3xl shadow-lg">
                  <CardHeader>
                    <CardTitle className="text-xl text-[#1a1a1a]">
                      {t('tenant.contracts.title')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    {dashboardLoading ? (
                      <Skeleton className="h-20 w-full rounded-2xl" />
                    ) : (
                      <div className="space-y-3">
                        {dashboard!.allContracts.slice(0, contractsLimit).map((c, i) => (
                          <div
                            key={c.contractId || c.id || i}
                            className="bg-[#f5f7fa] rounded-2xl p-4"
                          >
                            <div className="flex items-center justify-between mb-1">
                              <Link to={`/contract/${c.contractId || c.id}`} className="text-sm font-medium text-[#3A6EA5] hover:underline">
                                {c.propertyTitle || c.propertyName}
                              </Link>
                              <div className="flex gap-2">
                                {c.isAnchoredToBlockChain && (
                                  <Badge variant="outline" className="text-emerald-700 border-emerald-300 bg-emerald-50 text-[10px] px-1.5 py-0 h-5">
                                    {c.anchoringStatusDisplayName || c.anchoringStatus || 'Anchored'}
                                  </Badge>
                                )}
                                <Badge
                                  variant="outline"
                                  className={
                                    c.contractStatus === 'Active' || c.status === 'Active'
                                      ? 'text-green-700 border-green-300 bg-green-50'
                                      : c.contractStatus === 'Pending' || c.status === 'Pending'
                                        ? 'text-yellow-700 border-yellow-300 bg-yellow-50'
                                        : 'text-[#6a7282] border-[#d1d5db]'
                                  }
                                >
                                  {c.contractStatusDisplayName || c.contractStatus || 'Active'}
                                </Badge>
                              </div>
                            </div>
                            <p className="text-xs text-[#6a7282]">
                              Expires: {formatDate(c.expiryDate || c.endDate)}
                            </p>
                            <div className="flex gap-2 mt-3">
                              <Button
                                size="sm"
                                variant="outline"
                                className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5]"
                                onClick={() => {
                                  if (c.documentUrl) {
                                    window.open(c.documentUrl, '_blank')
                                  } else {
                                    toast.success(`Downloading contract ${c.contractId || c.id}`)
                                  }
                                }}
                              >
                                <Download className="w-3 h-3 mr-1" />
                                Download
                              </Button>
                              {(c.contractStatus === 'Pending' || c.status === 'Pending') && (
                                <Button
                                  size="sm"
                                  className="rounded-xl bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white"
                                  onClick={() => handleSignContract((c.contractId || c.id)!)}
                                  disabled={signingContractId === (c.contractId || c.id)}
                                >
                                  <PenTool className="w-3 h-3 mr-1" />
                                  {signingContractId === (c.contractId || c.id) ? 'Signing...' : 'Sign'}
                                </Button>
                              )}
                            </div>
                          </div>
                        ))}
                        {renderPaginationButtons(contractsLimit, setContractsLimit, dashboard!.allContracts.length, 4)}
                      </div>
                    )}
                  </CardContent>
                </Card>
              )}

            {/* Saved Properties */}
            {(dashboardLoading ||
              (dashboard?.savedProperties?.length ?? 0) > 0) && (
                <Card className="rounded-3xl shadow-lg">
                  <CardHeader>
                    <CardTitle className="text-xl text-[#1a1a1a]">
                      {t('tenant.savedPropertiesCard.title')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    {dashboardLoading ? (
                      <div className="space-y-3">
                        <Skeleton className="h-16 w-full rounded-2xl" />
                        <Skeleton className="h-16 w-full rounded-2xl" />
                      </div>
                    ) : (
                      <>
                        <div className="space-y-3">
                          {dashboard!.savedProperties.map((p, i) => (
                            <Link
                              key={p.id || (p as any).propertyId || i}
                              to={`/property/${(p as any).propertyId || p.id}`}
                              className="flex items-center gap-3 bg-[#f5f7fa] rounded-2xl p-3 hover:bg-[#e8eef5] transition-colors"
                            >
                              <img
                                src={getImageUrl(p.imageUrl || p.imagePath || p.image || p.images?.[0] || '')}
                                alt={p.title}
                                className="w-12 h-12 rounded-xl object-cover flex-shrink-0"
                              />
                              <div className="flex-1 min-w-0">
                                <p className="text-sm font-medium text-[#1a1a1a] truncate">
                                  {p.title}
                                </p>
                                <p className="text-xs text-[#6a7282] truncate">
                                  {p.address || p.location}
                                </p>
                                <p className="text-sm font-bold text-[#3A6EA5]">
                                  {(p.price ?? 0).toLocaleString()} EGP
                                </p>
                              </div>
                            </Link>
                          ))}
                        </div>
                        <div className="mt-4">
                          <Button
                            variant="outline"
                            className="w-full rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white"
                            asChild
                          >
                            <Link to="/saved">{t('tenant.savedPropertiesCard.viewAll')}</Link>
                          </Button>
                        </div>
                      </>
                    )}
                  </CardContent>
                </Card>
              )}

            {/* Payment History */}
            {(dashboardLoading ||
              (dashboard?.paidPayments?.length ?? 0) > 0) && (
                <Card className="rounded-3xl shadow-lg">
                  <CardHeader>
                    <CardTitle className="text-xl text-[#1a1a1a]">
                      {t('tenant.paymentHistory.title')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    {dashboardLoading ? (
                      <div className="space-y-3">
                        <Skeleton className="h-16 w-full rounded-2xl" />
                        <Skeleton className="h-16 w-full rounded-2xl" />
                      </div>
                    ) : (
                      <div className="space-y-3">
                        {dashboard!.paidPayments.slice(0, paymentsLimit).map((p, i) => {
                          const contract = dashboard!.allContracts?.find(c => c.contractId === p.contractId)
                          return (
                            <div
                              key={p.id || p.transactionId || i}
                              className="bg-[#f5f7fa] rounded-2xl p-4"
                            >
                              <div className="flex items-center justify-between mb-1">
                                <p className="text-sm font-medium text-[#1a1a1a] truncate flex-1 mr-2">
                                  {p.propertyTitle || p.propertyName || contract?.propertyTitle || 'Property'}
                                </p>
                                <p className="text-sm font-bold text-green-600 flex-shrink-0">
                                  {i18n.language === 'ar' ? `${(p.amountPaid ?? p.amount ?? p.price ?? 0).toLocaleString()} ${t('currency', { ns: 'common' })}` : `${t('currency', { ns: 'common' })} ${(p.amountPaid ?? p.amount ?? p.price ?? 0).toLocaleString()}`}
                                </p>
                              </div>
                              <p className="text-xs text-[#6a7282] flex items-center gap-1">
                                <Clock className="w-3 h-3" />
                                {formatDate(p.paidAt)}
                              </p>
                            </div>
                          )
                        })}
                        {renderPaginationButtons(paymentsLimit, setPaymentsLimit, dashboard!.paidPayments.length, 5)}
                      </div>
                    )}
                  </CardContent>
                </Card>
              )}

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

      <PaymentModal 
        clientSecret={paymentClientSecret} 
        onClose={() => setPaymentClientSecret(null)} 
        onSuccess={() => {
          setPaymentClientSecret(null)
          refetchDashboard?.()
        }} 
      />
    </div>
  )
}
