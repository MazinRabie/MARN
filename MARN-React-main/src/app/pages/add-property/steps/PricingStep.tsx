import { useState, useEffect } from 'react'
import { DollarSign, HelpCircle } from 'lucide-react'
import { Label } from '../../../components/ui/label'
import { Input } from '../../../components/ui/input'
import { Checkbox } from '../../../components/ui/checkbox'
import { PropertyFormData, TouchedFields } from '../types'
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '../../../components/ui/tooltip'
import { useTranslation } from 'react-i18next'

interface PricingStepProps {
  formData: PropertyFormData
  updateFormData: (updates: Partial<PropertyFormData>) => void
  touched: TouchedFields
  updateTouched: (field: keyof PropertyFormData) => void
}

export function PricingStep({ formData, updateFormData, touched, updateTouched }: PricingStepProps) {
  const { t } = useTranslation('properties')
  const [localPrice, setLocalPrice] = useState(formData.price)
  const [localDeposit, setLocalDeposit] = useState(formData.deposit)

  useEffect(() => {
    setLocalPrice(formData.price)
    setLocalDeposit(formData.deposit)
  }, [formData])

  const toggleUtility = (utility: string, checked: boolean) => {
    const isSelected = formData.utilities.includes(utility)
    let newUtilities = formData.utilities
    if (checked && !isSelected) {
      newUtilities = [...formData.utilities, utility]
    } else if (!checked && isSelected) {
      newUtilities = formData.utilities.filter(u => u !== utility)
    }
    updateFormData({ utilities: newUtilities })
  }

  // To highlight if the rent input is missing and user touched the "price" proxy
  const hasRent = !!formData.price?.trim()
  const isRentError = touched.price && !hasRent
  const rentInputClass = `pl-12 rounded-xl ${isRentError ? 'border-red-500 bg-red-50' : 'border-[#3A6EA5]/20 bg-white'}`

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-6">
        {t('addProperty.pricingStep.title')}
      </h2>

      <div className="bg-white rounded-2xl p-6 space-y-6">
        <div className="flex items-center gap-2 mb-4">
          <h3 className="font-semibold text-[#1a1a1a] mb-0">
            {t('addProperty.pricingStep.rentalPricing')} <span className="text-red-500">*</span>
          </h3>
          <TooltipProvider>
            <Tooltip>
              <TooltipTrigger asChild>
                <HelpCircle className="w-4 h-4 text-[#4a5565] cursor-pointer hover:text-[#3A6EA5] transition-colors" />
              </TooltipTrigger>
              <TooltipContent className="max-w-75">
                <p>{t('addProperty.pricingStep.tooltipText')}</p>
              </TooltipContent>
            </Tooltip>
          </TooltipProvider>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <Label
              htmlFor="price"
              className="text-[#1a1a1a] mb-2 block"
            >
              {t('addProperty.pricingStep.rentPrice')}
            </Label>
            <div className="relative">
              <DollarSign className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]" />
              <Input
                id="price"
                type="number"
                placeholder={t('addProperty.pricingStep.pricePlaceholder', { defaultValue: '2800' })}
                className={rentInputClass}
                value={localPrice}
                onChange={(e) => setLocalPrice(e.target.value)}
                onBlur={() => {
                  updateFormData({ price: localPrice })
                  updateTouched('price' as any)
                }}
              />
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <Label
            htmlFor="deposit"
            className="text-[#1a1a1a] mb-2 block"
          >
            {t('addProperty.pricingStep.securityDeposit')}
          </Label>
          <div className="relative">
            <DollarSign className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]" />
            <Input
              id="deposit"
              type="number"
              placeholder={t('addProperty.pricingStep.pricePlaceholder', { defaultValue: '2800' })}
              className="pl-12 rounded-xl bg-white border-[#3A6EA5]/20"
              value={localDeposit}
              onChange={(e) => setLocalDeposit(e.target.value)}
              onBlur={() => {
                updateFormData({ deposit: localDeposit })
                updateTouched('deposit' as any)
              }}
            />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-2xl p-6">
        <h3 className="font-semibold text-[#1a1a1a] mb-4">
          {t('addProperty.pricingStep.utilitiesIncluded')}
        </h3>
        <div className="grid grid-cols-2 gap-3">
          {[
            'Water',
            'Electricity',
            'Gas',
            'Internet',
            'Trash',
            'Parking',
          ].map((utility) => (
            <div key={utility} className="flex items-center">
              <Checkbox
                id={utility}
                className="border-[#3A6EA5] data-[state=checked]:bg-[#3A6EA5]"
                checked={formData.utilities.includes(utility)}
                onCheckedChange={(checked) => toggleUtility(utility, checked as boolean)}
              />
              <label
                htmlFor={utility}
                className="ms-3 text-[#1a1a1a] cursor-pointer"
              >
                {t(`addProperty.pricingStep.utilities.${utility}`)}
              </label>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
