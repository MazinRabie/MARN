import { createRoot } from 'react-dom/client'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { GoogleOAuthProvider } from '@react-oauth/google'
import App from './app/App.tsx'
import { AuthProvider } from './context/AuthProvider.tsx'
import './styles/index.css'
import './i18n/config'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 3, // 3 seconds
      retry: 1,
    },
  },
})

const googleClientId =
  (import.meta.env.VITE_GOOGLE_CLIENT_ID as string | undefined) ?? ''

createRoot(document.getElementById('root')!).render(
  <GoogleOAuthProvider clientId={googleClientId}>
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <App />
      </AuthProvider>
    </QueryClientProvider>
  </GoogleOAuthProvider>,
)
