import { useQuery, keepPreviousData } from '@tanstack/react-query'
import { adminService } from '@/services/adminService'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import type { GenerateReportPayload, ReviewModerationReportPayload } from '@/services/adminService'

export function useAdminStats() {
  return useQuery({
    queryKey: ['adminStats'],
    queryFn: () => adminService.getStats(),
    staleTime: 5 * 60 * 1000,
  })
}

export function useAdminUsers(page = 1, pageSize = 20, search?: string, status?: string, includeDeleted?: boolean) {
  return useQuery({
    queryKey: ['adminUsers', page, pageSize, search, status, includeDeleted],
    queryFn: () => adminService.getUsers(page, pageSize, search, status, includeDeleted),
    placeholderData: keepPreviousData,
  })
}

export function useAdminVerifications(page = 1, pageSize = 20) {
  return useQuery({
    queryKey: ['adminVerifications', page, pageSize],
    queryFn: () => adminService.getVerifications(page, pageSize),
    placeholderData: keepPreviousData,
  })
}

export function useAdminUserStats(page = 1, pageSize = 20) {
  return useQuery({
    queryKey: ['adminUserStats', page, pageSize],
    queryFn: () => adminService.getUserStats(page, pageSize),
    placeholderData: keepPreviousData,
  })
}

export function useAdminUserVerification(userId: string | null) {
  return useQuery({
    queryKey: ['adminUserVerification', userId],
    queryFn: () => adminService.getUserVerification(userId!),
    enabled: !!userId,
    staleTime: 60 * 1000,
  })
}

export function useAdminRoleUsers(page = 1, pageSize = 20, search?: string) {
  return useQuery({
    queryKey: ['adminRoleUsers', page, pageSize, search],
    queryFn: () => adminService.getRoleUsers(page, pageSize, search),
    placeholderData: keepPreviousData,
  })
}

export function useAdminAnalyticsReports(page = 1, pageSize = 20) {
  return useQuery({
    queryKey: ['adminAnalyticsReports', page, pageSize],
    queryFn: () => adminService.getAnalyticsReports(page, pageSize),
    staleTime: 30 * 1000,
    placeholderData: keepPreviousData,
  })
}

export function useGenerateReport() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (payload: GenerateReportPayload) =>
      adminService.generateReport(payload),
    onSuccess: () => {
      toast.success('Report generated successfully')
      queryClient.invalidateQueries({ queryKey: ['adminAnalyticsReports'] })
    },
    onError: () => toast.error('Failed to generate report'),
  })
}

export function useAdminPropertyVerifications(page = 1, pageSize = 20) {
  return useQuery({
    queryKey: ['adminPropertyVerifications', page, pageSize],
    queryFn: () => adminService.getPendingPropertyVerifications(page, pageSize),
    placeholderData: keepPreviousData,
  })
}

export function useAdminPropertyVerification(propertyId: number | null) {
  return useQuery({
    queryKey: ['adminPropertyVerification', propertyId],
    queryFn: () => adminService.getPropertyVerification(propertyId!),
    enabled: propertyId != null,
    staleTime: 60 * 1000,
  })
}

export function useUpdateUserRoles() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ userId, roles }: { userId: string; roles: string[] }) =>
      adminService.updateUserRoles(userId, roles),
    onSuccess: () => {
      toast.success('Roles updated successfully')
      queryClient.invalidateQueries({ queryKey: ['adminRoleUsers'] })
    },
    onError: () => toast.error('Failed to update roles'),
  })
}

export function useAdminModerationReports(page = 1, pageSize = 20, search?: string, status?: string) {
  return useQuery({
    queryKey: ['adminModerationReports', page, pageSize, search, status],
    queryFn: () => adminService.getModerationReports(page, pageSize, search, status),
    placeholderData: keepPreviousData,
  })
}

export function useAdminModerationReport(reportId: number | null) {
  return useQuery({
    queryKey: ['adminModerationReport', reportId],
    queryFn: () => adminService.getModerationReport(reportId!),
    enabled: reportId != null,
  })
}

export function useReviewModerationReport() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ reportId, payload }: { reportId: number; payload: ReviewModerationReportPayload }) =>
      adminService.reviewModerationReport(reportId, payload),
    onSuccess: () => {
      toast.success('Report reviewed successfully')
      queryClient.invalidateQueries({ queryKey: ['adminModerationReports'] })
    },
    onError: () => toast.error('Failed to review report'),
  })
}

export function useAdminProperties(page = 1, pageSize = 20, search?: string, status?: string) {
  return useQuery({
    queryKey: ['adminProperties', page, pageSize, search, status],
    queryFn: () => adminService.getProperties(page, pageSize, search, status),
    placeholderData: keepPreviousData,
  })
}

export function useAdminContracts(page = 1, pageSize = 20, search?: string, status?: string) {
  return useQuery({
    queryKey: ['adminContracts', page, pageSize, search, status],
    queryFn: () => adminService.getContracts(page, pageSize, search, status),
    placeholderData: keepPreviousData,
  })
}

export function useCancelContract() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (contractId: number) => adminService.cancelContract(contractId),
    onSuccess: () => {
      toast.success('Contract cancelled successfully')
      queryClient.invalidateQueries({ queryKey: ['adminContracts'] })
    },
    onError: () => toast.error('Failed to cancel contract'),
  })
}

export function useAdminRoles() {
  return useQuery({
    queryKey: ['adminRoles'],
    queryFn: () => adminService.getRoles(),
    staleTime: 5 * 60 * 1000,
  })
}

export function useAdminRevenue(page = 1, pageSize = 20, period = 'thisYear', search?: string, status?: string) {
  return useQuery({
    queryKey: ['adminRevenue', page, pageSize, period, search, status],
    queryFn: () => adminService.getRevenueStats(page, pageSize, period, search, status),
    placeholderData: keepPreviousData,
  })
}

export function useAdminPropertyModerationQueue(page = 1, pageSize = 20, search?: string) {
  return useQuery({
    queryKey: ['adminPropertyModerationQueue', page, pageSize, search],
    queryFn: () => adminService.getPendingPropertyVerifications(page, pageSize, search),
    placeholderData: keepPreviousData,
  })
}

export function useReviewPropertyModeration() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ propertyId, status, note }: { propertyId: number; status: 'Approved' | 'Rejected' | 'Pending'; note?: string }) => {
      if (status === 'Approved') {
        return adminService.approvePropertyVerification(propertyId)
      } else if (status === 'Rejected' || status === 'Declined') {
        return adminService.declinePropertyVerification(propertyId, note || 'Declined by admin')
      }
      throw new Error('Unsupported status')
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['adminPropertyModerationQueue'] })
      queryClient.invalidateQueries({ queryKey: ['adminProperties'] })
    },
    onError: () => toast.error('Failed to review property'),
  })
}

export function useDeleteProperty() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (propertyId: number) => adminService.deleteProperty(propertyId),
    onSuccess: () => {
      toast.success('Property deleted successfully')
      queryClient.invalidateQueries({ queryKey: ['adminProperties'] })
      queryClient.invalidateQueries({ queryKey: ['adminPropertyModerationQueue'] })
    },
    onError: () => toast.error('Failed to delete property'),
  })
}

export function useRestoreProperty() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (propertyId: number) => adminService.restoreProperty(propertyId),
    onSuccess: () => {
      toast.success('Property restored successfully')
      queryClient.invalidateQueries({ queryKey: ['adminProperties'] })
      queryClient.invalidateQueries({ queryKey: ['adminPropertyModerationQueue'] })
    },
    onError: () => toast.error('Failed to restore property'),
  })
}
