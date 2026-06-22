import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { useSearchParams, Link } from 'react-router-dom'
import { Eye, Ban, UserCheck, Search, XCircle, Loader2 } from 'lucide-react'
import { Button } from '../../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../../components/ui/card'
import { Input } from '../../../components/ui/input'
import { Skeleton } from '../../../components/ui/skeleton'
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '../../../components/ui/tooltip'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../../../components/ui/tabs'
import { useAdminUsers, useAdminUserVerification } from '@/hooks/useAdminStats'
import { adminService, type AdminUserStatsItem } from '@/services/adminService'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { getStatusBadge, buildImageUrl, TruncatedTooltip } from '../utils'
import { RoleManagementView } from './RoleManagementView'
import { VerificationsTab } from './VerificationsTab'
import { useTranslation } from 'react-i18next'

export function UserManagementTab() {
  const { t, i18n } = useTranslation('admin')
  const [selectedUser, setSelectedUser] = useState<AdminUserStatsItem | null>(null)
  const [pageSize, setPageSize] = useState(10)
  const [userSearch, setUserSearch] = useState('')
  const [activeUserSearch, setActiveUserSearch] = useState('')

  const [searchParams, setSearchParams] = useSearchParams()
  const urlStatus = searchParams.get('userStatus')
  const statusFilter = (urlStatus && urlStatus !== 'Unverified') ? urlStatus : 'Pending'
  const setStatusFilter = (val: string) => {
    setSearchParams((prev) => {
      prev.set('userStatus', val)
      return prev
    }, { preventScrollReset: true })
  }
  
  useEffect(() => {
    setPageSize(10)
  }, [statusFilter])

  const [showConfirmModal, setShowConfirmModal] = useState(false)
  const [actionType, setActionType] = useState<'ban' | 'unban' | 'restore' | 'delete' | null>(null)
  const [pendingUserId, setPendingUserId] = useState<string | null>(null)

  const queryClient = useQueryClient()

  const { data: verificationDetailData, isLoading: verificationDetailLoading } = useAdminUserVerification(selectedUser?.userId ?? null)
  const verificationDetail = verificationDetailData?.data

  // Note: the backend handles "Deleted" items implicitly when IncludeDeleted is true, but since there's no native "Deleted" filter, 
  // we request All + includeDeleted, and then filter locally if statusFilter === "Deleted".
  const apiStatus = statusFilter === 'Deleted' ? 'All' : statusFilter
  const includeDeleted = statusFilter === 'Deleted' || statusFilter === 'All'

  const { data: usersData, isLoading: usersLoading, isFetching: usersFetching } = useAdminUsers(
    1,
    pageSize,
    activeUserSearch || undefined,
    apiStatus,
    includeDeleted
  )

  let users = usersData?.data?.items ?? []
  if (statusFilter === 'Deleted') {
    users = users.filter(u => u.isDeleted)
  }

  const totalCount = usersData?.data?.totalCount ?? 0

  const userAction = useMutation({
    mutationFn: ({ userId, action }: { userId: string, action: 'ban' | 'unban' | 'restore' | 'delete' }) => {
      if (action === 'ban') return adminService.banUser(userId)
      if (action === 'unban') return adminService.unbanUser(userId)
      if (action === 'delete') return adminService.deleteUser(userId)
      return adminService.restoreUser(userId)
    },
    onSuccess: () => {
      const labels: Record<string, string> = {
        ban: 'banned',
        unban: 'unbanned',
        restore: 'restored',
        delete: 'deleted',
      }
      toast.success(t('toasts.userActionSuccess', { action: labels[actionType!] ?? actionType }))
      queryClient.invalidateQueries({ queryKey: ['adminUsers'] })
      queryClient.invalidateQueries({ queryKey: ['adminRoleUsers'] })
      queryClient.invalidateQueries({ queryKey: ['adminStats'] })
      queryClient.invalidateQueries({ queryKey: ['adminUserStats'] })
      setShowConfirmModal(false)
      setPendingUserId(null)
      setSelectedUser(null)
    },
    onError: () => toast.error(t('toasts.actionFailed')),
  })

  const handleUserAction = (userId: string, action: 'ban' | 'unban' | 'restore' | 'delete') => {
    setActionType(action)
    setPendingUserId(userId)
    setShowConfirmModal(true)
  }

  const confirmUserAction = () => {
    if (pendingUserId && actionType) {
      userAction.mutate({ userId: pendingUserId, action: actionType })
    }
  }

  const activeSubTab = searchParams.get('subtab') || 'verifications'
  const handleSubTabChange = (value: string) => {
    setSearchParams((prev) => {
      if (value === 'verifications') {
        prev.delete('subtab')
      } else {
        prev.set('subtab', value)
      }
      return prev
    }, { replace: true, preventScrollReset: true })
  }

  return (
    <div className="space-y-6">
      <Tabs value={activeSubTab} onValueChange={handleSubTabChange} className="w-full" dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}>
        <TabsList className="bg-[#EEF3F9] border border-[#3A6EA5]/20 rounded-2xl p-1.5 mb-6 gap-1 shadow-md shadow-[#3A6EA5]/15 flex flex-wrap h-auto">
          <TabsTrigger value="verifications" className="rounded-xl py-2 px-5 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
            {t('tabs.verifications')}
          </TabsTrigger>
          <TabsTrigger value="users" className="rounded-xl py-2 px-5 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
            {t('users.title')}
          </TabsTrigger>
          <TabsTrigger value="roles" className="rounded-xl py-2 px-5 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
            {t('roles.title')}
          </TabsTrigger>
        </TabsList>

        <TabsContent value="users" className="mt-0">
          <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
            <CardHeader>
              <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <CardTitle className="text-2xl text-[#1a1a1a]">
                  {t('users.title')}
                </CardTitle>
                <div className="flex w-full sm:w-auto items-center gap-2">
                  <Input
                    placeholder={t('users.search')}
                    className="w-full sm:w-64 bg-white rounded-xl border-[#3A6EA5]/20"
                    value={userSearch}
                    onChange={(e) => setUserSearch(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') setActiveUserSearch(userSearch)
                    }}
                  />
                  <Button
                    size="icon"
                    className="bg-[#3A6EA5] hover:bg-[#2A527A] text-white rounded-xl flex-shrink-0"
                    onClick={() => setActiveUserSearch(userSearch)}
                  >
                    <Search className="w-4 h-4" />
                  </Button>
                </div>
              </div>
              <div className="flex flex-wrap gap-2 mt-4">
                {['Pending', 'Verified', 'Banned', 'Deleted', 'All'].map((status) => (
                  <Button
                    key={status}
                    variant={statusFilter === status ? 'default' : 'outline'}
                    size="sm"
                    className={statusFilter === status ? 'bg-[#3A6EA5] text-white rounded-xl' : 'rounded-xl border-[#3A6EA5]/20 text-[#4a5565]'}
                    onClick={() => setStatusFilter(status)}
                  >
                    {status === 'All' ? t('tabs.all') : t(`users.status.${status.toLowerCase()}`)}
                  </Button>
                ))}
              </div>
            </CardHeader>
            <CardContent>
              <TooltipProvider delayDuration={1000}>
              {!usersLoading && users.length === 0 ? (
                <div className="py-10 text-center text-[#4a5565] border-b border-[#3A6EA5]/20">
                  {t('users.noUsers')}
                </div>
              ) : (
                <div className="overflow-x-auto overflow-y-scroll max-h-[600px] border-b border-[#3A6EA5]/20">
                  <table className="w-full relative" style={{ tableLayout: 'fixed' }}>
                    <thead className="sticky top-0 bg-[#F2F4F6] z-10">
                      <tr className="border-b border-[#3A6EA5]/20">
                        <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '30%' }}>{t('table.fullName')}</th>
                        <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '25%' }}>{t('table.roles')}</th>
                        <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '20%' }}>{t('table.status')}</th>
                        <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('table.joinDate')}</th>
                        <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '10%' }}>{t('table.actions')}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {usersLoading ? (
                        Array.from({ length: 5 }).map((_, i) => (
                          <tr key={i} className="border-b border-[#3A6EA5]/10">
                            {Array.from({ length: 5 }).map((_, j) => (
                              <td key={j} className="py-4 px-4">
                                <Skeleton className="h-5 w-full rounded" />
                              </td>
                            ))}
                          </tr>
                        ))
                      ) : (
                      users.map((user) => (
                        <tr key={user.userId} className="border-b border-[#3A6EA5]/10 hover:bg-white/50 transition-colors">
                          <td className="py-4 px-4 text-[#1a1a1a] font-medium min-w-0">
                            <div className="flex flex-col min-w-0">
                              {user.accountStatusDisplayName === 'Verified' && user.roles.includes('Renter') ? (
                                <Link to={`/user/${user.userId}`} className="block w-full min-w-0" target="_blank">
                                  <TruncatedTooltip text={user.fullName ?? ''} className="hover:underline text-[#3A6EA5] font-semibold inline-block max-w-full" />
                                </Link>
                              ) : (
                                <TruncatedTooltip text={user.fullName ?? ''} className="inline-block max-w-full" />
                              )}
                              <TruncatedTooltip text={user.email} className="text-xs text-[#4a5565] font-normal max-w-full inline-block" />
                            </div>
                          </td>
                          <td className="py-4 px-4 text-[#4a5565]">
                            <div className="flex flex-wrap gap-1">
                              {user.rolesDisplayNames.map(role => (
                                <span key={role} className="px-2 py-1 bg-gray-200 text-gray-700 text-xs rounded-lg font-medium">
                                  {role}
                                </span>
                              ))}
                            </div>
                          </td>
                          <td className="py-4 px-4">
                            <div className="flex gap-2">
                              {getStatusBadge(user.accountStatusDisplayName)}
                              {user.isDeleted && (
                                <span className="px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-700">
                                  {t('userModal.deleted')}
                                </span>
                              )}
                            </div>
                          </td>
                          <td className="py-4 px-4 text-[#4a5565]">
                            {new Date(user.createdAt).toLocaleDateString('en-GB')}
                          </td>
                          <td className="py-4 px-4">
                            <TooltipProvider delayDuration={700}>
                              <div className="flex gap-2 justify-start">
                                <Tooltip>
                                  <TooltipTrigger asChild>
                                    <Button
                                      size="icon"
                                      variant="outline"
                                      className="rounded-xl border-[#3A6EA5]/20 w-8 h-8 shrink-0"
                                      onClick={() => setSelectedUser(user)}
                                    >
                                      <Eye className="w-4 h-4" />
                                    </Button>
                                  </TooltipTrigger>
                                  <TooltipContent>
                                    <p>{t('table.view')}</p>
                                  </TooltipContent>
                                </Tooltip>
                                {user.isDeleted ? (
                                  <Tooltip>
                                    <TooltipTrigger asChild>
                                      <Button
                                        size="icon"
                                        variant="outline"
                                        className="border-[#00A650] text-[#00A650] hover:bg-[#00A650] hover:text-white rounded-xl w-8 h-8 shrink-0"
                                        onClick={() => handleUserAction(user.userId, 'restore')}
                                      >
                                        <UserCheck className="w-4 h-4" />
                                      </Button>
                                    </TooltipTrigger>
                                    <TooltipContent>
                                      <p>{t('table.restore')}</p>
                                    </TooltipContent>
                                  </Tooltip>
                                ) : (
                                  <>
                                    {user.accountStatus === 'Banned' ? (
                                      <Tooltip>
                                        <TooltipTrigger asChild>
                                          <Button
                                            size="icon"
                                            variant="outline"
                                            className="border-[#00A650] text-[#00A650] hover:bg-[#00A650] hover:text-white rounded-xl w-8 h-8 shrink-0"
                                            onClick={() => handleUserAction(user.userId, 'unban')}
                                          >
                                            <UserCheck className="w-4 h-4" />
                                          </Button>
                                        </TooltipTrigger>
                                        <TooltipContent>
                                          <p>{t('table.unban')}</p>
                                        </TooltipContent>
                                      </Tooltip>
                                    ) : (
                                      <Tooltip>
                                        <TooltipTrigger asChild>
                                          <span className="inline-block">
                                            <Button
                                              size="icon"
                                              variant="outline"
                                              className="border-red-500 text-red-500 hover:bg-red-500 hover:text-white rounded-xl w-8 h-8 shrink-0"
                                              disabled={user.roles.includes('Admin')}
                                              onClick={() => handleUserAction(user.userId, 'ban')}
                                            >
                                              <Ban className="w-4 h-4" />
                                            </Button>
                                          </span>
                                        </TooltipTrigger>
                                        <TooltipContent>
                                          {user.roles.includes('Admin') ? <p>{t('table.adminNoBan')}</p> : <p>{t('table.ban')}</p>}
                                        </TooltipContent>
                                      </Tooltip>
                                    )}
                                    <Tooltip>
                                      <TooltipTrigger asChild>
                                        <span className="inline-block">
                                          <Button
                                            size="icon"
                                            variant="outline"
                                            className="border-[#FF4D4F] text-[#FF4D4F] hover:bg-[#FF4D4F] hover:text-white rounded-xl w-8 h-8 shrink-0"
                                            disabled={user.roles.includes('Admin')}
                                            onClick={() => handleUserAction(user.userId, 'delete')}
                                          >
                                            <XCircle className="w-4 h-4" />
                                          </Button>
                                        </span>
                                      </TooltipTrigger>
                                      <TooltipContent>
                                        {user.roles.includes('Admin') ? <p>{t('table.adminNoDelete')}</p> : <p>{t('table.delete')}</p>}
                                      </TooltipContent>
                                    </Tooltip>
                                  </>
                                )}
                              </div>
                            </TooltipProvider>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                  {totalCount > users.length && (
                    <tfoot>
                      <tr>
                        <td colSpan={5}>
                          <div className="py-6 flex justify-center items-center min-h-[40px]">
                            {usersFetching ? (
                              <Loader2 className="w-6 h-6 animate-spin text-[#3A6EA5]" />
                            ) : (
                              <Button
                                variant="outline"
                                className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white"
                                onClick={() => setPageSize((p) => p + 10)}
                              >
                                {t('table.showMore')}
                              </Button>
                            )}
                          </div>
                        </td>
                      </tr>
                    </tfoot>
                  )}
                </table>
              </div>
              )}
              </TooltipProvider>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="roles" className="mt-0">
          <RoleManagementView />
        </TabsContent>

        <TabsContent value="verifications" className="mt-0">
          <VerificationsTab />
        </TabsContent>
      </Tabs>

      {/* User Detail Modal */}
      {selectedUser && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4" onClick={() => setSelectedUser(null)}>
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-3xl p-8 max-w-2xl w-full shadow-2xl max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-start justify-between mb-6">
              <div className="flex items-center gap-4">
                {selectedUser.profileImage ? (
                  <img src={selectedUser.profileImage} alt={selectedUser.fullName || 'User'} className="w-14 h-14 rounded-2xl object-cover shrink-0" />
                ) : (
                  <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center text-white text-xl font-bold shrink-0">
                    {(selectedUser.fullName || selectedUser.email || '?').charAt(0).toUpperCase()}
                  </div>
                )}
                <div>
                  <h3 className="text-2xl font-bold text-[#1a1a1a]">
                    {selectedUser.fullName || 'Unknown User'}
                  </h3>
                  <p className="text-sm text-[#4a5565] mt-0.5">
                    {selectedUser.email}
                  </p>
                  <div className="flex items-center gap-2 mt-1.5">
                    {getStatusBadge(selectedUser.accountStatusDisplayName)}
                    {selectedUser.rolesDisplayNames.length > 0 && (
                      <span className="px-3 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-700">
                        {selectedUser.rolesDisplayNames.join(', ')}
                      </span>
                    )}
                    {selectedUser.isDeleted && (
                      <span className="px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-700">
                        {t('userModal.deleted')}
                      </span>
                    )}
                  </div>
                </div>
              </div>
              <Button size="sm" variant="outline" className="rounded-xl border-[#3A6EA5]/20 shrink-0" onClick={() => setSelectedUser(null)}>
                <XCircle className="w-4 h-4" />
              </Button>
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6 text-sm">
              <div className="bg-[#F2F4F6] rounded-2xl p-4 sm:col-span-2">
                <p className="text-[#4a5565] mb-1">{t('userModal.joined')}</p>
                <p className="font-semibold text-[#1a1a1a]">{new Date(selectedUser.createdAt).toLocaleDateString('en-GB')}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4 sm:col-span-2">
                <p className="text-[#4a5565] mb-1">{t('userModal.userId')}</p>
                <p className="font-mono text-xs font-semibold text-[#1a1a1a] break-all">{selectedUser.userId}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('userModal.properties')}</p>
                <p className="font-semibold text-[#1a1a1a]">{selectedUser.ownedPropertiesCount}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('userModal.activeContracts')}</p>
                <p className="font-semibold text-[#1a1a1a]">{selectedUser.activeContractsCount}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('userModal.totalPaid')}</p>
                <p className="font-semibold text-[#1a1a1a]">{t('currency', { ns: 'common' })} {(selectedUser.totalPaidAmount ?? 0).toLocaleString()}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('userModal.totalReceived')}</p>
                <p className="font-semibold text-[#1a1a1a]">{t('currency', { ns: 'common' })} {(selectedUser.totalReceivedAmount ?? 0).toLocaleString()}</p>
              </div>
            </div>

            {/* Identity Verification Details */}
            {(verificationDetailLoading || verificationDetail) && (
              <>
                <h4 className="font-semibold text-lg text-[#1a1a1a] mb-4">{t('verificationModal.title')}</h4>
                <div className="grid grid-cols-2 gap-4 mb-6 text-sm">
                  {verificationDetailLoading ? (
                    Array.from({ length: 4 }).map((_, i) => (
                      <div key={i} className="bg-[#F2F4F6] rounded-2xl p-4 space-y-2">
                        <Skeleton className="h-3 w-20 rounded" />
                        <Skeleton className="h-5 w-32 rounded" />
                      </div>
                    ))
                  ) : (
                    <>
                      <div className="bg-[#F2F4F6] rounded-2xl p-4">
                        <p className="text-[#4a5565] mb-1">{t('verificationModal.nationalId')}</p>
                        <p className="font-mono font-semibold text-[#1a1a1a]">{verificationDetail?.nationalIDNumber ?? '—'}</p>
                      </div>
                      <div className="bg-[#F2F4F6] rounded-2xl p-4">
                        <p className="text-[#4a5565] mb-1">{t('verificationModal.birthDate')}</p>
                        <p className="font-semibold text-[#1a1a1a]">
                          {verificationDetail?.birthDate ? new Date(verificationDetail.birthDate).toLocaleDateString('en-GB') : '—'}
                        </p>
                      </div>
                      <div className="bg-[#F2F4F6] rounded-2xl p-4">
                        <p className="text-[#4a5565] mb-1">{t('verificationModal.gender')}</p>
                        <p className="font-semibold text-[#1a1a1a] capitalize">{verificationDetail?.gender?.toLowerCase() ?? '—'}</p>
                      </div>
                      <div className="bg-[#F2F4F6] rounded-2xl p-4">
                        <p className="text-[#4a5565] mb-1">{t('verificationModal.arabicAddress')}</p>
                        <p className="font-semibold text-[#1a1a1a]" dir="rtl">{verificationDetail?.arabicAddress ?? '—'}</p>
                      </div>
                      <div className="bg-[#F2F4F6] rounded-2xl p-4">
                        <p className="text-[#4a5565] mb-1">{t('verificationModal.phone')}</p>
                        <p className="font-semibold text-[#1a1a1a]">{verificationDetail?.phoneNumber ?? '—'}</p>
                      </div>
                    </>
                  )}
                </div>

                <div className="grid grid-cols-2 gap-4 mb-6">
                  {verificationDetailLoading ? (
                    Array.from({ length: 2 }).map((_, i) => (
                      <div key={i}>
                        <Skeleton className="h-4 w-16 rounded mb-2" />
                        <Skeleton className="h-32 w-full rounded-2xl" />
                      </div>
                    ))
                  ) : (
                    [
                      { label: t('verificationModal.frontId'), src: buildImageUrl(verificationDetail?.frontIdPhoto ?? null) },
                      { label: t('verificationModal.backId'), src: buildImageUrl(verificationDetail?.backIdPhoto ?? null) },
                    ].map(({ label, src }) => (
                      <div key={label}>
                        <p className="text-sm text-[#4a5565] mb-2 font-medium">{label}</p>
                        {src ? (
                          <img src={src} alt={label} className="w-full rounded-2xl border border-[#3A6EA5]/20 object-cover max-h-48 cursor-pointer hover:opacity-90 transition-opacity" onClick={() => window.open(src, '_blank')} />
                        ) : (
                          <div className="w-full rounded-2xl border border-dashed border-[#3A6EA5]/30 bg-[#F2F4F6] flex items-center justify-center h-32 text-[#4a5565] text-sm">{t('verificationModal.noImage')}</div>
                        )}
                      </div>
                    ))
                  )}
                </div>
              </>
            )}

            <div className="flex gap-3">
              {selectedUser.isDeleted ? (
                <Button className="flex-1 bg-green-600 hover:bg-green-700 text-white rounded-xl" disabled={userAction.isPending} onClick={() => handleUserAction(selectedUser.userId, 'restore')}>
                  <UserCheck className="w-4 h-4 mr-2" /> {t('table.restore')}
                </Button>
              ) : (
                <>
                  {selectedUser.accountStatus === 'Banned' ? (
                    <Button className="flex-1 bg-green-600 hover:bg-green-700 text-white rounded-xl" disabled={userAction.isPending} onClick={() => handleUserAction(selectedUser.userId, 'unban')}>
                      <UserCheck className="w-4 h-4 mr-2" /> {t('users.actions.unban')}
                    </Button>
                  ) : !selectedUser.roles.includes('Admin') ? (
                    <Button variant="outline" className="flex-1 border-[#FF4D4F] text-[#FF4D4F] hover:bg-[#FF4D4F] hover:text-white rounded-xl" disabled={userAction.isPending} onClick={() => handleUserAction(selectedUser.userId, 'ban')}>
                      <Ban className="w-4 h-4 mr-2" /> {t('users.actions.ban')}
                    </Button>
                  ) : null}
                  {!selectedUser.roles.includes('Admin') && (
                    <Button variant="outline" className="flex-1 border-[#FF4D4F] text-[#FF4D4F] hover:bg-[#FF4D4F] hover:text-white rounded-xl" disabled={userAction.isPending} onClick={() => handleUserAction(selectedUser.userId, 'delete')}>
                      <XCircle className="w-4 h-4 mr-2" /> {t('table.delete')}
                    </Button>
                  )}
                </>
              )}
              <Button variant="outline" className="rounded-xl border-[#3A6EA5]/20" onClick={() => setSelectedUser(null)}>
                {t('userModal.close')}
              </Button>
            </div>
          </motion.div>
        </div>
      )}

      {/* Confirmation Modal */}
      {showConfirmModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="bg-white rounded-3xl p-8 max-w-md w-full shadow-2xl">
            <h3 className="text-2xl font-bold text-[#1a1a1a] mb-4">{t('confirmModal.title')}</h3>
            <p className="text-[#4a5565] mb-6">
              {t('confirmModal.messageUser', { action: t(`confirmModal.actions.${actionType}`) })}
              {actionType === 'delete' && ' ' + t('confirmModal.deleteWarning')}
              {' '}{t('confirmModal.reversibleWarning')}
            </p>
            <div className="flex gap-4">
              <Button variant="outline" className="flex-1 rounded-xl border-[#3A6EA5]/20" onClick={() => setShowConfirmModal(false)}>
                {t('confirmModal.cancel')}
              </Button>
              <Button
                className="flex-1 bg-[#FF4D4F] hover:bg-[#E04343] text-white rounded-xl" disabled={userAction.isPending} onClick={confirmUserAction}>
                {userAction.isPending ? t('confirmModal.processing') : t('confirmModal.confirm')}
              </Button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  )
}
