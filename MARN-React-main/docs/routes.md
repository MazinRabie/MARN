# Application Routes

This document outlines all the routing paths in the application based on `src/app/App.tsx`.

## Public Routes

Accessible to everyone.

| Path            | Component              | Notes                     |
| :-------------- | :--------------------- | :------------------------ |
| `/`             | `LandingPage`          | Home page                 |
| `/search`       | `SearchPage`           |                           |
| `/property/:id` | `PropertyDetailsPage`  | Property details          |
| `/about`        | `AboutPage`            |                           |
| `/how-it-works` | `HowItWorksPage`       |                           |
| `/faq`          | `FAQPage`              |                           |
| `/contact`      | `ContactPage`          |                           |
| `/terms`        | `TermsPage`            |                           |
| `/privacy`      | `PrivacyPage`          |                           |
| `/user/:id`     | `ViewUserProfilePage`  | Public user profile view  |
| `/owner/:id`    | `ViewOwnerProfilePage` | Public owner profile view |
| `/chatbot`      | `ChatbotPage`          |                           |
| `/modal-test`   | `ModalTestPage`        | Testing page              |

## Guest Routes

Accessible only to unauthenticated users (auto-redirect to dashboard if signed in).

| Path                | Component             |
| :------------------ | :-------------------- |
| `/login`            | `LoginPage`           |
| `/signup`           | `SignUpPage`          |
| `/forgot-password`  | `ForgotPasswordPage`  |
| `/otp-verification` | `OTPVerificationPage` |
| `/confirm-email`    | `ConfirmEmailPage`    |
| `/reset-password`   | `ResetPasswordPage`   |

## Protected Routes

Require authentication.

### Shared (Any authenticated user)

| Path                           | Component                   |
| :----------------------------- | :-------------------------- |
| `/messages`                    | `MessagesPage`              |
| `/messages/rental-request/:id` | `ChatWithRentalRequestPage` |
| `/profile-settings`            | `ProfileSettingsPage`       |
| `/contract/:id`                | `ContractPage`              |

### Tenant Only

| Path                | Component         |
| :------------------ | :---------------- |
| `/tenant-dashboard` | `TenantDashboard` |

### Owner Only

| Path                     | Component             |
| :----------------------- | :-------------------- |
| `/owner-dashboard`       | `OwnerDashboard`      |
| `/add-property`          | `AddPropertyPage`     |
| `/edit-property/:id`     | `EditPropertyPage`    |
| `/property-by-owner/:id` | `PropertyByOwnerPage` |

### Admin Only

| Path               | Component            |
| :----------------- | :------------------- |
| `/admin-dashboard` | `AdminDashboardPage` |

## Catch-All

| Path | Component      | Notes          |
| :--- | :------------- | :------------- |
| `*`  | `NotFoundPage` | 404 Error Page |
