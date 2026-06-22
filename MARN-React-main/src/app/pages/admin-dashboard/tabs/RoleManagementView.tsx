import { useState } from 'react'
import { motion } from 'framer-motion'
import { Loader2, Search, ShieldCheck } from 'lucide-react'
import { Button } from '../../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../../components/ui/card'
import { Input } from '../../../components/ui/input'
import { Skeleton } from '../../../components/ui/skeleton'
import { Checkbox } from '../../../components/ui/checkbox'
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '../../../components/ui/tooltip'
import { useAdminRoleUsers, useAdminRoles, useUpdateUserRoles } from '@/hooks/useAdminStats'
import { getStatusBadge } from '../utils'
import { useTranslation } from 'react-i18next'

export function RoleManagementView() {
  const { t } = useTranslation('admin')
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [search, setSearch] = useState('')
  const [activeSearch, setActiveSearch] = useState('')

  const { data: rolesData } = useAdminRoles()
  const { data: roleUsersData, isLoading, isFetching } = useAdminRoleUsers(page, pageSize, activeSearch || undefined)
  const updateRolesMutation = useUpdateUserRoles()

  const assignableRoles = rolesData?.data?.filter(r => r.isAssignable) || []
  const protectedRoles = rolesData?.data?.filter(r => r.isProtected) || []
  const protectedRoleNames = protectedRoles.map(r => r.roleName)

  const users = roleUsersData?.data?.items || []
  const totalCount = roleUsersData?.data?.totalCount || 0

  const [selectedUserId, setSelectedUserId] = useState<string | null>(null)
  const [selectedRoles, setSelectedRoles] = useState<string[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)

  const openRolesModal = (userId: string, currentRoles: string[]) => {
    setSelectedUserId(userId)
    // Only pre-select assignable roles
    setSelectedRoles(currentRoles.filter(r => assignableRoles.some(ar => ar.roleName === r)))
    setIsModalOpen(true)
  }

  const handleUpdateRoles = () => {
    if (!selectedUserId) return
    const userToUpdate = users.find(u => u.userId === selectedUserId)
    const currentProtected = userToUpdate?.roles.filter(r => protectedRoleNames.includes(r)) || []
    
    // Combine selected assignable roles with existing protected roles
    const finalRoles = [...selectedRoles, ...currentProtected]
    
    updateRolesMutation.mutate({ userId: selectedUserId, roles: finalRoles }, {
      onSuccess: () => {
        setIsModalOpen(false)
        setSelectedUserId(null)
      }
    })
  }

  return (
    <div className="space-y-6">
      <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
        <CardHeader>
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <CardTitle className="text-2xl text-[#1a1a1a]">
              {t('roles.title')}
            </CardTitle>
            <div className="flex w-full sm:w-auto items-center gap-2">
              <Input
                placeholder={t('roles.search')}
                className="w-full sm:w-64 bg-white rounded-xl border-[#3A6EA5]/20"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') {
                    setActiveSearch(search)
                    setPage(1)
                  }
                }}
              />
              <Button
                size="icon"
                className="bg-[#3A6EA5] hover:bg-[#2A527A] text-white rounded-xl flex-shrink-0"
                onClick={() => {
                  setActiveSearch(search)
                  setPage(1)
                }}
              >
                <Search className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          {!isLoading && users.length === 0 ? (
            <div className="py-10 text-center text-[#4a5565]">
              {t('roles.noRoles')}
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-[#F2F4F6]">
                  <tr className="border-b border-[#3A6EA5]/20">
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">{t('table.fullName')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">{t('table.roles')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">{t('table.status')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold">{t('table.actions')}</th>
                  </tr>
                </thead>
                <tbody>
                  {isLoading ? (
                    Array.from({ length: 5 }).map((_, i) => (
                      <tr key={i} className="border-b border-[#3A6EA5]/10">
                        {Array.from({ length: 4 }).map((_, j) => (
                          <td key={j} className="py-4 px-4">
                            <Skeleton className="h-5 w-full rounded" />
                          </td>
                        ))}
                      </tr>
                    ))
                  ) : (
                  users.map((user) => (
                    <tr key={user.userId} className="border-b border-[#3A6EA5]/10 hover:bg-white/50 transition-colors">
                      <td className="py-4 px-4 text-[#1a1a1a] font-medium">
                        <div className="flex flex-col">
                          <span>{user.fullName}</span>
                          <span className="text-xs text-[#4a5565] font-normal">{user.email}</span>
                        </div>
                      </td>
                      <td className="py-4 px-4 text-[#4a5565]">
                        <div className="flex flex-wrap gap-1">
                          {user.rolesDisplayNames.map(role => (
                            <span key={role} className="px-2 py-1 bg-blue-100 text-blue-700 text-xs rounded-lg font-medium">
                              {role}
                            </span>
                          ))}
                        </div>
                      </td>
                      <td className="py-4 px-4">
                        <div className="flex gap-2">
                          {getStatusBadge(user.accountStatusDisplayName)}
                          {user.isDeleted && (
                            <span className="px-3 py-1 rounded-full text-xs font-semibold bg-gray-200 text-gray-600">
                              {t('userModal.deleted')}
                            </span>
                          )}
                        </div>
                      </td>
                      <td className="py-4 px-4">
                        <TooltipProvider delayDuration={700}>
                          <Tooltip>
                            <TooltipTrigger asChild>
                              <span className="inline-block">
                                <Button
                                  size="icon"
                                  variant="outline"
                                  className="border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white rounded-xl w-8 h-8 shrink-0"
                                  disabled={user.isDeleted || user.accountStatus === 'Banned'}
                                  onClick={() => openRolesModal(user.userId, user.roles)}
                                >
                                  <ShieldCheck className="w-4 h-4" />
                                </Button>
                              </span>
                            </TooltipTrigger>
                            <TooltipContent>
                              {user.isDeleted || user.accountStatus === 'Banned' 
                                ? <p>{t('roles.cannotEditDeleted')}</p> 
                                : <p>{t('roles.updateRoles')}</p>}
                            </TooltipContent>
                          </Tooltip>
                        </TooltipProvider>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
          )}
          {totalCount > users.length && (
            <div className="mt-4 flex justify-center items-center min-h-[40px]">
              {isFetching ? (
                <Loader2 className="w-6 h-6 animate-spin text-[#3A6EA5]" />
              ) : (
                <Button
                  variant="outline"
                  className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white"
                  onClick={() => setPageSize((p) => p + 20)}
                >
                  {t('table.showMore')}
                </Button>
              )}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Roles Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-3xl p-8 max-w-md w-full shadow-2xl"
          >
            <h3 className="text-2xl font-bold text-[#1a1a1a] mb-2">{t('roles.updateRoles')}</h3>
            <p className="text-[#4a5565] mb-6 text-sm">
              {t('roles.updateDescription')}
            </p>
            <div className="space-y-3 mb-6">
              {assignableRoles.map((role) => (
                <label key={role.roleName} className="flex items-center gap-3 cursor-pointer p-3 rounded-xl hover:bg-[#F2F4F6] transition-colors">
                  <Checkbox
                    checked={selectedRoles.includes(role.roleName)}
                    onCheckedChange={(checked) =>
                      setSelectedRoles(
                        checked
                          ? [...selectedRoles, role.roleName]
                          : selectedRoles.filter((r) => r !== role.roleName)
                      )
                    }
                  />
                  <span className="text-[#1a1a1a] font-medium">{role.roleNameDisplayName || role.roleName}</span>
                </label>
              ))}
            </div>
            <div className="flex gap-4">
              <Button
                variant="outline"
                className="flex-1 rounded-xl border-[#3A6EA5]/20"
                onClick={() => {
                  setIsModalOpen(false)
                  setSelectedUserId(null)
                  setSelectedRoles([])
                }}
              >
                {t('roles.cancel')}
              </Button>
              <Button
                className="flex-1 bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl"
                disabled={updateRolesMutation.isPending}
                onClick={handleUpdateRoles}
              >
                {updateRolesMutation.isPending ? t('roles.saving') : t('roles.saveRoles')}
              </Button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  )
}
