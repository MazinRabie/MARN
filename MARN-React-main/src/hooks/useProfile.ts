import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { userService } from '@/services/userService'
import type {
  UpdateProfilePayload,
  ChangePasswordPayload,
  UpdateLegalProfilePayload,
  Toggle2FAPayload,
  UpdateRoommatePreferencesPayload,
} from '@/services/userService'

export function useProfile() {
  const queryClient = useQueryClient()

  const query = useQuery({
    queryKey: ['profile'],
    queryFn: () => userService.getProfile(),
  })

  const update = useMutation({
    mutationFn: (payload: UpdateProfilePayload) =>
      userService.updateProfile(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile'] })
    },
  })

  const updateLegal = useMutation({
    mutationFn: (payload: UpdateLegalProfilePayload) =>
      userService.updateLegalProfile(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile'] })
    },
  })

  const changePassword = useMutation({
    mutationFn: (payload: ChangePasswordPayload) =>
      userService.changePassword(payload),
  })

  const toggle2FA = useMutation({
    mutationFn: (payload: Toggle2FAPayload) => userService.toggle2FA(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile'] })
    },
  })

  const uploadAvatar = useMutation({
    mutationFn: (file: File) => userService.uploadAvatar(file),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile'] })
    },
  })

  const updateRoommate = useMutation({
    mutationFn: (payload: UpdateRoommatePreferencesPayload) =>
      userService.updateRoommatePreferences(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile'] })
    },
  })

  const deleteAccount = useMutation({
    mutationFn: () => userService.deleteProfile(),
  })


  return {
    ...query,
    update,
    updateLegal,
    changePassword,
    uploadAvatar,
    toggle2FA,
    updateRoommate,
    deleteAccount,
  }
}

export function useUserProfile(id: string | undefined) {
  return useQuery({
    queryKey: ['userProfile', id],
    queryFn: () => userService.getUserProfileById(id!),
    enabled: !!id,
  })
}
