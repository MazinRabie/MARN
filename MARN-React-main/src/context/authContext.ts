import { createContext } from 'react'
import type { User } from '@/types/user'

export interface AuthContextValue {
  user: User | null
  token: string | null
  isAuthenticated: boolean
  login: (token: string, user: User, remember: boolean) => void
  logout: () => void
}

export const AuthContext = createContext<AuthContextValue | null>(null)
