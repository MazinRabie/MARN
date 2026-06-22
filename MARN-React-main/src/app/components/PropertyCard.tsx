import { Heart, MapPin, Star } from 'lucide-react'
import { useState, useEffect, useRef } from 'react'
import { motion } from 'motion/react'
import { Link } from 'react-router'
import { ImageWithFallback } from './figma/ImageWithFallback'
import { toast } from 'sonner'
import { propertyService } from '@/services/propertyService'
import { useTranslation } from 'react-i18next'
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from './ui/tooltip'

const TruncatedText = ({ text, className, as: Component = 'div' }: { text: string, className?: string, as?: any }) => {
  const textRef = useRef<HTMLElement>(null)
  const [isOverflowing, setIsOverflowing] = useState(false)

  const handleMouseEnter = () => {
    if (textRef.current) {
      setIsOverflowing(textRef.current.scrollWidth > textRef.current.clientWidth)
    }
  }

  return (
    <TooltipProvider delayDuration={1000}>
      <Tooltip delayDuration={1000}>
        <TooltipTrigger asChild>
          <Component
            ref={textRef}
            onMouseEnter={handleMouseEnter}
            className={`truncate ${className || ''}`}
          >
            {text}
          </Component>
        </TooltipTrigger>
        {isOverflowing && (
          <TooltipContent>
            <p>{text}</p>
          </TooltipContent>
        )}
      </Tooltip>
    </TooltipProvider>
  )
}

interface PropertyCardProps {
  id: string
  image: string
  title: string
  location: string
  price: number
  rating: number
  reviews: number
  type: string
  beds?: number
  baths?: number
  guests?: number
  isSaved?: boolean
  rentalUnitDisplayName?: string
  rentalUnit?: string
}

export function PropertyCard({
  id,
  image,
  title,
  location,
  price,
  rating,
  reviews,
  type,
  beds,
  baths,
  guests,
  isSaved,
  rentalUnitDisplayName,
  rentalUnit,
} : PropertyCardProps) {
  const { t, i18n } = useTranslation('properties')
  const [isFavorite, setIsFavorite] = useState(isSaved || false)

  useEffect(() => {
    setIsFavorite(isSaved || false)
  }, [isSaved])

  const handleToggleFavorite = async (e: React.MouseEvent) => {
    e.preventDefault()
    // Optimistic update
    setIsFavorite(!isFavorite)
    try {
      await propertyService.toggleSaveProperty(id)
      if (!isFavorite) {
        toast.success('Added to saved properties')
      } else {
        toast.success('Removed from saved properties')
      }
    } catch (error) {
      console.error('Failed to toggle save property', error)
      toast.error('Failed to update saved properties')
      // Revert optimistic update
      setIsFavorite(isFavorite)
    }
  }

  return (
    <motion.div
      whileHover={{ y: -8 }}
      transition={{ duration: 0.3 }}
      className="group h-full"
    >
      <Link to={`/property/${id}`} className="block h-full">
        <div className="bg-white rounded-3xl overflow-hidden shadow-lg shadow-black/10 hover:shadow-2xl hover:shadow-black/20 transition-all duration-300 h-full flex flex-col">
          {/* Image */}
          <div className="relative overflow-hidden aspect-[4/3]">
            <ImageWithFallback
              src={image}
              alt={title}
              className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
            />

            {/* Favorite Button */}
            <button
              onClick={handleToggleFavorite}
              className="absolute top-4 right-4 w-10 h-10 rounded-full bg-white/90 backdrop-blur-sm flex items-center justify-center hover:scale-110 transition-transform"
            >
              <Heart
                className={`w-5 h-5 ${
                  isFavorite
                    ? 'fill-[#3A6EA5] text-[#3A6EA5]'
                    : 'text-[#1a1a1a]'
                }`}
              />
            </button>

            {/* Property Type Badge */}
            <div className="absolute bottom-4 left-4">
              <span className="px-3 py-1 bg-white/90 backdrop-blur-sm rounded-full text-sm text-[#1a1a1a]">
                {t(`addProperty.detailsStep.types.${type?.toLowerCase()}`, { defaultValue: type })}
              </span>
            </div>
          </div>

          {/* Content */}
          <div className="p-5 flex flex-col flex-grow">
            <div className="flex items-start justify-between mb-2 gap-2">
              <TruncatedText 
                as="h3" 
                text={title} 
                className="font-semibold text-lg text-[#1a1a1a] text-left flex-1" 
              />
              <div className="flex items-center gap-1 flex-shrink-0 mt-0.5">
                <Star className="w-4 h-4 fill-[#3A6EA5] text-[#3A6EA5]" />
                <span className="text-sm font-medium text-[#1a1a1a]">
                  {Math.round(rating * 10) / 10}
                </span>
                <span className="text-sm text-[#6a7282]">({reviews})</span>
              </div>
            </div>

            <div className="flex items-start gap-1 mb-3">
              <MapPin className="w-4 h-4 text-[#3A6EA5] shrink-0 mt-0.5" />
              <TruncatedText 
                as="span" 
                text={location} 
                className="text-sm text-[#4a5565] text-left" 
              />
            </div>

            <div className="mt-auto">

            {beds !== undefined && baths !== undefined && (
              <div className="flex items-center flex-wrap gap-2 mb-3 text-sm text-[#4a5565]">
                <span className="whitespace-nowrap">{t('card.beds', { count: beds })}</span>
                <span>•</span>
                <span className="whitespace-nowrap">{t('card.baths', { count: baths })}</span>
                {guests !== undefined && (
                  <>
                    <span>•</span>
                    <span className="whitespace-nowrap">{t('card.guests', { count: guests })}</span>
                  </>
                )}
              </div>
            )}

              <div className="flex items-baseline gap-1 flex-wrap" dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}>
                <span className="text-2xl font-bold text-[#3A6EA5] whitespace-nowrap">
                  {i18n.language === 'ar' 
                    ? `${price.toLocaleString(undefined, { maximumFractionDigits: 1 })} ${t('currency', { ns: 'common' })}` 
                    : `${t('currency', { ns: 'common' })} ${price.toLocaleString(undefined, { maximumFractionDigits: 1 })}`}
                </span>
                <span className="text-[#6a7282] whitespace-nowrap">
                  / {rentalUnit 
                      ? t(`addProperty.availabilityStep.${rentalUnit.toLowerCase()}`, { defaultValue: rentalUnitDisplayName || t('card.perMonth') }) 
                      : (rentalUnitDisplayName ? rentalUnitDisplayName : t('card.perMonth'))}
                </span>
              </div>
            </div>
          </div>
        </div>
      </Link>
    </motion.div>
  )
}
