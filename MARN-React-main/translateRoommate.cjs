const fs = require('fs');
const file = 'c:/Coding/MARN AI/src/app/pages/profile-settings/RoommateTab.tsx';
let content = fs.readFileSync(file, 'utf8');

const replacements = [
  ["<span className=\"text-xs text-[#4a5565] shrink-0 mr-1\">Importance:</span>", "<span className=\"text-xs text-[#4a5565] shrink-0 mr-1\">{t('roommateTab.fields.importance')}</span>"],
  ["Roommate Preferences & Lifestyle", "{t('roommateTab.title')}"],
  ["Help potential roommates understand your lifestyle and\\s*compatibility.", "{t('roommateTab.subtitle')}"],
  ["Location & Search", "{t('roommateTab.sections.locationSearch')}"],
  ["label=\"Governorate\"", "label={t('roommateTab.fields.governorate')}"],
  ["label=\"Search Status\"", "label={t('roommateTab.fields.searchStatus')}"],
  ["placeholder=\"Are you actively searching\\?\"", "placeholder={t('roommateTab.fields.searchStatusPlaceholder')}"],
  ["Lifestyle & Preferences", "{t('roommateTab.sections.lifestylePreferences')}"],
  [">Smoking<", ">{t('roommateTab.fields.smoking')}<"],
  ["\\? 'Yes' : 'No'", "? t('roommateTab.fields.yes') : t('roommateTab.fields.no')"],
  [">Pets<", ">{t('roommateTab.fields.pets')}<"],
  ["Type of Pet", "{t('roommateTab.fields.petType')}"],
  ["placeholder=\"e.g., Dog, Cat, Bird\"", "placeholder={t('roommateTab.fields.petTypePlaceholder')}"],
  ["label=\"Sleep Schedule\"", "label={t('roommateTab.fields.sleepSchedule')}"],
  [">Education<", ">{t('roommateTab.sections.education')}<"],
  ["label=\"Education Level\"", "label={t('roommateTab.fields.educationLevel')}"],
  ["label=\"Field of Study \\(Optional\\)\"", "label={t('roommateTab.fields.fieldOfStudy')}"],
  ["Social & Work", "{t('roommateTab.sections.socialWork')}"],
  [">Noise Tolerance<", ">{t('roommateTab.fields.noiseTolerance')}<"],
  ["'Low'", "t('roommateTab.fields.noiseLow')"],
  ["'Medium'", "t('roommateTab.fields.noiseMedium')"],
  ["'High'", "t('roommateTab.fields.noiseHigh')"],
  [">Low<", ">{t('roommateTab.fields.noiseLow')}<"],
  [">Medium<", ">{t('roommateTab.fields.noiseMedium')}<"],
  [">High<", ">{t('roommateTab.fields.noiseHigh')}<"],
  ["label=\"Guests Frequency\"", "label={t('roommateTab.fields.guestsFrequency')}"],
  ["placeholder=\"How often do you have guests\\?\"", "placeholder={t('roommateTab.fields.guestsFrequencyPlaceholder')}"],
  ["label=\"Work Schedule\"", "label={t('roommateTab.fields.workSchedule')}"],
  ["label=\"Sharing Level\"", "label={t('roommateTab.fields.sharingLevel')}"],
  ["Budget Range", "{t('roommateTab.sections.budgetRange')}"],
  ["Minimum", "{t('roommateTab.fields.budgetMin')}"],
  ["Maximum", "{t('roommateTab.fields.budgetMax')}"],
  ["\\(per month\\)", "{t('roommateTab.fields.perMonth')}"],
  ["Visibility Settings", "{t('roommateTab.sections.visibilitySettings')}"],
  ["Profile Visibility for Roommates", "{t('roommateTab.fields.profileVisibility')}"],
  ["'Visible to users browsing for roommates.'", "t('roommateTab.fields.profileVisibilityOn')"],
  ["'Only you can see this information.'", "t('roommateTab.fields.profileVisibilityOff')"],
  ["Your roommate preferences are stored but hidden from other\\s*users. Enable visibility to help potential roommates find you.", "{t('roommateTab.visibility.hiddenNote')}"],
  ["You have unsaved changes. Don't forget to save your preferences!", "{t('roommateTab.unsavedBanner')}"],
  [">Cancel<", ">{t('roommateTab.cancel')}<"],
  ["'Saving…'", "t('roommateTab.savePreferences')"],
  ["'Save Preferences'", "t('roommateTab.savePreferences')"],
  ["toast\\.success\\('Preferences saved successfully!'\\)", "toast.success(t('roommateTab.toasts.saved'))"],
  ["err\\.message \\?\\? 'Failed to save preferences.'", "err.message ?? t('roommateTab.toasts.failed')"],
  ["toast\\.error\\('Failed to save preferences.'\\)", "toast.error(t('roommateTab.toasts.failed'))"]
];

for (let [find, replace] of replacements) {
  content = content.replace(new RegExp(find, 'g'), replace);
}

fs.writeFileSync(file, content);
console.log("Done");
