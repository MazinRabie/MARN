const fs = require('fs');
let content = fs.readFileSync('src/app/pages/PropertyDetailsPage.tsx', 'utf8');

content = content.replace(
  'import { usePropertyRatingSummary, usePropertyComments, useAddPropertyFeedback, useUpdatePropertyComment } from \'@/hooks/usePropertyFeedback\'',
  'import { usePropertyRatingSummary, usePropertyComments, useAddPropertyFeedback, useUpdatePropertyComment, useDeletePropertyFeedback } from \'@/hooks/usePropertyFeedback\''
);

if (!content.includes('useDeletePropertyFeedback')) {
  content = content.replace(
    'import { usePropertyRatingSummary, usePropertyComments, useUpdatePropertyComment } from \'@/hooks/usePropertyFeedback\'',
    'import { usePropertyRatingSummary, usePropertyComments, useUpdatePropertyComment, useDeletePropertyFeedback } from \'@/hooks/usePropertyFeedback\''
  );
}

if (!content.includes('Trash2')) {
  content = content.replace(
    '  MoreVertical,',
    '  MoreVertical,\n  Trash2,'
  );
}

fs.writeFileSync('src/app/pages/PropertyDetailsPage.tsx', content);
