import { motion } from 'motion/react'
import { useState } from 'react'
import { useLocation, useNavigate } from 'react-router'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../components/ui/tabs'
import { ProfileTab } from './profile-settings/ProfileTab'
import { SecurityTab } from './profile-settings/SecurityTab'
import { DocumentsTab } from './profile-settings/DocumentsTab'
import { RoommateTab } from './profile-settings/RoommateTab'

import { useTranslation } from 'react-i18next'

const TAB_TRIGGER_CLASS =
  'px-6 py-2.5 rounded-full text-sm font-medium text-[#4a5565] transition-all hover:bg-white/70 hover:text-[#3A6EA5] data-[state=active]:bg-gradient-to-r data-[state=active]:from-[#3A6EA5] data-[state=active]:to-[#9CBBDC] data-[state=active]:text-white data-[state=active]:shadow-md'

const VALID_TABS = ['profile', 'security', 'documents', 'roommate']

export function ProfileSettingsPage() {
  const { t, i18n } = useTranslation('profile')
  const isRTL = i18n.dir() === 'rtl'
  const location = useLocation()
  const navigate = useNavigate()

  const hashTab = location.hash.replace('#', '')
  const [activeTab, setActiveTab] = useState(
    VALID_TABS.includes(hashTab) ? hashTab : 'profile'
  )

  const handleTabChange = (value: string) => {
    setActiveTab(value)
    navigate({ hash: value }, { replace: true })
  }

  return (
    <div className="min-h-screen py-20" dir={isRTL ? 'rtl' : 'ltr'}>
      <div className="max-w-[1440px] mx-auto px-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
            {t('title')}
          </h1>
          <p className="text-lg text-[#4a5565] mb-8">
            {t('subtitle')}
          </p>

          <Tabs value={activeTab} onValueChange={handleTabChange} className="space-y-8" dir={isRTL ? 'rtl' : 'ltr'}>
            <TabsList className="w-fit h-auto bg-[#EEF3F9] border border-[#3A6EA5]/20 p-1.5 rounded-full gap-1 shadow-md shadow-[#3A6EA5]/15">
              <TabsTrigger value="profile" className={TAB_TRIGGER_CLASS}>
                {t('tabs.profile')}
              </TabsTrigger>
              <TabsTrigger value="security" className={TAB_TRIGGER_CLASS}>
                {t('tabs.security')}
              </TabsTrigger>
              <TabsTrigger value="documents" className={TAB_TRIGGER_CLASS}>
                {t('tabs.documents')}
              </TabsTrigger>
              <TabsTrigger value="roommate" className={TAB_TRIGGER_CLASS}>
                {t('tabs.roommate')}
              </TabsTrigger>
            </TabsList>

            <TabsContent value="profile">
              <ProfileTab />
            </TabsContent>
            <TabsContent value="security">
              <SecurityTab />
            </TabsContent>
            <TabsContent value="documents">
              <DocumentsTab />
            </TabsContent>
            <TabsContent value="roommate">
              <RoommateTab />
            </TabsContent>
          </Tabs>
        </motion.div>
      </div>
    </div>
  )
}
