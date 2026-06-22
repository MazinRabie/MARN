import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { motion } from 'motion/react'
import { Link } from 'react-router-dom'
import {
  FileText,
  Download,
  XCircle,
  Loader2,
  Search,
  Eye,
  CheckCircle,
} from 'lucide-react'
import { Button } from '../../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../../components/ui/card'
import { Input } from '../../../components/ui/input'
import { Skeleton } from '../../../components/ui/skeleton'
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '../../../components/ui/tooltip'
import {
  useAdminContracts,
  useCancelContract,
} from '@/hooks/useAdminStats'
import { adminService, type AdminContractStatsItem } from '@/services/adminService'
import { getStatusBadge, TruncatedTooltip } from '../utils'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'

export function ContractsModerationTab() {
  const { t, i18n } = useTranslation('admin')
  const [pageSize, setPageSize] = useState(10)
  const [contractSearch, setContractSearch] = useState('')
  const [activeContractSearch, setActiveContractSearch] = useState('')

  const [searchParams, setSearchParams] = useSearchParams()
  const contractStatus = searchParams.get('contractStatus') || 'Pending'
  const setContractStatus = (val: string) => {
    setSearchParams((prev) => {
      prev.set('contractStatus', val)
      return prev
    }, { preventScrollReset: true })
  }
  
  useEffect(() => {
    setPageSize(10)
  }, [contractStatus])

  const {
    data: contractsData,
    isLoading: contractsLoading,
    isFetching: contractsFetching,
  } = useAdminContracts(1, pageSize, activeContractSearch || undefined, contractStatus)

  const cancelContractMutation = useCancelContract()

  const [selectedContract, setSelectedContract] = useState<AdminContractStatsItem | null>(null)

  const contracts = contractsData?.data?.contracts?.items ?? []
  const totalCount = contractsData?.data?.contracts?.totalCount ?? 0

  const handleDownload = async (contractId: number) => {
    try {
      const response = await adminService.downloadContractPdf(contractId)
      const url = window.URL.createObjectURL(new Blob([response.data]))
      const link = document.createElement('a')
      link.href = url
      link.setAttribute('download', `Contract_${contractId}.pdf`)
      document.body.appendChild(link)
      link.click()
      link.parentNode?.removeChild(link)
    } catch {
      // toast is already handled globally or silently error
    }
  }

  const [showContractCancelConfirmModal, setShowContractCancelConfirmModal] = useState(false)
  const [pendingCancelContractId, setPendingCancelContractId] = useState<number | null>(null)

  const handleCancelContract = (contractId: number) => {
    setPendingCancelContractId(contractId)
    setShowContractCancelConfirmModal(true)
  }

  const confirmCancelContract = () => {
    if (pendingCancelContractId) {
      cancelContractMutation.mutate(pendingCancelContractId, {
        onSuccess: () => {
          setShowContractCancelConfirmModal(false)
          setPendingCancelContractId(null)
        }
      })
    }
  }

  return (
    <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
      <CardHeader>
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
          <CardTitle className="text-2xl text-[#1a1a1a]">
            {t('contractsModeration.title')}
          </CardTitle>
          <div className="flex w-full sm:w-auto items-center gap-2">
            <Input
              placeholder={t('contractsModeration.search')}
              className="w-full sm:w-64 bg-white rounded-xl border-[#3A6EA5]/20"
              value={contractSearch}
              onChange={(e) => setContractSearch(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') setActiveContractSearch(contractSearch)
              }}
            />
            <Button
              size="icon"
              className="bg-[#3A6EA5] hover:bg-[#2A527A] text-white rounded-xl flex-shrink-0"
              onClick={() => setActiveContractSearch(contractSearch)}
            >
              <Search className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div className="flex gap-2 mb-6">
          {['Pending', 'Active', 'Cancelled', 'Expired', 'All'].map((statusOption) => (
            <Button
              key={statusOption}
              variant={contractStatus === statusOption ? 'default' : 'outline'}
              size="sm"
              className={contractStatus === statusOption ? 'bg-[#3A6EA5] text-white rounded-xl' : 'rounded-xl border-[#3A6EA5]/20 text-[#4a5565]'}
              onClick={() => setContractStatus(statusOption)}
            >
              {statusOption === 'All' ? t('tabs.all') : t(`contractsModeration.${statusOption.toLowerCase()}`)}
            </Button>
          ))}
        </div>
        <TooltipProvider delayDuration={1000}>
        {!contractsLoading && contracts.length === 0 ? (
          <div className="py-10 text-center text-[#4a5565] border-b border-[#3A6EA5]/20">
            {t('contractsModeration.noContracts')}
          </div>
        ) : (
          <div className="overflow-x-auto overflow-y-scroll max-h-[600px] border-b border-[#3A6EA5]/20">
            <table className="w-full relative" style={{ tableLayout: 'fixed' }}>
              <thead className="sticky top-0 bg-[#F2F4F6] z-10">
                <tr className="border-b border-[#3A6EA5]/20">
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '25%' }}>
                    {t('table.contract')}
                  </th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '20%' }}>
                    {t('table.owner')}
                  </th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '20%' }}>
                    {t('table.renter')}
                  </th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '10%' }}>
                    {t('table.value')}
                  </th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>
                    {t('table.status')}
                  </th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '10%' }}>
                    {t('table.actions')}
                  </th>
                </tr>
              </thead>
              <tbody>
                {contractsLoading ? (
                  Array.from({ length: 5 }).map((_, i) => (
                    <tr key={i} className="border-b border-[#3A6EA5]/10">
                      {Array.from({ length: 6 }).map((_, j) => (
                        <td key={j} className="py-4 px-4">
                          <Skeleton className="h-5 w-full rounded" />
                        </td>
                      ))}
                    </tr>
                  ))
                ) : (
                contracts.map((item) => (
                  <tr key={item.contractId} className="border-b border-[#3A6EA5]/10 hover:bg-white/50 transition-colors">
                    <td className="py-4 px-4 text-[#1a1a1a] font-medium min-w-0">
                      <div className="flex items-center gap-3 min-w-0">
                        <div className="w-10 h-10 rounded-xl bg-[#3A6EA5]/10 flex items-center justify-center shrink-0">
                          <FileText className="w-5 h-5 text-[#3A6EA5]" />
                        </div>
                        <div className="min-w-0">
                          <Link to={`/contract/${item.contractId}`} target="_blank" className="block min-w-0">
                            <TruncatedTooltip text={item.propertyTitle} className="font-medium hover:underline text-[#3A6EA5] cursor-pointer" />
                          </Link>
                          <div className="text-xs text-[#4a5565] truncate">
                            {new Date(item.leaseStartDate).toLocaleDateString('en-GB')} - {new Date(item.leaseEndDate).toLocaleDateString('en-GB')}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-4 text-[#1a1a1a] min-w-0">
                      <TruncatedTooltip text={item.ownerName} />
                    </td>
                    <td className="py-4 px-4 text-[#1a1a1a] min-w-0">
                      <TruncatedTooltip text={item.renterName} />
                    </td>
                    <td className="py-4 px-4 font-semibold text-[#3A6EA5]">
                      <div className="flex items-center gap-1">
                        {i18n.language === 'ar' ? (
                          <>
                            <span>{item.totalContractAmount.toLocaleString()}</span>
                            <span>{t('currency', { ns: 'common' })}</span>
                          </>
                        ) : (
                          <>
                            <span>{t('currency', { ns: 'common' })}</span>
                            <span>{item.totalContractAmount.toLocaleString()}</span>
                          </>
                        )}
                      </div>
                    </td>
                    <td className="py-4 px-4">{getStatusBadge(item.statusDisplayName)}</td>
                    <td className="py-4 px-4">
                      <TooltipProvider delayDuration={700}>
                        <div className="flex gap-2 justify-start">
                          <Tooltip>
                            <TooltipTrigger asChild>
                              <Button size="icon" variant="outline" className="rounded-xl border-[#3A6EA5]/20 w-8 h-8 shrink-0" onClick={() => setSelectedContract(item)}>
                                <Eye className="w-4 h-4" />
                              </Button>
                            </TooltipTrigger>
                            <TooltipContent><p>{t('table.view')}</p></TooltipContent>
                          </Tooltip>
                          <Tooltip>
                            <TooltipTrigger asChild>
                              <Button size="icon" variant="outline" className="rounded-xl border-[#3A6EA5]/20 w-8 h-8 shrink-0" onClick={() => handleDownload(item.contractId)}>
                                <Download className="w-4 h-4" />
                              </Button>
                            </TooltipTrigger>
                            <TooltipContent><p>{t('table.downloadPdf')}</p></TooltipContent>
                          </Tooltip>
                          {item.canCancel && (
                            <Tooltip>
                              <TooltipTrigger asChild>
                                <Button size="icon" variant="outline" className="border-[#FF4D4F] text-[#FF4D4F] hover:bg-[#FF4D4F] hover:text-white rounded-xl w-8 h-8 shrink-0" disabled={cancelContractMutation.isPending} onClick={() => handleCancelContract(item.contractId)}>
                                  <XCircle className="w-4 h-4" />
                                </Button>
                              </TooltipTrigger>
                              <TooltipContent><p>{t('modals.cancel')}</p></TooltipContent>
                            </Tooltip>
                          )}
                        </div>
                      </TooltipProvider>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
            {totalCount > contracts.length && (
              <tfoot>
                <tr>
                  <td colSpan={6}>
                    <div className="py-6 flex justify-center items-center min-h-[40px]">
                      {contractsFetching ? (
                        <Loader2 className="w-6 h-6 animate-spin text-[#3A6EA5]" />
                      ) : (
                        <Button variant="outline" className="rounded-xl border-[#3A6EA5]/20 text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white" onClick={() => setPageSize((p) => p + 10)}>
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

      {/* Contract Detail Modal */}
      {selectedContract && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4" onClick={() => setSelectedContract(null)}>
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-3xl p-8 max-w-2xl w-full shadow-2xl max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-start justify-between mb-6">
              <div className="flex items-center gap-4">
                <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center shrink-0">
                  <FileText className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h3 className="text-2xl font-bold text-[#1a1a1a]">
                    {t('table.contract')} #{selectedContract.contractId}
                  </h3>
                  <p className="text-sm text-[#4a5565] mt-0.5">
                    {selectedContract.propertyTitle}
                  </p>
                  <div className="flex items-center gap-2 mt-1.5">
                    {getStatusBadge(selectedContract.statusDisplayName)}
                    {selectedContract.isAnchoredToBlockChain && (
                      <span className="px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-700">
                        {t('contractsModeration.anchored', { defaultValue: 'Anchored' })}
                      </span>
                    )}
                  </div>
                </div>
              </div>
              <Button size="sm" variant="outline" className="rounded-xl border-[#3A6EA5]/20 shrink-0" onClick={() => setSelectedContract(null)}>
                <XCircle className="w-4 h-4" />
              </Button>
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6 text-sm">
              <div className="bg-[#F2F4F6] rounded-2xl p-4 sm:col-span-2">
                <p className="text-[#4a5565] mb-1">{t('table.owner')}</p>
                <p className="font-semibold text-[#1a1a1a]">{selectedContract.ownerName}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4 sm:col-span-2">
                <p className="text-[#4a5565] mb-1">{t('table.renter')}</p>
                <p className="font-semibold text-[#1a1a1a]">{selectedContract.renterName}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('contractsModeration.startDate', { defaultValue: 'Start Date' })}</p>
                <p className="font-semibold text-[#1a1a1a]">{new Date(selectedContract.leaseStartDate).toLocaleDateString('en-GB')}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('contractsModeration.endDate', { defaultValue: 'End Date' })}</p>
                <p className="font-semibold text-[#1a1a1a]">{new Date(selectedContract.leaseEndDate).toLocaleDateString('en-GB')}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('table.value')}</p>
                <p className="font-semibold text-[#1a1a1a]">{t('currency', { ns: 'common' })} {(selectedContract.totalContractAmount ?? 0).toLocaleString()}</p>
              </div>
              <div className="bg-[#F2F4F6] rounded-2xl p-4">
                <p className="text-[#4a5565] mb-1">{t('contractsModeration.frequency', { defaultValue: 'Frequency' })}</p>
                <p className="font-semibold text-[#1a1a1a]">{selectedContract.paymentFrequencyDisplayName}</p>
              </div>
            </div>

            {selectedContract.isAnchoredToBlockChain && (
              <>
                <h4 className="font-semibold text-lg text-[#1a1a1a] mb-4">{t('contractsModeration.blockchainDetails', { defaultValue: 'Blockchain Details' })}</h4>
                <div className="bg-[#F2F4F6] rounded-2xl p-4 space-y-4 mb-6 text-sm">
                  <div>
                    <p className="text-[#4a5565] mb-1">{t('contractsModeration.transactionId', { defaultValue: 'Transaction ID' })}</p>
                    <p className="font-mono text-xs font-semibold text-[#1a1a1a] break-all">{selectedContract.transactionId ?? '—'}</p>
                  </div>
                  <div>
                    <p className="text-[#4a5565] mb-1">{t('contractsModeration.merkleRoot', { defaultValue: 'Merkle Root' })}</p>
                    <p className="font-mono text-xs font-semibold text-[#1a1a1a] break-all">{selectedContract.merkleRoot ?? '—'}</p>
                  </div>
                </div>
              </>
            )}

            <div className="flex gap-3">
              {selectedContract.canCancel && (
                <Button variant="outline" className="flex-1 border-[#FF4D4F] text-[#FF4D4F] hover:bg-[#FF4D4F] hover:text-white rounded-xl" onClick={() => handleCancelContract(selectedContract.contractId)}>
                  <XCircle className="w-4 h-4 mr-2" /> {t('modals.cancel', { defaultValue: 'Cancel Contract' })}
                </Button>
              )}
              <Button variant="outline" className="flex-1 rounded-xl border-[#3A6EA5]/20" onClick={() => setSelectedContract(null)}>
                {t('confirmModal.close', { defaultValue: 'Close' })}
              </Button>
            </div>
          </motion.div>
        </div>
      )}

      {/* Confirmation Modal */}
      {showContractCancelConfirmModal && (
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
              {t('confirmModal.cancelContractMessage')}
            </p>
            <div className="flex gap-4">
              <Button
                variant="outline"
                className="flex-1 rounded-xl border-[#3A6EA5]/20"
                onClick={() => {
                  setShowContractCancelConfirmModal(false)
                  setPendingCancelContractId(null)
                }}
              >
                {t('confirmModal.cancel')}
              </Button>
              <Button
                className="flex-1 bg-[#FF4D4F] hover:bg-[#E04343] text-white rounded-xl"
                disabled={cancelContractMutation.isPending}
                onClick={confirmCancelContract}
              >
                {cancelContractMutation.isPending ? t('confirmModal.processing') : t('confirmModal.confirm')}
              </Button>
            </div>
          </motion.div>
        </div>
      )}
    </Card>
  )
}
