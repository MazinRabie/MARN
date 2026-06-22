import { useState, useEffect } from 'react'
import { Plus, X, CheckCircle } from 'lucide-react'
import { Label } from '../../../components/ui/label'
import { Input } from '../../../components/ui/input'
import { Checkbox } from '../../../components/ui/checkbox'
import { RadioGroup, RadioGroupItem } from '../../../components/ui/radio-group'
import { Button } from '../../../components/ui/button'
import { useTranslation } from 'react-i18next'
import { PropertyFormData } from '../types'
import { toast } from 'sonner'

interface AvailabilityStepProps {
  formData: PropertyFormData
  updateFormData: (updates: Partial<PropertyFormData>) => void
}

export function AvailabilityStep({ formData, updateFormData }: AvailabilityStepProps) {
  const { t, i18n } = useTranslation('properties')
  const [localAvailableFrom, setLocalAvailableFrom] = useState(formData.availableFrom)
  const [newPreference, setNewPreference] = useState('')

  useEffect(() => {
    setLocalAvailableFrom(formData.availableFrom)
  }, [formData])

  // toggleLeaseDuration removed since we use RadioGroup

  const toggleTenantPreference = (preference: string, checked: boolean) => {
    const isSelected = formData.tenantPreferences.includes(preference)
    let newPreferences = formData.tenantPreferences
    if (checked && !isSelected) {
      newPreferences = [...formData.tenantPreferences, preference]
    } else if (!checked && isSelected) {
      newPreferences = formData.tenantPreferences.filter(p => p !== preference)
    }
    updateFormData({ tenantPreferences: newPreferences })
  }

  const toggleCustomPreference = (preference: string, checked: boolean) => {
    const isSelected = formData.customPreferences.includes(preference)
    let newPreferences = formData.customPreferences
    if (checked && !isSelected) {
      newPreferences = [...formData.customPreferences, preference]
    } else if (!checked && isSelected) {
      newPreferences = formData.customPreferences.filter(p => p !== preference)
    }
    updateFormData({ customPreferences: newPreferences })
  }

  const addCustomPreference = () => {
    if (newPreference.trim() && !formData.customPreferences.includes(newPreference.trim())) {
      updateFormData({ customPreferences: [...formData.customPreferences, newPreference.trim()] })
      setNewPreference('')
      toast.success(t('addProperty.toasts.preferenceAdded'))
    }
  }

  const removeCustomPreference = (preference: string) => {
    updateFormData({ customPreferences: formData.customPreferences.filter(p => p !== preference) })
  }

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-6">
        {t('addProperty.availabilityStep.title')}
      </h2>

      <div>
        <Label
          htmlFor="available-from"
          className="text-[#1a1a1a] mb-2 block"
        >
          {t('addProperty.availabilityStep.availableFrom')}
        </Label>
        <Input
          id="available-from"
          type="date"
          className="rounded-xl bg-white border-[#3A6EA5]/20"
          value={localAvailableFrom}
          onChange={(e) => setLocalAvailableFrom(e.target.value)}
          onBlur={() => updateFormData({ availableFrom: localAvailableFrom })}
        />
      </div>

      <div className="bg-white rounded-2xl p-6">
        <Label className="text-[#1a1a1a] mb-3 block">
          {t('addProperty.availabilityStep.leaseDuration')}
        </Label>
        <RadioGroup
          value={formData.leaseDuration}
          onValueChange={(val) => updateFormData({ leaseDuration: val })}
          className="space-y-3"
          dir={i18n.dir()}
        >
          {[
            { label: t('addProperty.availabilityStep.daily'), value: 'Daily' },
            { label: t('addProperty.availabilityStep.monthly'), value: 'Monthly' },
            { label: t('addProperty.availabilityStep.yearly'), value: 'Yearly' },
          ].map((option) => (
            <div key={option.value} className="flex items-center gap-3">
              <RadioGroupItem value={option.value} id={option.value} className="border-[#3A6EA5]/50 text-[#3A6EA5] data-[state=checked]:border-[#3A6EA5]" />
              <label
                htmlFor={option.value}
                className="text-[#1a1a1a] cursor-pointer"
              >
                {option.label}
              </label>
            </div>
          ))}
        </RadioGroup>
      </div>

      <div className="bg-white rounded-2xl p-6">
        <Label className="text-[#1a1a1a] mb-3 block">
          {t('addProperty.availabilityStep.tenantPreferences')}
        </Label>

        {/* Input to add new preference */}
        <div className="flex gap-2 mb-4">
          <Input
            value={newPreference}
            onChange={(e) => setNewPreference(e.target.value)}
            onKeyPress={(e) =>
              e.key === 'Enter' && addCustomPreference()
            }
            placeholder={t('addProperty.availabilityStep.enterPreferencePlaceholder')}
            className="rounded-xl border-[#3A6EA5]/20"
          />
          <Button
            type="button"
            onClick={addCustomPreference}
            className="bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white rounded-xl"
          >
            <Plus className="w-4 h-4" />
          </Button>
        </div>

        {/* Default preferences */}
        <div className="space-y-3">
          {[
            'Students Welcome',
            'Professionals Only',
            'Families Welcome',
            'No Smoking',
            'Pets Allowed',
          ].map((preference) => (
            <div key={preference} className="flex items-center">
              <Checkbox
                id={preference}
                className="border-[#3A6EA5] data-[state=checked]:bg-[#3A6EA5]"
                checked={formData.tenantPreferences.includes(preference)}
                onCheckedChange={(checked) => toggleTenantPreference(preference, checked as boolean)}
              />
              <label
                htmlFor={preference}
                className="ms-3 text-[#1a1a1a] cursor-pointer"
              >
                {t(`addProperty.availabilityStep.preferences.${preference}`, { defaultValue: preference })}
              </label>
            </div>
          ))}

          {/* Custom preferences */}
          {formData.customPreferences.map((preference) => (
            <div
              key={preference}
              className="flex items-center justify-between bg-[#9CBBDC]/20 rounded-xl p-3"
            >
              <div className="flex items-center">
                <Checkbox
                  id={preference}
                  className="border-[#3A6EA5] data-[state=checked]:bg-[#3A6EA5]"
                  checked={formData.customPreferences.includes(preference)}
                  onCheckedChange={(checked) => toggleCustomPreference(preference, checked as boolean)}
                />
                <label
                  htmlFor={preference}
                  className="ms-3 text-[#1a1a1a] cursor-pointer"
                >
                  {preference}
                </label>
              </div>
              <button
                onClick={() => removeCustomPreference(preference)}
                className="text-red-500 hover:text-red-700 transition-colors"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          ))}
        </div>

        <p className="text-xs text-[#4a5565] mt-4">
          {t('addProperty.availabilityStep.addPreferenceTip')}
        </p>
      </div>

      <div className="bg-gradient-to-br from-[#9CBBDC]/40 to-[#f5f7fa] rounded-2xl p-6">
        <div className="flex items-start gap-3">
          <CheckCircle className="w-6 h-6 text-[#3A6EA5] flex-shrink-0 mt-1" />
          <div>
            <h3 className="font-semibold text-[#1a1a1a] mb-2">
              {t('addProperty.availabilityStep.reviewBeforePublishing')}
            </h3>
            <p className="text-sm text-[#4a5565]">
              {t('addProperty.availabilityStep.reviewDescription')}
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
