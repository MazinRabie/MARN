import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Eye, Search, XCircle, ShieldAlert, Loader2, Filter } from 'lucide-react'
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
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '../../../components/ui/dialog'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../../../components/ui/select'
import { Checkbox } from '../../../components/ui/checkbox'
import { Popover, PopoverContent, PopoverTrigger } from '../../../components/ui/popover'
import {
  useAdminModerationReports,
  useAdminModerationReport,
  useReviewModerationReport,
} from '@/hooks/useAdminStats'
import { ReportModerationActionType } from '@/services/adminService'
import { getStatusBadge, TruncatedTooltip } from '../utils'
import { Link } from 'react-router-dom'
import { toast } from 'sonner'
import { Tabs, TabsList, TabsTrigger } from '../../../components/ui/tabs'
import { useTranslation } from 'react-i18next'

export function ModerationReportsTab() {
  const { t, i18n } = useTranslation('admin')
  const [pageSize, setPageSize] = useState(10)
  const [search, setSearch] = useState('')
  const [activeSearch, setActiveSearch] = useState('')
  const [activeStatusTab, setActiveStatusTab] = useState('InReview')
  
  useEffect(() => {
    setPageSize(10)
  }, [activeStatusTab])
  
  const { data: reportsData, isLoading, isFetching } = useAdminModerationReports(1, pageSize, activeSearch || undefined, activeStatusTab)
  const reports = reportsData?.data?.reports?.items || []
  const totalCount = reportsData?.data?.reports?.totalCount || 0

  const [typeFilters, setTypeFilters] = useState({
    User: true,
    Property: true,
    Message: true,
    PropertyComment: true,
  })
  const [pendingFilters, setPendingFilters] = useState(typeFilters)
  const [isFilterOpen, setIsFilterOpen] = useState(false)

  const filteredReports = reports.filter(item => {
    if (!item.reportableType) return true;
    return typeFilters[item.reportableType as keyof typeof typeFilters] !== false
  })

  const [selectedReportId, setSelectedReportId] = useState<number | null>(null)
  const { data: reportDetailData, isLoading: detailLoading } = useAdminModerationReport(selectedReportId)
  const reviewMutation = useReviewModerationReport()

  const [reviewStatus, setReviewStatus] = useState<string>('Approved')
  const [adminNote, setAdminNote] = useState('')
  const [selectedActionTypes, setSelectedActionTypes] = useState<string[]>([])

  const openReviewModal = (reportId: number) => {
    setSelectedReportId(reportId)
    setReviewStatus('Approved')
    setAdminNote('')
    setSelectedActionTypes([])
  }

  const handleReviewSubmit = () => {
    if (!selectedReportId) return
    
    if (reviewStatus === 'Approved' && selectedActionTypes.length === 0) {
      toast.error('Please select at least one action if approving the report.')
      return
    }

    reviewMutation.mutate(
      {
        reportId: selectedReportId,
        payload: {
          status: reviewStatus === 'Approved' ? 'Resolved' : 'Rejected',
          note: adminNote,
          actionTypes: selectedActionTypes.length > 0 ? selectedActionTypes : undefined,
        }
      },
      {
        onSuccess: () => {
          toast.success('Moderation review submitted successfully')
          setSelectedReportId(null)
        }
      }
    )
  }

  const reportDetail = reportDetailData?.data

  return (
    <div className="space-y-6">
      <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
        <CardHeader>
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <CardTitle className="text-2xl text-[#1a1a1a]">
              {t('moderationReports.title')}
            </CardTitle>
            <div className="flex w-full sm:w-auto items-center gap-2">
              <Input
                placeholder={t('moderationReports.search')}
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
          <div className="mt-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <Tabs value={activeStatusTab} onValueChange={setActiveStatusTab} className="w-full sm:w-auto flex-1" dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}>
              <TabsList className="bg-[#EEF3F9] border border-[#3A6EA5]/20 rounded-2xl p-1.5 gap-1 shadow-md shadow-[#3A6EA5]/15 h-auto">
                <TabsTrigger value="InReview" className="rounded-xl py-2 px-4 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
                  {t('moderationReports.inReview')}
                </TabsTrigger>
                <TabsTrigger value="Resolved" className="rounded-xl py-2 px-4 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
                  {t('moderationReports.resolved')}
                </TabsTrigger>
                <TabsTrigger value="Rejected" className="rounded-xl py-2 px-4 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
                  {t('moderationReports.rejected')}
                </TabsTrigger>
                <TabsTrigger value="All" className="rounded-xl py-2 px-4 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
                  {t('tabs.all')}
                </TabsTrigger>
              </TabsList>
            </Tabs>

            <Popover open={isFilterOpen} onOpenChange={(open) => {
              setIsFilterOpen(open)
              if (open) setPendingFilters(typeFilters)
            }}>
              <PopoverTrigger asChild>
                <Button variant="outline" className="rounded-xl border-[#3A6EA5]/20 gap-2 shrink-0 bg-white">
                  <Filter className="w-4 h-4" />
                  {t('moderationReports.filterTypes')}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-64 rounded-2xl p-4 shadow-xl border border-[#3A6EA5]/10 bg-white" align="end">
                <div className="space-y-4">
                  <h4 className="font-semibold text-sm text-[#1a1a1a]">{t('moderationReports.filterByType')}</h4>
                  <div className="space-y-3">
                    {Object.entries({
                      User: t('moderationReports.types.user'),
                      Property: t('moderationReports.types.property'),
                      Message: t('moderationReports.types.message'),
                      PropertyComment: t('moderationReports.types.propertyComment')
                    }).map(([key, label]) => (
                      <label key={key} className="flex items-center gap-3 cursor-pointer p-1 rounded hover:bg-gray-50">
                        <Checkbox 
                          checked={pendingFilters[key as keyof typeof pendingFilters]} 
                          onCheckedChange={(c) => setPendingFilters(prev => ({ ...prev, [key]: !!c }))}
                        />
                        <span className="text-sm text-[#4a5565]">{label}</span>
                      </label>
                    ))}
                  </div>
                  <div className="flex items-center justify-end gap-2 pt-4 border-t border-gray-100 mt-2">
                    <Button variant="ghost" size="sm" className="rounded-xl text-[#4a5565]" onClick={() => setIsFilterOpen(false)}>
                      {t('moderationReports.cancel')}
                    </Button>
                    <Button 
                      size="sm" 
                      className="bg-[#3A6EA5] hover:bg-[#2A527A] text-white rounded-xl"
                      onClick={() => {
                        setTypeFilters(pendingFilters)
                        setIsFilterOpen(false)
                      }}
                    >
                      {t('moderationReports.apply')}
                    </Button>
                  </div>
                </div>
              </PopoverContent>
            </Popover>
          </div>
        </CardHeader>
        <CardContent>
          {!isLoading && filteredReports.length === 0 ? (
            <div className="py-10 text-center text-[#4a5565] border-b border-[#3A6EA5]/20">
              {t('moderationReports.noReports')}
            </div>
          ) : (
          <div className="overflow-x-auto overflow-y-scroll max-h-[600px] border-b border-[#3A6EA5]/20">
            <TooltipProvider delayDuration={700}>
            <table className="w-full min-w-[800px] relative" style={{ tableLayout: 'fixed' }}>
              <thead className="sticky top-0 bg-[#F2F4F6] z-10">
                <tr className="border-b border-[#3A6EA5]/20">
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '20%' }}>{t('moderationReports.reportInfo')}</th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('moderationReports.target')}</th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '30%' }}>{t('moderationReports.reason')}</th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('moderationReports.status')}</th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '10%' }}>{t('moderationReports.date')}</th>
                  <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '10%' }}>{t('moderationReports.actions')}</th>
                </tr>
              </thead>
              <tbody>
                {isLoading ? (
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
                  filteredReports.map((item) => (
                    <tr key={item.reportId} className="border-b border-[#3A6EA5]/10 hover:bg-white/50 transition-colors">
                      <td className="py-4 px-4 text-[#1a1a1a]">
                        <div className="flex flex-col">
                          <span className="font-medium">{t('moderationReports.modal.reportNumber', { id: item.reportId })}</span>
                          <span className="text-xs text-[#4a5565]">{t('moderationReports.modal.by')}: {item.reporterName || t('moderationReports.modal.anonymous')}</span>
                        </div>
                      </td>
                      <td className="py-4 px-4">
                        <span className="px-2 py-1 bg-gray-200 text-gray-700 text-xs rounded-lg font-medium">
                          {item.reportableTypeDisplayName || item.reportableType}
                        </span>
                      </td>
                      <td className="py-4 px-4 text-[#4a5565] overflow-hidden">
                        <TruncatedTooltip text={item.reason || ''} />
                      </td>
                      <td className="py-4 px-4">
                        {getStatusBadge(item.statusDisplayName || item.status)}
                      </td>
                      <td className="py-4 px-4 text-[#4a5565]">
                        {new Date(item.createdAt).toLocaleDateString('en-GB')}
                      </td>
                      <td className="py-4 px-4">
                          <div className="flex gap-2 justify-start">
                            <Tooltip>
                              <TooltipTrigger asChild>
                                <Button
                                  size="icon"
                                  variant="outline"
                                  className="rounded-xl border-[#3A6EA5]/20 w-8 h-8 shrink-0"
                                  onClick={() => openReviewModal(item.reportId)}
                                >
                                  {item.status === 'InReview' ? <ShieldAlert className="w-4 h-4 text-orange-500" /> : <Eye className="w-4 h-4" />}
                                </Button>
                              </TooltipTrigger>
                              <TooltipContent><p>{item.status === 'InReview' ? t('moderationReports.reviewReport') : t('moderationReports.viewReport')}</p></TooltipContent>
                            </Tooltip>
                          </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
              {totalCount > filteredReports.length && (
                <tfoot>
                  <tr>
                    <td colSpan={6}>
                      <div className="py-6 flex justify-center items-center min-h-[40px]">
                        {isFetching ? (
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
            </TooltipProvider>
          </div>
          )}
        </CardContent>
      </Card>

      <Dialog
        open={selectedReportId !== null}
        onOpenChange={(open) => {
          if (!open) setSelectedReportId(null)
        }}
      >
        <DialogContent className="bg-white rounded-3xl max-w-4xl w-[95vw] mx-auto p-6 border-none shadow-2xl overflow-y-auto max-h-[90vh]">
          <DialogHeader>
            <DialogTitle className="text-2xl font-bold text-[#1a1a1a]">
              {t('moderationReports.modal.title')}
            </DialogTitle>
          </DialogHeader>

          {detailLoading ? (
            <div className="flex items-center justify-center p-10">
              <Loader2 className="w-8 h-8 animate-spin text-[#3A6EA5]" />
            </div>
          ) : reportDetail ? (
            <div className="space-y-6 py-4">
              <div className="grid sm:grid-cols-2 gap-4">
                <div className="space-y-1 bg-[#F2F4F6] p-4 rounded-2xl">
                  <p className="text-xs font-semibold text-[#4a5565] uppercase">{t('moderationReports.reportInfo')}</p>
                  <p className="text-sm font-medium text-[#1a1a1a]">{t('moderationReports.modal.reportNumber', { id: reportDetail.reportId })}</p>
                  <p className="text-sm text-[#4a5565]">{t('moderationReports.modal.submitted')}: {new Date(reportDetail.createdAt).toLocaleString('en-GB')}</p>
                  <p className="text-sm text-[#4a5565]">{t('moderationReports.modal.by')}: {reportDetail.reporterName || t('moderationReports.modal.anonymous')}</p>
                </div>
                <div className="space-y-1 bg-[#F2F4F6] p-4 rounded-2xl">
                  <p className="text-xs font-semibold text-[#4a5565] uppercase">{t('moderationReports.reason')}</p>
                  <p className="text-sm text-[#1a1a1a]">{reportDetail.reason}</p>
                </div>
              </div>

              {/* Target Details */}
              <div className="space-y-2 border border-[#3A6EA5]/20 rounded-2xl p-4 relative overflow-hidden">
                <div className="absolute top-0 left-0 w-1 h-full bg-[#3A6EA5]" />
                <p className="text-sm font-semibold text-[#1a1a1a]">{t('moderationReports.modal.reportedContent')}: {reportDetail.reportableTypeDisplayName}</p>
                {reportDetail.target ? (
                  <div className="space-y-1 mt-2">
                    <p className="text-sm font-medium text-[#1a1a1a]">{reportDetail.target.title}</p>
                    {reportDetail.target.subtitle && <p className="text-xs text-[#4a5565]">{reportDetail.target.subtitle}</p>}
                    <p className="text-sm bg-white p-3 rounded-xl border border-gray-100 mt-2 text-gray-700 italic">
                      "{reportDetail.target.preview}"
                    </p>
                    
                    <div className="mt-4 flex flex-wrap gap-2">
                      {reportDetail.target.isHidden && <span className="px-2 py-1 bg-yellow-100 text-yellow-700 text-xs rounded-lg font-medium">{t('moderationReports.modal.hidden')}</span>}
                      {reportDetail.target.isDeletedOrInactive && <span className="px-2 py-1 bg-red-100 text-red-700 text-xs rounded-lg font-medium">{t('moderationReports.modal.deletedInactive')}</span>}
                      
                      {reportDetail.target.propertyId && (
                        <Link to={`/property/${reportDetail.target.propertyId}`} target="_blank" className="text-xs font-semibold text-[#3A6EA5] hover:underline px-2 py-1 bg-[#3A6EA5]/10 rounded-lg">
                          {t('moderationReports.modal.viewProperty')}
                        </Link>
                      )}
                    </div>
                  </div>
                ) : (
                  <p className="text-sm text-[#4a5565]">{t('moderationReports.modal.targetNotAvailable')}</p>
                )}
              </div>

              {/* Resolution Form (only if InReview) */}
              {reportDetail.status === 'InReview' ? (
                <div className="space-y-4 pt-4 border-t border-[#3A6EA5]/10">
                  <h4 className="font-semibold text-[#1a1a1a]">{t('moderationReports.modal.resolveReport')}</h4>
                  
                  <div className="space-y-2">
                    <p className="text-sm font-medium">{t('moderationReports.modal.resolutionStatus')}</p>
                    <Select value={reviewStatus} onValueChange={setReviewStatus}>
                      <SelectTrigger className="w-full bg-[#F2F4F6] border-none rounded-xl">
                        <SelectValue placeholder={t('moderationReports.modal.selectOutcome')} />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Approved">{t('moderationReports.modal.approveAction')}</SelectItem>
                        <SelectItem value="Rejected">{t('moderationReports.modal.rejectAction')}</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  {reviewStatus === 'Approved' && (
                    <div className="space-y-3 bg-red-50/50 border border-red-100 p-4 rounded-xl">
                      <p className="text-sm font-medium text-red-800">{t('moderationReports.modal.actionsToTake')}</p>
                      
                      <div className="grid sm:grid-cols-2 gap-3">
                        <label className="flex items-center gap-3 cursor-pointer p-2 rounded-lg hover:bg-white/50 transition-colors">
                          <Checkbox
                            checked={selectedActionTypes.includes(ReportModerationActionType.BanUser)}
                            onCheckedChange={(c) => setSelectedActionTypes(prev => c ? [...prev, ReportModerationActionType.BanUser] : prev.filter(x => x !== ReportModerationActionType.BanUser))}
                          />
                          <span className="text-sm font-medium text-red-700">{t('moderationReports.modal.banUser')}</span>
                        </label>
                        
                        {reportDetail.reportableType === 'Property' && (
                          <label className="flex items-center gap-3 cursor-pointer p-2 rounded-lg hover:bg-white/50 transition-colors">
                            <Checkbox
                              checked={selectedActionTypes.includes(ReportModerationActionType.DeactivateProperty)}
                              onCheckedChange={(c) => setSelectedActionTypes(prev => c ? [...prev, ReportModerationActionType.DeactivateProperty] : prev.filter(x => x !== ReportModerationActionType.DeactivateProperty))}
                            />
                            <span className="text-sm font-medium text-red-700">{t('moderationReports.modal.deactivateProperty')}</span>
                          </label>
                        )}
                        
                        {reportDetail.reportableType === 'Message' && (
                          <label className="flex items-center gap-3 cursor-pointer p-2 rounded-lg hover:bg-white/50 transition-colors">
                            <Checkbox
                              checked={selectedActionTypes.includes(ReportModerationActionType.HideMessage)}
                              onCheckedChange={(c) => setSelectedActionTypes(prev => c ? [...prev, ReportModerationActionType.HideMessage] : prev.filter(x => x !== ReportModerationActionType.HideMessage))}
                            />
                            <span className="text-sm font-medium text-red-700">{t('moderationReports.modal.hideMessage')}</span>
                          </label>
                        )}
                        
                        {reportDetail.reportableType === 'PropertyComment' && (
                          <label className="flex items-center gap-3 cursor-pointer p-2 rounded-lg hover:bg-white/50 transition-colors">
                            <Checkbox
                              checked={selectedActionTypes.includes(ReportModerationActionType.HidePropertyComment)}
                              onCheckedChange={(c) => setSelectedActionTypes(prev => c ? [...prev, ReportModerationActionType.HidePropertyComment] : prev.filter(x => x !== ReportModerationActionType.HidePropertyComment))}
                            />
                            <span className="text-sm font-medium text-red-700">{t('moderationReports.modal.hideComment')}</span>
                          </label>
                        )}
                      </div>
                    </div>
                  )}

                  <div className="space-y-2">
                    <p className="text-sm font-medium">{t('moderationReports.modal.adminNote')}</p>
                    <textarea
                      className="w-full h-24 p-3 bg-[#F2F4F6] border-none rounded-xl text-sm focus:ring-2 focus:ring-[#3A6EA5] outline-none resize-none"
                      placeholder={t('moderationReports.modal.addContext')}
                      value={adminNote}
                      onChange={(e) => setAdminNote(e.target.value)}
                    />
                  </div>

                  <DialogFooter className="pt-4 flex-col sm:flex-row gap-3 sm:gap-0">
                    <Button variant="outline" onClick={() => setSelectedReportId(null)} className="rounded-xl w-full sm:w-auto">
                      {t('moderationReports.cancel')}
                    </Button>
                    <Button
                      onClick={handleReviewSubmit}
                      disabled={reviewMutation.isPending || (reviewStatus === 'Approved' && selectedActionTypes.length === 0)}
                      className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl w-full sm:w-auto"
                    >
                      {reviewMutation.isPending ? t('moderationReports.modal.submitting') : t('moderationReports.modal.submitReview')}
                    </Button>
                  </DialogFooter>
                </div>
              ) : (
                <div className="space-y-4 pt-4 border-t border-[#3A6EA5]/10 bg-gray-50/50 p-4 rounded-xl mt-4">
                  <h4 className="font-semibold text-[#1a1a1a]">{t('moderationReports.modal.resolutionDetails')}</h4>
                  <div className="grid sm:grid-cols-2 gap-4">
                    <div>
                      <p className="text-xs font-semibold text-[#4a5565] uppercase">{t('moderationReports.modal.outcome')}</p>
                      <p className="text-sm font-medium mt-1">{reportDetail.actionTakenDisplayName || t('moderationReports.modal.noActionTaken')}</p>
                    </div>
                    <div>
                      <p className="text-xs font-semibold text-[#4a5565] uppercase">{t('moderationReports.modal.reviewedBy')}</p>
                      <p className="text-sm mt-1">{reportDetail.reviewerName}</p>
                    </div>
                  </div>
                  {reportDetail.reviewerNote && (
                    <div>
                      <p className="text-xs font-semibold text-[#4a5565] uppercase">{t('moderationReports.modal.internalNote')}</p>
                      <p className="text-sm mt-1 italic text-gray-700">{reportDetail.reviewerNote}</p>
                    </div>
                  )}
                  {reportDetail.actionsTakenDisplayNames && reportDetail.actionsTakenDisplayNames.length > 0 && (
                    <div>
                      <p className="text-xs font-semibold text-[#4a5565] uppercase">{t('moderationReports.modal.automatedActionsFired')}</p>
                      <div className="mt-2 flex flex-wrap gap-2">
                        {reportDetail.actionsTakenDisplayNames.map((action, i) => (
                          <span key={i} className="px-2 py-1 bg-red-100 text-red-700 text-xs rounded-lg font-medium">
                            {action}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>
          ) : (
            <div className="p-10 text-center text-[#4a5565]">
              {t('moderationReports.modal.notFound')}
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}
