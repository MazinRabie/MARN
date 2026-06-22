# Known Bugs

Bugs found during the June 2026 regression audit. Sorted by impact.

---

## Active — breaks a user-visible feature

### 1. Profile photo upload always 404s

**File:** `src/services/userService.ts:483`
**Called by:** `src/hooks/useProfile.ts:48` → `src/app/pages/profile-settings/ProfileTab.tsx`

```ts
// current (broken)
return apiClient.post<ApiResponse<{ avatarUrl: string }>>('/Users/avatar', form)

// fix
return apiClient.post<ApiResponse<{ avatarUrl: string }>>('/api/Users/avatar', form)
```

Missing the `/api/` prefix. Every attempt to upload a profile photo returns 404 in production.

---

## Dead code — wrong URL but currently unreachable

These methods have incorrect URLs but are not called from any page or hook, so they don't affect users today. Fix them before wiring them to UI.

### 2. `rentalService.getBookingRequests` — wrong path

**File:** `src/services/rentalService.ts:7`

```ts
// current (broken)
apiClient.get('/api/Rentals/requests')

// correct controller (verify exact path in swagger)
apiClient.get('/api/BookingRequest/...')
```

`useBookingRequests()` is exported from `src/hooks/useBookingRequests.ts` but never imported by any page. Once wired to the Owner Dashboard's booking list it will 404.

### 3. `rentalService.getContracts` — wrong path

**File:** `src/services/rentalService.ts:21`

```ts
// current (broken)
apiClient.get('/api/Rentals/contracts')

// correct controller (verify exact path in swagger)
apiClient.get('/api/contracts/...')
```

`useContracts()` is exported from `src/hooks/useBookingRequests.ts` but never imported by any page.

### 4. `propertyService.updateProperty` — wrong path (shadowed by correct method)

**File:** `src/services/propertyService.ts:102-103`

```ts
// broken (never called)
updateProperty: (id, data) => apiClient.put(`/api/Property/${id}`, data)

// correct method that IS actually used (EditPropertyPage line 428)
submitPropertyEdit: (id, data) => apiClient.put(`/api/Property/edit/${id}`, data)
```

`updateProperty` is a dead duplicate of `submitPropertyEdit`. Pages correctly use `submitPropertyEdit`, but `updateProperty` sitting alongside it is a trap for anyone wiring a new edit flow.

### 5. `propertyService.deleteProperty` — wrong path

**File:** `src/services/propertyService.ts:111-112`

```ts
// broken (never called from pages)
deleteProperty: (id) => apiClient.delete(`/api/Property/${id}`)

// correct path (verify in swagger)
deleteProperty: (id) => apiClient.delete(`/api/Property/delete/${id}`)
```

Owner-side property deletion is not yet surfaced in UI. Admin deletion goes through `adminService.deleteProperty`, which is separate.

---

## Fixed (reference)

| Bug | Fixed in |
|---|---|
| Google OAuth login dropped when `MajorUpdates` branch diverged from `feat/google-auth` | commit `a373802` |
| `messageService.getConversations` called wrong URL | Fixed by `MajorUpdates` merge |
| `messageService.getMessages` called wrong URL | Fixed by `MajorUpdates` merge |
| `propertyService.createProperty` called `POST /api/Property` instead of `/api/Property/add` | Fixed by `MajorUpdates` merge |
