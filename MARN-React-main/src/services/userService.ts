import { apiClient } from './apiClient'
import type { ApiResponse } from '@/types/common'

// ─── Renter Dashboard ───────────────────────────────────────────────────────

export interface DashboardNotification {
  id: number
  type: string
  typeDisplayName: string
  title: string
  isRead: boolean
  createdAt: string
}

export interface DashboardNextPayment {
  date: string
  amount: number
  propertyId: number
  propertyTitle: string
}

export interface DashboardActiveRental {
  contractId: number
  id?: string
  propertyId?: string
  propertyTitle: string
  propertyName?: string
  contractStatus: string
  contractStatusDisplayName: string
  status?: string
  startDate: string
  endDate: string
  expiryDate?: string
  propertyAddress: string
  propertyImageUrl: string
  paymentFrequency: string
  paymentFrequencyDisplayName: string
  nextPaymentScheduleDate?: string
  nextPaymentScheduleId?: number
  nextPaymentScheduleStatus?: string
  nextPaymentScheduleStatusDisplayName?: string
  ownerId?: string
  monthlyRent?: number
  rentAmount?: number
  price?: number
  isAnchoredToBlockChain?: boolean
  anchoringStatus?: string
  anchoringStatusDisplayName?: string
  transactionId?: string
  merkleRoot?: string
}

export interface DashboardPendingBooking {
  bookingRequestId: number
  id?: string
  propertyId: number | string
  propertyTitle: string
  propertyName?: string
  startDate: string
  endDate: string
  requestedDate?: string
  status?: string
  paymentFrequency?: string
  paymentFrequencyDisplayName?: string
  ownerId?: string
  ownerName?: string
  ownerProfileImage?: string
}

export interface DashboardSavedProperty {
  id: number | string
  propertyId?: number | string
  title: string
  price: number
  location?: string
  address?: string
  imageUrl?: string | null
  imagePath?: string | null
  image?: string | null
  images?: string[]
  bedrooms?: number
  bathrooms?: number
  maxOccupants?: number
  type?: string
  typeDisplayName?: string
  averageRating?: number
  ratings?: number
  rentalUnit?: string
  rentalUnitDisplayName?: string
  isSaved?: boolean
}

export interface DashboardContract {
  contractId: number
  id?: string
  propertyTitle: string
  propertyName?: string
  contractStatus: string
  contractStatusDisplayName: string
  status?: string
  expiryDate: string
  endDate?: string
  startDate?: string
  documentUrl?: string
  ownerId?: string
  ownerName?: string
  propertyId?: number
  isAnchoredToBlockChain?: boolean
  anchoringStatus?: string
  anchoringStatusDisplayName?: string
  transactionId?: string
  merkleRoot?: string
}

export interface DashboardPaidPayment {
  contractId: number
  id?: string
  transactionId?: string
  amountPaid: number
  amount?: number
  price?: number
  paidAt: string
  propertyTitle?: string
  propertyName?: string
}

export interface RenterDashboard {
  activeRentalsCount: number
  nextPayment: DashboardNextPayment | null
  savedPropertiesCount: number
  unreadNotificationsCount: number
  accountStatus: string
  accountStatusDisplayName: string
  activeRentals: DashboardActiveRental[]
  pendingBookingRequests: DashboardPendingBooking[]
  savedProperties: DashboardSavedProperty[]
  notifications: DashboardNotification[]
  allContracts: DashboardContract[]
  paidPayments: DashboardPaidPayment[]
}

export interface Profile {
  id: string
  email: string
  phoneNumber: string | null
  firstName: string
  lastName: string
  dateOfBirth: string | null
  language: string | null
  profileImage: string | null
  gender: string | null
  country: string | null
  bio: string | null
  frontIdPhoto: string | null
  backIdPhoto: string | null
  arabicAddress: string | null
  arabicFullName: string | null
  nationalIDNumber: string | null
  twoFactorEnabled: boolean
  governorate: string | null
  searchStatus: string | null
  roommatePreferencesEnabled: boolean
  smoking: boolean | null
  smokingImportance: number | null
  pets: boolean | null
  petsImportance: number | null
  sleepSchedule: string | null
  sleepImportance: number | null
  educationLevel: string | null
  educationImportance: number | null
  fieldOfStudy: string | null
  fieldOfStudyImportance: number | null
  noiseTolerance: number | null
  noiseToleranceImportance: number | null
  guestsFrequency: string | null
  guestsFrequencyImportance: number | null
  workSchedule: string | null
  workScheduleImportance: number | null
  sharingLevel: string | null
  sharingLevelImportance: number | null
  budgetRangeMin: number | null
  budgetRangeMax: number | null
  budgetImportance: number | null
}

export interface PublicProfileProperty {
  id: number
  title: string
  address: string
  imagePath: string | null
  price: number
  rentalUnit: string
  rentalUnitDisplayName: string
  type: string
  typeDisplayName: string
  averageRating: number
  ratings: number
}

export interface PublicProfile {
  id: string
  fullName: string
  email: string
  profileImage: string | null
  accountStatus: string
  accountStatusDisplayName?: string
  bio: string | null
  isOwner: boolean
  roommatePreferencesEnabled: boolean
  smoking: boolean | null
  pets: boolean | null
  sleepSchedule: string | null
  sleepScheduleDisplayName?: string
  educationLevel: string | null
  educationLevelDisplayName?: string
  fieldOfStudy: string | null
  fieldOfStudyDisplayName?: string
  noiseTolerance: number | null
  guestsFrequency: string | null
  guestsFrequencyDisplayName?: string
  workSchedule: string | null
  workScheduleDisplayName?: string
  sharingLevel: string | null
  sharingLevelDisplayName?: string
  budgetRangeMin: number | null
  budgetRangeMax: number | null
  
  // Basic Info added
  memberSince?: string
  dateOfBirth?: string | null
  gender?: string | null
  genderDisplayName?: string
  country?: string | null
  countryDisplayName?: string

  // Owner Data
  averageRating?: number
  ratingsCount?: number
  ownedPropertiesCount?: number
  ownedProperties?: PublicProfileProperty[]

  // Match Data (when viewed by another user)
  matchingPercentage?: number | null
  topMatchingTraits?: string[]
  mismatchedTraits?: string[]
  dealbreakersFound?: string[]
}

export interface Toggle2FAPayload {
  password: string
}

export interface UpdateLegalProfilePayload {
  id: string
  frontIdPhoto?: File
  backIdPhoto?: File
  arabicAddress: string
  arabicFullName: string
  nationalIDNumber: string
}

export interface UpdateRoommatePreferencesPayload {
  userId: string
  roommatePreferencesEnabled: boolean
  governorate?: string | null
  searchStatus?: string | null
  smoking?: boolean | null
  smokingImportance: number
  pets?: boolean | null
  petsImportance: number
  sleepSchedule?: string | null
  sleepImportance: number
  educationLevel?: string | null
  educationImportance: number
  fieldOfStudy?: string | null
  fieldOfStudyImportance: number
  noiseTolerance?: number | null
  noiseToleranceImportance: number
  guestsFrequency?: string | null
  guestsFrequencyImportance: number
  workSchedule?: string | null
  workScheduleImportance: number
  sharingLevel?: string | null
  sharingLevelImportance: number
  budgetRangeMin?: number | null
  budgetRangeMax?: number | null
  budgetImportance: number
}

export interface ChangePasswordPayload {
  id: string
  currentPassword: string
  newPassword: string
  confirmNewPassword: string
}

export interface UpdateProfilePayload {
  id: string
  firstName: string
  lastName: string
  phoneNumber: string
  country: string
  gender: string
  language: string
  dateOfBirth: string
  bio?: string
  profileImage?: File
}

// ─── Owner Dashboard ─────────────────────────────────────────────────────────

export interface OwnerDashboardProperty {
  id: number
  imagePath: string | null
  title: string
  address: string
  type: string
  typeDisplayName: string
  views: number
  isSaved: boolean
  occupiedPlaces: number
  totalPlaces: number
  price: number
  rentalUnit: string
  rentalUnitDisplayName: string
  averageRating: number
  ratings: number
  isActive: boolean
  status: string
  statusDisplayName: string
  activeContracts: any[]
}

export interface OwnerDashboardMonthlyEarning {
  year: number
  month: number
  total: number
}

export interface OwnerDashboardYearlyEarning {
  year: number
  total: number
}

export interface OwnerDashboardContract {
  contractId: number
  contractStatus: string
  contractStatusDisplayName: string
  transactionId: string
  merkleRoot: string
  anchoringStatus: string
  anchoringStatusDisplayName: string
  isAnchoredToBlockChain: boolean
  expiryDate: string
  renterId: string
  renterName: string
  propertyId: number
  propertyTitle: string
}

export interface OwnerDashboardBookingRequest {
  bookingRequestId: number
  startDate: string
  endDate: string
  paymentFrequency: string
  paymentFrequencyDisplayName: string
  propertyId: number
  propertyTitle: string
  renterId: string
  renterName: string
  renterProfileImage: string | null
}

export interface OwnerDashboardNotification {
  id: number
  type: string
  typeDisplayName: string
  title: string
  isRead: boolean
  createdAt: string
}

export interface OwnerDashboardPayment {
  amountReceived: number
  contractId: number
  paidAt: string
  availableAt: string
  status: string
  statusDisplayName: string
}

export interface OwnerDashboardData {
  propertiesCount: number
  properties: OwnerDashboardProperty[]
  occupiedPlaces: number
  vacantPlaces: number
  totalViews: number
  monthlyEarning: OwnerDashboardMonthlyEarning[]
  yearlyEarning: OwnerDashboardYearlyEarning[]
  withdrawableEarnings: number
  onHoldEarnings: number
  averageRating: number
  ratingsCount: number
  allContracts: OwnerDashboardContract[]
  unreadNotificationsCount: number
  notifications: OwnerDashboardNotification[]
  pendingBookingRequestsCount: number
  pendingBookingRequests: OwnerDashboardBookingRequest[]
  accountStatus: string
  accountStatusDisplayName: string
  receivedPayments: OwnerDashboardPayment[]
  stripeAccountEnabled: boolean
}

export const userService = {
  getProfile: () =>
    apiClient.get<ApiResponse<Profile>>('/api/Profile/edit-profile'),

  getPublicProfile: () =>
    apiClient.get<ApiResponse<PublicProfile>>('/api/Profile/profile'),

  getUserProfileById: (id: string) =>
    apiClient.get<ApiResponse<PublicProfile>>(`/api/Profile/profile/${id}`),

  getRenterDashboard: () =>
    apiClient.get<ApiResponse<RenterDashboard>>(
      '/api/Profile/renter-dashboard',
    ),

  getOwnerDashboard: () =>
    apiClient.get<ApiResponse<OwnerDashboardData>>(
      '/api/Profile/owner-dashboard',
    ),

  updateProfile: (payload: UpdateProfilePayload) => {
    const form = new FormData()
    form.append('Id', payload.id)
    form.append('FirstName', payload.firstName)
    form.append('LastName', payload.lastName)
    form.append('PhoneNumber', payload.phoneNumber)
    form.append('Country', payload.country)
    form.append('Gender', payload.gender)
    form.append('Language', payload.language)
    form.append('DateOfBirth', payload.dateOfBirth)
    if (payload.bio !== undefined) form.append('Bio', payload.bio)
    if (payload.profileImage) form.append('ProfileImage', payload.profileImage)
    return apiClient.put<ApiResponse<Profile>>(
      '/api/Profile/edit-profile-basic',
      form,
    )
  },

  updateLegalProfile: (payload: UpdateLegalProfilePayload) => {
    const form = new FormData()
    form.append('Id', payload.id)
    form.append('ArabicFullName', payload.arabicFullName)
    form.append('ArabicAddress', payload.arabicAddress)
    form.append('NationalIDNumber', payload.nationalIDNumber)
    if (payload.frontIdPhoto) form.append('FrontIdPhoto', payload.frontIdPhoto)
    if (payload.backIdPhoto) form.append('BackIdPhoto', payload.backIdPhoto)
    return apiClient.put<ApiResponse<Profile>>(
      '/api/Profile/edit-profile-legal',
      form,
    )
  },

  changePassword: (payload: ChangePasswordPayload) =>
    apiClient.put<void>('/api/Profile/change-password', payload),

  updateRoommatePreferences: (payload: UpdateRoommatePreferencesPayload) =>
    apiClient.put<ApiResponse<Profile>>(
      '/api/Profile/edit-profile-roommate-preferences',
      payload,
    ),

  toggle2FA: (payload: Toggle2FAPayload) =>
    apiClient.put<ApiResponse<boolean>>('/api/Profile/toggle-2fa', payload),

  uploadAvatar: (file: File) => {
    const form = new FormData()
    form.append('avatar', file)
    return apiClient.post<ApiResponse<{ avatarUrl: string }>>(
      '/api/Users/avatar',
      form,
    )
  },

  submitReport: (payload: { reportableType: string; reportableTargetId: string; reason: string }) =>
    apiClient.post<ApiResponse<any>>('/api/Reports', payload),

  deleteProfile: () =>
    apiClient.delete<void>('/api/Profile/delete-profile'),
}
