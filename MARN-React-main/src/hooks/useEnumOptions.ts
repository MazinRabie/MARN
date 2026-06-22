import { useEffect, useState } from 'react'
import { apiClient } from '@/services/apiClient'
import type { ApiResponse } from '@/types/common'

export interface EnumOption {
  id: number
  name: string
  displayName?: string
}

export type EnumEndpoint =
  | 'genders'
  | 'languages'
  | 'countries'
  | 'property-types'
  | 'cities'
  | 'governorates'
  | 'rental-units'
  | 'roommate-search-statuses'
  | 'sleep-schedules'
  | 'fields-of-study'
  | 'guests-frequencies'
  | 'work-schedules'
  | 'sharing-levels'
  | 'education-levels'
  | 'amenity-types'
  | 'property-sort-by'

interface State {
  options: EnumOption[]
  loading: boolean
  error: string | null
}

const cache = new Map<EnumEndpoint, EnumOption[]>()

export function useEnumOptions(endpoint: EnumEndpoint): State {
  const [state, setState] = useState<State>(() => {
    const cached = cache.get(endpoint)
    return cached
      ? { options: cached, loading: false, error: null }
      : { options: [], loading: true, error: null }
  })

  useEffect(() => {
    if (cache.has(endpoint)) return

    let cancelled = false

    apiClient
      .get<ApiResponse<EnumOption[]>>(`/api/Enum/${endpoint}`)
      .then((res) => {
        if (cancelled) return
        const options = res.data ?? []
        cache.set(endpoint, options)
        setState({ options, loading: false, error: null })
      })
      .catch(() => {
        if (!cancelled) {
          setState({
            options: [],
            loading: false,
            error: `Failed to load ${endpoint}`,
          })
        }
      })

    return () => {
      cancelled = true
    }
  }, [endpoint])

  return state
}
