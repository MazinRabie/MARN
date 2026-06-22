import { motion } from 'motion/react'
import { useSearchParams } from 'react-router-dom'
import {
  Users,
  Building,
  Clock,
  FileText,
  DollarSign,
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../../components/ui/tabs'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts'
import { useAdminStats } from '@/hooks/useAdminStats'
import { formatTrend } from './utils'
import {
  PropertyModerationTab,
  UserManagementTab,
  ReportsTab,
  ModerationReportsTab,
  ContractsModerationTab,
} from './tabs'
import { useTranslation } from 'react-i18next'

export function AdminDashboardPage() {
  const { t, i18n } = useTranslation('admin')
  const [searchParams, setSearchParams] = useSearchParams()
  const currentTab = searchParams.get('tab') || 'users'

  const handleTabChange = (value: string) => {
    setSearchParams((prev) => {
      prev.set('tab', value)
      // Clear sub-tab params when switching main tabs
      prev.delete('subtab')
      return prev
    }, { replace: true, preventScrollReset: true })
  }

  const { data: statsData, isLoading: statsLoading } = useAdminStats()

  const apiStats = statsData?.data
  const revenueData = apiStats?.monthlyRevenue ?? []

  const stats = [
    {
      icon: Users,
      label: t('stats.totalUsers'),
      value: statsLoading
        ? '…'
        : (apiStats?.totalUsers?.value ?? 0).toLocaleString(),
      change: statsLoading
        ? ''
        : formatTrend(apiStats?.totalUsers?.trendPercentage),
      color: 'from-blue-500 to-blue-600',
    },
    {
      icon: Building,
      label: t('stats.totalListings'),
      value: statsLoading
        ? '…'
        : (apiStats?.totalProperties?.value ?? 0).toLocaleString(),
      change: statsLoading
        ? ''
        : formatTrend(apiStats?.totalProperties?.trendPercentage),
      color: 'from-green-500 to-green-600',
    },
    {
      icon: Clock,
      label: t('stats.pendingVerifications'),
      value: statsLoading
        ? '…'
        : (apiStats?.pendingVerifications?.value ?? 0).toLocaleString(),
      change: statsLoading
        ? ''
        : formatTrend(apiStats?.pendingVerifications?.trendPercentage),
      color: 'from-yellow-500 to-yellow-600',
    },
    {
      icon: FileText,
      label: t('stats.activeContracts'),
      value: statsLoading
        ? '…'
        : (apiStats?.revenueSummary?.activeContracts ?? 0).toLocaleString(),
      change: statsLoading
        ? ''
        : formatTrend(apiStats?.totalContracts?.trendPercentage),
      color: 'from-purple-500 to-purple-600',
    },
  ]

  return (
    <div className="min-h-screen py-20">
      <div className="max-w-[1440px] mx-auto px-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          {/* Header */}
          <div className="mb-8">
            <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
              {t('header.title')}
            </h1>
            <p className="text-lg text-[#4a5565]">
              {t('header.subtitle')}
            </p>
          </div>

          {/* Stats Cards */}
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
            {stats.map((stat, index) => {
              const Icon = stat.icon
              return (
                <motion.div
                  key={stat.label}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 }}
                >
                  <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
                    <CardContent className="pt-6">
                      <div className="flex items-start justify-between mb-4">
                        <div
                          className={`w-12 h-12 rounded-2xl bg-gradient-to-br ${stat.color} flex items-center justify-center`}
                        >
                          <Icon className="w-6 h-6 text-white" />
                        </div>
                        <span
                          className={`text-sm font-semibold ${
                            stat.change.startsWith('+')
                              ? 'text-green-600'
                              : 'text-red-600'
                          }`}
                        >
                          {stat.change}
                        </span>
                      </div>
                      <h3 className="text-3xl font-bold text-[#1a1a1a] mb-1">
                        {stat.value}
                      </h3>
                      <p className="text-sm text-[#4a5565]">{stat.label}</p>
                    </CardContent>
                  </Card>
                </motion.div>
              )
            })}
          </div>

          {/* Revenue & Sales Data Section */}
          <div className="grid lg:grid-cols-3 gap-6 mb-12">
            <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <CardTitle className="text-xl text-[#1a1a1a] flex items-center gap-2">
                  <DollarSign className="w-5 h-5 text-[#3A6EA5]" />
                  {t('revenue.title')}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="bg-white rounded-2xl p-4">
                  <p className="text-sm text-[#4a5565] mb-1">{t('revenue.totalRevenue')}</p>
                  <p className="text-3xl font-bold text-[#3A6EA5]">
                    {statsLoading
                      ? '…'
                      : `${(apiStats?.revenueSummary?.totalRevenue ?? 0).toLocaleString()} ${t('currency', { ns: 'common' })}`}
                  </p>
                  {!statsLoading &&
                    apiStats?.revenueSummary?.revenueTrendPercentage !=
                      null && (
                      <p
                        className={`text-sm mt-1 ${
                          apiStats.revenueSummary.revenueTrendPercentage >= 0
                            ? 'text-green-600'
                            : 'text-red-600'
                        }`}
                      >
                        {formatTrend(
                          apiStats.revenueSummary.revenueTrendPercentage,
                        )}{' '}
                        {t('revenue.fromLastPeriod')}
                      </p>
                    )}
                </div>
                <div className="bg-white rounded-2xl p-4">
                  <p className="text-sm text-[#4a5565] mb-1">
                    {t('revenue.activeContracts')}
                  </p>
                  <p className="text-2xl font-bold text-[#1a1a1a]">
                    {statsLoading
                      ? '…'
                      : (
                          apiStats?.revenueSummary?.activeContracts ?? 0
                        ).toLocaleString()}
                  </p>
                </div>
                <div className="bg-white rounded-2xl p-4">
                  <p className="text-sm text-[#4a5565] mb-1">
                    {t('revenue.newUsersThisMonth')}
                  </p>
                  <p className="text-2xl font-bold text-[#1a1a1a]">
                    {statsLoading
                      ? '…'
                      : (
                          apiStats?.revenueSummary?.newUsersThisMonth ?? 0
                        ).toLocaleString()}
                  </p>
                </div>
              </CardContent>
            </Card>

            <Card className="lg:col-span-2 bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
              <CardHeader>
                <CardTitle className="text-xl text-[#1a1a1a]">
                  {t('revenue.monthlyRevenueGraph')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="h-64" dir="ltr">
                  <ResponsiveContainer width="100%" height="100%">
                    <LineChart data={revenueData}>
                      <CartesianGrid
                        strokeDasharray="3 3"
                        stroke="#3A6EA5"
                        opacity={0.2}
                      />
                      <XAxis 
                        dataKey="label" 
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
                          backgroundColor: 'white',
                          border: '1px solid #3A6EA5',
                          borderRadius: '12px',
                        }}
                        formatter={(value: number) =>
                          [`${value.toLocaleString()} ${t('currency', { ns: 'common' })}`, t('revenue.totalRevenue', { defaultValue: 'Revenue' })]
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
                        name={t('revenue.totalRevenue', { defaultValue: 'Revenue' })}
                        type="monotone"
                        dataKey="revenue"
                        stroke="#3A6EA5"
                        strokeWidth={3}
                        dot={{ fill: '#3A6EA5', r: 6 }}
                      />
                    </LineChart>
                  </ResponsiveContainer>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Main Content Tabs */}
          <Tabs value={currentTab} onValueChange={handleTabChange} className="space-y-8" dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}>
            <TabsList className="w-full h-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 bg-[#EEF3F9] p-2 rounded-[2rem] gap-2 border border-[#3A6EA5]/20 shadow-lg shadow-[#3A6EA5]/15">
              <TabsTrigger
                value="property-moderation"
                className="w-full rounded-2xl py-3 px-2 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md h-auto whitespace-normal text-center"
              >
                {t('tabs.properties')}
              </TabsTrigger>
              <TabsTrigger
                value="users"
                className="w-full rounded-2xl py-3 px-2 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md h-auto whitespace-normal text-center"
              >
                {t('tabs.users')}
              </TabsTrigger>
              <TabsTrigger
                value="reports"
                className="w-full rounded-2xl py-3 px-2 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md h-auto whitespace-normal text-center"
              >
                {t('tabs.reports')}
              </TabsTrigger>
              <TabsTrigger
                value="contracts"
                className="w-full rounded-2xl py-3 px-2 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md h-auto whitespace-normal text-center"
              >
                {t('tabs.contracts')}
              </TabsTrigger>
              <TabsTrigger
                value="moderation"
                className="w-full rounded-2xl py-3 px-2 text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md h-auto whitespace-normal text-center"
              >
                {t('tabs.moderation')}
              </TabsTrigger>
            </TabsList>

            <TabsContent value="property-moderation">
              <PropertyModerationTab />
            </TabsContent>

            <TabsContent value="users">
              <UserManagementTab />
            </TabsContent>

            <TabsContent value="reports">
              <ReportsTab />
            </TabsContent>

            <TabsContent value="moderation">
              <ModerationReportsTab />
            </TabsContent>

            <TabsContent value="contracts">
              <ContractsModerationTab />
            </TabsContent>
          </Tabs>
        </motion.div>
      </div>
    </div>
  )
}
