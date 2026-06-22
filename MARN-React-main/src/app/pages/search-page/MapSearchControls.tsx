import { useState, useCallback } from 'react'
import {
  Search,
  Navigation,
  MapPin,
  X,
  Loader2,
  ChevronDown,
} from 'lucide-react'
import { Button } from '@/app/components/ui/button'
import { Input } from '@/app/components/ui/input'
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@/app/components/ui/tooltip'
import { Popover, PopoverContent, PopoverTrigger } from '@/app/components/ui/popover'
import { useTranslation } from 'react-i18next'

const RADIUS_OPTIONS = [10, 25, 50] as const

interface MapSearchControlsProps {
  userLat: number | undefined
  userLng: number | undefined
  radiusKm: number
  onRadiusChange: (km: number) => void
  locationLabel: string
  onSetLocation: (lat: number, lng: number, label: string) => void
  onClearLocation: () => void
  isSelectMode?: boolean
  onToggleSelectMode?: () => void
}

export function MapSearchControls({
  userLat,
  radiusKm,
  onRadiusChange,
  locationLabel,
  onSetLocation,
  onClearLocation,
  isSelectMode,
  onToggleSelectMode,
}: MapSearchControlsProps) {
  const { t } = useTranslation('properties')
  const [postalCode, setPostalCode] = useState('')
  const [isGeocoding, setIsGeocoding] = useState(false)
  const [isLocating, setIsLocating] = useState(false)
  const [error, setError] = useState('')
  const [customRadiusInput, setCustomRadiusInput] = useState('')
  const [isCustomOpen, setIsCustomOpen] = useState(false)

  const isCustomRadius = !RADIUS_OPTIONS.includes(radiusKm as any)
  const hasLocation = userLat !== undefined

  /* ── Postal‑code geocode via Nominatim ──────────────────────────── */
  const handlePostalSearch = useCallback(async () => {
    const code = postalCode.trim()
    if (!code) return

    setIsGeocoding(true)
    setError('')

    try {
      const res = await fetch(
        `https://nominatim.openstreetmap.org/search?format=json&postalcode=${encodeURIComponent(code)}&country=Egypt&limit=1`,
        { headers: { 'User-Agent': 'MARN-PropertyApp/1.0' } },
      )
      const data = await res.json()

      if (data.length > 0) {
        const lat = parseFloat(data[0].lat)
        const lng = parseFloat(data[0].lon)
        onSetLocation(lat, lng, t('mapInput.postalCodePrefix', { code }))
        setPostalCode('')
      } else {
        setError(t('mapInput.errors.postalCodeNotFound'))
      }
    } catch {
      setError(t('mapInput.errors.geocodingFailed'))
    } finally {
      setIsGeocoding(false)
    }
  }, [postalCode, onSetLocation])

  /* ── Browser geolocation ────────────────────────────────────────── */
  const handleMyLocation = useCallback(() => {
    if (!navigator.geolocation) {
      setError(t('mapInput.errors.geolocationNotSupported'))
      return
    }

    setIsLocating(true)
    setError('')

    navigator.geolocation.getCurrentPosition(
      (position) => {
        onSetLocation(
          position.coords.latitude,
          position.coords.longitude,
          t('mapInput.myLocation'),
        )
        setIsLocating(false)
      },
      (err) => {
        setIsLocating(false)
        switch (err.code) {
          case err.PERMISSION_DENIED:
            setError(t('mapInput.errors.locationDenied'))
            break
          case err.POSITION_UNAVAILABLE:
            setError(t('mapInput.errors.locationUnavailable'))
            break
          case err.TIMEOUT:
            setError(t('mapInput.errors.locationTimeout'))
            break
          default:
            setError(t('mapInput.errors.locationError'))
        }
      },
      { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 },
    )
  }, [onSetLocation])

  return (
    <div className="mb-4 rounded-2xl bg-white/80 backdrop-blur-md border border-[#3A6EA5]/15 shadow-lg shadow-[#3A6EA5]/5 p-4">
      <div className="flex flex-wrap items-center gap-3">
        {/* ── Postal code input ────────────────────────────────── */}
        <div className="flex items-center gap-2 flex-1 min-w-[220px]">
          <div className="relative flex-1">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#3A6EA5]" />
            <Input
              placeholder={t('mapInput.searchByPostalCode')}
              value={postalCode}
              onChange={(e) => {
                setPostalCode(e.target.value)
                if (error) setError('')
              }}
              onKeyDown={(e) => {
                if (e.key === 'Enter') handlePostalSearch()
              }}
              className="pl-9 rounded-xl border-[#3A6EA5]/20 bg-white/70 text-sm h-10"
              disabled={isGeocoding}
            />
          </div>
          <Button
            size="sm"
            onClick={handlePostalSearch}
            disabled={isGeocoding || !postalCode.trim()}
            className="rounded-xl bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white h-10 px-4 shrink-0"
          >
            {isGeocoding ? (
              <Loader2 className="w-4 h-4 animate-spin" />
            ) : (
              <Search className="w-4 h-4" />
            )}
          </Button>
        </div>

        {/* ── Divider ─────────────────────────────────────────── */}
        <div className="w-px h-8 bg-[#3A6EA5]/15 hidden sm:block" />

        {/* ── My Location & Select Map buttons ────────────────── */}
        <TooltipProvider delayDuration={150}>
          <Tooltip>
            <TooltipTrigger asChild>
              <Button
                variant="outline"
                size="icon"
                onClick={handleMyLocation}
                disabled={isLocating}
                className="rounded-xl border-[#3A6EA5]/20 hover:bg-[#3A6EA5]/10 text-[#3A6EA5] h-10 w-10 shrink-0"
              >
                {isLocating ? (
                  <Loader2 className="w-4 h-4 animate-spin" />
                ) : (
                  <Navigation className="w-4 h-4" />
                )}
              </Button>
            </TooltipTrigger>
            <TooltipContent side="bottom" sideOffset={6} className="bg-[#1a1a1a] text-white text-xs border-none rounded-lg px-2 py-1.5 shadow-xl">
              {t('mapInput.goToMyLocation')}
            </TooltipContent>
          </Tooltip>

          <Tooltip>
            <TooltipTrigger asChild>
              <Button
                variant={isSelectMode ? "default" : "outline"}
                size="icon"
                onClick={onToggleSelectMode}
                className={`rounded-xl h-10 w-10 shrink-0 ${isSelectMode ? 'bg-[#3A6EA5] text-white hover:bg-[#2a5a8a]' : 'border-[#3A6EA5]/20 hover:bg-[#3A6EA5]/10 text-[#3A6EA5]'}`}
              >
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M5 16l-3-3 3-3" />
                  <path d="M19 16l3-3-3-3" />
                  <path d="M12 2v20" />
                  <path d="M2 12h20" />
                </svg>
              </Button>
            </TooltipTrigger>
            <TooltipContent side="bottom" sideOffset={6} className="bg-[#1a1a1a] text-white text-xs border-none rounded-lg px-2 py-1.5 shadow-xl">
              {t('mapInput.selectOnMap', { defaultValue: 'Select on Map' })}
            </TooltipContent>
          </Tooltip>
        </TooltipProvider>

        {/* ── Radius selector (only shown when location is set) ── */}
        {hasLocation && (
          <>
            <div className="w-px h-8 bg-[#3A6EA5]/15 hidden sm:block" />
            <div className="flex items-center gap-1.5">
              <span className="text-xs text-[#4a5565] font-medium mr-1">{t('mapInput.radius')}</span>
              {RADIUS_OPTIONS.map((r) => (
                <button
                  key={r}
                  onClick={() => onRadiusChange(r)}
                  className={`px-2.5 py-1 rounded-lg text-xs font-medium transition-all ${
                    radiusKm === r && !isCustomRadius
                      ? 'bg-[#3A6EA5] text-white shadow-sm'
                      : 'bg-[#f5f7fa] text-[#4a5565] hover:bg-[#3A6EA5]/10'
                  }`}
                >
                  {r}km
                </button>
              ))}

              <Popover open={isCustomOpen} onOpenChange={setIsCustomOpen}>
                <PopoverTrigger asChild>
                  <button
                    className={`flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-medium transition-all ${
                      isCustomRadius
                        ? 'bg-[#3A6EA5] text-white shadow-sm'
                        : 'bg-[#f5f7fa] text-[#4a5565] hover:bg-[#3A6EA5]/10'
                    }`}
                  >
                    {isCustomRadius ? `${radiusKm}km` : t('mapInput.customRadius', { defaultValue: 'Custom' })}
                    <ChevronDown className="w-3 h-3 opacity-70" />
                  </button>
                </PopoverTrigger>
                <PopoverContent className="w-[200px] p-3" align="center">
                  <div className="space-y-3">
                    <h4 className="font-medium text-sm text-[#1a1a1a]">{t('mapInput.enterCustomRadius', { defaultValue: 'Custom Distance' })}</h4>
                    <div className="flex items-center gap-2">
                      <div className="relative flex-1">
                        <Input
                          type="number"
                          min="1"
                          max="1000"
                          placeholder="e.g. 15"
                          value={customRadiusInput}
                          onChange={(e) => setCustomRadiusInput(e.target.value)}
                          onKeyDown={(e) => {
                            if (e.key === 'Enter') {
                              const val = parseInt(customRadiusInput);
                              if (!isNaN(val) && val > 0) {
                                onRadiusChange(val);
                                setIsCustomOpen(false);
                              }
                            }
                          }}
                          className="h-8 text-sm pr-7"
                        />
                        <span className="absolute right-2 top-1/2 -translate-y-1/2 text-xs text-[#6a7282]">
                          km
                        </span>
                      </div>
                      <Button 
                        size="sm" 
                        className="h-8 px-3 bg-[#3A6EA5] hover:bg-[#2a5a8a]"
                        onClick={() => {
                          const val = parseInt(customRadiusInput);
                          if (!isNaN(val) && val > 0) {
                            onRadiusChange(val);
                            setIsCustomOpen(false);
                          }
                        }}
                      >
                        {t('common.apply', { defaultValue: 'Apply' })}
                      </Button>
                    </div>
                  </div>
                </PopoverContent>
              </Popover>
            </div>
          </>
        )}

        {/* ── Active location chip & clear ─────────────────────── */}
        {hasLocation && (
          <>
            <div className="w-px h-8 bg-[#3A6EA5]/15 hidden sm:block" />
            <div className="flex items-center gap-2 px-3 py-1.5 bg-[#3A6EA5]/10 rounded-xl">
              <MapPin className="w-3.5 h-3.5 text-[#3A6EA5]" />
              <span className="text-xs font-medium text-[#1a1a1a]">
                {locationLabel}
              </span>
              <button
                onClick={onClearLocation}
                className="ml-1 p-0.5 rounded-full hover:bg-[#3A6EA5]/20 transition-colors"
              >
                <X className="w-3 h-3 text-[#3A6EA5]" />
              </button>
            </div>
          </>
        )}
      </div>

      {/* ── Error message ──────────────────────────────────────── */}
      {error && (
        <p className="mt-2 text-xs text-red-500 flex items-center gap-1">
          <X className="w-3 h-3" />
          {error}
        </p>
      )}
    </div>
  )
}
