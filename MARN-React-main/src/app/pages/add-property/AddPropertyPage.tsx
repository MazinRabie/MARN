import { useState, useEffect } from 'react'
import { useNavigate, useSearchParams } from 'react-router'
import { useTranslation } from 'react-i18next'
import { ChevronLeft, ChevronRight, CheckCircle, RotateCcw } from 'lucide-react'
import { motion } from 'motion/react'
import { Button } from '../../components/ui/button'
import { Card, CardContent } from '../../components/ui/card'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '../../components/ui/alert-dialog'
import { toast } from 'sonner'
import { PROPERTY_STEPS as STEPS } from '@/constants/property'
import { PropertyFormData, TouchedFields } from './types'
import { validateForm } from './validation'
import { propertyService } from '@/services/propertyService'

// Import Steps
import { PropertyDetailsStep } from './steps/PropertyDetailsStep'
import { AmenitiesStep } from './steps/AmenitiesStep'
import { PhotosStep } from './steps/PhotosStep'
import { PricingStep } from './steps/PricingStep'
import { AvailabilityStep } from './steps/AvailabilityStep'
import { LegalDocsStep } from './steps/LegalDocsStep'

const DEFAULT_FORM_DATA: PropertyFormData = {
  title: '', type: '', address: '', city: '', governorate: '', zip: '',
  bedrooms: '', beds: '', baths: '', sqm: '', description: '', numPeople: '', occupancyPreference: '',
  mapLocation: { lat: 31.4403, lng: 31.6517 },
  selectedAmenities: [], additionalAmenities: [], price: '', deposit: '',
  utilities: [], availableFrom: '', leaseDuration: 'Monthly',
  tenantPreferences: ['Students Welcome', 'Professionals Only', 'Families Welcome', 'No Smoking', 'Pets Allowed'],
  customPreferences: [],
  photos: [],
  legalDocs: []
}

export function AddPropertyPage() {
  const navigate = useNavigate()
  const { t } = useTranslation('properties')
  const [searchParams, setSearchParams] = useSearchParams()
  const stepParam = parseInt(searchParams.get('step') || '1', 10)
  const currentStep = isNaN(stepParam) || stepParam < 1 ? 1 : stepParam > STEPS.length ? STEPS.length : stepParam

  const setCurrentStep = (step: number) => {
    setSearchParams(prev => {
      const newParams = new URLSearchParams(prev)
      newParams.set('step', step.toString())
      return newParams
    }, { replace: true })
  }

  const [touched, setTouched] = useState<TouchedFields>({})

  const [formData, setFormData] = useState<PropertyFormData>(() => {
    const saved = sessionStorage.getItem('addPropertyFormData')
    if (saved) {
      try {
        const parsed = JSON.parse(saved)
        // Merge with DEFAULT_FORM_DATA and reset file arrays to prevent them being loaded as stale
        return { ...DEFAULT_FORM_DATA, ...parsed, photos: [], legalDocs: [] }
      } catch (e) {
        // ignore
      }
    }
    return DEFAULT_FORM_DATA
  })

  useEffect(() => {
    const saved = sessionStorage.getItem('addPropertyFormData')
    let hasActualData = false

    if (saved) {
      try {
        const parsed = JSON.parse(saved)
        hasActualData = Object.keys(DEFAULT_FORM_DATA).some((key) => {
          if (key === 'photos' || key === 'legalDocs') return false
          const defaultVal = DEFAULT_FORM_DATA[key as keyof PropertyFormData]
          const savedVal = parsed[key]
          
          if (Array.isArray(defaultVal) || typeof defaultVal === 'object') {
            return JSON.stringify(defaultVal) !== JSON.stringify(savedVal)
          }
          return defaultVal !== savedVal
        })
      } catch (e) {
        hasActualData = false
      }
    }

    setTimeout(() => {
      if (hasActualData) {
        toast.success(t('addProperty.toasts.draftRestored'), {
          description: t('addProperty.toasts.draftRestoredDesc'),
          duration: 4000,
        })
      } else {
        toast.info(t('addProperty.toasts.pageRefreshed'), {
          duration: 2000,
        })
      }
    }, 100)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  useEffect(() => {
    try {
      // Omit large files from sessionStorage to prevent QuotaExceededError
      const { photos, legalDocs, ...dataToSave } = formData
      sessionStorage.setItem('addPropertyFormData', JSON.stringify(dataToSave))
    } catch (error) {
      console.warn('Session storage quota exceeded, form state not persisted across refresh.')
    }
  }, [formData])

  const updateFormData = (updates: Partial<PropertyFormData>) => {
    setFormData((prev) => ({ ...prev, ...updates }))
  }

  const updateTouched = (field: keyof PropertyFormData) => {
    setTouched((prev) => ({ ...prev, [field]: true }))
  }

  // mapLocation is now part of formData

  const handleNext = () => {
    if (currentStep < STEPS.length) {
      setCurrentStep(currentStep + 1)
    }
  }

  const handlePrev = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1)
    }
  }

  const handleReset = () => {
    sessionStorage.removeItem('addPropertyFormData')
    setFormData(DEFAULT_FORM_DATA)
    setTouched({})
    setCurrentStep(1)
    toast.success(t('addProperty.toasts.progressReset'))
  }

  const handleSubmit = async () => {
    const errors = validateForm(formData)

    if (errors.length > 0) {
      const newTouched = { ...touched }
      errors.forEach(err => {
        // For special fields that map to multiple inputs, we mark a proxy key as touched
        newTouched[err.field as keyof PropertyFormData] = true
        toast.error(t('addProperty.validation.fieldMissing', { step: err.step, stepName: err.stepName, label: err.label }))
      })
      setTouched(newTouched)
      setCurrentStep(errors[0].step)
      return
    }

    try {
      const apiData = new FormData()

      const mapPropertyType = (type: string) => {
        const t = type.toLowerCase()
        if (t === 'apartment') return 'Apartment'
        if (t === 'house') return 'House'
        if (t === 'room') return 'Room'
        if (t === 'bed') return 'SharedRoom'
        return 'Apartment'
      }

      const mapGovernorate = (gov: string) => {
        if (!gov) return 'CairoGovernorate'
        const g = gov.replace(/\s+/g, '')
        const valid = ['CairoGovernorate', 'GizaGovernorate', 'AlexandriaGovernorate', 'QalyubiaGovernorate', 'PortSaidGovernorate', 'SuezGovernorate', 'DakhaliaGovernorate', 'SharkiaGovernorate', 'GharbiaGovernorate', 'MonufiaGovernorate', 'BehiraGovernorate', 'KafrElSheikhGovernorate', 'DamiettaGovernorate', 'IsmailiaGovernorate', 'FaiyumGovernorate', 'BeniSuefGovernorate', 'MiniaGovernorate', 'AsyutGovernorate', 'SohagGovernorate', 'QenaGovernorate', 'LuxorGovernorate', 'AswanGovernorate', 'RedSeaGovernorate', 'NewValleyGovernorate', 'MarsaMatruhGovernorate', 'NorthSinaiGovernorate', 'SouthSinaiGovernorate']
        if (g.toLowerCase().endsWith('governorate')) {
          const match = valid.find(v => v.toLowerCase() === g.toLowerCase())
          return match || 'CairoGovernorate'
        }
        const withSuffix = g + 'Governorate'
        const match = valid.find(v => v.toLowerCase() === withSuffix.toLowerCase())
        return match || 'CairoGovernorate'
      }

      const mapAmenity = (amenity: string) => {
        const a = amenity.toLowerCase()
        const dict: Record<string, string> = {
          'wifi': 'Wifi', 'wi-fi': 'Wifi', 'parking': 'Parking', 'air conditioning': 'AirConditioning',
          'ac': 'AirConditioning', 'heating': 'Heating', 'tv': 'Tv', 'television': 'Tv',
          'elevator': 'Elevator', 'pool': 'Pool', 'swimming pool': 'Pool', 'gym': 'Gym',
          'kitchen': 'Kitchen', 'dishwasher': 'Dishwasher', 'microwave': 'Microwave',
          'refrigerator': 'Refrigerator', 'fridge': 'Refrigerator', 'washer': 'Washer',
          'dryer': 'Dryer', 'balcony': 'Balcony', 'balcony/patio': 'Balcony',
          'hardwood floors': 'HardwoodFloors', 'storage space': 'StorageSpace',
          'security system': 'SecuritySystem'
        }
        return dict[a] || null
      }

      // Basic Details
      apiData.append('Title', formData.title)
      apiData.append('Description', formData.description)
      apiData.append('Type', mapPropertyType(formData.type))
      
      const isShared = formData.occupancyPreference === 'shared' || formData.occupancyPreference === 'either'
      apiData.append('IsShared', isShared.toString())
      
      apiData.append('MaxOccupants', formData.numPeople)
      apiData.append('Bedrooms', formData.bedrooms)
      apiData.append('Beds', formData.beds)
      apiData.append('Bathrooms', formData.baths)

      // Pricing Logic
      apiData.append('Price', formData.price)
      apiData.append('RentalUnit', formData.leaseDuration || 'Monthly')

      // Location & Property Data
      apiData.append('Address', formData.address)
      apiData.append('City', formData.city)
      apiData.append('Governorate', mapGovernorate(formData.governorate))
      apiData.append('ZipCode', formData.zip)
      apiData.append('SquareMeters', formData.sqm)
      
      apiData.append('Latitude', formData.mapLocation.lat.toString())
      apiData.append('Longitude', formData.mapLocation.lng.toString())

      // Legal Docs
      if (formData.legalDocs && formData.legalDocs.length > 0) {
        const legalFile = formData.legalDocs[0].file
        if (legalFile) {
          apiData.append('ProofOfOwnership', legalFile)
        }
      }

      // Photos
      if (formData.photos && formData.photos.length > 0) {
        const primaryFile = formData.photos[0].file
        if (primaryFile) {
          apiData.append('PrimaryImage', primaryFile)
        }
      }
      
      if (formData.photos) {
        for (let i = 1; i < formData.photos.length; i++) {
          const mediaFile = formData.photos[i].file
          if (mediaFile) {
            apiData.append('MediaFiles', mediaFile)
          }
        }
      }

      // Amenities
      const allAmenities = [...(formData.selectedAmenities || []), ...(formData.additionalAmenities || []), ...(formData.utilities || [])]
      allAmenities.forEach(amenity => {
        const mapped = mapAmenity(amenity)
        if (mapped) {
          apiData.append('Amenities', mapped)
        }
      })

      // Rules
      const allRules = [...(formData.tenantPreferences || []), ...(formData.customPreferences || [])]
      allRules.forEach(rule => {
        apiData.append('Rules', rule)
      })

      await propertyService.createProperty(apiData)

      toast.success(t('addProperty.toasts.submitted'))
      sessionStorage.removeItem('addPropertyFormData') // Clear session on success
      navigate('/owner-dashboard')
    } catch (error) {
      console.error('Failed to submit property', error)
      toast.error(t('addProperty.toasts.failed'))
    }
  }

  return (
    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}>
    <div className="min-h-screen pb-20">
      <div className="max-w-[1200px] mx-auto px-8 py-8">
        {/* Header */}
        <div className="mb-8">
          <button
            onClick={() => navigate('/owner-dashboard')}
            className="flex items-center gap-2 text-[#4a5565] hover:text-[#3A6EA5] transition-colors mb-4"
          >
            <ChevronLeft className="w-5 h-5 rtl:rotate-180" />
            {t('addProperty.backToDashboard')}
          </button>
          <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
            {t('addProperty.title')}
          </h1>
          <p className="text-[#4a5565]">
            {t('addProperty.subtitle')}
          </p>
        </div>

        {/* Progress Steps */}
        <div className="mb-12">
          <div className="flex items-start relative">
            {/* Track — inset by half a column so it runs center-to-center */}
            <div
              className="absolute top-6 h-1 bg-[#dce6f0]"
              style={{
                left: `${100 / (2 * STEPS.length)}%`,
                right: `${100 / (2 * STEPS.length)}%`,
              }}
            >
              <div
                className="h-full bg-[#3A6EA5] transition-all duration-500"
                style={{
                  width: `${((currentStep - 1) / (STEPS.length - 1)) * 100}%`,
                }}
              />
            </div>

            {STEPS.map((step) => {
              const Icon = step.icon
              const isActive = step.id === currentStep
              const isCompleted = step.id < currentStep

              return (
                <div key={step.id} className="relative flex-1 flex flex-col items-center gap-2">
                  <div
                    className={`w-12 h-12 rounded-full flex items-center justify-center transition-all ${isActive
                        ? 'bg-[#3A6EA5] text-white shadow-lg shadow-[#3A6EA5]/30'
                        : isCompleted
                          ? 'bg-[#9CBBDC] text-white'
                          : 'bg-white border-2 border-[#dce6f0] text-[#4a5565]'
                      }`}
                  >
                    <Icon className="w-5 h-5" />
                  </div>
                  <span
                    className={`text-xs text-center leading-tight px-1 ${isActive
                        ? 'text-[#3A6EA5] font-semibold'
                        : 'text-[#4a5565]'
                      }`}
                  >
                    {t(`addProperty.steps.${
                      step.id === 1 ? 'details' :
                      step.id === 2 ? 'amenities' :
                      step.id === 3 ? 'photos' :
                      step.id === 4 ? 'pricing' :
                      step.id === 5 ? 'availability' :
                      'legalDocs'
                    }`)}
                  </span>
                </div>
              )
            })}
          </div>
        </div>

        {/* Form Content */}
        <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
          <CardContent className="p-8">
            {currentStep === 1 && (
              <PropertyDetailsStep
                formData={formData}
                updateFormData={updateFormData}
                touched={touched}
                updateTouched={updateTouched}
              />
            )}

            {currentStep === 2 && (
              <AmenitiesStep
                formData={formData}
                updateFormData={updateFormData}
              />
            )}

            {currentStep === 3 && (
              <PhotosStep
                formData={formData}
                updateFormData={updateFormData}
                touched={touched}
              />
            )}

            {currentStep === 4 && (
              <PricingStep
                formData={formData}
                updateFormData={updateFormData}
                touched={touched}
                updateTouched={updateTouched}
              />
            )}

            {currentStep === 5 && (
              <AvailabilityStep
                formData={formData}
                updateFormData={updateFormData}
              />
            )}

            {currentStep === 6 && (
              <LegalDocsStep
                formData={formData}
                updateFormData={updateFormData}
                touched={touched}
              />
            )}

            {/* Navigation Buttons */}
            <div className="flex items-center justify-between mt-8 pt-6 border-t border-[#3A6EA5]/20">
              <div className="flex items-center gap-4">
                <Button
                  variant="outline"
                  onClick={handlePrev}
                  disabled={currentStep === 1}
                  className="rounded-xl border-[#3A6EA5]/20 disabled:opacity-50 flex items-center gap-2"
                >
                  <ChevronLeft className="w-4 h-4 rtl:rotate-180" />
                  {t('addProperty.steps.previous')}
                </Button>

                <AlertDialog>
                  <AlertDialogTrigger asChild>
                    <Button
                      variant="ghost"
                      className="text-red-500 hover:text-red-600 hover:bg-red-50 rounded-xl flex items-center gap-2"
                    >
                      <RotateCcw className="w-4 h-4" />
                      {t('addProperty.resetProgress')}
                    </Button>
                  </AlertDialogTrigger>
                  <AlertDialogContent onCloseAutoFocus={(e) => e.preventDefault()}>
                    <AlertDialogHeader>
                      <AlertDialogTitle>{t('addProperty.resetConfirmation.title')}</AlertDialogTitle>
                      <AlertDialogDescription>
                        {t('addProperty.resetConfirmation.description')}
                      </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                      <AlertDialogCancel>{t('addProperty.resetConfirmation.cancel')}</AlertDialogCancel>
                      <AlertDialogAction onClick={handleReset} className="bg-red-500 hover:bg-red-600 text-white">
                        {t('addProperty.resetConfirmation.confirm')}
                      </AlertDialogAction>
                    </AlertDialogFooter>
                  </AlertDialogContent>
                </AlertDialog>
              </div>

              {currentStep < STEPS.length ? (
                <Button
                  onClick={handleNext}
                  className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl shadow-lg shadow-[#3A6EA5]/30 flex items-center gap-2"
                >
                  {t('addProperty.steps.next')}
                  <ChevronRight className="w-4 h-4 rtl:rotate-180" />
                </Button>
              ) : (
                <Button
                  onClick={handleSubmit}
                  className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl shadow-lg shadow-[#3A6EA5]/30 flex items-center gap-2"
                >
                  {t('addProperty.steps.submitForApproval')}
                  <CheckCircle className="w-4 h-4" />
                </Button>
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
    </motion.div>
  )
}
