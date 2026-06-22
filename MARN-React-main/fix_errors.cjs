const fs = require('fs');

// Fix JSX error
let content = fs.readFileSync('src/app/pages/PropertyDetailsPage.tsx', 'utf8');
content = content.replace('                  </div>    </div>', '                  </div>');
fs.writeFileSync('src/app/pages/PropertyDetailsPage.tsx', content);

// Fix types
let types = fs.readFileSync('src/types/property.ts', 'utf8');
types = types.replace(
  `export type RentalUnit = 'Daily' | 'Monthly' | 'Yearly'`,
  `export type RentalUnit = 'Daily' | 'Monthly' | 'Quarterly' | 'Yearly'`
);
types = types.replace(
  `  amenities: string[]`,
  `  amenities: any[]`
);
types = types.replace(
  `  tenants?: Array<{
    id: string
    fullName: string
    profileImage?: string
  }>`,
  `  tenants?: Array<{
    id: string
    fullName: string
    profileImage?: string
  }>
  averageRating?: number
  cityDisplayName?: string
  governorateDisplayName?: string
  zipCode?: string
  ratingsCount?: number
  typeDisplayName?: string
  rentalUnitDisplayName?: string
  isActive?: boolean
  availability?: boolean
  bedrooms?: number
  bathrooms?: number
  activeRenters?: Array<{ id: string, name: string, profilePhoto?: string, matchingPercentage?: number }>
  hostedBy?: { id: string, fullName: string, profileImage: string, averageRating: number, propertiesCount: number, bio: string }
  rules?: any[]`
);

fs.writeFileSync('src/types/property.ts', types);
