const fs = require('fs');
const path = require('path');

const dir = 'c:/Coding/MARN AI/src/app/pages/profile-settings';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.tsx'));

const classReplacements = [
  { regex: /\bleft-(\d+|px|full|auto)\b/g, replace: 'start-$1' },
  { regex: /\bright-(\d+|px|full|auto)\b/g, replace: 'end-$1' },
  { regex: /\bpl-(\d+|px|auto)\b/g, replace: 'ps-$1' },
  { regex: /\bpr-(\d+|px|auto)\b/g, replace: 'pe-$1' },
  { regex: /\bml-(\d+|px|auto)\b/g, replace: 'ms-$1' },
  { regex: /\bmr-(\d+|px|auto)\b/g, replace: 'me-$1' }
];

files.forEach(file => {
  const filePath = path.join(dir, file);
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;

  classReplacements.forEach(({ regex, replace }) => {
    // Only replace inside className strings or template literals.
    // A simplified approach: just replace the tokens globally, as these are very specific tailwind tokens.
    // To be safe, let's just do global replace since things like 'pl-12' rarely appear in JS code accidentally except in classNames.
    content = content.replace(regex, replace);
  });

  if (content !== original) {
    fs.writeFileSync(filePath, content);
    console.log(`Updated ${file}`);
  }
});

console.log('Done');
