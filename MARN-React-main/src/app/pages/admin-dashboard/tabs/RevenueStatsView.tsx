import { useState } from 'react'
import { DollarSign, Search, Loader2 } from 'lucide-react'
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
import { TooltipProvider } from '../../../components/ui/tooltip'
import { useAdminRevenue } from '@/hooks/useAdminStats'
import { useTranslation } from 'react-i18next'

export function RevenueStatsView() {
  const { t } = useTranslation('admin')
  const [pageSize, setPageSize] = useState(20)
  const [search, setSearch] = useState('')
  const [activeSearch, setActiveSearch] = useState('')
  const [period, setPeriod] = useState('thisYear')
  const [statusFilter, setStatusFilter] = useState('All')

  const { data: revenueData, isLoading, isFetching } = useAdminRevenue(
    1,
    pageSize,
    period,
    activeSearch || undefined,
    statusFilter === 'All' ? undefined : statusFilter
  )

  // From the user's payload example, the backend returns:
  // "appliedPeriod", "totalPayments", "totalSales", "totalRevenue", "totalOwnerPayouts", "statusBreakdown"
  // And we expect payments to be under a "payments" object with "items". The user's example had no payments array visible in the short snippet, 
  // but let's assume it matches the previous DTO. Wait, the endpoint docs mention "Revenue" report has columns. 
  // The API might just return the summary details directly if it's the `getRevenueStats` endpoint.

  // Actually, the previous implementation used `apiStats?.payments?.items ?? []`.
  const apiStats = revenueData?.data
  const payments = apiStats?.payments?.items ?? []
  const totalCount = apiStats?.payments?.totalCount ?? 0

  return (
    <div className="space-y-6">
      <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
        <CardHeader>
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <CardTitle className="text-2xl text-[#1a1a1a]">
              {t('revenue.title')}
            </CardTitle>
            <div className="flex flex-col sm:flex-row w-full sm:w-auto items-center gap-2">
              <Select value={period} onValueChange={setPeriod}>
                <SelectTrigger className="w-full sm:w-40 bg-white border-none rounded-xl">
                  <SelectValue placeholder="Period" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="thisMonth">{t('generateReport.periodOptions.thisMonth')}</SelectItem>
                  <SelectItem value="thisYear">{t('generateReport.periodOptions.thisYear')}</SelectItem>
                  <SelectItem value="allTime">{t('generateReport.periodOptions.allTime')}</SelectItem>
                </SelectContent>
              </Select>

              <div className="flex w-full sm:w-auto items-center gap-2">
                <Input
                  placeholder={t('revenue.search')}
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
          </div>
          <div className="flex flex-wrap gap-2 mt-4">
            {['All', 'Available', 'Withdrawn', 'OnHold'].map((status) => (
              <Button
                key={status}
                variant={statusFilter === status ? 'default' : 'outline'}
                size="sm"
                className={statusFilter === status ? 'bg-[#3A6EA5] text-white rounded-xl' : 'rounded-xl border-[#3A6EA5]/20 text-[#4a5565]'}
                onClick={() => setStatusFilter(status)}
              >
                {status === 'All' ? t('tabs.all') : t(`revenue.status.${status.charAt(0).toLowerCase() + status.slice(1)}`)}
              </Button>
            ))}
          </div>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
            <div className="bg-white rounded-2xl p-4 flex items-center gap-4 shadow-sm">
              <div className="w-12 h-12 rounded-xl bg-blue-100 flex items-center justify-center shrink-0">
                <DollarSign className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-sm text-[#4a5565]">{t('revenue.totalSales')}</p>
                <p className="text-xl font-bold text-[#1a1a1a]">{(apiStats?.totalSales ?? 0).toLocaleString()} {t('currency', { ns: 'common' })}</p>
              </div>
            </div>
            <div className="bg-white rounded-2xl p-4 flex items-center gap-4 shadow-sm">
              <div className="w-12 h-12 rounded-xl bg-green-100 flex items-center justify-center shrink-0">
                <DollarSign className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-sm text-[#4a5565]">{t('revenue.platformRevenue')}</p>
                <p className="text-xl font-bold text-[#1a1a1a]">{(apiStats?.totalRevenue ?? 0).toLocaleString()} {t('currency', { ns: 'common' })}</p>
              </div>
            </div>
            <div className="bg-white rounded-2xl p-4 flex items-center gap-4 shadow-sm">
              <div className="w-12 h-12 rounded-xl bg-purple-100 flex items-center justify-center shrink-0">
                <DollarSign className="w-6 h-6 text-purple-600" />
              </div>
              <div>
                <p className="text-sm text-[#4a5565]">{t('revenue.ownerPayouts')}</p>
                <p className="text-xl font-bold text-[#1a1a1a]">{(apiStats?.totalOwnerPayouts ?? 0).toLocaleString()} {t('currency', { ns: 'common' })}</p>
              </div>
            </div>
          </div>

          {!isLoading && payments.length === 0 ? (
            <div className="py-10 text-center text-[#4a5565] border-b border-[#3A6EA5]/20">
              {t('revenue.noPayments')}
            </div>
          ) : (
            <div className="overflow-x-auto overflow-y-scroll max-h-[500px] border-b border-[#3A6EA5]/20">
              <TooltipProvider delayDuration={1000}>
              <table className="w-full relative" style={{ tableLayout: 'fixed' }}>
                <thead className="sticky top-0 bg-[#F2F4F6] z-10">
                  <tr className="border-b border-[#3A6EA5]/20">
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '30%' }}>{t('table.contract')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('revenue.sales')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('revenue.revenue')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('revenue.ownerPayout')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '15%' }}>{t('table.status')}</th>
                    <th className="text-start py-4 px-4 text-[#1a1a1a] font-semibold" style={{ width: '10%' }}>{t('revenue.date')}</th>
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
                  payments.map((item: any) => (
                    <tr key={item.paymentId} className="border-b border-[#3A6EA5]/10 hover:bg-white/50 transition-colors">
                      <td className="py-4 px-4 text-[#1a1a1a] font-medium">
                        <div className="flex flex-col">
                          <span>{item.propertyTitle}</span>
                          <span className="text-xs text-[#4a5565] font-normal">{t('table.renter')}: {item.renterName} • {t('table.owner')}: {item.ownerName}</span>
                        </div>
                      </td>
                      <td className="py-4 px-4 text-[#1a1a1a]">
                        <div className="flex items-center gap-1">
                          <span>{t('currency', { ns: 'common' })}</span>
                          <span>{(item.amountTotal ?? 0).toLocaleString()}</span>
                        </div>
                      </td>
                      <td className="py-4 px-4 text-green-600 font-medium">
                        <div className="flex items-center gap-1">
                          <span>{t('currency', { ns: 'common' })}</span>
                          <span>{(item.platformFee ?? 0).toLocaleString()}</span>
                        </div>
                      </td>
                      <td className="py-4 px-4 text-[#4a5565]">
                        <div className="flex items-center gap-1">
                          <span>{t('currency', { ns: 'common' })}</span>
                          <span>{(item.ownerAmount ?? 0).toLocaleString()}</span>
                        </div>
                      </td>
                      <td className="py-4 px-4">
                        <span className={`px-2 py-1 text-xs rounded-lg font-medium ${item.status === 'Available' ? 'bg-green-100 text-green-700' :
                            item.status === 'Withdrawn' ? 'bg-blue-100 text-blue-700' :
                              'bg-yellow-100 text-yellow-700'
                          }`}>
                          {t(`revenue.status.${item.status.charAt(0).toLowerCase() + item.status.slice(1)}`, { defaultValue: item.status })}
                        </span>
                      </td>
                      <td className="py-4 px-4 text-[#4a5565]">
                        {item.paidAt ? new Date(item.paidAt).toLocaleDateString('en-GB') : '—'}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
            </TooltipProvider>
          </div>
          )}{totalCount > payments.length && (
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
    </div>
  )
}
