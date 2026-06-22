import { MapIcon, MapPin, ArrowDown, ArrowUp } from 'lucide-react'
import { Button } from '@/app/components/ui/button'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/app/components/ui/select'
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/app/components/ui/tooltip'
import { useTranslation } from 'react-i18next'

interface SearchHeaderProps {
  total: number
  isLoading: boolean
  sortBy: string
  onSortByChange: (sortBy: string) => void
  sortAscending: boolean
  onSortAscendingChange: (asc: boolean) => void
  sortByOptions: { id: number | string; name: string; displayName?: string }[]
  sortByLoading: boolean
  showMap: boolean
  onToggleMap: () => void
  locationLabel?: string
  radiusKm?: number
}

export function SearchHeader({
  total,
  isLoading,
  sortBy,
  onSortByChange,
  sortAscending,
  onSortAscendingChange,
  sortByOptions,
  sortByLoading,
  showMap,
  onToggleMap,
  locationLabel,
  radiusKm,
}: SearchHeaderProps) {
  const { t, i18n } = useTranslation('properties')
  
  // fallback if options not loaded
  const defaultOptions = [
    { name: 'Newest', displayName: 'Newest' },
    { name: 'Price', displayName: 'Price' },
    { name: 'Rating', displayName: 'Rating' },
    { name: 'Bedrooms', displayName: 'Bedrooms' },
    { name: 'Bathrooms', displayName: 'Bathrooms' },
    { name: 'SquareMeters', displayName: 'Square Meters' },
    { name: 'Distance', displayName: 'Distance' }
  ]
  
  const options = sortByOptions?.length ? sortByOptions : defaultOptions

  return (
    <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
      <div>
        <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
          {t('search.title')}
        </h1>
        <p className="text-[#4a5565] flex items-center gap-2 flex-wrap">
          {isLoading ? t('search.searching') : t('search.propertiesFound', { count: total })}
          {locationLabel && (
            <span className="inline-flex items-center gap-1 px-2.5 py-0.5 bg-[#3A6EA5]/10 rounded-full text-xs font-medium text-[#3A6EA5]">
              <MapPin className="w-3 h-3" />
              {t('search.near')}: {locationLabel} • {radiusKm}km
            </span>
          )}
        </p>
      </div>

      <div className="flex flex-wrap items-center gap-4">
        {/* Sort */}
        <div className="flex items-center gap-2">
          <Select
            value={sortBy}
            onValueChange={onSortByChange}
            dir={i18n.dir()}
          >
            <SelectTrigger className="w-[180px] rounded-xl bg-white border-[#3A6EA5]/20" dir={i18n.dir()}>
              <SelectValue placeholder={sortByLoading ? t('search.loading') : t('search.sortBy')} />
            </SelectTrigger>
            <SelectContent dir={i18n.dir()}>
              {options.map((opt) => (
                <SelectItem key={opt.name} value={opt.name}>
                  {opt.displayName || opt.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          
          <TooltipProvider delayDuration={150}>
            <Tooltip>
              <TooltipTrigger asChild>
                <Button
                  variant="outline"
                  size="icon"
                  className="rounded-xl border-[#3A6EA5]/20 hover:bg-[#3A6EA5]/10"
                  onClick={() => onSortAscendingChange(!sortAscending)}
                >
                  {sortAscending ? <ArrowUp className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
                </Button>
              </TooltipTrigger>
              <TooltipContent side="bottom" className="bg-[#1a1a1a] text-white text-xs border-none rounded-lg px-2 py-1.5 shadow-xl" dir={i18n.dir()}>
                {sortAscending ? t('search.sortAscending', 'Ascending') : t('search.sortDescending', 'Descending')}
              </TooltipContent>
            </Tooltip>
          </TooltipProvider>
        </div>

        <Button
          variant={showMap ? 'default' : 'outline'}
          className={`rounded-xl ${
            showMap
              ? 'bg-[#3A6EA5] text-white'
              : 'border-[#3A6EA5]/20 hover:bg-[#3A6EA5]/10'
          }`}
          onClick={onToggleMap}
        >
          <MapIcon className="w-4 h-4 mr-2" />
          {showMap ? t('search.hideMap') : t('search.showMap')}
        </Button>
      </div>
    </div>
  )
}
