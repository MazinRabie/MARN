import { useState } from 'react'
import { X, MapPin, Navigation } from 'lucide-react'
import { Button } from './ui/button'
import { Input } from './ui/input'
import { Label } from './ui/label'

interface LocationModalProps {
  isOpen: boolean
  onClose: () => void
  onSave: (location: { address: string; lat: number; lng: number }) => void
}

export function LocationModal({ isOpen, onClose, onSave }: LocationModalProps) {
  const [address, setAddress] = useState('')
  const [coordinates, setCoordinates] = useState({
    lat: 37.7749,
    lng: -122.4194,
  })

  const handleUseCurrentLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setCoordinates({
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          })
          // In production, you'd reverse geocode to get the address
          setAddress(
            `${position.coords.latitude}, ${position.coords.longitude}`,
          )
        },
        (error) => {
          console.error('Error getting location:', error)
        },
      )
    }
  }

  const handleSave = () => {
    onSave({ address, ...coordinates })
    onClose()
  }

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl">
        {/* Header */}
        <div className="sticky top-0 bg-white border-b border-[#3A6EA5]/20 p-6 rounded-t-3xl flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center">
              <MapPin className="w-5 h-5 text-white" />
            </div>
            <h2 className="text-2xl font-bold text-[#1a1a1a]">
              Upload Location
            </h2>
          </div>
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-xl hover:bg-[#f5f7fa] flex items-center justify-center transition-colors"
          >
            <X className="w-5 h-5 text-[#4a5565]" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-6">
          {/* Map Preview */}
          <div className="bg-[#f5f7fa] rounded-2xl h-64 flex items-center justify-center relative overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-[#9CBBDC]/30 to-[#f5f7fa]"></div>
            <div className="relative z-10 text-center">
              <MapPin className="w-16 h-16 text-[#3A6EA5] mx-auto mb-4" />
              <p className="text-[#4a5565]">
                Interactive map would display here
              </p>
              <p className="text-sm text-[#4a5565] mt-2">
                Lat: {coordinates.lat.toFixed(4)}, Lng:{' '}
                {coordinates.lng.toFixed(4)}
              </p>
            </div>
          </div>

          {/* Current Location Button */}
          <Button
            type="button"
            variant="outline"
            className="w-full border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white rounded-xl"
            onClick={handleUseCurrentLocation}
          >
            <Navigation className="w-5 h-5 mr-2" />
            Use Current Location
          </Button>

          {/* Manual Address Input */}
          <div>
            <Label htmlFor="address" className="text-[#1a1a1a] mb-2 block">
              Or Enter Address Manually
            </Label>
            <Input
              id="address"
              value={address}
              onChange={(e) => setAddress(e.target.value)}
              placeholder="123 Main St, San Francisco, CA 94102"
              className="bg-[#f5f7fa] rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5]"
            />
            <p className="text-sm text-[#4a5565] mt-2">
              You can also click on the map to drop a pin
            </p>
          </div>

          {/* Action Buttons */}
          <div className="flex gap-4 pt-4">
            <Button
              type="button"
              variant="outline"
              className="flex-1 rounded-xl border-[#3A6EA5]/20"
              onClick={onClose}
            >
              Cancel
            </Button>
            <Button
              type="button"
              className="flex-1 bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl"
              onClick={handleSave}
              disabled={!address}
            >
              Save Location
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
