const fs = require('fs');
let content = fs.readFileSync('src/app/pages/PropertyDetailsPage.tsx', 'utf8');
content = content.replace(`user?.role === 'Admin'`, `(user as any)?.role === 'Admin'`);
content = content.replace(`(property?.activeRenters || property?.tenants).length > 0`, `(property?.activeRenters || property?.tenants)?.length > 0`);
content = content.replace(`(property?.activeRenters || property?.tenants).map`, `(property?.activeRenters || property?.tenants)?.map`);
fs.writeFileSync('src/app/pages/PropertyDetailsPage.tsx', content);

let types = fs.readFileSync('src/types/property.ts', 'utf8');
types = types.replace(`export type PropertyStatus = 'available' | 'rented' | 'pending' | 'inactive'`, `export type PropertyStatus = 'available' | 'rented' | 'pending' | 'inactive' | 'Occupied' | 'occupied'`);
fs.writeFileSync('src/types/property.ts', types);
