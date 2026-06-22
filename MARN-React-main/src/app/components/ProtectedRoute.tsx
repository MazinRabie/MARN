import { Navigate, useLocation } from 'react-router'
import { useAuth } from '@/hooks/useAuth'
import type { UserRole } from '@/types/user'

interface ProtectedRouteProps {
  children: React.ReactNode
  /** If provided, only users with one of these roles can access the route. */
  roles?: UserRole[]
  /** Where to redirect unauthenticated users. Defaults to /login. */
  redirectTo?: string
}

/**
 * Blocks unauthenticated users. When `roles` is provided, also blocks users
 * whose role is not in the allowed list.
 */
export function ProtectedRoute({
  children,
  roles,
  redirectTo = '/login',
}: ProtectedRouteProps) {
  const { isAuthenticated, user } = useAuth()
  const location = useLocation()

  if (!isAuthenticated) {
    return <Navigate to={redirectTo} state={{ from: location }} replace />
  }

  if (roles && user) {
    const userRoles = user.roles ?? [user.role]
    const hasAllowedRole = roles.some(r => userRoles.includes(r))
    
    if (!hasAllowedRole) {
      // Redirect to their own dashboard if they hit a page for another role
      const fallback =
        userRoles.includes('admin')
          ? '/admin-dashboard'
          : userRoles.includes('owner')
            ? '/owner-dashboard'
            : '/tenant-dashboard'
      return <Navigate to={fallback} replace />
    }
  }

  return <>{children}</>
}

/**
 * Blocks authenticated users from accessing guest-only pages (login, signup, etc.).
 * Redirects them to their role-specific dashboard.
 */
export function GuestRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, user } = useAuth()

  if (isAuthenticated) {
    const userRoles = user?.roles ?? (user?.role ? [user.role] : [])
    const dashboard =
      userRoles.includes('admin')
        ? '/admin-dashboard'
        : userRoles.includes('owner')
          ? '/owner-dashboard'
          : '/tenant-dashboard'
    return <Navigate to={dashboard} replace />
  }

  return <>{children}</>
}
