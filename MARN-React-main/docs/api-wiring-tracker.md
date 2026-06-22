# API Wiring Tracker

Tracks every backend endpoint against its frontend service function and hook.
Update the **Status** and **Notes** fields as endpoints get wired.

## Legend

| Badge | Meaning |
|---|---|
| ✅ Wired | Service function + hook both exist, path matches swagger |
| ⚠️ Path mismatch | Called in code but URL doesn't match current swagger |
| 🔧 Service only | Service function exists, no hook/UI yet |
| ❌ Missing | Not wired at all |

---

## Improvement Suggestions

> Address these as cross-cutting concerns before/during wiring new endpoints.

1. **Stale service paths** — `rentalService` calls `/api/Rentals/...` and `messageService` calls `/Messages/...`; neither path exists in current swagger. These are likely renamed routes that need to be updated before the features will work.

2. **Property service path drift** — `propertyService.createProperty` calls `POST /api/Property` but swagger is `POST /api/Property/add`; update/delete paths are similarly wrong. Audit the entire service before shipping property CRUD.

3. **Centralise route strings** — define all API paths in a single `src/constants/apiRoutes.ts` so path typos and renames are caught at one place instead of scattered across services.

4. **Pagination not threaded through UI** — most paged endpoints (users, properties, contracts, reports) accept `pageNumber`/`pageSize` but the UI doesn't expose controls. Wire `useInfiniteQuery` or a simple page-state hook so large datasets are navigable.

5. ~~**Mutation query-key gaps**~~ — Fixed: `ban`/`unban`/`restore` now invalidate both `adminUserStats` and `adminStats`.

6. **Admin property verifications tab missing** — the UI has no tab for `GET /api/Admin/verifications/properties/pending`; the flow is symmetric to user verifications and should be added.

7. ~~**Admin roles management not surfaced**~~ — Fixed: `GET /api/Admin/roles/users` + `PATCH /api/Admin/roles/users/{userId}` are wired; hardcoded mock replaced. "Downgrade" button replaced with "Update Roles" modal (Admin/Moderator checkboxes, pre-populated from current roles). Admin Management tab merged into User Management tab as a second section.

8. **Real-time channels** — Notifications and Chat are polling/request-based. Evaluate adding a SignalR/WebSocket layer so unread counts and messages update without refresh.

9. **Generic error handling** — `onError: () => toast.error('Action failed')` hides server messages. Extract the error message from the `ApiResponse` envelope and show it in the toast so the admin knows what actually went wrong.

10. **Report/moderation workflow missing** — `GET /api/Admin/reports` and `PATCH /api/Admin/reports/{reportId}/review` are not wired at all; there is no UI tab for moderation. This is a core admin responsibility.

---

## Account

### POST `/api/Account/login`
- **Status:** ✅ Wired
- **Service:** `authService.login()` → `src/services/authService.ts`
- **Hook:** `useLogin` → `src/hooks/useLogin.ts`
- **Options:** `{ email, password }`
- **Response:** `{ token, expiration, requiresTwoFactor, twoFactorProvider, isExternalLogin, externalProvider }`
- **Notes:** —

---

### POST `/api/Account/verify-2fa`
- **Status:** ✅ Wired
- **Service:** `authService.verify2fa()` → `src/services/authService.ts`
- **Hook:** `useVerify2fa` → `src/hooks/useVerify2fa.ts`
- **Options:** `{ email, code, rememberMe }` + `Authorization: Bearer <tempToken>`
- **Response:** Same shape as login (full JWT on success)
- **Notes:** Requires the temporary token returned by `/login` when `requiresTwoFactor: true`.

---

### POST `/api/Account/external/google`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** Google OAuth credential payload
- **Response:** `{ token, ... }` (same as login; creates account on first login)
- **Notes:** Add `authService.googleLogin()` + wire to the Google button in the login page.

---

### POST `/api/Account/register`
- **Status:** ✅ Wired
- **Service:** `authService.register()` → `src/services/authService.ts`
- **Hook:** `useRegister` → `src/hooks/useRegister.ts`
- **Options:** `{ firstName, lastName, email, dateOfBirth, password, confirmPassword, gender }`
- **Response:** `{ message, data: boolean }`
- **Notes:** —

---

### GET `/api/Account/confirm-email`
- **Status:** ✅ Wired
- **Service:** `authService.confirmEmail(userId, token)` → `src/services/authService.ts`
- **Hook:** Called inline in the confirm-email page
- **Options:** Query params `userId`, `token`
- **Response:** `{ message, data: boolean }`
- **Notes:** —

---

### POST `/api/Account/resend-confirmation-email`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `{ email }`
- **Response:** `{ message }`
- **Notes:** Add a resend link on the "check your email" screen.

---

### POST `/api/Account/forgot-password`
- **Status:** ✅ Wired
- **Service:** `authService.forgotPassword()` → `src/services/authService.ts`
- **Hook:** Inline mutation in ForgotPasswordPage
- **Options:** `{ email }`
- **Response:** `{ message }`
- **Notes:** —

---

### POST `/api/Account/validate-reset-token`
- **Status:** ❌ Missing (optional per swagger)
- **Service:** —
- **Hook:** —
- **Options:** `{ email, token }`
- **Response:** `{ valid: boolean }`
- **Notes:** Optional guard — call before showing the new-password form to pre-validate the link.

---

### PUT `/api/Account/reset-password`
- **Status:** ✅ Wired
- **Service:** `authService.resetPassword()` → `src/services/authService.ts`
- **Hook:** Inline mutation in ResetPasswordPage
- **Options:** `{ email, token, newPassword, confirmPassword }`
- **Response:** `{ message, data: boolean }`
- **Notes:** —

---

## Admin

### GET `/api/Admin/dashboard/overview`
- **Status:** ✅ Wired
- **Service:** `adminService.getStats()` → `src/services/adminService.ts`
- **Hook:** `useAdminStats` → `src/hooks/useAdminStats.ts`
- **Options:** None
- **Response:** `{ totalUsers, totalProperties, pendingVerifications, totalContracts, revenueSummary, contractSummary, monthlyRevenue[] }`
- **Notes:** Powers the four stat cards and the monthly revenue line chart.

---

### POST `/api/Admin/analytics-reports/generate`
- **Status:** ✅ Wired
- **Service:** `adminService.generateReport(payload)` → `src/services/adminService.ts`
- **Hook:** `useGenerateReport` → `src/hooks/useAdminStats.ts`
- **Options:** `{ scope, format, period }` — uses `GenerateReportPayload` type from `components['schemas']['AdminAnalyticsReportGenerateRequestDto']`
- **Response:** 200 no body (`content?: never`)
- **Notes:** Wired to the Generate Report button in the Reports tab. Invalidates `adminAnalyticsReports` on success.

---

### GET `/api/Admin/analytics-reports`
- **Status:** ✅ Wired
- **Service:** `adminService.getAnalyticsReports(page, pageSize)` → `src/services/adminService.ts`
- **Hook:** `useAdminAnalyticsReports` → `src/hooks/useAdminStats.ts`
- **Options:** `PageNumber`, `PageSize`
- **Response:** `AdminAnalyticsReportsResult` (manual interface — swagger has `content?: never`)
- **Notes:** Powers the Generated Reports list in the Reports tab.

---

### GET `/api/Admin/analytics-reports/{reportId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `reportId` path param
- **Response:** Single report metadata
- **Notes:** —

---

### GET `/api/Admin/analytics-reports/{reportId}/download`
- **Status:** ✅ Wired
- **Service:** `adminService.downloadAnalyticsReport(reportId)` → `src/services/adminService.ts`
- **Hook:** Called directly via `handleDownloadReport` in `ReportsTab.tsx`
- **Options:** `reportId` path param
- **Response:** File blob — `responseType: 'blob'`
- **Notes:** Triggers browser download with filename from `AdminAnalyticsReport.fileName`.

---

### GET `/api/Admin/stats/users`
- **Status:** ✅ Wired
- **Service:** `adminService.getUserStats()` → `src/services/adminService.ts`
- **Hook:** `useAdminUserStats` → `src/hooks/useAdminStats.ts`
- **Options:** `pageNumber`, `pageSize`
- **Response:** `{ totalUsers, deletedUsers, statusBreakdown[], roleBreakdown[], newUsersOverTime[], users: { items[], pageNumber, pageSize, totalCount, totalPages } }`
- **Notes:** Powers the User Management tab. `statusBreakdown` and `roleBreakdown` are fetched but not yet visualised — good candidates for mini-charts above the table.

---

### GET `/api/Admin/stats/properties`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `pageNumber`, `pageSize`, period filters
- **Response:** Property stats + paged property table
- **Notes:** Needed for a Properties admin tab (symmetrical to Users tab).

---

### GET `/api/Admin/stats/properties/{propertyId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** Deep property view: owner info, media, amenities, comments, ratings, contracts, booking requests
- **Notes:** Power a property detail modal in the admin properties tab.

---

### DELETE `/api/Admin/stats/properties/{propertyId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** Success/failure
- **Notes:** Soft-delete action in property detail modal.

---

### PATCH `/api/Admin/stats/properties/{propertyId}/restore-deleted`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** Success/failure
- **Notes:** Restore action for soft-deleted properties.

---

### GET `/api/Admin/stats/contracts`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `pageNumber`, `pageSize`, period filters
- **Response:** Contract stats + paged contract table
- **Notes:** Needed for a Contracts admin tab.

---

### GET `/api/Admin/stats/contracts/{contractId}/download`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `contractId` path param
- **Response:** PDF file download
- **Notes:** —

---

### PATCH `/api/Admin/stats/contracts/{contractId}/cancel`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `contractId` path param + cancellation reason body
- **Response:** Success/failure
- **Notes:** Admin-level contract cancellation (bypasses normal renter/owner flow).

---

### GET `/api/Admin/stats/revenue`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** Period filters
- **Response:** Detailed payment and revenue breakdown
- **Notes:** Richer data source than the overview endpoint — use for the Revenue & Sales card section.

---

### GET `/api/Admin/verifications/users/pending`
- **Status:** ✅ Wired
- **Service:** `adminService.getVerifications()` → `src/services/adminService.ts`
- **Hook:** `useAdminVerifications` → `src/hooks/useAdminStats.ts`
- **Options:** `pageNumber`, `pageSize`
- **Response:** `{ items: PendingUserVerification[], pageNumber, pageSize, totalCount, totalPages }`
- **Notes:** Powers the Review Submissions tab.

---

### GET `/api/Admin/verifications/users/{userId}`
- **Status:** ✅ Wired
- **Service:** `adminService.getUserVerification(userId)` → `src/services/adminService.ts`
- **Hook:** `useAdminUserVerification` → `src/hooks/useAdminStats.ts`
- **Options:** `userId` path param
- **Response:** `PendingUserVerification` with `frontIdPhoto`, `backIdPhoto`, `nationalIDNumber`, etc.
- **Notes:** Drives the ID-card view modal.

---

### PATCH `/api/Admin/verifications/users/{userId}/approve`
- **Status:** ✅ Wired
- **Service:** `adminService.approveVerification(userId)` → `src/services/adminService.ts`
- **Hook:** Inline `useMutation` in `VerificationsTab.tsx`
- **Options:** `userId` path param
- **Response:** `ApiResponse<boolean>`
- **Notes:** —

---

### PATCH `/api/Admin/verifications/users/{userId}/decline`
- **Status:** ✅ Wired
- **Service:** `adminService.rejectVerification(userId, reason)` → `src/services/adminService.ts`
- **Hook:** Inline `useMutation` in `VerificationsTab.tsx`
- **Options:** `userId` path param + `{ reason }` body
- **Response:** `ApiResponse<boolean>`
- **Notes:** —

---

### GET `/api/Admin/verifications/properties/pending`
- **Status:** ✅ Wired
- **Service:** `adminService.getPendingPropertyVerifications(page, pageSize)`
- **Hook:** `useAdminPropertyVerifications` in `src/hooks/useAdminStats.ts`
- **Options:** `pageNumber`, `pageSize`
- **Response:** Paged list of properties awaiting ownership-document review
- **Notes:** "Property Verifications" tab in `PropertyVerificationsTab.tsx`. Interfaces defined manually (swagger has `content?: never`).

---

### GET `/api/Admin/verifications/properties/{propertyId}`
- **Status:** ✅ Wired
- **Service:** `adminService.getPropertyVerification(propertyId)`
- **Hook:** `useAdminPropertyVerification` in `src/hooks/useAdminStats.ts`
- **Options:** `propertyId` path param
- **Response:** Full property verification payload (ownership docs, images)
- **Notes:** Powers the detail modal in the Property Verifications tab.

---

### PATCH `/api/Admin/verifications/properties/{propertyId}/approve`
- **Status:** ✅ Wired
- **Service:** `adminService.approvePropertyVerification(propertyId)`
- **Hook:** Inline `useMutation` (`approvePropertyVerification`) in `PropertyVerificationsTab.tsx`
- **Options:** `propertyId` path param
- **Response:** `ApiResponse<boolean>`
- **Notes:** —

---

### PATCH `/api/Admin/verifications/properties/{propertyId}/decline`
- **Status:** ✅ Wired
- **Service:** `adminService.declinePropertyVerification(propertyId, reason)`
- **Hook:** Inline `useMutation` (`declinePropertyVerification`) in `PropertyVerificationsTab.tsx`
- **Options:** `propertyId` path param + `{ reason }` body
- **Response:** `ApiResponse<boolean>`
- **Notes:** —

---

### GET `/api/Admin/users`
- **Status:** 🔧 Service only (superseded)
- **Service:** `adminService.getUsers()` → kept in service but not used in UI
- **Hook:** `useAdminUsers` — replaced by `useAdminUserStats`
- **Options:** `pageNumber`, `pageSize`
- **Response:** Lightweight `AdminUser[]`
- **Notes:** The stats/users endpoint is richer and now preferred. Consider removing `getUsers` to avoid confusion.

---

### GET `/api/Admin/users/{userId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `userId` path param
- **Response:** Full admin user view: roles, properties, contracts, payment summaries
- **Notes:** Could back a deeper user profile page (more than the current modal).

---

### DELETE `/api/Admin/users/{userId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `userId` path param
- **Response:** Success/failure
- **Notes:** Soft-delete. Add a Delete action to the user detail modal (distinct from Ban).

---

### PATCH `/api/Admin/users/{userId}/ban`
- **Status:** ✅ Wired
- **Service:** `adminService.banUser(userId)` → `src/services/adminService.ts`
- **Hook:** Inline `useMutation` in `UserManagementTab.tsx`
- **Options:** `userId` path param
- **Response:** 200 no body (`content?: never`)
- **Notes:** Fixed from POST → PATCH. Ban button shown for non-banned, non-deleted users.

---

### PATCH `/api/Admin/users/{userId}/unban`
- **Status:** ✅ Wired
- **Service:** `adminService.unbanUser(userId)` → `src/services/adminService.ts`
- **Hook:** Inline `useMutation` in `UserManagementTab.tsx`
- **Options:** `userId` path param
- **Response:** 200 no body (`content?: never`)
- **Notes:** Renamed from the broken `suspendUser` (which called non-existent `/suspend`). "Unban" button shown for `accountStatus === 'Banned'` users. Reverts to `StatusBeforeBan` per swagger.

---

### PATCH `/api/Admin/users/{userId}/restore`
- **Status:** ✅ Wired
- **Service:** `adminService.restoreUser(userId)` → `src/services/adminService.ts`
- **Hook:** Inline `useMutation` in `UserManagementTab.tsx`
- **Options:** `userId` path param
- **Response:** 200 no body (`content?: never`)
- **Notes:** Fixed from POST → PATCH. "Restore" button shown only for `user.isDeleted === true`.

---

### GET `/api/Admin/roles`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** None
- **Response:** All system roles with assignment metadata
- **Notes:** Use to populate the role-assignment dropdown in the Admins tab.

---

### GET `/api/Admin/roles/users`
- **Status:** ✅ Wired
- **Service:** `adminService.getRoleUsers(page, pageSize, search?)` → `src/services/adminService.ts`
- **Hook:** `useAdminRoleUsers` → `src/hooks/useAdminStats.ts`
- **Options:** `pageNumber`, `pageSize`, `Search`, `Role`, `AccountStatus`, `IncludeDeleted`
- **Response:** `AdminRoleUsersResult` (manual interface — swagger has `content?: never`)
- **Notes:** Replaced the hardcoded `adminUsers` mock array. Powers the Admins tab table.

---

### GET `/api/Admin/roles/users/{userId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `userId` path param
- **Response:** Single user's current roles + available assignable roles
- **Notes:** —

---

### PATCH `/api/Admin/roles/users/{userId}`
- **Status:** ✅ Wired
- **Service:** `adminService.updateUserRoles(userId, roles)` → `src/services/adminService.ts`
- **Hook:** `useUpdateUserRoles` → `src/hooks/useAdminStats.ts`
- **Options:** `userId` path param + `AdminUpdateUserRolesDto { roles: string[] }` body
- **Response:** 200 no body
- **Notes:** Wired to the "Update Roles" button in the Admins & Role Management section (inside User Management tab). Opens a modal pre-populated with the user's current Admin/Moderator roles; submits the checked selection. Protected roles (Owner, Renter) are preserved by the server automatically.

---

### GET `/api/Admin/reports`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `pageNumber`, `pageSize`, status/type filters
- **Response:** Moderation queue with paging, breakdowns, and filter state
- **Notes:** Needs its own Moderation tab in the Admin Dashboard.

---

### GET `/api/Admin/reports/{reportId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `reportId` path param
- **Response:** Full report details (reporter, reported entity, reason, history)
- **Notes:** —

---

### PATCH `/api/Admin/reports/{reportId}/review`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `reportId` path param + `{ action, note }` body (see `report-moderation-action-types` enum)
- **Response:** Updated report record
- **Notes:** Supports multiple compatible actions in one call.

---

## BookingRequest

### POST `/api/BookingRequest/add`
- **Status:** ⚠️ Path mismatch
- **Service:** `rentalService.getBookingRequests()` uses `/api/Rentals/requests` — wrong path
- **Hook:** `useBookingRequests`
- **Options:** `{ propertyId, ... }`
- **Response:** Created booking request
- **Notes:** Update `rentalService` to use correct path `/api/BookingRequest/add`.

---

### POST `/api/BookingRequest/{bookingRequestId}/start-chat`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `bookingRequestId` path param
- **Response:** Chat/conversation object
- **Notes:** Should be called after a booking request is accepted to open the renter–owner chat thread.

---

### DELETE `/api/BookingRequest/cancel/{bookingRequestId}`
- **Status:** ⚠️ Path mismatch
- **Service:** `rentalService` uses `/api/Rentals/requests/${id}/reject` — wrong path
- **Hook:** `useBookingRequests`
- **Options:** `bookingRequestId` path param
- **Response:** Success/failure
- **Notes:** —

---

## Chat

### GET `/api/Chat/users`
- **Status:** ⚠️ Path mismatch
- **Service:** `messageService.getConversations()` uses `/Messages/conversations` — wrong path
- **Hook:** `useConversations`
- **Options:** None
- **Response:** List of users the current user has chatted with + online status + unread count
- **Notes:** Update path to `/api/Chat/users`.

---

### GET `/api/Chat/search`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `q` query param (username or email)
- **Response:** Matching users
- **Notes:** Wire to the new-chat user search in the Chat UI.

---

### GET `/api/Chat/history/{otherUserId}`
- **Status:** ⚠️ Path mismatch
- **Service:** `messageService.getMessages()` uses `/Messages/conversations/${id}` — wrong path
- **Hook:** Inline in chat page
- **Options:** `otherUserId` path param
- **Response:** Chat message history
- **Notes:** Update path to `/api/Chat/history/{otherUserId}`.

---

## Contract

### POST `/api/contracts/create/{bookingRequestId}`
- **Status:** ⚠️ Path mismatch
- **Service:** `rentalService.getContracts()` uses `/api/Rentals/contracts` — wrong path
- **Hook:** `useContracts`
- **Options:** `bookingRequestId` path param
- **Response:** Created contract record
- **Notes:** Only the property owner can call this. Update all contract paths in `rentalService`.

---

### POST `/api/contracts/{contractId}/sign`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `contractId` path param
- **Response:** Signed contract + PDF hash + OpenTimestamps proof
- **Notes:** Renter-only action. Should be the primary CTA on the contract detail page.

---

### GET `/api/contracts/{contractId}`
- **Status:** ⚠️ Path mismatch
- **Service:** `rentalService.getContractById()` uses `/api/Rentals/contracts/${id}`
- **Hook:** `useContract`
- **Options:** `contractId` path param
- **Response:** Single contract record
- **Notes:** Update to `/api/contracts/${contractId}`.

---

### GET `/api/contracts/{contractId}/proof`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `contractId` path param
- **Response:** OpenTimestamps `.ots` proof file
- **Notes:** —

---

### GET `/api/contracts/{contractId}/download`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `contractId` path param
- **Response:** PDF file
- **Notes:** Add a download button to contract detail page/card.

---

### POST `/api/contracts/verify`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `{ file }` multipart upload
- **Response:** `{ valid: boolean, hash, ... }`
- **Notes:** Allows tenants/owners to verify a contract PDF matches the stored hash.

---

### DELETE `/api/contracts/cancel/{contractId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `contractId` path param
- **Response:** Success/failure
- **Notes:** Cancels a **pending** contract (before signing).

---

## Enum

### GET `/api/Enum/all`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** `useEnumOptions` fetches each enum individually
- **Options:** None
- **Response:** All enums in one payload
- **Notes:** Calling `/api/Enum/all` once on app boot would replace ~30 individual requests. Consider a `useAllEnums` hook that pre-warms the cache.

---

### GET `/api/Enum/{type}` (individual enums)
- **Status:** ✅ Wired (partial)
- **Service:** `useEnumOptions(endpoint)` → `src/hooks/useEnumOptions.ts`
- **Hook:** `useEnumOptions`
- **Options:** `endpoint` slug (e.g. `'genders'`, `'cities'`)
- **Response:** `EnumOption[]`
- **Notes:** The following slugs are wired in `EnumEndpoint` type: `genders`, `languages`, `countries`, `property-types`, `cities`, `governorates`, `rental-units`, `roommate-search-statuses`, `sleep-schedules`, `fields-of-study`, `guests-frequencies`, `work-schedules`, `sharing-levels`, `education-levels`. All remaining enums (`amenity-types`, `contract-statuses`, `payment-frequencies`, `payment-statuses`, `report-statuses`, `reportable-types`, `admin-analytics-report-*`, etc.) need to be added to `EnumEndpoint` union as they are used.

---

## Homepage

### GET `/api/Homepage/recommendations`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** None (auth required)
- **Response:** Recommended property list personalised for the authenticated user
- **Notes:** Wire to a "Recommended for you" section on the home/search page.

---

## Notification

### GET `/api/Notification/notifications-get`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** None
- **Response:** All notifications ordered by newest first
- **Notes:** Wire to the notification bell/dropdown in the header. Poll or use SignalR.

---

### GET `/api/Notification/test-notification`
- **Status:** ❌ Missing (test only)
- **Service:** —
- **Hook:** —
- **Notes:** Skip for production UI.

---

### POST `/api/Notification/save-fcm-token`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `{ token }` (FCM device token)
- **Response:** Success/failure
- **Notes:** Call on login and whenever Firebase issues a new token.

---

### DELETE `/api/Notification/remove-fcm-token`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `{ token }`
- **Response:** Success/failure
- **Notes:** Call on logout.

---

## Payment

### POST `/api/Payment/start-payment`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `{ paymentScheduleId }`
- **Response:** Stripe Payment Intent `{ clientSecret }`
- **Notes:** Entry point for the Stripe checkout flow. Use `@stripe/stripe-js` to confirm the intent with the returned `clientSecret`.

---

### POST `/api/Payment/connect-account`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** None (auth required — owner only)
- **Response:** Stripe Connect onboarding URL
- **Notes:** Show when `stripeAccountEnabled: false` on the owner dashboard. Redirect to the onboarding URL.

---

### POST `/api/Payment/withdraw`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** None (auth required — owner only)
- **Response:** Withdrawal confirmation
- **Notes:** Wire to the "Withdraw" button in the owner dashboard earnings section.

---

### POST `/api/Payment/webhook`
- **Status:** — (backend only)
- **Notes:** No frontend action needed.

---

## Profile

### GET `/api/Profile/renter-dashboard`
- **Status:** ✅ Wired
- **Service:** `userService.getRenterDashboard()` → `src/services/userService.ts`
- **Hook:** `useRenterDashboard` → `src/hooks/useRenterDashboard.ts`
- **Options:** None
- **Response:** `RenterDashboard` (active rentals, bookings, saved properties, notifications, contracts, payments)
- **Notes:** —

---

### GET `/api/Profile/owner-dashboard`
- **Status:** ✅ Wired
- **Service:** `userService.getOwnerDashboard()` → `src/services/userService.ts`
- **Hook:** `useOwnerDashboard` → `src/hooks/useOwnerDashboard.ts`
- **Options:** None
- **Response:** `OwnerDashboardData`
- **Notes:** —

---

### GET `/api/Profile/profile`
- **Status:** ✅ Wired
- **Service:** `userService.getPublicProfile()` → `src/services/userService.ts`
- **Hook:** `useProfile` → `src/hooks/useProfile.ts`
- **Options:** None (own profile)
- **Response:** `PublicProfile`
- **Notes:** —

---

### GET `/api/Profile/profile/{userId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `userId` path param
- **Response:** `PublicProfile` of another user
- **Notes:** Add `userService.getPublicProfileById(userId)` for owner/roommate profile pages.

---

### GET `/api/Profile/edit-profile`
- **Status:** ✅ Wired
- **Service:** `userService.getProfile()` → `src/services/userService.ts`
- **Hook:** `useProfile` → `src/hooks/useProfile.ts`
- **Options:** None
- **Response:** Full `Profile` with all editable fields
- **Notes:** —

---

### PUT `/api/Profile/edit-profile-basic`
- **Status:** ✅ Wired
- **Service:** `userService.updateProfile()` → `src/services/userService.ts`
- **Hook:** Inline mutation in ProfilePage
- **Options:** FormData: `Id, FirstName, LastName, PhoneNumber, Country, Gender, Language, DateOfBirth, Bio?, ProfileImage?`
- **Response:** Updated `Profile`
- **Notes:** —

---

### PUT `/api/Profile/edit-profile-legal`
- **Status:** ✅ Wired
- **Service:** `userService.updateLegalProfile()` → `src/services/userService.ts`
- **Hook:** Inline mutation in ProfilePage
- **Options:** FormData: `Id, ArabicFullName, ArabicAddress, NationalIDNumber, FrontIdPhoto?, BackIdPhoto?`
- **Response:** Updated `Profile`
- **Notes:** —

---

### PUT `/api/Profile/edit-profile-roommate-preferences`
- **Status:** ✅ Wired
- **Service:** `userService.updateRoommatePreferences()` → `src/services/userService.ts`
- **Hook:** Inline mutation in ProfilePage
- **Options:** `UpdateRoommatePreferencesPayload` (full preferences object)
- **Response:** Updated `Profile`
- **Notes:** —

---

### PUT `/api/Profile/toggle-2fa`
- **Status:** ✅ Wired
- **Service:** `userService.toggle2FA()` → `src/services/userService.ts`
- **Hook:** Inline mutation in ProfilePage
- **Options:** `{ password }`
- **Response:** `ApiResponse<boolean>`
- **Notes:** —

---

### PUT `/api/Profile/change-password`
- **Status:** ✅ Wired
- **Service:** `userService.changePassword()` → `src/services/userService.ts`
- **Hook:** Inline mutation in ProfilePage
- **Options:** `{ id, currentPassword, newPassword, confirmNewPassword }`
- **Response:** `void`
- **Notes:** —

---

### DELETE `/api/Profile/delete-profile`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** None (uses auth token)
- **Response:** Success/failure
- **Notes:** Add a "Delete Account" danger-zone button in Profile Settings.

---

## Property

### POST `/api/Property/become-owner`
- **Status:** ✅ Wired
- **Service:** `propertyService.becomeOwner()` → `src/services/propertyService.ts`
- **Hook:** Inline mutation
- **Options:** None
- **Response:** New JWT token string (with Owner role)
- **Notes:** —

---

### POST `/api/Property/add`
- **Status:** ⚠️ Path mismatch
- **Service:** `propertyService.createProperty()` calls `POST /api/Property` — missing `/add`
- **Hook:** Inline mutation in AddPropertyPage
- **Options:** FormData with property fields + images
- **Response:** Created `Property`
- **Notes:** Update to `POST /api/Property/add`.

---

### GET `/api/Property/search`
- **Status:** ✅ Wired
- **Service:** `propertyService.getProperties(filters)` → `src/services/propertyService.ts`
- **Hook:** `useProperties` → `src/hooks/useProperties.ts`
- **Options:** Extensive filter/sort/pagination query params (see `PropertyFilters` type)
- **Response:** `SearchPaginatedResponse<SearchProperty>`
- **Notes:** Anonymous-accessible. Authenticated users receive save-state on each card.

---

### GET `/api/Property/{propertyId}`
- **Status:** ✅ Wired
- **Service:** `propertyService.getPropertyById(id)` → `src/services/propertyService.ts`
- **Hook:** `useProperty` → `src/hooks/useProperty.ts`
- **Options:** `propertyId` path param
- **Response:** Full `Property` with owner-only extras for authenticated owners
- **Notes:** —

---

### GET `/api/Property/edit/{propertyId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** Editable property data including existing images and rule sets
- **Notes:** Must be fetched before showing the edit form to pre-populate fields.

---

### PUT `/api/Property/edit/{propertyId}`
- **Status:** ⚠️ Path mismatch
- **Service:** `propertyService.updateProperty()` calls `PUT /api/Property/${id}` — wrong path
- **Hook:** Inline mutation in EditPropertyPage
- **Options:** FormData edit layout
- **Response:** Updated `Property`
- **Notes:** Update to `PUT /api/Property/edit/${propertyId}`.

---

### PUT `/api/Property/deactivate/{propertyId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** Updated property status
- **Notes:** Toggle active/inactive visibility. Wire to a status switch on the owner dashboard property cards.

---

### POST `/api/Property/save/{propertyId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** Saved/unsaved state
- **Notes:** Toggles saved state. Wire to the heart/bookmark icon on property cards and detail pages.

---

### DELETE `/api/Property/delete/{propertyId}`
- **Status:** ⚠️ Path mismatch
- **Service:** `propertyService.deleteProperty()` calls `DELETE /api/Property/${id}` — missing `/delete/`
- **Hook:** Inline mutation
- **Options:** `propertyId` path param
- **Response:** `ApiResponse<void>`
- **Notes:** Update to `DELETE /api/Property/delete/${propertyId}`.

---

## PropertyFeedback

### GET `/api/properties/{propertyId}/ratings/summary`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** `{ averageRating, totalRatings, breakdown: { 1..5: count } }`
- **Notes:** Show above the comments section on the property detail page.

---

### POST `/api/properties/{propertyId}/ratings`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param + `{ rating: 1–5, review?: string }`
- **Response:** Created rating
- **Notes:** Creates or updates (upsert) the current user's rating.

---

### PUT `/api/properties/{propertyId}/ratings/me`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param + `{ rating, review? }`
- **Response:** Updated rating
- **Notes:** —

---

### DELETE `/api/properties/{propertyId}/ratings/me`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param
- **Response:** Success/failure
- **Notes:** —

---

### GET `/api/properties/{propertyId}/comments`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param + pagination
- **Response:** Paged flat comments (newest first)
- **Notes:** Wire to the comments section on the property detail page.

---

### POST `/api/properties/{propertyId}/comments`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId` path param + `{ body }`
- **Response:** Created comment
- **Notes:** —

---

### PUT `/api/properties/{propertyId}/comments/{commentId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId`, `commentId` path params + `{ body }`
- **Response:** Updated comment
- **Notes:** —

---

### DELETE `/api/properties/{propertyId}/comments/{commentId}`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `propertyId`, `commentId` path params
- **Response:** Success/failure
- **Notes:** —

---

## Reports

### POST `/api/Reports`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `{ reportableType, reportableId, reason, description? }` (see `reportable-types` and `report-statuses` enums)
- **Response:** Created report
- **Notes:** Add a "Report" menu item on user profiles, property cards, and chat messages.

---

## Roommate

### GET `/api/Roommate/matches`
- **Status:** ✅ Wired
- **Service:** `roommateService.getMatches(limit)` → `src/services/roommateService.ts`
- **Hook:** `useRoommateMatches` → `src/hooks/useRoommateMatches.ts`
- **Options:** None (uses auth profile preferences)
- **Response:** Top roommate matches ranked by preference score
- **Notes:** Wired to `/roommate-matching` page. Interface defined manually (swagger has `content?: never`). Requires `roommatePreferencesEnabled: true` — page shows CTA to set preferences if disabled.

---

## Support

### POST `/api/Support/contact-us`
- **Status:** ❌ Missing
- **Service:** —
- **Hook:** —
- **Options:** `{ name, email, subject, message }`
- **Response:** Success/failure
- **Notes:** Wire to the Contact Us page form.

---

## TempGen (Test-only — skip in production UI)

### GET `/api/TempGen/generate`
- **Status:** — (test/seeding only)

### GET `/api/TempGen/preview-contract`
- **Status:** — (test/seeding only)

---

*Last updated: 2026-05-28 — wired: analytics-reports/generate, analytics-reports (list + download), Admin/roles/users (GET + PATCH), fixed ban/unban/restore HTTP methods. PATCH roles/users/{userId}: replaced "Downgrade" with "Update Roles" modal; merged Admin Management tab into User Management tab.*
