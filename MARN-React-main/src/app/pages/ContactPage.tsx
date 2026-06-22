import { motion } from 'motion/react'
import { Mail, Phone, MapPin, Clock, Send } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Label } from '../components/ui/label'
import { Textarea } from '../components/ui/textarea'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '../components/ui/select'
import { useState } from 'react'
import { supportService } from '@/services/supportService'
import { toast } from 'sonner'
import { useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router'

export function ContactPage() {
  const { t, i18n } = useTranslation('pages')
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    phoneNumber: '',
    subject: '',
    message: '',
  })

  const contactMutation = useMutation({
    mutationFn: () => supportService.contactUs(formData),
    onSuccess: () => {
      toast.success(t('contact.toast.success'))
      setFormData({
        fullName: '',
        email: '',
        phoneNumber: '',
        subject: '',
        message: '',
      })
    },
    onError: () => toast.error(t('contact.toast.error')),
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    contactMutation.mutate()
  }

  const contactMethods = [
    {
      icon: Mail,
      title: t('contact.email'),
      details: t('contact.methods.emailDetails'),
      description: t('contact.methods.emailDesc'),
    },
    {
      icon: Phone,
      title: t('contact.phone'),
      details: t('contact.methods.phoneDetails'),
      description: t('contact.methods.phoneDesc'),
    },
    {
      icon: MapPin,
      title: t('contact.visit'),
      details: t('contact.methods.visitDetails'),
      description: t('contact.methods.visitDesc'),
    },
    {
      icon: Clock,
      title: t('contact.hours'),
      details: t('contact.methods.hoursDetails'),
      description: t('contact.methods.hoursDesc'),
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
            <h1 className="text-6xl font-bold text-[#1a1a1a] mb-6">
              {t('contact.title')}
            </h1>
            <p className="text-xl text-[#4a5565]">
              {t('contact.subtitle')}
            </p>
          </motion.div>
        </div>
      </section>

      {/* Contact Methods */}
      <section className="py-20">
        <div className="max-w-[1440px] mx-auto px-8">
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
            {contactMethods.map((method, index) => {
              const Icon = method.icon
              return (
                <motion.div
                  key={method.title}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.5, delay: index * 0.1 }}
                  className="bg-[#F2F4F6] rounded-3xl p-6 shadow-lg shadow-[#3A6EA5]/10 text-center"
                >
                  <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center mb-4 mx-auto">
                    <Icon className="w-8 h-8 text-white" />
                  </div>
                  <h3 className="font-semibold text-lg text-[#1a1a1a] mb-2">
                    {method.title}
                  </h3>
                  <p className="text-[#1a1a1a] font-medium mb-1">
                    {method.details}
                  </p>
                  <p className="text-sm text-[#4a5565]">{method.description}</p>
                </motion.div>
              )
            })}
          </div>

          {/* Contact Form & Map */}
          <div className="grid lg:grid-cols-2 gap-12">
            {/* Contact Form */}
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6 }}
            >
              <div className="bg-[#F2F4F6] rounded-3xl p-8 shadow-2xl shadow-[#3A6EA5]/20">
                <h2 className="text-3xl font-bold text-[#1a1a1a] mb-6">
                  {t('contact.sendMessage')}
                </h2>
                <form onSubmit={handleSubmit} className="space-y-6" dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}>
                  <div>
                    <Label htmlFor="name" className="text-[#1a1a1a] mb-2 block">
                      {t('contact.form.fullName')} *
                    </Label>
                    <Input
                      id="name"
                      required
                      value={formData.fullName}
                      onChange={(e) =>
                        setFormData({ ...formData, fullName: e.target.value })
                      }
                      className={`bg-white rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${i18n.language === 'ar' ? 'text-right' : 'text-left'}`}
                      placeholder={t('contact.form.fullNamePlaceholder')}
                    />
                  </div>

                  <div>
                    <Label
                      htmlFor="email"
                      className="text-[#1a1a1a] mb-2 block"
                    >
                      {t('contact.form.emailAddress')} *
                    </Label>
                    <Input
                      id="email"
                      type="email"
                      required
                      value={formData.email}
                      onChange={(e) =>
                        setFormData({ ...formData, email: e.target.value })
                      }
                      className={`bg-white rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${i18n.language === 'ar' ? 'text-right' : 'text-left'}`}
                      placeholder={t('contact.form.emailPlaceholder')}
                      dir="ltr"
                    />
                  </div>

                  <div>
                    <Label
                      htmlFor="phone"
                      className="text-[#1a1a1a] mb-2 block"
                    >
                      {t('contact.form.phoneNumber')} *
                    </Label>
                    <Input
                      id="phone"
                      type="tel"
                      required
                      value={formData.phoneNumber}
                      onChange={(e) =>
                        setFormData({ ...formData, phoneNumber: e.target.value })
                      }
                      className={`bg-white rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] ${i18n.language === 'ar' ? 'text-right' : 'text-left'}`}
                      placeholder={t('contact.form.phonePlaceholder')}
                      dir="ltr"
                    />
                  </div>

                  <div>
                    <Label
                      htmlFor="subject"
                      className="text-[#1a1a1a] mb-2 block"
                    >
                      {t('contact.form.subject')} *
                    </Label>
                    <Select
                      value={formData.subject}
                      onValueChange={(value) =>
                        setFormData({ ...formData, subject: value })
                      }
                    >
                      <SelectTrigger className={`bg-white rounded-xl border-[#3A6EA5]/20 ${i18n.language === 'ar' ? 'flex-row-reverse' : ''}`}>
                        <SelectValue placeholder={t('contact.selectSubjectPlaceholder')} />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="general">{t('contact.form.subjects.general')}</SelectItem>
                        <SelectItem value="tenant">{t('contact.form.subjects.tenantSupport')}</SelectItem>
                        <SelectItem value="owner">
                          {t('contact.form.subjects.ownerSupport')}
                        </SelectItem>
                        <SelectItem value="technical">
                          {t('contact.form.subjects.technical')}
                        </SelectItem>
                        <SelectItem value="billing">
                          {t('contact.form.subjects.billing')}
                        </SelectItem>
                        <SelectItem value="feedback">{t('contact.form.subjects.feedback')}</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <Label
                      htmlFor="message"
                      className="text-[#1a1a1a] mb-2 block"
                    >
                      {t('contact.form.message')} *
                    </Label>
                    <Textarea
                      id="message"
                      required
                      value={formData.message}
                      onChange={(e) =>
                        setFormData({ ...formData, message: e.target.value })
                      }
                      className="bg-white rounded-xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] min-h-[150px] resize-none"
                      placeholder={t('contact.form.messagePlaceholder')}
                    />
                  </div>

                  <Button
                    type="submit"
                    size="lg"
                    disabled={contactMutation.isPending}
                    className="w-full bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl shadow-lg shadow-[#3A6EA5]/30"
                  >
                    <Send className={`w-5 h-5 ${i18n.language === 'ar' ? 'ml-2 rotate-180' : 'mr-2'}`} />
                    {contactMutation.isPending ? t('common.pleaseWait', { ns: 'common' }) : t('contact.form.send')}
                  </Button>
                </form>
              </div>
            </motion.div>

            {/* Map Placeholder */}
            <motion.div
              initial={{ opacity: 0, x: 20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6 }}
            >
              <div className="bg-[#F2F4F6] rounded-3xl overflow-hidden shadow-2xl shadow-[#3A6EA5]/20 h-full min-h-[600px] flex items-center justify-center">
                <div className="text-center p-8">
                  <MapPin className="w-16 h-16 text-[#3A6EA5] mx-auto mb-4" />
                  <h3 className="text-2xl font-bold text-[#1a1a1a] mb-4">
                    {t('contact.location.title')}
                  </h3>
                  <p className="text-[#4a5565] mb-2">{t('contact.location.address1')}</p>
                  <p className="text-[#4a5565] mb-6">{t('contact.location.address2')}</p>

                </div>
              </div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* FAQ Link */}
      <section className="bg-[#F2F4F6] py-20">
        <div className="max-w-[1440px] mx-auto px-8 text-center">
          <h2 className="text-3xl font-bold text-[#1a1a1a] mb-4">
            {t('contact.faqNote.title')}
          </h2>
          <p className="text-lg text-[#4a5565] mb-8 max-w-2xl mx-auto">
            {t('contact.faqNote.fullSubtitle')}
          </p>
          <Button
            size="lg"
            variant="outline"
            className="border-2 border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white rounded-2xl px-8 py-6"
            asChild
          >
            <Link to="/faq">{t('contact.faqNote.visitFaq')}</Link>
          </Button>
        </div>
      </section>
    </div>
  )
}
