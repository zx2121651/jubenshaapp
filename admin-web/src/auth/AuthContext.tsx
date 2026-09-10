import { createContext, useContext, useState, useMemo } from 'react'
import type { ReactNode } from 'react'

interface AuthCtx {
  user: string | null
  login: (username: string) => void
  logout: () => void
}

const Ctx = createContext<AuthCtx>({ user: null, login: () => {}, logout: () => {} })

const TOKEN_KEY = 'admin.auth.user'

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<string | null>(() => {
    try {
      return localStorage.getItem(TOKEN_KEY)
    } catch {
      return null
    }
  })

  const value = useMemo<AuthCtx>(
    () => ({
      user,
      login: (username: string) => {
        localStorage.setItem(TOKEN_KEY, username)
        setUser(username)
      },
      logout: () => {
        localStorage.removeItem(TOKEN_KEY)
        setUser(null)
      },
    }),
    [user],
  )

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>
}

export function useAuth() {
  return useContext(Ctx)
}