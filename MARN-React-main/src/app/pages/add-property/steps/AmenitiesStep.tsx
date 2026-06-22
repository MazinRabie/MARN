import { Label } from '../../../components/ui/label'
import { Checkbox } from '../../../components/ui/checkbox'
import { useTranslation } from 'react-i18next'
import { PROPERTY_AMENITIES as AMENITIES } from '@/constants/property'
import { PropertyFormData } from '../types'

interface AmenitiesStepProps {
  formData: PropertyFormData
  updateFormData: (updates: Partial<PropertyFormData>) => void
}

export function AmenitiesStep({ formData, updateFormData }: AmenitiesStepProps) {
  const { t } = useTranslation('properties')
  const toggleAmenity = (amenity: string) => {
    const isSelected = formData.selectedAmenities.includes(amenity)
    const newAmenities = isSelected
      ? formData.selectedAmenities.filter(a => a !== amenity)
      : [...formData.selectedAmenities, amenity]
    updateFormData({ selectedAmenities: newAmenities })
  }

  const toggleAdditionalAmenity = (amenity: string, checked: boolean) => {
    const isSelected = formData.additionalAmenities.includes(amenity)
    let newAmenities = formData.additionalAmenities
    if (checked && !isSelected) {
      newAmenities = [...formData.additionalAmenities, amenity]
    } else if (!checked && isSelected) {
      newAmenities = formData.additionalAmenities.filter(a => a !== amenity)
    }
    updateFormData({ additionalAmenities: newAmenities })
  }

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-6">
        {t('addProperty.amenitiesStep.title')}
      </h2>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {AMENITIES.map((amenity) => {
          const Icon = amenity.icon
          const isSelected = formData.selectedAmenities.includes(amenity.name)

          return (
            <button
              key={amenity.name}
              onClick={() => toggleAmenity(amenity.name)}
              className={`p-6 rounded-2xl transition-all ${
                isSelected
                  ? 'bg-[#3A6EA5] text-white shadow-lg shadow-[#3A6EA5]/30'
                  : 'bg-white text-[#1a1a1a] hover:bg-[#9CBBDC]/20'
              }`}
            >
              <Icon className="w-8 h-8 mx-auto mb-3" />
              <p className="text-sm font-medium">{t(`addProperty.amenitiesStep.items.${amenity.name}`, { defaultValue: amenity.name })}</p>
            </button>
          )
        })}
      </div>

      <div className="bg-white rounded-2xl p-6">
        <Label className="text-[#1a1a1a] mb-3 block">
          {t('addProperty.amenitiesStep.additionalAmenities')}
        </Label>
        <div className="space-y-3">
          {[
            'Dishwasher',
            'Microwave',
            'Refrigerator',
            'Balcony/Patio',
            'Hardwood Floors',
            'Storage Space',
            'Security System',
            'Elevator',
          ].map((amenity) => (
            <div key={amenity} className="flex items-center">
              <Checkbox
                id={amenity}
                className="border-[#3A6EA5] data-[state=checked]:bg-[#3A6EA5]"
                checked={formData.additionalAmenities.includes(amenity)}
                onCheckedChange={(checked) => toggleAdditionalAmenity(amenity, checked as boolean)}
              />
              <label
                htmlFor={amenity}
                className="ms-3 text-[#1a1a1a] cursor-pointer"
              >
                {t(`addProperty.amenitiesStep.items.${amenity}`)}
              </label>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
