import { useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import {
  TrendingUp,
  Download,
  Calendar,
  Loader2,
} from 'lucide-react'
import { Button } from '../../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../../components/ui/card'
import { Input } from '../../../components/ui/input'
import { Skeleton } from '../../../components/ui/skeleton'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '../../../components/ui/select'
import {
  useAdminAnalyticsReports,
  useGenerateReport,
} from '@/hooks/useAdminStats'
import { adminService } from '@/services/adminService'
import { toast } from 'sonner'
import { RevenueStatsView } from './RevenueStatsView'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../../../components/ui/tabs'
import { useTranslation } from 'react-i18next'

export function ReportsTab() {
  const { t, i18n } = useTranslation('admin')
  const [reportScope, setReportScope] = useState<string>('Overview')
  const [reportFormat, setReportFormat] = useState<string>('Pdf')
  const [reportPeriod, setReportPeriod] = useState<string>('ThisMonth')
  const [reportFromUtc, setReportFromUtc] = useState<string>('')
  const [reportToUtc, setReportToUtc] = useState<string>('')
  const [pageSize, setPageSize] = useState(10)

  const { data: analyticsReportsData, isLoading: analyticsReportsLoading, isFetching: analyticsReportsFetching } =
    useAdminAnalyticsReports(1, pageSize)
  const generateReport = useGenerateReport()

  const analyticsReports = analyticsReportsData?.data?.items ?? []
  const totalCount = analyticsReportsData?.data?.totalCount ?? 0

  const handleDownloadReport = async (reportId: number, fileName: string) => {
    try {
      const response = await adminService.downloadAnalyticsReport(reportId)
      const url = URL.createObjectURL(response.data)
      const a = document.createElement('a')
      a.href = url
      a.download = fileName
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
    } catch {
      toast.error(t('toasts.reportDownloadFailed'))
    }
  }

  const [searchParams, setSearchParams] = useSearchParams()
  const activeSubTab = searchParams.get('subtab') || 'reports'
  const handleSubTabChange = (value: string) => {
    setSearchParams((prev) => {
      if (value === 'reports') {
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
        <TabsList className="bg-[#EEF3F9] border border-[#3A6EA5]/20 rounded-2xl p-1.5 mb-6 gap-1 shadow-md shadow-[#3A6EA5]/15 h-auto">
          <TabsTrigger value="reports" className="rounded-xl py-2 px-5 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
            {t('generateReport.generatedReports')}
          </TabsTrigger>
          <TabsTrigger value="revenue" className="rounded-xl py-2 px-5 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md">
            {t('revenue.title')}
          </TabsTrigger>
        </TabsList>

        <TabsContent value="reports" className="mt-0">
          <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
            <CardHeader>
              <CardTitle className="text-2xl text-[#1a1a1a]">
                {t('reports.title')}
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              {/* Generate Action */}
              <div className="bg-white rounded-2xl p-6 space-y-4">
                <h3 className="font-semibold text-[#1a1a1a]">
                  {t('generateReport.title')}
                </h3>
                <div className="grid sm:grid-cols-3 gap-3">
                  <div className="space-y-1">
                    <p className="text-xs text-[#4a5565] font-medium">
                      {t('generateReport.scope')}
                    </p>
                    <Select
                      value={reportScope}
                      onValueChange={setReportScope}
                    >
                      <SelectTrigger className="bg-[#F2F4F6] border-none rounded-xl">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Overview">{t('generateReport.scopeOptions.overview')}</SelectItem>
                        <SelectItem value="Users">{t('generateReport.scopeOptions.users')}</SelectItem>
                        <SelectItem value="Properties">
                          {t('generateReport.scopeOptions.properties')}
                        </SelectItem>
                        <SelectItem value="Contracts">{t('generateReport.scopeOptions.contracts')}</SelectItem>
                        <SelectItem value="Revenue">{t('generateReport.scopeOptions.revenue')}</SelectItem>
                        <SelectItem value="Full">{t('generateReport.scopeOptions.full')}</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-1">
                    <p className="text-xs text-[#4a5565] font-medium">
                      {t('generateReport.format')}
                    </p>
                    <Select
                      value={reportFormat}
                      onValueChange={setReportFormat}
                    >
                      <SelectTrigger className="bg-[#F2F4F6] border-none rounded-xl">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Pdf">{t('generateReport.formatOptions.pdf')}</SelectItem>
                        <SelectItem value="Csv">{t('generateReport.formatOptions.csv')}</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-1">
                    <p className="text-xs text-[#4a5565] font-medium">
                      {t('generateReport.period')}
                    </p>
                    <Select
                      value={reportPeriod}
                      onValueChange={setReportPeriod}
                    >
                      <SelectTrigger className="bg-[#F2F4F6] border-none rounded-xl">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="ThisMonth">
                          {t('generateReport.periodOptions.thisMonth')}
                        </SelectItem>
                        <SelectItem value="ThisYear">{t('generateReport.periodOptions.thisYear')}</SelectItem>
                        <SelectItem value="AllTime">{t('generateReport.periodOptions.allTime')}</SelectItem>
                        <SelectItem value="Custom">{t('generateReport.periodOptions.custom')}</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                {reportPeriod === 'Custom' && (
                  <div className="grid sm:grid-cols-2 gap-3">
                    <div className="space-y-1">
                      <p className="text-xs text-[#4a5565] font-medium">
                        {t('generateReport.from')}
                      </p>
                      <Input
                        type="date"
                        className="bg-[#F2F4F6] border-none rounded-xl"
                        value={reportFromUtc}
                        onChange={(e) => setReportFromUtc(e.target.value)}
                      />
                    </div>
                    <div className="space-y-1">
                      <p className="text-xs text-[#4a5565] font-medium">
                        {t('generateReport.to')}
                      </p>
                      <Input
                        type="date"
                        className="bg-[#F2F4F6] border-none rounded-xl"
                        value={reportToUtc}
                        onChange={(e) => setReportToUtc(e.target.value)}
                      />
                    </div>
                  </div>
                )}
                <Button
                  size="lg"
                  className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-2xl shadow-lg shadow-[#3A6EA5]/30"
                  disabled={
                    generateReport.isPending ||
                    (reportPeriod === 'Custom' &&
                      (!reportFromUtc || !reportToUtc))
                  }
                  onClick={() =>
                    generateReport.mutate({
                      scope: reportScope as
                        | 'Overview'
                        | 'Users'
                        | 'Properties'
                        | 'Contracts'
                        | 'Revenue'
                        | 'Full',
                      format: reportFormat as 'Pdf' | 'Csv',
                      period: reportPeriod as
                        | 'AllTime'
                        | 'ThisMonth'
                        | 'ThisYear'
                        | 'Custom',
                      ...(reportPeriod === 'Custom' &&
                      reportFromUtc &&
                      reportToUtc
                        ? {
                            fromUtc: new Date(reportFromUtc).toISOString(),
                            toUtc: new Date(reportToUtc).toISOString(),
                          }
                        : {}),
                    })
                  }
                >
                  <TrendingUp className="w-5 h-5 mr-2" />
                  {generateReport.isPending
                    ? t('generateReport.generating')
                    : t('generateReport.generate')}
                </Button>
              </div>

              {/* Generated Reports List */}
              <div className="bg-white rounded-2xl p-6">
                <h3 className="font-semibold text-[#1a1a1a] mb-4">
                  {t('generateReport.generatedReports')}
                </h3>
                {analyticsReportsLoading ? (
                  <div className="space-y-3">
                    {Array.from({ length: 3 }).map((_, i) => (
                      <Skeleton
                        key={i}
                        className="h-16 w-full rounded-xl"
                      />
                    ))}
                  </div>
                ) : analyticsReports.length === 0 ? (
                  <p className="text-center text-[#4a5565] py-6">
                    {t('generateReport.noReports')}
                  </p>
                ) : (
                  <div className="space-y-3 overflow-y-auto max-h-[600px] pr-2">
                    {analyticsReports.map((report) => (
                      <div
                        key={report.reportId}
                        className="flex items-center justify-between p-4 bg-[#F2F4F6] rounded-xl"
                      >
                        <div className="flex items-center gap-3">
                          <Calendar className="w-5 h-5 text-[#3A6EA5] shrink-0" />
                          <div>
                            <p className="font-medium text-[#1a1a1a]">
                              {report.scopeDisplayName} —{' '}
                              {report.periodDisplayName}
                            </p>
                            <p className="text-sm text-[#4a5565]">
                              {new Date(
                                report.generatedAt,
                              ).toLocaleDateString('en-GB')}
                              {' • '}
                              {report.formatDisplayName}
                              {report.fileSizeBytes != null && (
                                <>
                                  {' '}
                                  •{' '}
                                  {(
                                    report.fileSizeBytes /
                                    1024 /
                                    1024
                                  ).toFixed(1)}{' '}
                                  MB
                                </>
                              )}
                            </p>
                          </div>
                        </div>
                        <Button
                          size="sm"
                          variant="outline"
                          className="rounded-xl border-[#3A6EA5]/20 shrink-0"
                          onClick={() =>
                            handleDownloadReport(
                              report.reportId,
                              report.fileName,
                            )
                          }
                        >
                          <Download className="w-4 h-4" />
                        </Button>
                      </div>
                    ))}
                  </div>
                )}
                {totalCount > analyticsReports.length && (
                  <div className="mt-4 flex justify-center items-center min-h-[40px]">
                    {analyticsReportsFetching ? (
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
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="revenue" className="mt-0">
          <RevenueStatsView />
        </TabsContent>
      </Tabs>
    </div>
  )
}
