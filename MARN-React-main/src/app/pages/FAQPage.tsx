import { motion } from 'motion/react'
import { useState } from 'react'
import { ChevronDown, Search, MessageCircle } from 'lucide-react'
import { Input } from '../components/ui/input'
import { Button } from '../components/ui/button'
import { Link } from 'react-router'
import { useTranslation } from 'react-i18next'

export function FAQPage() {
  const { t, i18n } = useTranslation('pages')
  const [searchQuery, setSearchQuery] = useState('')
  const [expandedId, setExpandedId] = useState<string | null>(null)

  const categories = [
    {
      name: t('faq.categories.cat1'),
      faqs: [
        { id: 'q1', question: t('faq.questions.q1.question'), answer: t('faq.questions.q1.answer') },
        { id: 'q2', question: t('faq.questions.q2.question'), answer: t('faq.questions.q2.answer') },
        { id: 'q3', question: t('faq.questions.q3.question'), answer: t('faq.questions.q3.answer') },
        { id: 'q4', question: t('faq.questions.q4.question'), answer: t('faq.questions.q4.answer') },
        { id: 'q5', question: t('faq.questions.q5.question'), answer: t('faq.questions.q5.answer') },
        { id: 'q6', question: t('faq.questions.q6.question'), answer: t('faq.questions.q6.answer') },
        { id: 'q7', question: t('faq.questions.q7.question'), answer: t('faq.questions.q7.answer') }
      ],
    },
    {
      name: t('faq.categories.cat2'),
      faqs: [
        { id: 'q8', question: t('faq.questions.q8.question'), answer: t('faq.questions.q8.answer') },
        { id: 'q9', question: t('faq.questions.q9.question'), answer: t('faq.questions.q9.answer') },
        { id: 'q10', question: t('faq.questions.q10.question'), answer: t('faq.questions.q10.answer') },
        { id: 'q11', question: t('faq.questions.q11.question'), answer: t('faq.questions.q11.answer') },
        { id: 'q12', question: t('faq.questions.q12.question'), answer: t('faq.questions.q12.answer') },
        { id: 'q13', question: t('faq.questions.q13.question'), answer: t('faq.questions.q13.answer') }
      ],
    },
    {
      name: t('faq.categories.cat3'),
      faqs: [
        { id: 'q14', question: t('faq.questions.q14.question'), answer: t('faq.questions.q14.answer') },
        { id: 'q15', question: t('faq.questions.q15.question'), answer: t('faq.questions.q15.answer') },
        { id: 'q16', question: t('faq.questions.q16.question'), answer: t('faq.questions.q16.answer') },
        { id: 'q17', question: t('faq.questions.q17.question'), answer: t('faq.questions.q17.answer') },
        { id: 'q18', question: t('faq.questions.q18.question'), answer: t('faq.questions.q18.answer') }
      ],
    },
    {
      name: t('faq.categories.cat4'),
      faqs: [
        { id: 'q19', question: t('faq.questions.q19.question'), answer: t('faq.questions.q19.answer') },
        { id: 'q20', question: t('faq.questions.q20.question'), answer: t('faq.questions.q20.answer') },
        { id: 'q21', question: t('faq.questions.q21.question'), answer: t('faq.questions.q21.answer') },
        { id: 'q22', question: t('faq.questions.q22.question'), answer: t('faq.questions.q22.answer') },
        { id: 'q23', question: t('faq.questions.q23.question'), answer: t('faq.questions.q23.answer') },
        { id: 'q24', question: t('faq.questions.q24.question'), answer: t('faq.questions.q24.answer') }
      ],
    },
    {
      name: t('faq.categories.cat5'),
      faqs: [
        { id: 'q25', question: t('faq.questions.q25.question'), answer: t('faq.questions.q25.answer') },
        { id: 'q26', question: t('faq.questions.q26.question'), answer: t('faq.questions.q26.answer') },
        { id: 'q27', question: t('faq.questions.q27.question'), answer: t('faq.questions.q27.answer') },
        { id: 'q28', question: t('faq.questions.q28.question'), answer: t('faq.questions.q28.answer') },
        { id: 'q29', question: t('faq.questions.q29.question'), answer: t('faq.questions.q29.answer') },
        { id: 'q30', question: t('faq.questions.q30.question'), answer: t('faq.questions.q30.answer') }
      ],
    },
    {
      name: t('faq.categories.cat6'),
      faqs: [
        { id: 'q31', question: t('faq.questions.q31.question'), answer: t('faq.questions.q31.answer') },
        { id: 'q32', question: t('faq.questions.q32.question'), answer: t('faq.questions.q32.answer') },
        { id: 'q33', question: t('faq.questions.q33.question'), answer: t('faq.questions.q33.answer') },
        { id: 'q34', question: t('faq.questions.q34.question'), answer: t('faq.questions.q34.answer') },
        { id: 'q35', question: t('faq.questions.q35.question'), answer: t('faq.questions.q35.answer') }
      ],
    },
    {
      name: t('faq.categories.cat7'),
      faqs: [
        { id: 'q36', question: t('faq.questions.q36.question'), answer: t('faq.questions.q36.answer') },
        { id: 'q37', question: t('faq.questions.q37.question'), answer: t('faq.questions.q37.answer') },
        { id: 'q38', question: t('faq.questions.q38.question'), answer: t('faq.questions.q38.answer') },
        { id: 'q39', question: t('faq.questions.q39.question'), answer: t('faq.questions.q39.answer') },
        { id: 'q40', question: t('faq.questions.q40.question'), answer: t('faq.questions.q40.answer') }
      ],
    },
    {
      name: t('faq.categories.cat8'),
      faqs: [
        { id: 'q41', question: t('faq.questions.q41.question'), answer: t('faq.questions.q41.answer') },
        { id: 'q42', question: t('faq.questions.q42.question'), answer: t('faq.questions.q42.answer') },
        { id: 'q43', question: t('faq.questions.q43.question'), answer: t('faq.questions.q43.answer') },
        { id: 'q44', question: t('faq.questions.q44.question'), answer: t('faq.questions.q44.answer') },
        { id: 'q45', question: t('faq.questions.q45.question'), answer: t('faq.questions.q45.answer') }
      ],
    },
    {
      name: t('faq.categories.cat9'),
      faqs: [
        { id: 'q46', question: t('faq.questions.q46.question'), answer: t('faq.questions.q46.answer') },
        { id: 'q47', question: t('faq.questions.q47.question'), answer: t('faq.questions.q47.answer') },
        { id: 'q48', question: t('faq.questions.q48.question'), answer: t('faq.questions.q48.answer') },
        { id: 'q49', question: t('faq.questions.q49.question'), answer: t('faq.questions.q49.answer') },
        { id: 'q50', question: t('faq.questions.q50.question'), answer: t('faq.questions.q50.answer') },
        { id: 'q51', question: t('faq.questions.q51.question'), answer: t('faq.questions.q51.answer') },
        { id: 'q52', question: t('faq.questions.q52.question'), answer: t('faq.questions.q52.answer') }
      ],
    },
    {
      name: t('faq.categories.cat10'),
      faqs: [
        { id: 'q53', question: t('faq.questions.q53.question'), answer: t('faq.questions.q53.answer') },
        { id: 'q54', question: t('faq.questions.q54.question'), answer: t('faq.questions.q54.answer') },
        { id: 'q55', question: t('faq.questions.q55.question'), answer: t('faq.questions.q55.answer') },
        { id: 'q56', question: t('faq.questions.q56.question'), answer: t('faq.questions.q56.answer') },
        { id: 'q57', question: t('faq.questions.q57.question'), answer: t('faq.questions.q57.answer') },
        { id: 'q58', question: t('faq.questions.q58.question'), answer: t('faq.questions.q58.answer') }
      ],
    },
    {
      name: t('faq.categories.cat11'),
      faqs: [
        { id: 'q59', question: t('faq.questions.q59.question'), answer: t('faq.questions.q59.answer') },
        { id: 'q60', question: t('faq.questions.q60.question'), answer: t('faq.questions.q60.answer') },
        { id: 'q61', question: t('faq.questions.q61.question'), answer: t('faq.questions.q61.answer') },
        { id: 'q62', question: t('faq.questions.q62.question'), answer: t('faq.questions.q62.answer') }
      ],
    },
    {
      name: t('faq.categories.cat12'),
      faqs: [
        { id: 'q63', question: t('faq.questions.q63.question'), answer: t('faq.questions.q63.answer') },
        { id: 'q64', question: t('faq.questions.q64.question'), answer: t('faq.questions.q64.answer') },
        { id: 'q65', question: t('faq.questions.q65.question'), answer: t('faq.questions.q65.answer') }
      ],
    },
    {
      name: t('faq.categories.cat13'),
      faqs: [
        { id: 'q66', question: t('faq.questions.q66.question'), answer: t('faq.questions.q66.answer') },
        { id: 'q67', question: t('faq.questions.q67.question'), answer: t('faq.questions.q67.answer') },
        { id: 'q68', question: t('faq.questions.q68.question'), answer: t('faq.questions.q68.answer') }
      ],
    },
    {
      name: t('faq.categories.cat14'),
      faqs: [
        { id: 'q69', question: t('faq.questions.q69.question'), answer: t('faq.questions.q69.answer') },
        { id: 'q70', question: t('faq.questions.q70.question'), answer: t('faq.questions.q70.answer') },
        { id: 'q71', question: t('faq.questions.q71.question'), answer: t('faq.questions.q71.answer') },
        { id: 'q72', question: t('faq.questions.q72.question'), answer: t('faq.questions.q72.answer') },
        { id: 'q73', question: t('faq.questions.q73.question'), answer: t('faq.questions.q73.answer') }
      ],
    },
    {
      name: t('faq.categories.cat15'),
      faqs: [
        { id: 'q74', question: t('faq.questions.q74.question'), answer: t('faq.questions.q74.answer') }
      ],
    }
  ]

  const filteredCategories = categories
    .map((category) => ({
      ...category,
      faqs: category.faqs.filter(
        (faq) =>
          faq.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().includes(searchQuery.toLowerCase()),
      ),
    }))
    .filter((category) => category.faqs.length > 0)

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
              {t('faq.title')}
            </h1>
            <p className="text-xl text-[#4a5565] mb-8">
              {t('faq.subtitle')}
            </p>

            {/* Search Bar */}
            <div className="relative max-w-2xl mx-auto">
              <Search className={`absolute ${i18n.language === 'ar' ? 'right-4' : 'left-4'} top-1/2 -translate-y-1/2 w-5 h-5 text-[#4a5565]`} />
              <Input
                placeholder={t('faq.searchPlaceholder')}
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className={`${i18n.language === 'ar' ? 'pr-12 pl-4' : 'pl-12 pr-4'} py-6 bg-white rounded-2xl border-[#3A6EA5]/20 focus:border-[#3A6EA5] text-lg shadow-lg`}
                dir={i18n.language === 'ar' ? 'rtl' : 'ltr'}
              />
            </div>
          </motion.div>
        </div>
      </section>

      {/* FAQ Categories */}
      <section className="py-20">
        <div className="max-w-[1440px] mx-auto px-8">
          {filteredCategories.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-xl text-[#4a5565] mb-6">
                {t('faq.noResults')} "{searchQuery}"
              </p>
              <Button
                variant="outline"
                className="rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white"
                onClick={() => setSearchQuery('')}
              >
                {t('faq.clearSearch')}
              </Button>
            </div>
          ) : (
            <div className="space-y-12">
              {filteredCategories.map((category, catIndex) => (
                <motion.div
                  key={category.name}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ duration: 0.5, delay: catIndex * 0.1 }}
                >
                  <h2 className="text-3xl font-bold text-[#1a1a1a] mb-6">
                    {category.name}
                  </h2>
                  <div className="space-y-4">
                    {category.faqs.map((faq) => (
                      <div
                        key={faq.id}
                        className="bg-[#F2F4F6] rounded-2xl shadow-lg shadow-[#3A6EA5]/10 overflow-hidden"
                      >
                        <button
                          onClick={() =>
                            setExpandedId(expandedId === faq.id ? null : faq.id)
                          }
                          className="w-full px-6 py-5 flex items-center justify-between text-left hover:bg-[#9CBBDC]/20 transition-colors"
                        >
                          <span className={`font-semibold text-lg text-[#1a1a1a] ${i18n.language === 'ar' ? 'pl-4' : 'pr-4'}`}>
                            {faq.question}
                          </span>
                          <ChevronDown
                            className={`w-6 h-6 text-[#3A6EA5] flex-shrink-0 transition-transform ${
                              expandedId === faq.id ? 'rotate-180' : ''
                            }`}
                          />
                        </button>
                        <motion.div
                          initial={false}
                          animate={{
                            height: expandedId === faq.id ? 'auto' : 0,
                            opacity: expandedId === faq.id ? 1 : 0,
                          }}
                          transition={{ duration: 0.15 }}
                          className="overflow-hidden"
                        >
                          <div className="px-6 pb-5 pt-2">
                            <p className="text-[#4a5565] leading-relaxed whitespace-pre-line">
                              {faq.answer}
                            </p>
                          </div>
                        </motion.div>
                      </div>
                    ))}
                  </div>
                </motion.div>
              ))}
            </div>
          )}
        </div>
      </section>

      {/* Still Have Questions */}
      <section className="bg-[#F2F4F6] py-20">
        <div className="max-w-[1440px] mx-auto px-8">
          <div className="bg-white rounded-3xl p-12 shadow-2xl shadow-[#3A6EA5]/20 text-center max-w-3xl mx-auto">
            <MessageCircle className="w-16 h-16 text-[#3A6EA5] mx-auto mb-6" />
            <h2 className="text-3xl font-bold text-[#1a1a1a] mb-4">
              {t('faq.stillHaveQuestions.title')}
            </h2>
            <p className="text-lg text-[#4a5565] mb-8">
              {t('faq.stillHaveQuestions.subtitle')}
            </p>
            <div className="flex gap-4 justify-center flex-wrap">
              <Button
                size="lg"
                className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-2xl px-8 py-6 shadow-lg shadow-[#3A6EA5]/30"
                asChild
              >
                <Link to="/contact">{t('faq.stillHaveQuestions.contactSupport')}</Link>
              </Button>
              <Button
                size="lg"
                variant="outline"
                className="border-2 border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white rounded-2xl px-8 py-6"
                asChild
              >
                <Link to="/messages">{t('faq.stillHaveQuestions.liveChat')}</Link>
              </Button>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}
