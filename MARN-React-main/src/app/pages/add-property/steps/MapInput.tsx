import { useState, useCallback } from 'react'
import { MapContainer, TileLayer, Marker, useMapEvents } from 'react-leaflet'
import { Navigation, Search, MapPin, Loader2, X } from 'lucide-react'
import { Button } from '../../../components/ui/button'
import { Input } from '../../../components/ui/input'
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '../../../components/ui/tooltip'
import { useTranslation } from 'react-i18next'
import 'leaflet/dist/leaflet.css'
import L from 'leaflet'

// Fix Leaflet's default icon issue in React
delete (L.Icon.Default.prototype as any)._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
});

// Beautiful marker matching the app's blue accent
const activePropertyIcon = new L.DivIcon({
  className: 'property-marker-active',
  html: `
    <div style="
      width: 44px; height: 44px;
      background: linear-gradient(135deg, #2d5a8a, #1a3d5e);
      border-radius: 50% 50% 50% 4px;
      transform: rotate(-45deg);
      border: 3px solid #FFD700;
      box-shadow: 0 6px 20px rgba(58,110,165,0.6), 0 0 0 4px rgba(255,215,0,0.3);
      display: flex; align-items: center; justify-content: center;
      animation: markerPulse 1.5s ease-in-out infinite;
    ">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="white" style="transform: rotate(45deg)">
        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
        <polyline points="9 22 9 12 15 12 15 22" fill="rgba(255,255,255,0.3)" stroke="white" stroke-width="1.5"/>
      </svg>
    </div>
  `,
  iconSize: [44, 44],
  iconAnchor: [4, 44],
  popupAnchor: [18, -44],
})

interface MapInputProps {
  location: { lat: number; lng: number }
  onChange: (location: { lat: number; lng: number }) => void
}

function LocationMarker({ location, onChange, isSelectMode }: MapInputProps & { isSelectMode: boolean }) {
  const map = useMapEvents({
    click(e) {
      if (isSelectMode) {
        onChange({ lat: e.latlng.lat, lng: e.latlng.lng })
        map.flyTo(e.latlng, map.getZoom())
      }
    },
  })

  return (
    <Marker
      position={location}
      draggable={true}
      icon={activePropertyIcon}
      eventHandlers={{
        dragend: (e) => {
          const marker = e.target
          const position = marker.getLatLng()
          onChange({ lat: position.lat, lng: position.lng })
        },
      }}
    ></Marker>
  )
}

export function MapInput({ location, onChange }: MapInputProps) {
  const { t } = useTranslation('properties')
  const [map, setMap] = useState<L.Map | null>(null)
  
  const [isSelectMode, setIsSelectMode] = useState(false)
  const [postalCode, setPostalCode] = useState('')
  const [isGeocoding, setIsGeocoding] = useState(false)
  const [isLocating, setIsLocating] = useState(false)
  const [error, setError] = useState('')

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
        onChange({ lat, lng })
        if (map) map.flyTo({ lat, lng }, 15)
        setPostalCode('')
      } else {
        setError(t('mapInput.errors.postalCodeNotFound'))
      }
    } catch {
      setError(t('mapInput.errors.geocodingFailed'))
    } finally {
      setIsGeocoding(false)
    }
  }, [postalCode, onChange, map, t])

  const handleMyLocation = useCallback(() => {
    if (!navigator.geolocation) {
      setError(t('mapInput.errors.geolocationNotSupported'))
      return
    }

    setIsLocating(true)
    setError('')

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const newLoc = { lat: position.coords.latitude, lng: position.coords.longitude }
        onChange(newLoc)
        if (map) map.flyTo(newLoc, 15)
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
  }, [onChange, map, t])

  return (
    <div className="w-full h-[450px] relative rounded-3xl overflow-hidden shadow-lg shadow-black/5 border border-[#3A6EA5]/10 z-0 group">
      
      {/* Overlay Controls */}
      <div className="absolute top-4 left-4 right-4 z-[400] rounded-2xl bg-white/80 backdrop-blur-md border border-[#3A6EA5]/15 shadow-lg shadow-[#3A6EA5]/5 p-3 flex flex-wrap items-center gap-3">
        {/* Postal Code Search */}
        <div className="flex items-center gap-2 flex-1 min-w-[220px]">
          <div className="relative flex-1">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#3A6EA5]" />
            <Input
              placeholder={t('mapInput.searchByPostalCode', { defaultValue: 'Search by postal code...' })}
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
            type="button"
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

        <div className="w-px h-8 bg-[#3A6EA5]/15 hidden sm:block" />

        {/* Action Buttons */}
        <TooltipProvider delayDuration={150}>
          <Tooltip>
            <TooltipTrigger asChild>
              <Button
                type="button"
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
              {t('mapInput.goToMyLocation', { defaultValue: 'Go to my location' })}
            </TooltipContent>
          </Tooltip>

          <Tooltip>
            <TooltipTrigger asChild>
              <Button
                type="button"
                variant={isSelectMode ? "default" : "outline"}
                size="icon"
                onClick={() => setIsSelectMode(!isSelectMode)}
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
      </div>

      {error && (
        <div className="absolute top-[88px] left-4 z-[400] bg-red-50 text-red-500 text-xs px-3 py-2 rounded-xl border border-red-200 shadow-sm flex items-center gap-1 w-max max-w-full">
          <X className="w-3 h-3 flex-shrink-0 cursor-pointer" onClick={() => setError('')} />
          <span>{error}</span>
        </div>
      )}

      <MapContainer
        center={location}
        zoom={13}
        scrollWheelZoom={true}
        style={{ height: '100%', width: '100%' }}
        ref={setMap}
        className={`z-0 ${isSelectMode ? 'map-select-mode' : ''}`}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/">CARTO</a>'
          url="https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png"
        />
        <LocationMarker location={location} onChange={onChange} isSelectMode={isSelectMode} />
      </MapContainer>
      
      <style>{`
        @keyframes markerPulse {
          0%, 100% { transform: rotate(-45deg) scale(1); }
          50% { transform: rotate(-45deg) scale(1.08); }
        }
        .map-select-mode {
          cursor: crosshair !important;
        }
        .map-select-mode .leaflet-interactive {
          cursor: crosshair !important;
        }
      `}</style>
    </div>
  )
}
