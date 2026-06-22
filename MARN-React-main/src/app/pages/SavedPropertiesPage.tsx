import { motion } from 'motion/react'
import { Heart, Search, Loader2 } from 'lucide-react'
import { Link } from 'react-router'
import { useRenterDashboard } from '@/hooks/useRenterDashboard'
import { getImageUrl } from '@/constants/assets'
import { PropertyCard } from '../components/PropertyCard'
import { Button } from '../components/ui/button'
import { useTranslation } from 'react-i18next'

export function SavedPropertiesPage() {
  const { t } = useTranslation('properties')
  const { data: dashboardRes, isLoading } = useRenterDashboard()

  const savedProperties = dashboardRes?.data?.savedProperties ?? []

  return (
    <div className="min-h-screen py-12 md:py-20">
      <div className="max-w-[1440px] mx-auto px-4 md:px-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <div className="flex flex-col md:flex-row md:items-end justify-between mb-8 gap-4">
            <div>
              <h1 className="text-4xl font-bold text-[#1a1a1a] flex items-center gap-3">
                <Heart className="w-8 h-8 text-[#3A6EA5] fill-[#3A6EA5]" />
                {t('savedProperties.title')}
              </h1>
              <p className="text-lg text-[#4a5565] mt-2">
                {t('savedProperties.subtitle')}
              </p>
            </div>

            {savedProperties.length > 0 && (
              <p className="text-[#6a7282] font-medium bg-white px-4 py-2 rounded-xl shadow-sm border border-gray-100">
                {savedProperties.length === 1 ? t('savedProperties.savedCount_one', { count: savedProperties.length }) : t('savedProperties.savedCount_other', { count: savedProperties.length })}
              </p>
            )}
          </div>

          {isLoading ? (
            <div className="flex flex-col items-center justify-center py-32">
              <Loader2 className="w-10 h-10 text-[#3A6EA5] animate-spin mb-4" />
              <p className="text-[#4a5565]">{t('savedProperties.loading')}</p>
            </div>
          ) : savedProperties.length === 0 ? (
            <div className="bg-white rounded-3xl p-12 text-center shadow-sm border border-gray-100 mt-8">
              <div className="w-20 h-20 bg-[#f5f7fa] rounded-full flex items-center justify-center mx-auto mb-6">
                <Heart className="w-10 h-10 text-[#6a7282]" />
              </div>
              <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-3">
                {t('savedProperties.noSaved')}
              </h2>
              <p className="text-[#4a5565] max-w-md mx-auto mb-8">
                {t('savedProperties.noSavedDesc')}
              </p>
              <Button
                asChild
                className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl px-8"
              >
                <Link to="/search" className="flex items-center gap-2">
                  <Search className="w-4 h-4" />
                  {t('savedProperties.explore')}
                </Link>
              </Button>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {savedProperties.map((property) => (
                <PropertyCard
                  key={property.id}
                  id={String((property as any).propertyId || property.id)}
                  image={getImageUrl(property.imageUrl || property.imagePath || property.image || property.images?.[0] || '')}
                  title={property.title}
                  location={(property as any).address || property.location}
                  price={property.price}
                  rating={(property as any).averageRating || (property as any).rating || 0}
                  reviews={(property as any).ratings || (property as any).reviews || 0}
                  type={(property as any).type || 'Rental'}
                  beds={(property as any).bedrooms || (property as any).beds}
                  baths={(property as any).bathrooms || (property as any).baths}
                  guests={(property as any).maxOccupants || (property as any).guests}
                  isSaved={true}
                  rentalUnitDisplayName={(property as any).rentalUnitDisplayName}
                  rentalUnit={(property as any).rentalUnit}
                />
              ))}
            </div>
          )}
        </motion.div>
      </div>
    </div>
  )
}
