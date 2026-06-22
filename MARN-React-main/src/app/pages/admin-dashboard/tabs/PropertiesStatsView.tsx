import { useState, useRef } from 'react'
import { motion } from 'framer-motion'
import { useSearchParams } from 'react-router-dom'
import { Eye, Search, XCircle, Trash2, RotateCcw, Loader2, Building } from 'lucide-react'
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
import { useAdminProperties, useRestoreProperty, useDeleteProperty } from '@/hooks/useAdminStats'
import { getStatusBadge, TruncatedTooltip } from '../utils'
import type { AdminPropertyStatsItem } from '@/services/adminService'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

export function PropertiesStatsView() {
  const { t } = useTranslation('admin')
  const [pageSize, setPageSize] = useState(20)
  const [search, setSearch] = useState('')
  const [activeSearch, setActiveSearch] = useState('')

  const [searchParams, setSearchParams] = useSearchParams()
  const statusFilter = searchParams.get('propertyStatus') || 'All'
  const setStatusFilter = (val: string) => {
    setSearchParams((prev) => {
      prev.set('propertyStatus', val)
      return prev
    }, { preventScrollReset: true })
  }

  const { data: propertiesData, isLoading, isFetching } = useAdminProperties(
    1,
    pageSize,
    activeSearch || undefined,
    statusFilter === 'All' ? undefined : statusFilter
  )

  const properties = propertiesData?.data?.properties?.items || []
  const totalCount = propertiesData?.data?.properties?.totalCount || 0

  const deletePropertyMutation = useDeleteProperty()
  const restorePropertyMutation = useRestoreProperty()

  const [showConfirmModal, setShowConfirmModal] = useState(false)
  const [pendingAction, setPendingAction] = useState<'delete' | 'restore' | null>(null)
  const [pendingPropertyId, setPendingPropertyId] = useState<number | null>(null)

  const handleAction = (propertyId: number, action: 'delete' | 'restore') => {
    setPendingPropertyId(propertyId)
    setPendingAction(action)
    setShowConfirmModal(true)
  }

  const confirmAction = () => {
    if (!pendingPropertyId || !pendingAction) return
    if (pendingAction === 'delete') {
      deletePropertyMutation.mutate(pendingPropertyId, {
        onSuccess: () => {
          setShowConfirmModal(false)
          setPendingPropertyId(null)
          setPendingAction(null)
        }
      })
    } else {
      restorePropertyMutation.mutate(pendingPropertyId, {
        onSuccess: () => {
          setShowConfirmModal(false)
          setPendingPropertyId(null)
          setPendingAction(null)
        }
      })
    }
  }

  return (
    <div className="space-y-6">
      <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
        <CardHeader>
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <CardTitle className="text-2xl text-[#1a1a1a]">
              {t('tabs.properties')}
            </CardTitle>
            <div className="flex w-full sm:w-auto items-center gap-2">
              <Input
                placeholder={t('properties.search')}
                className="w-full sm:w-64 bg-white rounded-xl border-[#3A6EA5]/20"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') setActiveSearch(search)
                }}
              />
              <Button
                size="icon"
                className="bg-[#3A6EA5] hover:bg-[#2A527A] text-white rounded-xl flex-shrink-0"
                onClick={() => setActiveSearch(search)}
              >
                <Search className="w-4 h-4" />
              </Button>
            </div>
          </div>
          <div className="flex flex-wrap gap-2 mt-4">
            {['All', 'Pending', 'Verified', 'Declined'].map((status) => (
              <Button
                key={status}
                variant={statusFilter === status ? 'default' : 'outline'}
                size="sm"
                className={statusFilter === status ? 'bg-[#3A6EA5] text-white rounded-xl' : 'rounded-xl border-[#3A6EA5]/20 text-[#4a5565]'}
                onClick={() => setStatusFilter(status)}
              >
                {status === 'All' ? t('tabs.all') : status === 'Pending' ? t('verifications.pending') : status === 'Verified' ? t('properties.verified') : t('properties.declined')}
              </Button>
            ))}
          </div>
        </CardHeader>
        <CardContent>
          <TooltipProvider delayDuration={1000}>
            {!isLoading && properties.length === 0 ? (
              <div className="py-10 text-center text-[#4a5565]">
                {t('properties.noProperties')}
              </div>
            ) : (
              <div className="overflow-x-auto overflow-y-scroll max-h-[600px] border-b border-[#3A6EA5]/20">
                <table className="w-full relative" style={{ tableLayout: 'fixed' }}>
                  <thead className="sticky top-0 bg-[#F2F4F6] z-10">
                    <tr className="border-b border-[#3A6EA5]/20">
                      <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '22%' }}>{t('table.property')}</th>
                      <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('table.owner')}</th>
                      <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '12%' }}>{t('table.type')}</th>
                      <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('table.location')}</th>
                      <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '13%' }}>{t('table.submitted')}</th>
                      <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '12%' }}>{t('table.status')}</th>
                      <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '11%' }}>{t('table.actions')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {isLoading ? (
                      Array.from({ length: 5 }).map((_, i) => (
                        <tr key={i} className="border-b border-[#3A6EA5]/10">
                          {Array.from({ length: 7 }).map((_, j) => (
                            <td key={j} className="py-4 px-4">
                              <Skeleton className="h-5 w-full rounded" />
                            </td>
                          ))}
                        </tr>
                      ))
                    ) : (
                    properties.map((item: AdminPropertyStatsItem) => (
                      <tr key={item.propertyId} className="border-b border-[#3A6EA5]/10 hover:bg-white/50 transition-colors">
                        <td className="py-4 px-4 text-[#1a1a1a] font-medium">
                          <div className="flex items-center gap-3 min-w-0">
                            <div className="w-10 h-10 rounded-xl bg-[#3A6EA5]/10 flex items-center justify-center shrink-0">
                              <Building className="w-5 h-5 text-[#3A6EA5]" />
                            </div>
                            <div className="min-w-0">
                              <TruncatedTooltip text={item.title} className="font-medium" />
                              <div className="text-xs text-[#4a5565] truncate">{item.cityDisplayName}</div>
                            </div>
                          </div>
                        </td>
                        <td className="py-4 px-4">
                          <TruncatedTooltip text={item.ownerName} className="text-[#1a1a1a] font-medium" />
                        </td>
                        <td className="py-4 px-4 text-[#4a5565]">
                          <TruncatedTooltip text={item.typeDisplayName} />
                        </td>
                        <td className="py-4 px-4 text-[#4a5565]">
                          <TruncatedTooltip text={item.governorateDisplayName} />
                        </td>
                        <td className="py-4 px-4 text-[#4a5565]">
                          {new Date(item.createdAt).toLocaleDateString('en-GB')}
                        </td>
                        <td className="py-4 px-4">
                          <div className="flex gap-2">
                            {getStatusBadge(item.statusDisplayName)}
                            {item.isDeleted && (
                              <span className="px-3 py-1 rounded-full text-xs font-semibold bg-gray-200 text-gray-600">
                                {t('userModal.deleted')}
                              </span>
                            )}
                          </div>
                        </td>
                        <td className="py-4 px-4">
                          <TooltipProvider delayDuration={300}>
                            <div className="flex gap-2 justify-start">
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <Link to={item.isDeleted ? '#' : `/admin/property/${item.propertyId}`} className={item.isDeleted ? 'pointer-events-none' : ''}>
                                    <Button size="icon" variant="outline" className={`rounded-xl border-[#3A6EA5]/20 w-8 h-8 shrink-0 ${item.isDeleted ? 'opacity-50' : ''}`} disabled={item.isDeleted}>
                                      <Eye className="w-4 h-4" />
                                    </Button>
                                  </Link>
                                </TooltipTrigger>
                                <TooltipContent><p>{t('table.view')}</p></TooltipContent>
                              </Tooltip>
                              {item.isDeleted ? (
                                <Tooltip>
                                  <TooltipTrigger asChild>
                                    <Button
                                      size="icon"
                                      variant="outline"
                                      className="border-[#00A650] text-[#00A650] hover:bg-[#00A650] hover:text-white rounded-xl w-8 h-8 shrink-0"
                                      disabled={restorePropertyMutation.isPending}
                                      onClick={() => handleAction(item.propertyId, 'restore')}
                                    >
                                      <RotateCcw className="w-4 h-4" />
                                    </Button>
                                  </TooltipTrigger>
                                  <TooltipContent><p>{t('table.restore')}</p></TooltipContent>
                                </Tooltip>
                              ) : (
                                <Tooltip>
                                  <TooltipTrigger asChild>
                                    <Button
                                      size="icon"
                                      variant="outline"
                                      className="border-[#FF4D4F] text-[#FF4D4F] hover:bg-[#FF4D4F] hover:text-white rounded-xl w-8 h-8 shrink-0"
                                      disabled={deletePropertyMutation.isPending}
                                      onClick={() => handleAction(item.propertyId, 'delete')}
                                    >
                                      <Trash2 className="w-4 h-4" />
                                    </Button>
                                  </TooltipTrigger>
                                  <TooltipContent><p>{t('table.delete')}</p></TooltipContent>
                                </Tooltip>
                              )}
                            </div>
                          </TooltipProvider>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
            )}
          </TooltipProvider>
          {totalCount > properties.length && (
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

      {showConfirmModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-3xl p-8 max-w-md w-full shadow-2xl"
          >
            <h3 className="text-2xl font-bold text-[#1a1a1a] mb-4">
              {t('confirmModal.title')}
            </h3>
            <p className="text-[#4a5565] mb-6">
              {t('confirmModal.message', { action: pendingAction })}
            </p>
            <div className="flex gap-4">
              <Button
                variant="outline"
                className="flex-1 rounded-xl border-[#3A6EA5]/20"
                onClick={() => {
                  setShowConfirmModal(false)
                  setPendingPropertyId(null)
                  setPendingAction(null)
                }}
              >
                {t('confirmModal.cancel')}
              </Button>
              <Button
                className="flex-1 bg-[#FF4D4F] hover:bg-[#E04343] text-white rounded-xl"
                disabled={deletePropertyMutation.isPending || restorePropertyMutation.isPending}
                onClick={confirmAction}
              >
                {deletePropertyMutation.isPending || restorePropertyMutation.isPending ? t('confirmModal.processing') : t('confirmModal.confirm')}
              </Button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  )
}
