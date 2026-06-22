# API Connectivity Summary

> [!NOTE]
> This report covers **page-level** API connectivity only. Reusable components embedded in pages (e.g., PropertyCard's favourite button) are excluded per your instructions — their issues belong in their own component files.

---

## ✅ Pages Fully Connected to API

These pages fetch data from and/or submit data to the backend API and are **working end-to-end**.

| Page | File | API Integration Details |
|------|------|------------------------|
| **Login** | [LoginPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/LoginPage.tsx) | `useLogin` hook → `authService.login()`. Role-based redirect, 2FA flow, error handling. |
| **Sign Up** | [SignUpPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/SignUpPage.tsx) | `useRegister` hook → `authService.register()`. Validation errors mapped to fields via `HttpError`. |
| **Forgot Password** | [ForgotPasswordPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ForgotPasswordPage.tsx) | `useMutation` → `authService.forgotPassword()`. Sends reset email. |
| **Reset Password** | [ResetPasswordPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ResetPasswordPage.tsx) | `useMutation` → `authService.resetPassword()`. Reads `email` & `token` from URL params. |
| **Confirm Email** | [ConfirmEmailPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ConfirmEmailPage.tsx) | `authService.confirmEmail()` called on mount. Auto-redirects to login on success. |
| **Two-Factor Auth** | [TwoFactorPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/TwoFactorPage.tsx) | `useVerify2fa` hook. Submits OTP code with temp token, handles role-based redirect. |
| **Search** | [SearchPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/search-page/SearchPage.tsx) | `useProperties` hook → `propertyService.search()`. Filter params, pagination, list/map views. |
| **Property Details** | [PropertyDetailsPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/PropertyDetailsPage.tsx) | `useProperty` hook → `propertyService.getById()`. Booking via `useCreateBookingRequest`. Reviews via `usePropertyReviews` / `useCreateReview`. |
| **Owner Dashboard** | [OwnerDashboard.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/OwnerDashboard.tsx) | `useOwnerDashboard` hook → `userService.getOwnerDashboard()`. Stats, properties, requests, revenue charts. Booking accept/reject via `useBookingRequests`. |
| **Tenant Dashboard** | [TenantDashboard.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/TenantDashboard.tsx) | `useRenterDashboard` → renter dashboard data. `useProperties` for recommendations. Active rentals, payments, notifications, contracts, saved properties. |
| **Admin Dashboard** | [AdminDashboardPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/admin-dashboard/AdminDashboardPage.tsx) | Fully connected: `useAdminStats`, `useAdminRoleUsers`, `useAdminVerifications`, `useAdminPropertyVerifications`, `useAdminAnalyticsReports`, `useGenerateReport`, `useUpdateUserRoles`. Approve/reject/ban/unban/restore users. Download reports. |
| **Messages** | [MessagesPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/MessagesPage.tsx) | `useConversations`, `useMessages`, `useSendMessage` hooks → `messageService`. List conversations, read messages, send messages. |
| **Chat with Rental Request** | [ChatWithRentalRequestPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ChatWithRentalRequestPage.tsx) | `useMessages`, `useSendMessage` → messages API. **Note:** Rental request sidebar info is hardcoded (static `RENTAL_REQUEST` object), but the chat itself is API-connected. |
| **Profile Settings – Profile Tab** | [ProfileTab.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/profile-settings/ProfileTab.tsx) | `useProfile` hook → GET profile + `update` mutation. Avatar upload, field validation via `HttpError`. Enum selects fetched from API. |
| **Profile Settings – Security Tab** | [SecurityTab.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/profile-settings/SecurityTab.tsx) | `useProfile` → `changePassword` + `toggle2FA` mutations. Full error handling. |
| **Profile Settings – Documents Tab** | [DocumentsTab.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/profile-settings/DocumentsTab.tsx) | `useProfile` → `updateLegal` mutation. Uploads ID card images, Arabic name/address, national ID. |
| **Profile Settings – Roommate Tab** | [RoommateTab.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/profile-settings/RoommateTab.tsx) | `useProfile` → `updateRoommate` mutation. Saves all roommate preferences. Enum selects from API. |
| **Add Property** | [AddPropertyPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/add-property/AddPropertyPage.tsx) | `propertyService.createProperty()` via FormData. Uploads images, legal docs, amenities, rules. Multi-step form with validation. |
| **Contract** | [ContractPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ContractPage.tsx) | `useContract` hook → fetches contract details from API. Download/view contract document. **Note:** Upload of signed contract is client-side only (no API call for upload submission yet). |
| **Property By Owner** | [PropertyByOwnerPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/PropertyByOwnerPage.tsx) | `useProperty` + `useBookingRequests` hooks. Shows property details & rental requests. Accept/reject booking requests via API. |
| **Landing Page** | [LandingPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/LandingPage.tsx) | `useProperties` hook for featured properties section. Rest is static content. |

---

## ❌ Pages NOT Connected to API (Fully Static / Hardcoded)

These pages render **entirely static/hardcoded content** with no API calls.

| Page | File | Notes |
|------|------|-------|
| **About** | [AboutPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/AboutPage.tsx) | Static informational content. |
| **FAQ** | [FAQPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/FAQPage.tsx) | Static accordion Q&A. |
| **Terms** | [TermsPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/TermsPage.tsx) | Static legal text. |
| **Privacy** | [PrivacyPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/PrivacyPage.tsx) | Static privacy policy. |
| **How It Works** | [HowItWorksPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/HowItWorksPage.tsx) | Static step-by-step guide. |
| **Contact** | [ContactPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ContactPage.tsx) | Static contact info. Form submit is a `toast.success()` only — no API call. |
| **Not Found (404)** | [NotFoundPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/NotFoundPage.tsx) | Static 404 page. |
| **OTP Verification** | [OTPVerificationPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/OTPVerificationPage.tsx) | UI only — `handleVerify` does `console.log` and navigates. **No API call**. Resend is also `console.log` only. |
| **Chatbot** | [ChatbotPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ChatbotPage.tsx) | Fully static. Bot responses are from a hardcoded `getBotResponse()` function with `setTimeout`. No API/AI integration. |
| **View Owner Profile** | [ViewOwnerProfilePage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ViewOwnerProfilePage.tsx) | All data from hardcoded `OWNER_PROFILE` and `PROPERTIES` constants. Report is `toast.success()` only. |
| **View User Profile** | [ViewUserProfilePage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ViewUserProfilePage.tsx) | All data from hardcoded `USER_PROFILE` constant. Report is `toast.success()` only. |
| **Edit Property** | [EditPropertyPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/EditPropertyPage.tsx) | Form is pre-filled with hardcoded data. `handleUpdate` is just `toast.success()` → navigate. **No API call to fetch or save property edits.** |
| **Modal Test** | [ModalTestPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ModalTestPage.tsx) | Dev/test page. No API. |

---

## ⚠️ Partially Connected Pages (Mixed)

These pages have **some** API-connected functionality but also contain significant hardcoded/unconnected features at the page level.

| Page | File | What Works | What Doesn't |
|------|------|-----------|--------------|
| **Chat with Rental Request** | [ChatWithRentalRequestPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ChatWithRentalRequestPage.tsx) | Chat messaging (send/receive) via `useMessages` / `useSendMessage` | Rental request sidebar is hardcoded (`RENTAL_REQUEST` constant). "Start Contract" and "Reject Request" buttons have no API handlers. Edit/delete message handlers are empty stubs. |
| **Contract** | [ContractPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ContractPage.tsx) | Contract details fetched via `useContract` hook. Download document works. | **Upload signed contract** — `handleSubmit` only shows a toast and navigates; no API call to actually upload the signed PDF. |
| **Contact** | [ContactPage.tsx](file:///c:/Coding/MARN%20AI/src/app/pages/ContactPage.tsx) | — | Contact form `handleSubmit` just calls `toast.success()`. No API endpoint. |

---

## Quick Stats

| Category | Count |
|----------|-------|
| **Fully Connected** | 21 pages/tabs |
| **Not Connected** | 13 pages |
| **Partially Connected** | 3 pages |
| **Total** | 37 pages/tabs |
