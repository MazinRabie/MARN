const fs = require('fs');
let content = fs.readFileSync('src/app/pages/PropertyDetailsPage.tsx', 'utf8');

// 1. imports
content = content.replace(
  `import { propertyService } from '@/services/propertyService'`,
  `import { propertyService } from '@/services/propertyService'\nimport { useTranslation } from 'react-i18next'`
);
content = content.replace(
  `const queryClient = useQueryClient()`,
  `const queryClient = useQueryClient()\n  const { t } = useTranslation(['properties', 'common'])`
);

// 2. locationString
content = content.replace(
  `  const isInactive = property?.status === 'inactive' || property?.isActive === false
  const canBook = isAvailable || (isShared && hasSpace && !isInactive)

  let unavailableText = 'Property Unavailable'`,
  `  const isInactive = property?.status === 'inactive' || property?.isActive === false
  const canBook = isAvailable || (isShared && hasSpace && !isInactive)

  const locationString = useMemo(() => {
    if (!property) return ''
    const parts = [property.address, property.cityDisplayName, property.governorateDisplayName].filter(Boolean)
    const uniqueParts = parts.filter((part, index, self) => 
      index === self.findIndex((p) => p?.toLowerCase() === part?.toLowerCase())
    )
    return uniqueParts.join(', ') + (property.zipCode ? \` \${property.zipCode}\` : '')
  }, [property])

  let unavailableText = 'Property Unavailable'`
);

// 3. activeRenters
content = content.replace(
  `const currentOccupantsCount = property?.currentOccupantsCount || property?.tenants?.length || 0`,
  `const currentOccupantsCount = property?.currentOccupantsCount || property?.activeRenters?.length || property?.tenants?.length || 0`
);

content = content.replace(
  `{!isLoading && property?.tenants && property.tenants.length > 0 && (`,
  `{!isLoading && (property?.activeRenters || property?.tenants) && (property?.activeRenters || property?.tenants).length > 0 && (`
);

content = content.replace(
  `{property.tenants.map(tenant => (`,
  `{(property?.activeRenters || property?.tenants).map((tenant: any) => (`
);

// 4. effectiveOwnerRating
content = content.replace(
  `const effectiveOwnerRating = hostedBy?.averageRating || property?.rating || 4.9`,
  `const effectiveOwnerRating = hostedBy?.averageRating || property?.averageRating || property?.rating || 4.9`
);

// 5. handleShare toast
content = content.replace(
  `toast.success('Link copied to clipboard!')`,
  `toast.success(t('details.linkCopied', { ns: 'properties' }))`
);

// 6. location string
content = content.replace(
  `<span>{property?.address ?? property?.location}</span>`,
  `<span>{locationString || property?.location}</span>`
);

// 7. rating in title
content = content.replace(
  `                  <div className="flex items-center gap-4 flex-wrap">
                    {property?.rating !== undefined && (
                      <>
                        <div className="flex items-center gap-1">
                          <Star className="w-5 h-5 fill-[#3A6EA5] text-[#3A6EA5]" />
                          <span className="font-semibold text-[#1a1a1a]">
                            {property.rating}
                          </span>
                          {property.reviews !== undefined && (
                            <span className="text-[#4a5565]">
                              ({property.reviews} reviews)
                            </span>
                          )}
                        </div>
                        <span className="text-[#4a5565]">•</span>
                      </>
                    )}
                    <span className="px-3 py-1 bg-[#9CBBDC]/20 rounded-full text-sm text-[#1a1a1a]">
                      {property?.type}
                    </span>
                    <span className="text-[#4a5565]">•</span>
                    <span className="text-[#1a1a1a]">
                      {(property as any)?.bedrooms ?? property?.beds} {((property as any)?.bedrooms ?? property?.beds) === 1 ? 'bed' : 'beds'} • {(property as any)?.bathrooms ?? property?.baths} {((property as any)?.bathrooms ?? property?.baths) === 1 ? 'bath' : 'baths'}
                      {property?.area ? \` • \${property.area} sq ft\` : ''}
                    </span>
                  </div>`,
  `                  <div className="flex items-center gap-4 flex-wrap">
                    {(property?.averageRating !== undefined || property?.rating !== undefined) && (
                      <>
                        <div className="flex items-center gap-1">
                          <Star className="w-5 h-5 fill-[#3A6EA5] text-[#3A6EA5]" />
                          <span className="font-semibold text-[#1a1a1a]">
                            {property?.averageRating ?? property?.rating}
                          </span>
                          {(property?.ratingsCount !== undefined || property?.reviews !== undefined) && (
                            <span className="text-[#4a5565]">
                              ({property?.ratingsCount ?? property?.reviews} reviews)
                            </span>
                          )}
                        </div>
                        <span className="text-[#4a5565]">•</span>
                      </>
                    )}
                    <span className="px-3 py-1 bg-[#9CBBDC]/20 rounded-full text-sm text-[#1a1a1a]">
                      {property?.typeDisplayName || property?.type}
                    </span>
                    <span className="text-[#4a5565]">•</span>
                    <span className="text-[#1a1a1a]">
                      {(property as any)?.bedrooms ?? property?.beds} {((property as any)?.bedrooms ?? property?.beds) === 1 ? 'bed' : 'beds'} • {(property as any)?.bathrooms ?? property?.baths} {((property as any)?.bathrooms ?? property?.baths) === 1 ? 'bath' : 'baths'}
                      {(property?.squareMeters || property?.area) ? \` • \${property?.squareMeters || property?.area} \${property?.squareMeters ? 'sqm' : 'sq ft'}\` : ''}
                    </span>
                  </div>`
);

// 8. Add dir="auto"
content = content.replace(
  `<p className="text-[#1a1a1a] leading-relaxed">\n                  {property.description}\n                </p>`,
  `<p dir="auto" className="text-[#1a1a1a] leading-relaxed">\n                  {property.description}\n                </p>`
);

content = content.replace(
  `<p className="text-[#1a1a1a] mt-4">\n                  {effectiveOwnerBio}\n                </p>`,
  `<p dir="auto" className="text-[#1a1a1a] mt-4">\n                  {effectiveOwnerBio}\n                </p>`
);

content = content.replace(
  `<p className="text-[#1a1a1a] text-sm leading-relaxed mt-2">\n                              {comment.content}\n                            </p>`,
  `<p dir="auto" className="text-[#1a1a1a] text-sm leading-relaxed mt-2">\n                              {comment.content}\n                            </p>`
);

content = content.replace(
  `<Textarea\n                    placeholder="Share your experience..."`,
  `<Textarea\n                    dir="auto"\n                    placeholder="Share your experience..."`
);

content = content.replace(
  `<Textarea\n                                className="w-full p-2 border border-gray-200 rounded-xl resize-none text-sm focus:outline-none focus:ring-1 focus:ring-[#3A6EA5]"`,
  `<Textarea\n                                dir="auto"\n                                className="w-full p-2 border border-gray-200 rounded-xl resize-none text-sm focus:outline-none focus:ring-1 focus:ring-[#3A6EA5]"`
);

// 9. Booking widget price & EGP translation
content = content.replace(
  `<span className="text-4xl font-bold text-[#3A6EA5]">
                          {property?.price?.toLocaleString()} EGP
                        </span>
                        <span className="text-[#4a5565]">/ month</span>
                      </div>
                      {property?.rating !== undefined && (
                        <div className="flex items-center gap-1 text-sm">
                          <Star className="w-4 h-4 fill-[#3A6EA5] text-[#3A6EA5]" />
                          <span className="text-[#1a1a1a]">
                            {property.rating}{' '}
                            {property.reviews !== undefined &&
                              \`(\${property.reviews} reviews)\`}
                          </span>
                        </div>
                      )}`,
  `<span className="text-4xl font-bold text-[#3A6EA5]">
                          {property?.price?.toLocaleString()} {t('egp', { ns: 'properties' }) || 'EGP'}
                        </span>
                        <span className="text-[#4a5565]">/ {property?.rentalUnitDisplayName || property?.rentalUnit || 'month'}</span>
                      </div>
                      {(property?.averageRating !== undefined || property?.rating !== undefined) && (
                        <div className="flex items-center gap-1 text-sm">
                          <Star className="w-4 h-4 fill-[#3A6EA5] text-[#3A6EA5]" />
                          <span className="text-[#1a1a1a]">
                            {property?.averageRating ?? property?.rating}{' '}
                            {(property?.ratingsCount !== undefined || property?.reviews !== undefined) &&
                              \`(\${property?.ratingsCount ?? property?.reviews} reviews)\`}
                          </span>
                        </div>
                      )}`
);

content = content.replace(
  `<span>{property?.price?.toLocaleString()} EGP</span>`,
  `<span>{property?.price?.toLocaleString()} {t('egp', { ns: 'properties' }) || 'EGP'}</span>`
);
content = content.replace(
  `<span>{property?.price?.toLocaleString()} EGP</span>`,
  `<span>{property?.price?.toLocaleString()} {t('egp', { ns: 'properties' }) || 'EGP'}</span>`
);
content = content.replace(
  ` EGP\n                        </span>`,
  ` {t('egp', { ns: 'properties' }) || 'EGP'}\n                        </span>`
);
content = content.replace(
  ` EGP\n                        </span>`,
  ` {t('egp', { ns: 'properties' }) || 'EGP'}\n                        </span>`
);

// 10. Logical alignment
content = content.replace(
  `<Button\n                              variant="outline"\n                              className="w-full justify-start text-left rounded-xl border-[#3A6EA5]/20 hover:bg-white"`,
  `<Button\n                              variant="outline"\n                              className="w-full justify-start text-start rounded-xl border-[#3A6EA5]/20 hover:bg-white"`
);

fs.writeFileSync('src/app/pages/PropertyDetailsPage.tsx', content);
