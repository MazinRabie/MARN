import { useState } from 'react'
import { Popover, PopoverContent, PopoverTrigger } from '@/app/components/ui/popover'
import { Input } from '@/app/components/ui/input'
import { Button } from '@/app/components/ui/button'
import { useTranslation } from 'react-i18next'
import { ChevronsLeft, ChevronsRight, ChevronLeft, ChevronRight } from 'lucide-react'

interface PaginationProps {
  page: number
  totalPages: number
  onPageChange: (page: number) => void
}

function EllipsisDropdown({ onPageChange, totalPages }: { onPageChange: (p: number) => void, totalPages: number }) {
  const { t } = useTranslation('properties')
  const [open, setOpen] = useState(false)
  const [inputVal, setInputVal] = useState('')
  const [errorMsg, setErrorMsg] = useState('')

  const handleApply = () => {
    const val = parseInt(inputVal, 10)
    if (isNaN(val) || val < 1) return

    if (val > totalPages) {
      setErrorMsg(t('search.maxPagesError', { defaultValue: 'Max number of pages is {{max}}', max: totalPages }))
      return
    }

    setErrorMsg('')
    onPageChange(val)
    setOpen(false)
    setInputVal('')
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  return (
    <Popover open={open} onOpenChange={(val) => {
      setOpen(val)
      if (!val) setErrorMsg('')
    }}>
      <PopoverTrigger asChild>
        <button className="w-12 h-12 rounded-xl bg-[#f5f7fa] text-[#1a1a1a] hover:bg-[#9CBBDC] hover:text-white transition-all flex items-center justify-center font-bold tracking-widest">
          ...
        </button>
      </PopoverTrigger>
      <PopoverContent className="w-64 p-4" side="top">
        <div className="flex flex-col gap-3">
          <span className="text-sm font-medium">{t('search.goToPage', { defaultValue: 'Go to page' })} (1 - {totalPages})</span>
          <div className="flex gap-2">
            <Input 
              type="number" 
              min={1} 
              max={totalPages} 
              value={inputVal} 
              onChange={(e) => {
                setInputVal(e.target.value)
                setErrorMsg('')
              }}
              onKeyDown={(e) => e.key === 'Enter' && handleApply()}
              className={`h-9 focus-visible:ring-[#3A6EA5] ${errorMsg ? 'border-red-500' : ''}`}
            />
            <Button size="sm" onClick={handleApply} className="h-9 bg-[#3A6EA5] hover:bg-[#3A6EA5]/90 shrink-0">
              {t('search.apply', { defaultValue: 'Apply' })}
            </Button>
          </div>
          {errorMsg && (
            <span className="text-xs text-red-500 font-medium">{errorMsg}</span>
          )}
        </div>
      </PopoverContent>
    </Popover>
  )
}

const getPageItems = (current: number, total: number) => {
  if (total <= 4) return Array.from({ length: total }, (_, i) => i + 1)
  
  if (current <= 3) {
    return [1, 2, 3, '...', total]
  }
  if (current >= total - 2) {
    return [1, '...', total - 2, total - 1, total]
  }
  return [1, '...', current - 1, current, current + 1, '...', total]
}

export function Pagination({ page, totalPages, onPageChange }: PaginationProps) {
  const { i18n } = useTranslation()
  const isRtl = i18n.language === 'ar' || i18n.dir() === 'rtl'

  if (totalPages <= 1) return null

  const items = getPageItems(page, totalPages)

  return (
    <div className="flex justify-center items-center gap-2 mt-12">
      {totalPages > 4 && (
        <button
          onClick={() => {
            onPageChange(1)
            window.scrollTo({ top: 0, behavior: 'smooth' })
          }}
          disabled={page === 1}
          className="w-12 h-12 flex items-center justify-center rounded-xl bg-[#f5f7fa] text-[#1a1a1a] hover:bg-[#9CBBDC] hover:text-white disabled:opacity-40 disabled:cursor-not-allowed transition-all"
        >
          <ChevronsLeft className={`w-5 h-5 ${isRtl ? 'rotate-180' : ''}`} />
        </button>
      )}
      
      <button
        onClick={() => {
          onPageChange(Math.max(1, page - 1))
          window.scrollTo({ top: 0, behavior: 'smooth' })
        }}
        disabled={page === 1}
        className="w-12 h-12 flex items-center justify-center rounded-xl bg-[#f5f7fa] text-[#1a1a1a] hover:bg-[#9CBBDC] hover:text-white disabled:opacity-40 disabled:cursor-not-allowed transition-all"
      >
        <ChevronLeft className={`w-5 h-5 ${isRtl ? 'rotate-180' : ''}`} />
      </button>

      {items.map((p, idx) => {
        if (p === '...') {
          return (
            <EllipsisDropdown 
              key={`ellipsis-${idx}`} 
              totalPages={totalPages} 
              onPageChange={onPageChange} 
            />
          )
        }
        
        return (
          <button
            key={p}
            onClick={() => {
              onPageChange(p as number)
              window.scrollTo({ top: 0, behavior: 'smooth' })
            }}
            className={`w-12 h-12 rounded-xl transition-all flex items-center justify-center ${
              p === page
                ? 'bg-[#3A6EA5] text-white shadow-lg shadow-[#3A6EA5]/30 font-semibold'
                : 'bg-[#f5f7fa] text-[#1a1a1a] hover:bg-[#9CBBDC] hover:text-white'
            }`}
          >
            {p}
          </button>
        )
      })}

      <button
        onClick={() => {
          onPageChange(Math.min(totalPages, page + 1))
          window.scrollTo({ top: 0, behavior: 'smooth' })
        }}
        disabled={page === totalPages}
        className="w-12 h-12 flex items-center justify-center rounded-xl bg-[#f5f7fa] text-[#1a1a1a] hover:bg-[#9CBBDC] hover:text-white disabled:opacity-40 disabled:cursor-not-allowed transition-all"
      >
        <ChevronRight className={`w-5 h-5 ${isRtl ? 'rotate-180' : ''}`} />
      </button>

      {totalPages > 4 && (
        <button
          onClick={() => {
            onPageChange(totalPages)
            window.scrollTo({ top: 0, behavior: 'smooth' })
          }}
          disabled={page === totalPages}
          className="w-12 h-12 flex items-center justify-center rounded-xl bg-[#f5f7fa] text-[#1a1a1a] hover:bg-[#9CBBDC] hover:text-white disabled:opacity-40 disabled:cursor-not-allowed transition-all"
        >
          <ChevronsRight className={`w-5 h-5 ${isRtl ? 'rotate-180' : ''}`} />
        </button>
      )}
    </div>
  )
}
