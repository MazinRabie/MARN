import { apiClient, axiosInstance } from './apiClient'
import type { ApiResponse, SearchPaginatedResponse } from '@/types/common'
import type { components } from '@/types/api.generated'

export interface AdminStatMetric {
  value: number
  trendPercentage: number
}

export interface AdminRevenueSummary {
  totalRevenue: number
  totalSales: number
  newUsersThisMonth: number
  activeContracts: number
  revenueTrendPercentage: number
}

export interface AdminContractSummary {
  all: number
  active: number
  pending: number
  expired: number
  cancelled: number
}

export interface AdminMonthlyRevenue {
  year: number
  month: number
  label: string
  revenue: number
  sales: number
}

export interface AdminStats {
  totalUsers: AdminStatMetric
  totalProperties: AdminStatMetric
  pendingVerifications: AdminStatMetric
  totalContracts: AdminStatMetric
  revenueSummary: AdminRevenueSummary
  contractSummary: AdminContractSummary
  monthlyRevenue: AdminMonthlyRevenue[]
}

export interface AdminUser {
  id: string
  name: string
  email: string
  role: string
  status: string
  joinDate: string
}

export interface AdminPropertyStatsItem {
  propertyId: number
  title: string
  ownerName: string
  ownerId: string
  status: string
  statusDisplayName: string
  type: string
  typeDisplayName: string
  city: string
  cityDisplayName: string
  governorate: string
  governorateDisplayName: string
  price: number
  averageRating: number
  commentsCount: number
  isActive: boolean
  canDeactivate: boolean
  canRestore: boolean
  isDeleted: boolean
  createdAt: string
}

export interface AdminStatsPropertiesResponse {
  appliedPeriod: unknown
  totalProperties: number
  deletedProperties: number
  activeProperties: number
  inactiveProperties: number
  statusBreakdown: unknown[]
  typeBreakdown: unknown[]
  governorateBreakdown: unknown[]
  properties: SearchPaginatedResponse<AdminPropertyStatsItem>
}

export interface AdminContractStatsItem {
  contractId: number
  status: string
  statusDisplayName: string
  transactionId: string | null
  merkleRoot: string | null
  anchoringStatus: string
  anchoringStatusDisplayName: string
  isAnchoredToBlockChain: boolean
  canCancel: boolean
  createdAt: string
  leaseStartDate: string
  leaseEndDate: string
  totalContractAmount: number
  paymentFrequency: string
  paymentFrequencyDisplayName: string
  propertyId: number
  propertyTitle: string
  ownerId: string
  ownerName: string
  renterId: string
  renterName: string
}

export interface AdminStatsContractsResponse {
  appliedPeriod: unknown
  totalContracts: number
  totalContractValue: number
  statusBreakdown: unknown[]
  contracts: SearchPaginatedResponse<AdminContractStatsItem>
}

export interface AdminUserStatsItem {
  userId: string
  fullName: string
  email: string
  phoneNumber?: string | null
  profileImage: string | null
  accountStatus: string
  accountStatusDisplayName: string
  isDeleted: boolean
  createdAt: string
  roles: string[]
  rolesDisplayNames: string[]
  ownedPropertiesCount: number
  activePropertiesCount: number
  renterContractsCount: number
  ownerContractsCount: number
  activeContractsCount: number
  cancelledContractsCount: number
  paymentsMadeCount: number
  paymentsReceivedCount: number
  totalPaidAmount: number
  totalReceivedAmount: number
  reportsSubmittedCount: number
  reportsAgainstUserCount: number
}

export interface AdminStatusBreakdown {
  status: string
  statusDisplayName: string
  count: number
}

export interface AdminRoleBreakdown {
  roleName: string
  roleNameDisplayName: string
  count: number
}

export interface AdminNewUsersOverTime {
  periodStartUtc: string
  label: string
  count: number
}

export interface AdminUserStats {
  appliedPeriod: {
    period: string
    fromUtc: string | null
    toUtc: string | null
    grouping: string
  }
  totalUsers: number
  deletedUsers: number
  statusBreakdown: AdminStatusBreakdown[]
  roleBreakdown: AdminRoleBreakdown[]
  newUsersOverTime: AdminNewUsersOverTime[]
  users: {
    items: AdminUserStatsItem[]
    pageNumber: number
    pageSize: number
    totalCount: number
    totalPages: number
  }
}

export interface PendingUserVerification {
  userId: string
  fullName: string
  email: string
  phoneNumber: string | null
  profileImage: string | null
  createdAt: string
  accountStatus: string
  accountStatusDisplayName: string
  frontIdPhoto: string | null
  backIdPhoto: string | null
  arabicFullName: string | null
  arabicAddress: string | null
  nationalIDNumber: string | null
  birthDate?: string | null
  gender?: string | null
}

export interface AdminRoleUser {
  userId: string
  fullName: string
  email: string
  profileImage: string | null
  accountStatus: string
  accountStatusDisplayName: string
  isDeleted: boolean
  createdAt: string
  roles: string[]
  rolesDisplayNames: string[]
}

export interface AdminRoleUsersResult {
  items: AdminRoleUser[]
  pageNumber: number
  pageSize: number
  totalCount: number
  totalPages: number
}

export interface AdminAnalyticsReport {
  reportId: number
  scope: string
  scopeDisplayName: string
  format: string
  formatDisplayName: string
  period: string
  periodDisplayName: string
  fileName: string
  fileSizeBytes: number | null
  generatedAt: string
  fromUtc: string | null
  toUtc: string | null
}

export interface AdminAnalyticsReportsResult {
  items: AdminAnalyticsReport[]
  pageNumber: number
  pageSize: number
  totalCount: number
  totalPages: number
}

export type GenerateReportPayload =
  components['schemas']['AdminAnalyticsReportGenerateRequestDto']

export interface AdminModerationReport {
  reportId: number
  reportableType: string
  reportableTypeDisplayName?: string
  status: string
  statusDisplayName?: string
  reason: string
  createdAt: string
  reviewedAt: string | null
  actionTaken: string | null
  actionTakenDisplayName: string
  actionsTaken: string[]
  actionsTakenDisplayNames: string[]
  reporterId: string
  reporterName: string
  reviewerId: string | null
  reviewerName: string | null
  targetLabel: string
}

export interface ModerationReportTarget {
  exists: boolean
  isHidden: boolean
  isDeletedOrInactive: boolean
  title: string
  subtitle: string
  preview: string
  userId: string | null
  propertyId: number | null
  messageId: string | null
  propertyCommentId: number | null
}

export interface AdminModerationReportDetail extends AdminModerationReport {
  reviewerNote: string | null
  reportableTargetId: string
  target: ModerationReportTarget
}

export enum ReportModerationActionType {
  BanUser = 'BanUser',
  DeactivateProperty = 'DeactivateProperty',
  HideMessage = 'HideMessage',
  HidePropertyComment = 'HidePropertyComment'
}

export interface ReviewModerationReportPayload {
  status: 'Resolved' | 'Rejected'
  note?: string
  actionTypes?: string[]
}

// PATCH with no request body — removes Content-Type so ASP.NET doesn't attempt to read an absent body
const patchNoBody = (url: string) =>
  axiosInstance
    .patch(url, undefined, {
      transformRequest: (_, headers) => {
        delete headers['Content-Type']
        return undefined
      },
    })
    .then((r) => r.data)

// No schema in swagger — defined manually from API docs
export interface PendingPropertyVerification {
  propertyId: number
  title: string
  address: string
  city: string
  cityDisplayName: string
  governorate: string
  governorateDisplayName: string
  type: string
  typeDisplayName: string
  status: string
  statusDisplayName: string
  ownerFullName: string
  ownerEmail: string
  ownerId: string
  createdAt: string
  primaryImage: string | null
}

export interface PendingPropertyVerificationDetail extends PendingPropertyVerification {
  description: string | null
  proofOfOwnership: string | null
  ownerAccountStatus: string
  ownerAccountStatusDisplayName: string
  price: number
  rentalUnit: string
  rentalUnitDisplayName: string
  zipCode: string | null
  latitude: number | null
  longitude: number | null
  isActive: boolean
}

export interface AdminRoleDefinition {
  roleName: string
  normalizedName: string
  usersCount: number
  isProtected: boolean
  isAssignable: boolean
}

export interface AdminDetailedPaymentListItemDto {
  paymentId: number
  contractId: number
  paymentScheduleId: number
  status: string
  statusDisplayName: string
  amountTotal: number
  platformFee: number
  ownerAmount: number
  paidAt: string | null
  availableAt: string | null
  currency: string
  propertyId: number
  propertyTitle: string
  ownerId: string
  ownerName: string
  renterId: string
  renterName: string
}

export interface AdminStatsRevenueResponse {
  appliedPeriod: unknown
  totalPayments: number
  totalSales: number
  totalRevenue: number
  totalOwnerPayouts: number
  statusBreakdown: unknown[]
  revenueOverTime: unknown[]
  payments: SearchPaginatedResponse<AdminDetailedPaymentListItemDto>
}

export const adminService = {
  getStats: () =>
    apiClient.get<ApiResponse<AdminStats>>('/api/Admin/dashboard/overview'),

  getUsers: (page = 1, pageSize = 20, search?: string, status?: string, includeDeleted?: boolean) => {
    const params = new URLSearchParams({
      PageNumber: String(page),
      PageSize: String(pageSize),
    })
    if (search) params.append('Search', search)
    if (status && status !== 'All') params.append('AccountStatus', status)
    if (includeDeleted) params.append('IncludeDeleted', 'true')
    return apiClient.get<ApiResponse<SearchPaginatedResponse<AdminUserStatsItem>>>(
      `/api/Admin/users?${params}`,
    )
  },

  getUserStats: (page = 1, pageSize = 20) =>
    apiClient.get<ApiResponse<AdminUserStats>>(
      `/api/Admin/stats/users?PageNumber=${page}&PageSize=${pageSize}`,
    ),

  getVerifications: (page = 1, pageSize = 20) =>
    apiClient.get<
      ApiResponse<SearchPaginatedResponse<PendingUserVerification>>
    >(
      `/api/Admin/verifications/users/pending?pageNumber=${page}&pageSize=${pageSize}`,
    ),

  getUserVerification: (userId: string) =>
    apiClient.get<ApiResponse<PendingUserVerification>>(
      `/api/Admin/verifications/users/${userId}`,
    ),

  approveVerification: (userId: string) =>
    patchNoBody(`/api/Admin/verifications/users/${userId}/approve`),

  rejectVerification: (userId: string, reason: string) =>
    apiClient.patch<ApiResponse<boolean>>(
      `/api/Admin/verifications/users/${userId}/decline`,
      { reason },
    ),

  banUser: (userId: string) => patchNoBody(`/api/Admin/users/${userId}/ban`),

  unbanUser: (userId: string) =>
    patchNoBody(`/api/Admin/users/${userId}/unban`),

  restoreUser: (userId: string) =>
    patchNoBody(`/api/Admin/users/${userId}/restore`),
    
  deleteUser: (userId: string) => 
    apiClient.delete<ApiResponse<void>>(`/api/Admin/users/${userId}`),

  getRoleUsers: (page = 1, pageSize = 20, search?: string) => {
    const params = new URLSearchParams({
      PageNumber: String(page),
      PageSize: String(pageSize),
    })
    if (search) params.append('Search', search)
    return apiClient.get<ApiResponse<AdminRoleUsersResult>>(
      `/api/Admin/roles/users?${params}`,
    )
  },

  updateUserRoles: (userId: string, roles: string[]) =>
    apiClient.patch<ApiResponse<void>>(`/api/Admin/roles/users/${userId}`, {
      roles,
    }),

  generateReport: (payload: GenerateReportPayload) =>
    apiClient.post<void>('/api/Admin/analytics-reports/generate', payload),

  getAnalyticsReports: (page = 1, pageSize = 20) =>
    apiClient.get<ApiResponse<AdminAnalyticsReportsResult>>(
      `/api/Admin/analytics-reports?PageNumber=${page}&PageSize=${pageSize}`,
    ),

  downloadAnalyticsReport: (reportId: number) =>
    axiosInstance.get<Blob>(
      `/api/Admin/analytics-reports/${reportId}/download`,
      {
        responseType: 'blob',
      },
    ),

  getPendingPropertyVerifications: (page = 1, pageSize = 20, search?: string) => {
    const params = new URLSearchParams({
      PageNumber: String(page),
      PageSize: String(pageSize),
    })
    if (search) params.append('Search', search)
    return apiClient.get<
      ApiResponse<SearchPaginatedResponse<PendingPropertyVerification>>
    >(`/api/Admin/verifications/properties/pending?${params}`)
  },

  getPropertyVerification: (propertyId: number) =>
    apiClient.get<ApiResponse<PendingPropertyVerificationDetail>>(
      `/api/Admin/verifications/properties/${propertyId}`,
    ),

  approvePropertyVerification: (propertyId: number) =>
    patchNoBody(`/api/Admin/verifications/properties/${propertyId}/approve`),

  declinePropertyVerification: (propertyId: number, reason: string) =>
    apiClient.patch<ApiResponse<boolean>>(
      `/api/Admin/verifications/properties/${propertyId}/decline`,
      { reason },
    ),

  getModerationReports: (page = 1, pageSize = 20, search?: string, status?: string) => {
    const params = new URLSearchParams({
      PageNumber: String(page),
      PageSize: String(pageSize),
    })
    if (search) params.append('Search', search)
    if (status && status !== 'All') params.append('Status', status)
    return apiClient.get<ApiResponse<{ reports: SearchPaginatedResponse<AdminModerationReport>, statusBreakdown: any[], typeBreakdown: any[] }>>(
      `/api/Admin/reports?${params}`,
    )
  },

  getModerationReport: (reportId: number) =>
    apiClient.get<ApiResponse<AdminModerationReportDetail>>(`/api/Admin/reports/${reportId}`),

  reviewModerationReport: (reportId: number, payload: ReviewModerationReportPayload) =>
    axiosInstance.patch<ApiResponse<void>>(`/api/Admin/reports/${reportId}/review`, payload, { headers: { 'Content-Type': 'application/json' } }).then(r => r.data),

  getProperties: (page = 1, pageSize = 20, search?: string, status?: string) => {
    const params = new URLSearchParams({
      PageNumber: String(page),
      PageSize: String(pageSize),
    })
    if (search) params.append('Search', search)
    if (status && status !== 'All') params.append('Status', status)
    params.append('IncludeDeleted', 'true')
    return apiClient.get<ApiResponse<AdminStatsPropertiesResponse>>(
      `/api/Admin/stats/properties?${params}`,
    )
  },

  deleteProperty: (propertyId: number) =>
    apiClient.delete<ApiResponse<void>>(`/api/Admin/stats/properties/${propertyId}`),

  deleteComment: (propertyId: number, commentId: number) =>
    apiClient.delete<ApiResponse<void>>(`/api/properties/${propertyId}/comments/${commentId}`),

  restoreProperty: (propertyId: number) =>
    patchNoBody(`/api/Admin/stats/properties/${propertyId}/restore-deleted`),

  getContracts: (page = 1, pageSize = 20, search?: string, status?: string) => {
    const params = new URLSearchParams({
      PageNumber: String(page),
      PageSize: String(pageSize),
    })
    if (search) params.append('Search', search)
    if (status && status !== 'All') params.append('Status', status)
    return apiClient.get<ApiResponse<AdminStatsContractsResponse>>(
      `/api/Admin/stats/contracts?${params}`,
    )
  },

  downloadContractPdf: (contractId: number) =>
    axiosInstance.get<Blob>(`/api/contracts/${contractId}/download`, {
      responseType: 'blob',
    }),

  cancelContract: (contractId: number) =>
    patchNoBody(`/api/Admin/stats/contracts/${contractId}/cancel`),

  getRoles: () => apiClient.get<ApiResponse<AdminRoleDefinition[]>>('/api/Admin/roles'),

  getRevenueStats: (page = 1, pageSize = 20, period = 'thisYear', search?: string, status?: string) => {
    const params = new URLSearchParams({
      PageNumber: String(page),
      PageSize: String(pageSize),
      period: period,
    })
    if (search) params.append('Search', search)
    if (status && status !== 'All') params.append('Status', status)
    return apiClient.get<ApiResponse<AdminStatsRevenueResponse>>(
      `/api/Admin/stats/revenue?${params}`
    )
  },
}
