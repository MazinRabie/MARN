import { motion } from 'motion/react'
import { Home, Search, ArrowLeft } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Link } from 'react-router'
import { useTranslation } from 'react-i18next'

export function NotFoundPage() {
  const { t, i18n } = useTranslation('pages')
  return (
    <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC]/30 to-[#9CBBDC]/50 flex items-center justify-center px-4">
      <div className="max-w-2xl mx-auto text-center">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          {/* 404 Animation */}
          <div className="mb-8">
            <motion.h1
              initial={{ scale: 0.5, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ duration: 0.5, type: 'spring', bounce: 0.5 }}
              className="text-[180px] md:text-[240px] font-bold bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] bg-clip-text text-transparent leading-none"
            >
              {t('notFound.code')}
            </motion.h1>
          </div>

          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.3, duration: 0.6 }}
          >
            <h2 className="text-4xl md:text-5xl font-bold text-[#1a1a1a] mb-4">
              {t('notFound.title')}
            </h2>
            <p className="text-xl text-[#4a5565] mb-8 max-w-md mx-auto">
              {t('notFound.subtitle')}
            </p>
          </motion.div>

          {/* Quick Links */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5, duration: 0.6 }}
            className="flex flex-col sm:flex-row gap-4 justify-center mb-12"
          >
            <Button
              size="lg"
              className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-2xl px-8 py-6 shadow-lg shadow-[#3A6EA5]/30"
              asChild
            >
              <Link to="/">
                <Home className={`w-5 h-5 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
                {t('notFound.goHome')}
              </Link>
            </Button>
            <Button
              size="lg"
              variant="outline"
              className="border-2 border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white rounded-2xl px-8 py-6"
              asChild
            >
              <Link to="/search">
                <Search className={`w-5 h-5 ${i18n.language === 'ar' ? 'ml-2' : 'mr-2'}`} />
                {t('notFound.searchProperties')}
              </Link>
            </Button>
          </motion.div>

          {/* Popular Pages */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.7, duration: 0.6 }}
            className="bg-white/60 backdrop-blur-sm rounded-3xl p-8 shadow-lg shadow-[#3A6EA5]/10"
          >
            <h3 className="text-lg font-semibold text-[#1a1a1a] mb-4">
              {t('notFound.popularPages')}
            </h3>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {[
                { name: t('notFound.links.search'), path: '/search' },
                { name: t('notFound.links.aboutUs'), path: '/about' },
                { name: t('notFound.links.howItWorks'), path: '/how-it-works' },
                { name: t('notFound.links.contact'), path: '/contact' },
              ].map((link) => (
                <Link
                  key={link.path}
                  to={link.path}
                  className="text-[#4a5565] hover:text-[#3A6EA5] transition-colors font-medium"
                >
                  {link.name}
                </Link>
              ))}
            </div>
          </motion.div>

          {/* Back Button */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.9, duration: 0.6 }}
            className="mt-8"
          >
            <button
              onClick={() => window.history.back()}
              className="inline-flex items-center gap-2 text-[#4a5565] hover:text-[#3A6EA5] transition-colors"
            >
              <ArrowLeft className={`w-4 h-4 ${i18n.language === 'ar' ? 'rotate-180' : ''}`} />
              <span>{t('notFound.goBack')}</span>
            </button>
          </motion.div>
        </motion.div>
      </div>
    </div>
  )
}
