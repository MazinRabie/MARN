import { useState, useCallback, useEffect } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { AuthContext } from './authContext'
import type { User } from '@/types/user'

const TOKEN_KEY = 'token'
const USER_KEY = 'user'

import { decodeUserFromToken } from '@/utils/tokenUtils'
import { resetImageCache } from '@/constants/assets'
import { stopNotificationConnection } from '@/services/notificationService'
import { stopChatConnection } from '@/services/messageService'

function readToken(): string | null {
  return localStorage.getItem(TOKEN_KEY) ?? sessionStorage.getItem(TOKEN_KEY)
}

function readUser(token: string | null): User | null {
  try {
    const raw =
      localStorage.getItem(USER_KEY) ?? sessionStorage.getItem(USER_KEY) ?? null
    let user = raw ? (JSON.parse(raw) as User) : null
    
    // Repair the stored user object if it's missing the firstName
    if (user && !user.firstName && token) {
      try {
        const decoded = decodeUserFromToken(token)
        user = { ...user, firstName: decoded.firstName, lastName: decoded.lastName }
      } catch {}
    }
    
    return user
  } catch {
    return null
  }
}

function writeStorage(token: string, user: User, persist: boolean): void {
  const storage = persist ? localStorage : sessionStorage
  storage.setItem(TOKEN_KEY, token)
  storage.setItem(USER_KEY, JSON.stringify(user))
}

function clearStorage(): void {
  ;[localStorage, sessionStorage].forEach((s) => {
    s.removeItem(TOKEN_KEY)
    s.removeItem(USER_KEY)
  })
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const queryClient = useQueryClient()
  const [token, setToken] = useState<string | null>(readToken)
  const [user, setUser] = useState<User | null>(() => readUser(readToken()))

  const login = useCallback(
    (newToken: string, newUser: User, remember: boolean) => {
      // Clear all cached queries from the previous session so the new user
      // never sees stale data belonging to another account.
      queryClient.clear()
      resetImageCache()
      writeStorage(newToken, newUser, remember)
      setToken(newToken)
      setUser(newUser)
    },
    [queryClient],
  )

  const logout = useCallback(() => {
    clearStorage()
    queryClient.clear()
    resetImageCache()
    setToken(null)
    setUser(null)
    // Fire-and-forget: close frames sent to server → OnDisconnectedAsync → user goes offline
    Promise.allSettled([stopNotificationConnection(), stopChatConnection()])
  }, [queryClient])

  useEffect(() => {
    const handleUnauthorized = () => {
      logout()
    }
    window.addEventListener('auth-unauthorized', handleUnauthorized)
    return () => window.removeEventListener('auth-unauthorized', handleUnauthorized)
  }, [logout])

  return (
    <AuthContext.Provider
      value={{ user, token, isAuthenticated: !!token, login, logout }}
    >
      {children}
    </AuthContext.Provider>
  )
}
