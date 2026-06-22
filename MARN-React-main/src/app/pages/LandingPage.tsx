import {
  Search,
  MapPin,
  Shield,
  Users,
  CheckCircle,
  Star,
  ArrowRight,
} from 'lucide-react'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { PropertyCard } from '../components/PropertyCard'
import { motion } from 'motion/react'
import { Link, useNavigate } from 'react-router'
import { useRecommendations } from '@/hooks/useProperties'
import { getImageUrl } from '@/constants/assets'
import { Skeleton } from '../components/ui/skeleton'
import { useTranslation } from 'react-i18next'
import { ImageWithFallback } from '../components/figma/ImageWithFallback'

const FEATURED_PROPERTIES = [
  {
    id: '1',
    image: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
    title: 'Modern Downtown Apartment',
    location: 'New Damietta, Egypt',
    price: 12500,
    rating: 4.9,
    reviews: 124,
    type: 'Apartment',
    beds: 2,
    baths: 2,
    guests: 4,
  },
  {
    id: '2',
    image: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
    title: 'Cozy Apartment in Zamalek',
    location: 'New Damietta, Egypt',
    price: 8500,
    rating: 4.8,
    reviews: 89,
    type: 'Apartment',
    beds: 1,
    baths: 1,
    guests: 2,
  },
  {
    id: '3',
    image: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
    title: 'Luxury House in New Cairo',
    location: 'New Damietta, Egypt',
    price: 35000,
    rating: 5.0,
    reviews: 156,
    type: 'House',
    beds: 4,
    baths: 3,
    guests: 8,
  },
  {
    id: '4',
    image: 'https://images.unsplash.com/photo-1515263487990-61b07816b324?w=800',
    title: 'Penthouse with Nile View',
    location: 'New Damietta, Egypt',
    price: 28000,
    rating: 4.9,
    reviews: 203,
    type: 'Penthouse',
    beds: 3,
    baths: 3,
    guests: 6,
  },
]

const BENEFITS = [
  {
    icon: Shield,
    key: 'securePayments',
  },
  {
    icon: CheckCircle,
    key: 'verifiedListings',
  },
  {
    icon: Users,
    key: 'roommateMatching',
  },
]

const TESTIMONIALS = [
  {
    name: 'Fatima Hassan',
    roleKey: 'tenant',
    image: 'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?w=200&fit=crop',
    rating: 5,
    text: 'MARN made finding my dream apartment so easy! The process was seamless and the support team was incredibly helpful.',
  },
  {
    name: 'Ahmed Youssef',
    roleKey: 'propertyOwner',
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop',
    rating: 5,
    text: 'As a landlord, MARN has been a game-changer. I get quality tenants and the platform handles everything smoothly.',
  },
  {
    name: 'Laila Mahmoud',
    roleKey: 'roommateSeeker',
    image: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&fit=crop',
    rating: 5,
    text: 'The roommate matching feature is brilliant! I found the perfect roommate who shares my lifestyle and interests.',
  },
]

export function LandingPage() {
  const { t, i18n } = useTranslation('landing')
  const navigate = useNavigate()
  const { data, isLoading } = useRecommendations()
  const rawProperties = data?.data?.items ?? []

  // Deduplicate properties (fix for backend join bug returning duplicates for saved properties)
  const propertiesMap = new Map()
  rawProperties.forEach(p => {
    if (!propertiesMap.has(p.id) || p.isSaved) {
      propertiesMap.set(p.id, p)
    }
  })
  const properties = Array.from(propertiesMap.values()).slice(0, 4)

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-[#F2F4F6]">
        <div className="relative max-w-[1440px] mx-auto px-8 py-24">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="text-center max-w-4xl mx-auto"
          >
            <h1 className="text-6xl font-bold text-[#1a1a1a] mb-6 leading-[1.2]">
              <span className="block pb-2">{t('hero.title')}</span>
              <span className="block bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] bg-clip-text text-transparent pb-3">
                {t('hero.titleHighlight')}
              </span>
            </h1>
            <p className="text-xl text-[#4a5565] mb-12 max-w-2xl mx-auto">
              {t('hero.subtitle')}
            </p>

            {/* Search Bar */}
            <div className="bg-white rounded-3xl shadow-2xl shadow-[#3A6EA5]/20 p-3 max-w-3xl mx-auto border border-[#3A6EA5]/10">
              <form
                className="flex flex-col md:flex-row gap-3"
                onSubmit={(e) => {
                  e.preventDefault()
                  const formData = new FormData(e.currentTarget)
                  const q = formData.get('q')
                  if (q) {
                    navigate(`/search?q=${encodeURIComponent(q.toString())}`)
                  } else {
                    navigate('/search')
                  }
                }}
              >
                <div className="flex-1 relative">
                  <MapPin className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#6a7282]`} />
                  <Input
                    name="q"
                    placeholder={t('hero.locationPlaceholder')}
                    className={`${i18n.language === 'ar' ? 'pr-12 pl-4' : 'pl-12 pr-4'} h-14 bg-[#f8f9fb] rounded-2xl border-none focus:bg-white text-base md:text-lg`}
                  />
                </div>
                <Button
                  type="submit"
                  size="lg"
                  className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-2xl px-8 py-6 shadow-lg shadow-[#3A6EA5]/30"
                >
                  <Search className={`w-5 h-5 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
                  {t('hero.searchButton')}
                </Button>
              </form>
            </div>

            {/* Quick Stats */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-16">
              {[
                { label: t('hero.stats.activeListings'), value: '10,000+' },
                { label: t('hero.stats.happyTenants'), value: '50,000+' },
                { label: t('hero.stats.citiesCovered'), value: '100+' },
              ].map((stat, index) => (
                <motion.div
                  key={stat.label}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.6, delay: 0.2 + index * 0.1 }}
                  className="text-center"
                >
                  <div className="text-4xl font-bold text-[#3A6EA5] mb-2">
                    {stat.value}
                  </div>
                  <div className="text-[#4a5565]">{stat.label}</div>
                </motion.div>
              ))}
            </div>
          </motion.div>
        </div>
      </section>

      {/* Featured Properties */}
      <section className="max-w-[1440px] mx-auto px-8 py-20">
        <div className="text-center mb-12">
          <h2 className="text-4xl font-bold text-[#1a1a1a] mb-4">
            {t('featured.title')}
          </h2>
          <p className="text-lg text-[#4a5565] max-w-2xl mx-auto">
            {t('featured.subtitle')}
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {isLoading ? (
            Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="bg-white rounded-3xl overflow-hidden shadow-lg shadow-black/10 border border-[#3A6EA5]/10">
                <Skeleton className="aspect-[4/3] w-full" />
                <div className="p-5 space-y-3">
                  <Skeleton className="h-5 w-3/4" />
                  <Skeleton className="h-4 w-1/2" />
                  <Skeleton className="h-6 w-1/3" />
                </div>
              </div>
            ))
          ) : properties.length > 0 ? (
            properties.map((property, index) => (
              <motion.div
                key={property.id}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
              >
                <PropertyCard
                  id={String(property.id)}
                  image={getImageUrl(property.imagePath)}
                  title={property.title}
                  location={property.address}
                  price={property.price}
                  rating={property.averageRating}
                  reviews={property.ratings}
                  type={property.type}
                  beds={property.bedrooms}
                  baths={property.bathrooms}
                  guests={property.maxOccupants}
                  isSaved={property.isSaved}
                  rentalUnitDisplayName={property.rentalUnitDisplayName}
                  rentalUnit={property.rentalUnit}
                />
              </motion.div>
            ))
          ) : (
            FEATURED_PROPERTIES.map((property, index) => (
              <motion.div
                key={property.id}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
              >
                <div className="pointer-events-none">
                  <PropertyCard {...property} />
                </div>
              </motion.div>
            ))
          )}
        </div>

        <div className="text-center">
          <Button
            variant="outline"
            size="lg"
            className="rounded-2xl border-[#9CBBDC] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white hover:border-[#3A6EA5]"
            asChild
          >
            <Link to="/search" className="flex items-center">
              {t('featured.viewAll')}
              <ArrowRight className={`w-4 h-4 ${i18n.language === 'ar' ? 'mr-2 rotate-180' : 'ml-2'}`} />
            </Link>
          </Button>
        </div>
      </section>

      {/* Platform Benefits */}
      <section className="bg-[#f5f7fa] py-20">
        <div className="max-w-[1440px] mx-auto px-8">
          <div className="text-center mb-12">
            <h2 className="text-4xl font-bold text-[#1a1a1a] mb-4">
              {t('benefits.title')}
            </h2>
            <p className="text-lg text-[#4a5565] max-w-2xl mx-auto">
              {t('benefits.subtitle')}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {BENEFITS.map((benefit, index) => {
              const Icon = benefit.icon
              return (
                <motion.div
                  key={benefit.key}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.5, delay: index * 0.1 }}
                  className="bg-white rounded-3xl p-8 shadow-lg shadow-black/5 hover:shadow-2xl hover:shadow-black/10 transition-all"
                >
                  <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center mb-6">
                    <Icon className="w-8 h-8 text-white" />
                  </div>
                  <h3 className="text-2xl font-semibold text-[#1a1a1a] mb-3">
                    {t(`benefits.${benefit.key}.title`)}
                  </h3>
                  <p className="text-[#4a5565]">{t(`benefits.${benefit.key}.description`)}</p>
                </motion.div>
              )
            })}
          </div>
        </div>
      </section>

      {/* Testimonials */}
      <section className="max-w-[1440px] mx-auto px-8 py-20">
        <div className="text-center mb-12">
          <h2 className="text-4xl font-bold text-[#1a1a1a] mb-4">
            {t('testimonials.title')}
          </h2>
          <p className="text-lg text-[#4a5565] max-w-2xl mx-auto">
            {t('testimonials.subtitle')}
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {TESTIMONIALS.map((testimonial, index) => (
            <motion.div
              key={testimonial.name}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className="bg-white rounded-3xl p-8 shadow-lg shadow-black/5 border border-[#3A6EA5]/10"
            >
              <div className="flex items-center gap-1 mb-4">
                {[...Array(testimonial.rating)].map((_, i) => (
                  <Star
                    key={i}
                    className="w-5 h-5 fill-[#3A6EA5] text-[#3A6EA5]"
                  />
                ))}
              </div>
              <p className="text-[#364153] mb-6 leading-relaxed" dir="ltr">
                "{testimonial.text}"
              </p>
              <div className="flex items-center gap-3">
                <ImageWithFallback
                  src={testimonial.image}
                  alt={testimonial.name}
                  className="w-12 h-12 rounded-full object-cover"
                />
                <div>
                  <div className="font-semibold text-[#1a1a1a]">
                    {testimonial.name}
                  </div>
                  <div className="text-sm text-[#3A6EA5]">
                    {t(`testimonials.roles.${testimonial.roleKey}`)}
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] py-20">
        <div className="max-w-[1440px] mx-auto px-8 text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
          >
            <h2 className="text-4xl font-bold text-white mb-6">
              {t('cta.title')}
            </h2>
            <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
              {t('cta.subtitle')}
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button
                size="lg"
                className="bg-white text-[#3A6EA5] hover:bg-white/90 rounded-2xl px-8 py-6 shadow-lg"
                asChild
              >
                <Link to="/search">{t('cta.browseProperties')}</Link>
              </Button>
              <Button
                size="lg"
                className="bg-[#1e3a5f] text-white hover:bg-[#13253c] shadow-lg shadow-[#1e3a5f]/20 rounded-2xl px-8 py-6"
                asChild
              >
                <Link to="/owner-dashboard">{t('cta.listYourProperty')}</Link>
              </Button>
            </div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
