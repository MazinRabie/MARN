import { useAuth } from '@/hooks/useAuth'
import { useProfile } from '@/hooks/useProfile'
import { useRoommateMatches } from '@/hooks/useRoommateMatches'
import { motion } from 'motion/react'
import { Link, useNavigate } from 'react-router'
import { Card, CardContent } from '../components/ui/card'
import { Button } from '../components/ui/button'
import { Skeleton } from '../components/ui/skeleton'
import { Badge } from '../components/ui/badge'
import { getImageUrl } from '@/constants/assets'
import {
  Users,
  MapPin,
  MessageSquare,
  User,
  HeartHandshake,
  Search,
  CheckCircle2,
  XCircle,
  AlertCircle
} from 'lucide-react'
import { HttpError } from '@/services/httpErrors'
import { toast } from 'sonner'
import { useEffect } from 'react'
import { useTranslation } from 'react-i18next'

export function RoommateMatchingPage() {
  const { t } = useTranslation('pages')
  const { isAuthenticated } = useAuth()
  const navigate = useNavigate()

  // Always fetch profile to check roommatePreferencesEnabled
  const { data: profileRes, isLoading: profileLoading } = useProfile()
  const profile = profileRes?.data

  const isPreferencesEnabled = profile?.roommatePreferencesEnabled === true

  const {
    data: matchesRes,
    isLoading: matchesLoading,
    error: matchesError
  } = useRoommateMatches(10, isPreferencesEnabled) // Only fetch matches if preferences are enabled

  const matches = matchesRes?.data ?? []

  useEffect(() => {
    if (matchesError) {
      if (matchesError instanceof HttpError) {
        // If it's a 401, we know they aren't authenticated properly
        if (matchesError.status === 401) {
            toast.error(t('roommateMatching.errors.authRequired'))
            navigate('/login')
        } else {
            toast.error(matchesError.message || t('roommateMatching.errors.loadFailed'))
        }
      } else {
        toast.error(t('roommateMatching.errors.unexpected'))
      }
    }
  }, [matchesError, navigate])


  if (!isAuthenticated) {
    return null // ProtectedRoute should handle this, but just in case
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6 }}
      className="min-h-screen pb-20"
    >
      {/* Hero Header */}
      <div className="bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] py-16 px-8 relative overflow-hidden">
        <div className="max-w-[1440px] mx-auto relative z-10 flex flex-col items-center text-center">
          <div className="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center mb-6 backdrop-blur-md">
            <HeartHandshake className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-4">
            {t('roommateMatching.hero.title')}
          </h1>
          <p className="text-white/90 text-lg max-w-2xl">
            {t('roommateMatching.hero.subtitle')}
          </p>

          {isPreferencesEnabled && (
            <Button
              className="mt-6 bg-white text-[#3A6EA5] hover:bg-white/90 rounded-2xl font-semibold shadow-md"
              asChild
            >
                <Link to="/settings#roommate">{t('roommateMatching.hero.updatePreferences')}</Link>
            </Button>
          )}
        </div>
        
        {/* Background decorations */}
        <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
          <div className="absolute -top-24 -left-24 w-96 h-96 bg-white/10 rounded-full blur-3xl"></div>
          <div className="absolute top-1/2 right-12 w-64 h-64 bg-white/5 rounded-full blur-2xl"></div>
        </div>
      </div>

      <div className="max-w-[1440px] mx-auto px-8 mt-12">
        {profileLoading ? (
          <div className="space-y-8">
            <Skeleton className="h-[200px] w-full rounded-3xl" />
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <Skeleton className="h-[400px] w-full rounded-3xl" />
              <Skeleton className="h-[400px] w-full rounded-3xl hidden md:block" />
              <Skeleton className="h-[400px] w-full rounded-3xl hidden lg:block" />
            </div>
          </div>
        ) : !isPreferencesEnabled ? (
          // Empty State: Preferences Disabled
          <Card className="bg-white border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 max-w-3xl mx-auto overflow-hidden">
             <div className="bg-[#F2F4F6] p-12 flex flex-col items-center text-center">
                <div className="w-20 h-20 bg-white rounded-full flex items-center justify-center mb-6 shadow-sm">
                    <Users className="w-10 h-10 text-[#3A6EA5]" />
                </div>
                <h2 className="text-3xl font-bold text-[#1a1a1a] mb-4">
                    {t('roommateMatching.disabled.title')}
                </h2>
                <p className="text-[#4a5565] text-lg max-w-lg mb-8">
                    {t('roommateMatching.disabled.description')}
                </p>
                <Button
                    size="lg"
                    className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-2xl text-lg px-8 py-6 h-auto"
                    asChild
                >
                    <Link to="/settings#roommate">
                        {t('roommateMatching.disabled.cta')}
                    </Link>
                </Button>
             </div>
          </Card>
        ) : (
          // Matches Grid
          <div className="space-y-8">
            <div className="flex items-center justify-between">
                <h2 className="text-2xl font-bold text-[#1a1a1a]">{t('roommateMatching.matches.heading')}</h2>
                {!matchesLoading && (
                    <p className="text-[#4a5565]">{t('roommateMatching.matches.count', { count: matches.length })}</p>
                )}
            </div>

            {matchesLoading ? (
               <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                 {[1, 2, 3, 4, 5, 6].map((i) => (
                   <Skeleton key={i} className="h-[500px] w-full rounded-3xl" />
                 ))}
               </div>
            ) : matches.length === 0 ? (
                <Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-md p-12 text-center">
                    <div className="flex justify-center mb-6">
                        <Search className="w-16 h-16 text-[#9CBBDC]" />
                    </div>
                    <h3 className="text-2xl font-bold text-[#1a1a1a] mb-2">{t('roommateMatching.empty.title')}</h3>
                    <p className="text-[#4a5565] max-w-md mx-auto mb-6">
                        {t('roommateMatching.empty.description')}
                    </p>
                    <Button variant="outline" className="rounded-xl border-[#3A6EA5] text-[#3A6EA5]" asChild>
                        <Link to="/settings#roommate">{t('roommateMatching.empty.tweakPreferences')}</Link>
                    </Button>
                </Card>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {matches.map((match) => (
                  <Card key={match.userId} className="bg-white border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 hover:shadow-xl transition-shadow overflow-hidden flex flex-col">
                    {/* Header: Avatar & Basic Info */}
                    <div className="p-6 bg-[#F2F4F6]">
                      <div className="flex items-center gap-4">
                        <div className="relative flex-shrink-0">
                          <img
                            src={getImageUrl(match.profileImage || '') || 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=300&auto=format&fit=crop'}
                            alt={match.fullName}
                            className="w-20 h-20 rounded-full object-cover border-4 border-white shadow-sm"
                          />
                          {match.compatibilityScore != null && (
                            <div className="absolute -bottom-2 -right-2 bg-gradient-to-br from-green-500 to-emerald-400 text-white font-bold text-xs px-2 py-0.5 rounded-full shadow-md ring-2 ring-[#F2F4F6]">
                              {match.compatibilityScore}%
                            </div>
                          )}
                        </div>
                        <div>
                            <h3 className="text-xl font-bold text-[#1a1a1a] leading-tight">{match.fullName}</h3>
                            {match.governorate && (
                                <p className="text-sm text-[#4a5565] flex items-center gap-1 mt-1">
                                    <MapPin className="w-3 h-3" /> {match.governorate}
                                </p>
                            )}
                            {(match.searchStatusDisplayName || match.searchStatus) && (
                                <Badge variant="outline" className="mt-2 bg-white border-[#3A6EA5]/20 text-[#3A6EA5] text-xs font-medium">
                                    {match.searchStatusDisplayName ?? match.searchStatus}
                                </Badge>
                            )}
                        </div>
                      </div>
                      
                      {match.bio && (
                          <p className="mt-4 text-sm text-[#4a5565] line-clamp-2">
                              "{match.bio}"
                          </p>
                      )}
                    </div>

                    <CardContent className="p-6 flex-1 flex flex-col">
                      {/* Matching Traits */}
                      <div className="flex-1 overflow-y-auto pr-2 custom-scrollbar">
                        <div className="space-y-4 mb-4">
                          {/* Top Matching Traits */}
                          {match.topMatchingTraits && match.topMatchingTraits.length > 0 && (
                            <div>
                              <h4 className="text-xs font-bold text-[#1a1a1a] uppercase tracking-wider mb-2 flex items-center gap-1.5">
                                <CheckCircle2 className="w-4 h-4 text-green-500" />
                                {t('roommateMatching.matches.topMatches')}
                              </h4>
                              <ul className="space-y-1.5">
                                {match.topMatchingTraits.map((trait, idx) => {
                                  let displayTrait = trait;
                                  if (trait === 'Both Non-Smokers') displayTrait = t('roommateMatching.traits.bothNonSmokers');
                                  else if (trait.startsWith('Both prefer')) displayTrait = trait.replace('Both prefer', t('roommateMatching.traits.bothPrefer'));
                                  else if (trait.startsWith('Both ')) displayTrait = trait.replace('Both ', t('roommateMatching.traits.bothAre') + ' ');

                                  return (
                                    <li key={idx} className="text-sm text-[#4a5565] flex items-start gap-2">
                                      <span className="text-green-500 mt-1 flex-shrink-0">•</span>
                                      <span>{displayTrait}</span>
                                    </li>
                                  )
                                })}
                              </ul>
                            </div>
                          )}

                          {/* Mismatched Traits */}
                          {match.mismatchedTraits && match.mismatchedTraits.length > 0 && (
                            <div>
                              <h4 className="text-xs font-bold text-[#1a1a1a] uppercase tracking-wider mb-2 flex items-center gap-1.5">
                                <AlertCircle className="w-4 h-4 text-amber-500" />
                                {t('roommateMatching.matches.differences')}
                              </h4>
                              <ul className="space-y-1.5">
                                {match.mismatchedTraits.map((trait, idx) => (
                                  <li key={idx} className="text-sm text-[#4a5565] flex items-start gap-2">
                                    <span className="text-amber-500 mt-1 flex-shrink-0">•</span>
                                    <span>{trait}</span>
                                  </li>
                                ))}
                              </ul>
                            </div>
                          )}

                          {/* Dealbreakers */}
                          {match.dealbreakersFound && match.dealbreakersFound.length > 0 && (
                            <div>
                              <h4 className="text-xs font-bold text-[#1a1a1a] uppercase tracking-wider mb-2 flex items-center gap-1.5">
                                <XCircle className="w-4 h-4 text-red-500" />
                                {t('roommateMatching.matches.dealbreakers')}
                              </h4>
                              <ul className="space-y-1.5">
                                {match.dealbreakersFound.map((trait, idx) => (
                                  <li key={idx} className="text-sm text-red-600 font-medium flex items-start gap-2">
                                    <span className="text-red-500 mt-1 flex-shrink-0">•</span>
                                    <span>{trait}</span>
                                  </li>
                                ))}
                              </ul>
                            </div>
                          )}
                        </div>
                      </div>

                      {/* Actions */}
                      <div className="grid grid-cols-2 gap-3 mt-auto pt-4 border-t border-[#F2F4F6]">
                          <Button variant="outline" className="rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white" asChild>
                              <Link to={`/user/${match.userId}`}>
                                <User className="w-4 h-4 mr-2" /> {t('roommateMatching.matches.viewProfile')}
                              </Link>
                          </Button>
                          <Button className="rounded-xl bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white shadow-md shadow-[#3A6EA5]/20" asChild>
                             <Link to={`/messages?recipientId=${match.userId}&ownerName=${encodeURIComponent(match.fullName)}&avatarUrl=${encodeURIComponent(getImageUrl(match.profileImage || ''))}`}>
                                <MessageSquare className="w-4 h-4 mr-2" /> {t('roommateMatching.matches.message')}
                             </Link>
                          </Button>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    </motion.div>
  )
}
