import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'
import LanguageDetector from 'i18next-browser-languagedetector'

import enCommon from '@/locales/en/common.json'
import enAuth from '@/locales/en/auth.json'
import enNavigation from '@/locales/en/navigation.json'
import enLanding from '@/locales/en/landing.json'
import enProperties from '@/locales/en/properties.json'
import enDashboard from '@/locales/en/dashboard.json'
import enProfile from '@/locales/en/profile.json'
import enMessages from '@/locales/en/messages.json'
import enAdmin from '@/locales/en/admin.json'
import enContracts from '@/locales/en/contracts.json'
import enPages from '@/locales/en/pages.json'
import enErrors from '@/locales/en/errors.json'

import arCommon from '@/locales/ar/common.json'
import arAuth from '@/locales/ar/auth.json'
import arNavigation from '@/locales/ar/navigation.json'
import arLanding from '@/locales/ar/landing.json'
import arProperties from '@/locales/ar/properties.json'
import arDashboard from '@/locales/ar/dashboard.json'
import arProfile from '@/locales/ar/profile.json'
import arMessages from '@/locales/ar/messages.json'
import arAdmin from '@/locales/ar/admin.json'
import arContracts from '@/locales/ar/contracts.json'
import arPages from '@/locales/ar/pages.json'
import arErrors from '@/locales/ar/errors.json'

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      en: {
        common: enCommon,
        auth: enAuth,
        navigation: enNavigation,
        landing: enLanding,
        properties: enProperties,
        dashboard: enDashboard,
        profile: enProfile,
        messages: enMessages,
        admin: enAdmin,
        contracts: enContracts,
        pages: enPages,
        errors: enErrors,
      },
      ar: {
        common: arCommon,
        auth: arAuth,
        navigation: arNavigation,
        landing: arLanding,
        properties: arProperties,
        dashboard: arDashboard,
        profile: arProfile,
        messages: arMessages,
        admin: arAdmin,
        contracts: arContracts,
        pages: arPages,
        errors: arErrors,
      },
    },
    lng: localStorage.getItem('i18nextLng') ?? 'en',
    fallbackLng: 'en',
    defaultNS: 'common',
    interpolation: { escapeValue: false },
    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage'],
    },
  })

i18n.on('languageChanged', (lng) => {
  document.documentElement.lang = lng
  document.documentElement.dir = lng === 'ar' ? 'rtl' : 'ltr'
})

// Apply on initial load
document.documentElement.lang = i18n.language
document.documentElement.dir = i18n.language === 'ar' ? 'rtl' : 'ltr'

export default i18n
