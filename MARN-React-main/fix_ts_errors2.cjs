const fs = require('fs');
let content = fs.readFileSync('src/app/pages/PropertyDetailsPage.tsx', 'utf8');

// Replace all length checks
content = content.replaceAll(`(property?.activeRenters || property?.tenants)?.length > 0`, `((property?.activeRenters || property?.tenants)?.length ?? 0) > 0`);
content = content.replaceAll(`(property?.activeRenters || property?.tenants)?.length! > 0`, `((property?.activeRenters || property?.tenants)?.length ?? 0) > 0`);
content = content.replaceAll(`(property?.activeRenters || property?.tenants).length > 0`, `((property?.activeRenters || property?.tenants)?.length ?? 0) > 0`);

// Replace the status overlap check
content = content.replace(`const isOccupied = property?.status === 'rented' || property?.status === 'Occupied' || property?.status === 'occupied'`, `const isOccupied = property?.status === 'rented' || (property?.status as any) === 'Occupied' || (property?.status as any) === 'occupied'`);

fs.writeFileSync('src/app/pages/PropertyDetailsPage.tsx', content);
