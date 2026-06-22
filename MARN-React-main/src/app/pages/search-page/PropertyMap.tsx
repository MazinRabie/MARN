import { useEffect, useMemo, useRef, useState } from 'react'
import { MapContainer, TileLayer, Marker, Popup, useMap, useMapEvents } from 'react-leaflet'
import { Link } from 'react-router'
import { MapPin, Star, BedDouble, Bath, Users, Loader2, MapIcon } from 'lucide-react'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import type { SearchProperty } from '@/types/property'
import { getImageUrl } from '@/constants/assets'
import { ImageWithFallback } from '@/app/components/figma/ImageWithFallback'
import { useTranslation } from 'react-i18next'

// Fix Leaflet's default icon issue in bundled React apps
delete (L.Icon.Default.prototype as any)._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl:
    'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
})

// Custom marker icon matching the app's blue accent
const propertyIcon = new L.DivIcon({
  className: 'property-marker',
  html: `
    <div style="
      width: 36px; height: 36px;
      background: linear-gradient(135deg, #3A6EA5, #2d5a8a);
      border-radius: 50% 50% 50% 4px;
      transform: rotate(-45deg);
      border: 3px solid white;
      box-shadow: 0 4px 12px rgba(58,110,165,0.4);
      display: flex; align-items: center; justify-content: center;
    ">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="white" style="transform: rotate(45deg)">
        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
        <polyline points="9 22 9 12 15 12 15 22" fill="rgba(255,255,255,0.3)" stroke="white" stroke-width="1.5"/>
      </svg>
    </div>
  `,
  iconSize: [36, 36],
  iconAnchor: [4, 36],
  popupAnchor: [14, -36],
})

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

// "You are here" user location marker
const userLocationIcon = new L.DivIcon({
  className: 'user-location-marker',
  html: `
    <div style="
      width: 20px; height: 20px;
      background: #3A6EA5;
      border-radius: 50%;
      border: 3px solid white;
      box-shadow: 0 0 0 6px rgba(58,110,165,0.25), 0 4px 12px rgba(58,110,165,0.4);
      animation: userPulse 2s ease-in-out infinite;
    "></div>
  `,
  iconSize: [20, 20],
  iconAnchor: [10, 10],
  popupAnchor: [0, -14],
})

/* ── Geocoding logic removed (using API coordinates) ───────────────── */

/* ── Auto-fit map bounds to markers ─────────────────────────────── */

function FitBounds({ positions, userLat, userLng, radiusKm }: { positions: [number, number][], userLat?: number, userLng?: number, radiusKm?: number }) {
  const map = useMap()
  const prevLength = useRef(0)

  useEffect(() => {
    if (userLat !== undefined && userLng !== undefined && radiusKm !== undefined) {
      // Fit to the precise circular bounds of the selected radius
      const bounds = L.latLng(userLat, userLng).toBounds(radiusKm * 1000)
      map.fitBounds(bounds, { padding: [20, 20] })
      prevLength.current = positions.length
    } else if (positions.length > 0 && positions.length !== prevLength.current) {
      // Fallback: fit to property markers
      const bounds = L.latLngBounds(positions.map(([lat, lng]) => [lat, lng]))
      map.fitBounds(bounds, { padding: [50, 50], maxZoom: 14 })
      prevLength.current = positions.length
    }
  }, [positions, userLat, userLng, radiusKm, map])

  return null
}

function MapClickHandler({ isSelectMode, onMapClick }: { isSelectMode?: boolean, onMapClick?: (lat: number, lng: number) => void }) {
  useMapEvents({
    click(e) {
      if (isSelectMode && onMapClick) {
        onMapClick(e.latlng.lat, e.latlng.lng)
      }
    }
  })
  return null
}

/* ── Main component ─────────────────────────────────────────────── */

interface PropertyMapProps {
  properties: SearchProperty[]
  userLat?: number
  userLng?: number
  radiusKm?: number
  isSelectMode?: boolean
  isShowingAll?: boolean
  showFetchAllButton?: boolean
  isFetchingAll?: boolean
  onToggleShowAll?: () => void
  onMapClick?: (lat: number, lng: number) => void
}

interface GeocodedProperty extends SearchProperty {
  lat: number
  lng: number
}

export function PropertyMap({ properties, userLat, userLng, radiusKm, isSelectMode, showFetchAllButton, isShowingAll, isFetchingAll, onToggleShowAll, onMapClick }: PropertyMapProps) {
  const { t, i18n } = useTranslation(['properties', 'common'])
  const isGeocoding = false // Removed geocoding progress state
  const geocodingProgress = { done: 0, total: 0 }

  // Egypt center as default
  const defaultCenter: [number, number] = [26.8206, 30.8025]

  const geocoded = useMemo(() => {
    const results: GeocodedProperty[] = []
    
    for (const p of properties) {
      const lat = p.latitude
      const lng = p.longitude
      
      if (lat !== undefined && lng !== undefined) {
        if (userLat !== undefined && userLng !== undefined && radiusKm !== undefined) {
          const distance = L.latLng(userLat, userLng).distanceTo(L.latLng(lat, lng))
          if (distance <= radiusKm * 1000) {
            results.push({ ...p, lat, lng })
          }
        } else {
          results.push({ ...p, lat, lng })
        }
      }
    }
    
    return results
  }, [properties, userLat, userLng, radiusKm])

  const positions = useMemo<[number, number][]>(
    () => geocoded.map((p) => [p.lat, p.lng]),
    [geocoded]
  )

  // Include user location in fit-bounds when available
  const allPositions = useMemo<[number, number][]>(() => {
    const pts = [...positions]
    if (userLat !== undefined && userLng !== undefined) {
      pts.push([userLat, userLng])
    }
    return pts
  }, [positions, userLat, userLng])

  const center = useMemo<[number, number]>(() => {
    if (userLat !== undefined && userLng !== undefined) return [userLat, userLng]
    return positions.length > 0 ? positions[0] : defaultCenter
  }, [positions, userLat, userLng])

  return (
    <div className="relative mb-8 rounded-3xl overflow-hidden shadow-lg shadow-black/5 border border-[#3A6EA5]/10">
      {/* Geocoding progress indicator */}
      {isGeocoding && (
        <div className="absolute top-4 left-1/2 -translate-x-1/2 z-10 flex items-center gap-2 bg-white/95 backdrop-blur-sm px-4 py-2 rounded-full shadow-lg border border-[#3A6EA5]/20">
          <Loader2 className="w-4 h-4 text-[#3A6EA5] animate-spin" />
          <span className="text-sm text-[#4a5565] font-medium">
            {t('search.locatingProperties', { done: geocodingProgress.done, total: geocodingProgress.total })}
          </span>
          <div className="w-20 h-1.5 bg-[#e8eef5] rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-[#3A6EA5] to-[#2d5a8a] rounded-full transition-all duration-300"
              style={{
                width: `${(geocodingProgress.done / geocodingProgress.total) * 100}%`,
              }}
            />
          </div>
        </div>
      )}

      {/* Property count badge */}
      {geocoded.length > 0 && !isGeocoding && (
        <div className="absolute top-4 right-4 z-10 flex items-center gap-1.5 bg-white/95 backdrop-blur-sm px-3 py-1.5 rounded-full shadow-md border border-[#3A6EA5]/15">
          <MapPin className="w-3.5 h-3.5 text-[#3A6EA5]" />
          <span className="text-sm font-medium text-[#1a1a1a]">
            {geocoded.length === 1 ? t('search.onMap_one', { count: geocoded.length }) : t('search.onMap_other', { count: geocoded.length })}
          </span>
        </div>
      )}

      <MapContainer
        center={center}
        zoom={6}
        scrollWheelZoom={true}
        style={{ height: 450, width: '100%' }}
        className={`z-0 ${isSelectMode ? 'map-select-mode' : ''}`}
      >
        <MapClickHandler isSelectMode={isSelectMode} onMapClick={onMapClick} />
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/">CARTO</a>'
          url="https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png"
        />

        {allPositions.length > 0 && <FitBounds positions={allPositions} userLat={userLat} userLng={userLng} radiusKm={radiusKm} />}

        {geocoded.map((property) => (
          <Marker
            key={property.id}
            position={[property.lat, property.lng]}
            icon={propertyIcon}
            eventHandlers={{
              mouseover: (e) => {
                e.target.setIcon(activePropertyIcon)
              },
              mouseout: (e) => {
                e.target.setIcon(propertyIcon)
              },
            }}
          >
            <Popup
              closeButton={true}
              minWidth={280}
              maxWidth={320}
              className="property-popup"
            >
              <Link
                to={`/property/${property.id}`}
                className="block no-underline text-inherit"
              >
                <div className="overflow-hidden">
                  {/* Property image */}
                  <div className="relative h-[140px] overflow-hidden">
                    <ImageWithFallback
                      src={getImageUrl(property.imagePath)}
                      alt={property.title}
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent" />
                    <span className="absolute bottom-2 left-2 px-2 py-0.5 bg-white/90 backdrop-blur-sm rounded-full text-xs font-medium text-[#1a1a1a]">
                      {t(`addProperty.detailsStep.types.${property.type?.toLowerCase()}`, { defaultValue: property.typeDisplayName || property.type })}
                    </span>
                  </div>

                  {/* Property details */}
                  <div className="px-4 py-3">
                    <h4 className="font-semibold text-sm text-[#1a1a1a] line-clamp-1 mb-1">
                      {property.title}
                    </h4>

                    <div className="flex items-center gap-1 mb-2">
                      <MapPin className="w-3 h-3 text-[#3A6EA5] flex-shrink-0" />
                      <span className="text-xs text-[#4a5565] line-clamp-1">
                        {property.address}
                      </span>
                    </div>

                    <div className="flex items-center gap-3 mb-2 text-xs text-[#6a7282]">
                      <span className="flex items-center gap-1">
                        <BedDouble className="w-3 h-3" />
                        {property.bedrooms}
                      </span>
                      <span className="flex items-center gap-1">
                        <Bath className="w-3 h-3" />
                        {property.bathrooms}
                      </span>
                      <span className="flex items-center gap-1">
                        <Users className="w-3 h-3" />
                        {property.maxOccupants}
                      </span>
                      {property.averageRating > 0 && (
                        <span className="flex items-center gap-1 ml-auto">
                          <Star className="w-3 h-3 fill-[#3A6EA5] text-[#3A6EA5]" />
                          <span className="font-medium text-[#1a1a1a]">
                            {property.averageRating.toFixed(1)}
                          </span>
                        </span>
                      )}
                    </div>

                    <div className="flex items-baseline gap-1 pt-2 border-t border-[#e8eef5]" dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}>
                      <span className="text-lg font-bold text-[#3A6EA5]">
                        {i18n.language === 'ar' 
                          ? `${property.price.toLocaleString()} ${t('currency', { ns: 'common', defaultValue: 'EGP' })}` 
                          : `${t('currency', { ns: 'common', defaultValue: 'EGP' })} ${property.price.toLocaleString()}`}
                      </span>
                      <span className="text-xs text-[#6a7282]">
                        / {property.rentalUnit === 'Monthly' ? t('editProperty.monthBased') : property.rentalUnit === 'Yearly' ? t('editProperty.yearBased') : t('editProperty.dayBased')}
                      </span>
                    </div>
                  </div>
                </div>
              </Link>
            </Popup>
          </Marker>
        ))}

        {/* "You are here" user location marker */}
        {userLat !== undefined && userLng !== undefined && (
          <Marker
            position={[userLat, userLng]}
            icon={userLocationIcon}
            zIndexOffset={1000}
          >
            <Popup
              closeButton={false}
              minWidth={120}
              className="user-location-popup"
            >
              <div className="text-center py-1 px-2">
                <p className="font-semibold text-sm text-[#3A6EA5] mb-0">You are here</p>
              </div>
            </Popup>
          </Marker>
        )}
      </MapContainer>

      {/* Fetch All for Map Button */}
      {showFetchAllButton && onToggleShowAll && (
        <div className="absolute bottom-6 left-4 z-[1000]">
          <button
            onClick={onToggleShowAll}
            disabled={isFetchingAll}
            className="flex items-center gap-2 bg-white/95 backdrop-blur-sm text-[#3A6EA5] px-4 py-2 rounded-xl shadow-md border border-[#3A6EA5]/20 font-medium text-sm hover:bg-white transition-colors cursor-pointer disabled:cursor-not-allowed"
          >
            {isFetchingAll ? (
              <Loader2 className="w-4 h-4 animate-spin" />
            ) : (
              <MapIcon className="w-4 h-4" />
            )}
            {isShowingAll 
              ? t('search.showCurrentPageOnly', { defaultValue: 'Show current page properties only' })
              : t('search.showAllOnMap', { defaultValue: 'Show all properties on map' })}
          </button>
        </div>
      )}

      {/* Inline styles for popup customization and marker animation */}
      <style>{`
        .property-popup .leaflet-popup-content-wrapper {
          padding: 0;
          border-radius: 16px;
          overflow: hidden;
          box-shadow: 0 10px 40px rgba(0,0,0,0.15);
        }
        .property-popup .leaflet-popup-content {
          margin: 0;
          width: 280px !important;
        }
        .property-popup .leaflet-popup-tip {
          box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .property-popup .leaflet-popup-close-button {
          z-index: 10;
          color: white !important;
          font-size: 20px !important;
          width: 28px !important;
          height: 28px !important;
          top: 4px !important;
          right: 4px !important;
          background: rgba(0,0,0,0.3) !important;
          border-radius: 50% !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          padding: 0 !important;
          line-height: 1 !important;
        }
        .property-popup .leaflet-popup-close-button:hover {
          background: rgba(0,0,0,0.5) !important;
        }
        @keyframes markerPulse {
          0%, 100% { transform: rotate(-45deg) scale(1); }
          50% { transform: rotate(-45deg) scale(1.08); }
        }
        @keyframes userPulse {
          0%, 100% { box-shadow: 0 0 0 6px rgba(58,110,165,0.25), 0 4px 12px rgba(58,110,165,0.4); }
          50% { box-shadow: 0 0 0 12px rgba(58,110,165,0.1), 0 4px 16px rgba(58,110,165,0.3); }
        }
        .user-location-popup .leaflet-popup-content-wrapper {
          padding: 4px 8px;
          border-radius: 12px;
          box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        .user-location-popup .leaflet-popup-content {
          margin: 0;
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
