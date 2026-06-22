import { useEffect } from 'react'
import { useLocation, useNavigationType } from 'react-router'

export function ScrollToTop() {
  const { pathname } = useLocation()
  const navType = useNavigationType()

  useEffect(() => {
    // Only scroll to top on new navigation (PUSH or REPLACE)
    // POP means the user used the back or forward button, so we let the browser handle scroll restoration
    if (navType !== 'POP') {
      window.scrollTo(0, 0)
    }
  }, [pathname])

  return null
}
