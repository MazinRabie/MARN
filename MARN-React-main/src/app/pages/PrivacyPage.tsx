import { motion } from 'motion/react'
import {
  Shield,
  Lock,
  Eye,
  Database,
  UserCheck,
  AlertCircle,
} from 'lucide-react'
import { useTranslation } from 'react-i18next'


export function PrivacyPage() {
  const { t, i18n } = useTranslation('pages')
  const sections = [
    {
      icon: Database,
      title: t('privacy.sections.s1.title'),
      content: t('privacy.sections.s1.content'),
    },
    {
      icon: Eye,
      title: t('privacy.sections.s2.title'),
      content: t('privacy.sections.s2.content'),
    },
    {
      icon: UserCheck,
      title: t('privacy.sections.s3.title'),
      content: t('privacy.sections.s3.content'),
    },
    {
      icon: Lock,
      title: t('privacy.sections.s4.title'),
      content: t('privacy.sections.s4.content'),
    },
    {
      title: t('privacy.sections.s5.title'),
      content: t('privacy.sections.s5.content'),
    },
    {
      title: t('privacy.sections.s6.title'),
      content: t('privacy.sections.s6.content'),
    },
    {
      title: t('privacy.sections.s7.title'),
      content: t('privacy.sections.s7.content'),
    },
    {
      title: t('privacy.sections.s8.title'),
      content: t('privacy.sections.s8.content'),
    },
    {
      title: t('privacy.sections.s9.title'),
      content: t('privacy.sections.s9.content'),
    },
    {
      title: t('privacy.sections.s10.title'),
      content: t('privacy.sections.s10.content'),
    },
    {
      title: t('privacy.sections.s11.title'),
      content: t('privacy.sections.s11.content'),
    },
    {
      title: t('privacy.sections.s12.title'),
      content: t('privacy.sections.s12.content'),
    },
    {
      title: t('privacy.sections.s13.title'),
      content: t('privacy.sections.s13.content'),
    },
    {
      title: t('privacy.sections.s14.title'),
      content: t('privacy.sections.s14.content'),
    },
    {
      title: t('privacy.sections.s15.title'),
      content: t('privacy.sections.s15.content'),
    },
  ]

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-br from-[#F2F4F6] via-[#9CBBDC]/30 to-[#9CBBDC]/50 py-20">
        <div className="max-w-[1440px] mx-auto px-8">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="text-center max-w-3xl mx-auto"
          >
            <div className="flex flex-col md:flex-row items-center justify-center gap-3 mb-6">
              <Shield className="w-12 h-12 text-[#3A6EA5]" />
              <h1 className="text-4xl md:text-6xl font-bold text-[#1a1a1a] text-center">
                {t('privacy.title')}
              </h1>
            </div>
            <p className="text-xl text-[#4a5565] mb-4">
              {t('privacy.lastUpdated')}
            </p>
            <p className="text-lg text-[#4a5565]">
              {t('privacy.intro')}
            </p>
          </motion.div>
        </div>
      </section>

      {/* Important Notice */}
      <section className="py-12 bg-[#9CBBDC]/10">
        <div className="max-w-[1440px] mx-auto px-8">
          <div className="max-w-4xl mx-auto">
            <div className="bg-white rounded-2xl p-6 shadow-lg shadow-[#3A6EA5]/10 flex flex-col md:flex-row items-start gap-4">
              <AlertCircle className="w-8 h-8 md:w-6 md:h-6 text-[#3A6EA5] flex-shrink-0 mt-1" />
              <div>
                <h3 className="font-semibold text-[#1a1a1a] mb-2">
                  {t('privacy.importantNotice.title')}
                </h3>
                <p className="text-[#4a5565]">
                  {t('privacy.importantNotice.body')}
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Privacy Content */}
      <section className="py-20">
        <div className="max-w-[1440px] mx-auto px-8">
          <div className="max-w-4xl mx-auto space-y-8">
            {sections.map((section, index) => {
              const Icon = section.icon
              return (
                <motion.div
                  key={section.title}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.5, delay: index * 0.05 }}
                  className="bg-[#F2F4F6] rounded-2xl p-8 shadow-lg shadow-[#3A6EA5]/10"
                >
                  <div className="flex flex-col md:flex-row items-start md:items-center gap-4 mb-4">
                    {Icon && (
                      <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center flex-shrink-0">
                        <Icon className="w-6 h-6 text-white" />
                      </div>
                    )}
                    <h2 className="text-xl md:text-2xl font-bold text-[#1a1a1a] mt-1 md:mt-0">
                      {section.title}
                    </h2>
                  </div>
                  <p className="text-[#4a5565] leading-relaxed whitespace-pre-line md:ml-16">
                    {section.content}
                  </p>
                </motion.div>
              )
            })}
          </div>
        </div>
      </section>

      {/* Footer CTA */}
      <section className="bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] py-16">
        <div className="max-w-[1440px] mx-auto px-8 text-center">
          <Lock className="w-12 h-12 md:w-16 md:h-16 text-white mx-auto mb-6" />
          <h2 className="text-2xl md:text-3xl font-bold text-white mb-4">
            {t('privacy.cta.title')}
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            {t('privacy.cta.subtitle')}
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <button
              onClick={() =>
                window.open(
                  'https://mail.google.com/mail/?view=cm&fs=1&to=kareemmustafafoda@gmail.com&su=Privacy%20Question',
                  '_blank'
                )
              }
              className="inline-flex items-center justify-center px-8 py-4 bg-white text-[#3A6EA5] rounded-2xl font-semibold hover:bg-white/90 transition-colors shadow-lg cursor-pointer"
            >
              {t('privacy.cta.emailPrivacy')}
            </button>
            <a
              href="/contact"
              className="inline-flex items-center justify-center px-8 py-4 border-2 border-white text-white rounded-2xl font-semibold hover:bg-white hover:text-[#3A6EA5] transition-colors"
            >
              {t('privacy.cta.contactUs')}
            </a>
          </div>
        </div>
      </section>
    </div>
  )
}
