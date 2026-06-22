const fs = require('fs');
const file = 'c:/Coding/MARN AI/src/app/pages/profile-settings/RoommateTab.tsx';
let content = fs.readFileSync(file, 'utf8');

// Sections
content = content.replace(/t\('roommateTab\.(locationSearch|lifestylePreferences|education|socialWork|budgetRange|visibilitySettings)'\)/g, "t('roommateTab.sections.$1')");

// Fields
content = content.replace(/t\('roommateTab\.(governorate|searchStatus|searchStatusPlaceholder|smoking|pets|petType|petTypePlaceholder|sleepSchedule|educationLevel|fieldOfStudy|noiseTolerance|guestsFrequency|guestsFrequencyPlaceholder|workSchedule|sharingLevel|budgetMin|budgetMax|perMonth|profileVisibility|profileVisibilityOn|profileVisibilityOff|importance|yes|no|noiseLow|noiseMedium|noiseHigh)'\)/g, "t('roommateTab.fields.$1')");

// visibility Note
content = content.replace(/t\('roommateTab\.hiddenFromUsers'\)/g, "t('roommateTab.visibility.hiddenNote')");

// unsavedBanner
content = content.replace(/t\('roommateTab\.unsavedChanges'\)/g, "t('roommateTab.unsavedBanner')");

// savePreferences
content = content.replace(/t\('roommateTab\.saving'\)/g, "t('roommateTab.savePreferences')");

// toasts
content = content.replace(/t\('roommateTab\.preferencesSaved'\)/g, "t('roommateTab.toasts.saved')");
content = content.replace(/t\('roommateTab\.preferencesError'\)/g, "t('roommateTab.toasts.failed')");

// Specific fields mapped differently
content = content.replace(/t\('roommateTab\.minimum'\)/g, "t('roommateTab.fields.budgetMin')");
content = content.replace(/t\('roommateTab\.maximum'\)/g, "t('roommateTab.fields.budgetMax')");
content = content.replace(/t\('roommateTab\.low'\)/g, "t('roommateTab.fields.noiseLow')");
content = content.replace(/t\('roommateTab\.medium'\)/g, "t('roommateTab.fields.noiseMedium')");
content = content.replace(/t\('roommateTab\.high'\)/g, "t('roommateTab.fields.noiseHigh')");
content = content.replace(/t\('roommateTab\.onlyYouSee'\)/g, "t('roommateTab.fields.profileVisibilityOff')");
content = content.replace(/t\('roommateTab\.visibleToRoommates'\)/g, "t('roommateTab.fields.profileVisibilityOn')");

fs.writeFileSync(file, content);
console.log("Done");
