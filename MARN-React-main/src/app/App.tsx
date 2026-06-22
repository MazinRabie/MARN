import { BrowserRouter as Router, Routes, Route } from 'react-router'
import { Navigation } from './components/Navigation'
import { Footer } from './components/Footer'
import { ScrollToTop } from './components/ScrollToTop'
import { ProtectedRoute, GuestRoute } from './components/ProtectedRoute'
import { LandingPage } from './pages/LandingPage'
import { SearchPage } from './pages/search-page/SearchPage'
import { PropertyDetailsPage } from './pages/PropertyDetailsPage'
import { TenantDashboard } from './pages/TenantDashboard'
import { OwnerDashboard } from './pages/OwnerDashboard'
import { AddPropertyPage } from './pages/add-property/AddPropertyPage'
import { MessagesPage } from './pages/MessagesPage'
import { AboutPage } from './pages/AboutPage'
import { HowItWorksPage } from './pages/HowItWorksPage'
import { FAQPage } from './pages/FAQPage'
import { ContactPage } from './pages/ContactPage'
import { TermsPage } from './pages/TermsPage'
import { PrivacyPage } from './pages/PrivacyPage'
import { NotFoundPage } from './pages/NotFoundPage'
import { NotificationsPage } from './pages/NotificationsPage'
import { LoginPage } from './pages/LoginPage'
import { SignUpPage } from './pages/SignUpPage'
import { ProfileSettingsPage } from './pages/ProfileSettingsPage'
import { ProfilePage } from './pages/ProfilePage'
import { ForgotPasswordPage } from './pages/ForgotPasswordPage'
import { ChatbotPage } from './pages/ChatbotPage'
import { AdminDashboardPage } from './pages/admin-dashboard/AdminDashboardPage'
import { AdminPropertyDetailsPage } from './pages/admin-dashboard/AdminPropertyDetailsPage'
import { OTPVerificationPage } from './pages/OTPVerificationPage'
import { TwoFactorPage } from './pages/TwoFactorPage'
import { ConfirmEmailPage } from './pages/ConfirmEmailPage'
import { ResetPasswordPage } from './pages/ResetPasswordPage'
import { ChatWithRentalRequestPage } from './pages/ChatWithRentalRequestPage'
import { ViewUserProfilePage } from './pages/ViewUserProfilePage'
import { ViewOwnerProfilePage } from './pages/ViewOwnerProfilePage'
import { ContractPage } from './pages/ContractPage'
import { EditPropertyPage } from './pages/edit-property/EditPropertyPage'
import { PropertyByOwnerPage } from './pages/PropertyByOwnerPage'
import { ModalTestPage } from './pages/ModalTestPage'
import { SavedPropertiesPage } from './pages/SavedPropertiesPage'
import { RoommateMatchingPage } from './pages/RoommateMatchingPage'
import EmailTestPage from './pages/EmailTestPage'
import { Toaster } from './components/ui/sonner'

export default function App() {
  return (
    <Router>
      <ScrollToTop />
      <div className="min-h-screen bg-[#F2F4F6]">
        <Navigation />
        <Routes>
          {/* Public pages */}
          <Route path="/" element={<LandingPage />} />
          <Route path="/search" element={<SearchPage />} />
          <Route path="/property/:id" element={<PropertyDetailsPage />} />
          <Route path="/about" element={<AboutPage />} />
          <Route path="/how-it-works" element={<HowItWorksPage />} />
          <Route path="/faq" element={<FAQPage />} />
          <Route path="/contact" element={<ContactPage />} />
          <Route path="/terms" element={<TermsPage />} />
          <Route path="/privacy" element={<PrivacyPage />} />

          {/* Auth pages — redirect to dashboard if already signed in */}
          <Route
            path="/login"
            element={
              <GuestRoute>
                <LoginPage />
              </GuestRoute>
            }
          />
          <Route
            path="/signup"
            element={
              <GuestRoute>
                <SignUpPage />
              </GuestRoute>
            }
          />
          <Route
            path="/forgot-password"
            element={
              <GuestRoute>
                <ForgotPasswordPage />
              </GuestRoute>
            }
          />
          <Route
            path="/otp-verification"
            element={
              <GuestRoute>
                <OTPVerificationPage />
              </GuestRoute>
            }
          />
          {/* 2FA verification — reached via router state from /login, not a GuestRoute
              so the guard inside the page handles missing state */}
          <Route path="/2fa-verification" element={<TwoFactorPage />} />
          <Route
            path="/confirm-email"
            element={
              <GuestRoute>
                <ConfirmEmailPage />
              </GuestRoute>
            }
          />
          <Route
            path="/reset-password"
            element={
              <GuestRoute>
                <ResetPasswordPage />
              </GuestRoute>
            }
          />

          {/* Tenant routes */}
          <Route
            path="/tenant-dashboard"
            element={
              <ProtectedRoute roles={['tenant', 'owner', 'admin']}>
                <TenantDashboard />
              </ProtectedRoute>
            }
          />

          {/* Owner routes */}
          <Route
            path="/owner-dashboard"
            element={
              <ProtectedRoute roles={['owner', 'admin']}>
                <OwnerDashboard />
              </ProtectedRoute>
            }
          />
          <Route
            path="/add-property"
            element={
              <ProtectedRoute roles={['owner', 'admin']}>
                <AddPropertyPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/edit-property/:id"
            element={
              <ProtectedRoute roles={['owner', 'admin']}>
                <EditPropertyPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/property-by-owner/:id"
            element={
              <ProtectedRoute roles={['owner', 'admin']}>
                <PropertyByOwnerPage />
              </ProtectedRoute>
            }
          />

          {/* Admin routes */}
          <Route
            path="/admin-dashboard"
            element={
              <ProtectedRoute roles={['admin']}>
                <AdminDashboardPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/property/:id"
            element={
              <ProtectedRoute roles={['admin']}>
                <AdminPropertyDetailsPage />
              </ProtectedRoute>
            }
          />

          {/* Shared authenticated routes */}
          <Route
            path="/messages"
            element={
              <ProtectedRoute>
                <MessagesPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/messages/rental-request/:id"
            element={
              <ProtectedRoute>
                <ChatWithRentalRequestPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/profile"
            element={
              <ProtectedRoute>
                <ProfilePage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/settings"
            element={
              <ProtectedRoute>
                <ProfileSettingsPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/saved"
            element={
              <ProtectedRoute>
                <SavedPropertiesPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/roommate-matching"
            element={
              <ProtectedRoute>
                <RoommateMatchingPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/notifications"
            element={
              <ProtectedRoute>
                <NotificationsPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/contract/:id"
            element={
              <ProtectedRoute>
                <ContractPage />
              </ProtectedRoute>
            }
          />
          <Route path="/user/:id" element={<ViewUserProfilePage />} />
          <Route path="/owner/:id" element={<ViewOwnerProfilePage />} />

          {/* Misc */}
          <Route path="/chatbot" element={<ChatbotPage />} />
          <Route path="/modal-test" element={<ModalTestPage />} />
          <Route path="/emailTest" element={<EmailTestPage />} />

          {/* 404 */}
          <Route path="*" element={<NotFoundPage />} />
        </Routes>
        <Footer />
        <Toaster richColors position="top-right" />
      </div>
    </Router>
  )
}
