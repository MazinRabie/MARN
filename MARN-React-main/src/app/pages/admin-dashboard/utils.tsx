import React from 'react'
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from '../../components/ui/tooltip'

const BASE_URL = (import.meta.env.VITE_API_BASE_URL as string | undefined) || (import.meta.env.PROD ? 'https://marn.runasp.net' : '')

export function buildImageUrl(path: string | null | undefined): string | undefined {
  if (!path) return undefined
  if (path.startsWith('http')) return path
  const base = BASE_URL.endsWith('/') ? BASE_URL.slice(0, -1) : BASE_URL
  const p = path.startsWith('/') ? path : `/${path}`
  return `${base}${p}`
}

export const formatTrend = (pct?: number) => {
  if (pct == null) return ''
  return pct >= 0 ? `+${pct}%` : `${pct}%`
}

export const getStatusBadge = (status?: string | null) => {
  if (!status) {
    return (
      <span className="px-3 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-700">
        Unknown
      </span>
    )
  }

  const styles: Record<string, string> = {
    pending: 'bg-yellow-100 text-yellow-700',
    active: 'bg-green-100 text-green-700',
    verified: 'bg-green-100 text-green-700',
    unverified: 'bg-yellow-100 text-yellow-700',
    suspended: 'bg-red-100 text-red-700',
    banned: 'bg-red-100 text-red-700',
    'in review': 'bg-yellow-100 text-yellow-700',
    inreview: 'bg-yellow-100 text-yellow-700',
    resolved: 'bg-green-100 text-green-700',
    rejected: 'bg-red-100 text-red-700',
    declined: 'bg-red-100 text-red-700',
  }
  return (
    <span
      className={`px-3 py-1 rounded-full text-xs font-semibold ${styles[status.toLowerCase()] ?? 'bg-gray-100 text-gray-700'}`}
    >
      {status}
    </span>
  )
}

export function TruncatedTooltip({ text, className }: { text: string; className?: string }) {
  const textRef = React.useRef<HTMLDivElement>(null)
  const [isOverflowing, setIsOverflowing] = React.useState(false)

  const handleMouseEnter = () => {
    if (textRef.current) {
      setIsOverflowing(textRef.current.scrollWidth > textRef.current.clientWidth)
    }
  }

  return (
    <Tooltip>
      <TooltipTrigger asChild>
        <div
          ref={textRef}
          onMouseEnter={handleMouseEnter}
          className={`truncate cursor-default ${className || ''}`}
        >
          {text}
        </div>
      </TooltipTrigger>
      {isOverflowing && (
        <TooltipContent side="top" className="max-w-xs">
          <p>{text}</p>
        </TooltipContent>
      )}
    </Tooltip>
  )
}
