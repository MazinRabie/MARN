# MARN — Claude Code Context

Real-estate rental platform. React/TypeScript SPA talking to an ASP.NET Core backend.

---

## Commands

```bash
npm run dev              # start dev server
npm run build            # production build
npm run lint             # ESLint
npm run types:generate   # pull latest swagger → src/types/api.generated.ts
npm run scaffold -- --method GET --path "/api/Some/path" --name hookName
                         # generate service + hook boilerplate for a new endpoint
```

---

## Stack

| Layer | Library |
|---|---|
| Framework | React 18, TypeScript, Vite |
| Routing | React Router v7 |
| Server state | TanStack Query v5 (`useQuery` / `useMutation`) |
| HTTP | Axios via `apiClient` wrapper (`src/services/apiClient.ts`) |
| UI primitives | shadcn/ui (Radix) in `src/app/components/ui/` |
| Styling | Tailwind CSS v4 |
| Animations | `motion/react` |
| Toasts | `sonner` → `toast.success()` / `toast.error()` |
| Charts | Recharts |
| Forms | React Hook Form |

---

## Folder structure

```
src/
  app/
    components/
      ui/          # shadcn/ui primitives — do not edit
      figma/       # custom project components
    pages/         # one file per route, named *Page.tsx
  context/
    AuthProvider.tsx   # reads/writes token + user to storage
    authContext.ts     # AuthContext type
  hooks/           # TanStack Query hooks (one file per domain)
  services/        # API service objects (one file per domain)
  types/
    common.ts          # ApiResponse<T>, PaginatedResponse<T>, SearchPaginatedResponse<T>, ApiError
    api.generated.ts   # auto-generated from swagger — do not edit by hand
    property.ts / rental.ts / user.ts / message.ts
  constants/
    assets.ts          # getImageUrl(), AVATAR_PLACEHOLDER, BASE_URL
  utils/
docs/
  api-wiring-tracker.md   # which endpoints are wired (✅) vs missing (❌) vs path-mismatched (⚠️)
scripts/
  scaffold-endpoint.mjs   # boilerplate generator
```

Path alias: `@` → `src/` (e.g. `import { apiClient } from '@/services/apiClient'`)

---

## Backend

- Base URL: set in `VITE_API_BASE_URL` env var (e.g. `https://marn.runasp.net`)
- Swagger UI: `https://marn.runasp.net/swagger`
- Swagger JSON: `https://marn.runasp.net/swagger/v1/swagger.json`
- All responses are wrapped: `{ code: "SUCCESS", message: "...", data: T }`
- Use `ApiResponse<T>` from `src/types/common.ts` as the return type
- Error responses are normalized to `HttpError` by the axios interceptor — catch and read `.message`, `.errors[]`, `.validationErrors`

---

## Auth

- JWT stored in `localStorage` (remember me) or `sessionStorage` (session only) under key `"token"`
- User object stored under key `"user"` (JSON)
- `apiClient` interceptor attaches `Authorization: Bearer <token>` automatically — no manual headers needed
- `useAuth()` hook returns `{ token, user, login(), logout() }` from `AuthContext`
- 2FA flow: `/api/Account/login` returns `requiresTwoFactor: true` + a temporary token → call `/api/Account/verify-2fa` with that token as Bearer

---

## API layer pattern

Every endpoint follows this three-layer pattern:

### 1. Service function (`src/services/<domain>Service.ts`)

```ts
import { apiClient } from './apiClient'
import type { ApiResponse } from '@/types/common'
import type { components } from '@/types/api.generated'

type MyResponse = components['schemas']['SomeDtoName']

export const myService = {
  getSomething: (id: string) =>
    apiClient.get<ApiResponse<MyResponse>>(`/api/Domain/something/${id}`),

  createSomething: (payload: CreatePayload) =>
    apiClient.post<ApiResponse<MyResponse>>('/api/Domain/something', payload),
}
```

### 2. Hook (`src/hooks/use<Domain>.ts`)

```ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { myService } from '@/services/myService'
import { toast } from 'sonner'

// GET → useQuery
export function useGetSomething(id: string) {
  return useQuery({
    queryKey: ['something', id],
    queryFn: () => myService.getSomething(id),
    enabled: !!id,
  })
}

// POST/PATCH/DELETE → useMutation
export function useCreateSomething() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (payload: CreatePayload) => myService.createSomething(payload),
    onSuccess: () => {
      toast.success('Created successfully')
      queryClient.invalidateQueries({ queryKey: ['something'] })
    },
    onError: () => toast.error('Failed to create'),
  })
}
```

### 3. Page usage

```tsx
const { data, isLoading } = useGetSomething(id)
const create = useCreateSomething()

// Access data
const items = data?.data?.items ?? []

// Trigger mutation
create.mutate(payload)
```

---

## Scaffold script

Generates service + hook boilerplate from the swagger generated types:

```bash
npm run scaffold -- --method GET   --path "/api/Admin/stats/revenue"      --name adminRevenue
npm run scaffold -- --method POST  --path "/api/Payment/start-payment"    --name startPayment
npm run scaffold -- --method PATCH --path "/api/Admin/users/{userId}/ban" --name banUser
```

Output: copy-pasteable service function, hook, import lines, and a reminder to update the tracker.
After wiring: update `docs/api-wiring-tracker.md` status from `❌ Missing` → `✅ Wired`.

---

## UI conventions

### Colours (do not use arbitrary values for these)

| Token | Value | Usage |
|---|---|---|
| Primary blue | `#3A6EA5` | buttons, borders, icons, chart strokes |
| Light blue | `#9CBBDC` | gradients, secondary accents |
| Background | `#F2F4F6` | card backgrounds, input backgrounds |
| Dark text | `#1a1a1a` | headings, primary content |
| Muted text | `#4a5565` | labels, secondary content |

### Card pattern

```tsx
<Card className="bg-[#F2F4F6] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10">
  <CardHeader>
    <CardTitle className="text-xl text-[#1a1a1a]">Title</CardTitle>
  </CardHeader>
  <CardContent>...</CardContent>
</Card>
```

### Button variants in use

```tsx
// Primary action
<Button className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] text-white rounded-2xl">

// Outlined (neutral)
<Button variant="outline" className="rounded-xl border-[#3A6EA5]/20">

// Danger
<Button variant="outline" className="border-red-500 text-red-500 hover:bg-red-500 hover:text-white rounded-xl">

// Success
<Button className="bg-green-600 hover:bg-green-700 text-white rounded-xl">
```

### Loading states

Use `<Skeleton>` from `src/app/components/ui/skeleton` for all loading placeholders — never show spinners inline.

### Page entry animation

Wrap the page root in:
```tsx
<motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}>
```

### Toasts

```ts
toast.success('Human-readable success message')
toast.error('Human-readable error message')   // never expose raw server errors to users
```

---

## Image URLs

Server returns relative paths like `/images/profiles/abc.png`.
Always pass them through `getImageUrl()` from `src/constants/assets.ts` before rendering:

```ts
import { getImageUrl } from '@/constants/assets'
<img src={getImageUrl(item.imagePath)} />
```

---

## Known issues (fix before adding new features)

These services call wrong URLs — the features look wired but fail in production:

| Service | Current (wrong) | Correct |
|---|---|---|
| `rentalService.getBookingRequests` | `GET /api/Rentals/requests` | `GET /api/BookingRequest/...` |
| `rentalService.getContracts` | `GET /api/Rentals/contracts` | `GET /api/contracts/...` |
| `messageService.getConversations` | `GET /Messages/conversations` | `GET /api/Chat/users` |
| `messageService.getMessages` | `GET /Messages/conversations/${id}` | `GET /api/Chat/history/{userId}` |
| `propertyService.createProperty` | `POST /api/Property` | `POST /api/Property/add` |
| `propertyService.updateProperty` | `PUT /api/Property/${id}` | `PUT /api/Property/edit/${id}` |
| `propertyService.deleteProperty` | `DELETE /api/Property/${id}` | `DELETE /api/Property/delete/${id}` |

---

## Type generation

Types in `src/types/api.generated.ts` are auto-generated — never edit manually.

```bash
npm run types:generate
```

Reference them as:
```ts
import type { components } from '@/types/api.generated'
type MyDto = components['schemas']['MyDtoName']
```

Some endpoints have `content?: never` on their 200 response in the swagger spec (backend docs gap).
When the scaffold script warns "no schema in generated types", define the interface manually in the relevant service file and file a note in the tracker.

---

## Wiring checklist (for each new endpoint)

1. `npm run types:generate` (if backend changed)
2. `npm run scaffold -- --method X --path "..." --name Y`
3. Paste service function into the correct `src/services/<domain>Service.ts`
4. Paste hook into the correct `src/hooks/use<Domain>.ts`
5. Import and use the hook in the page component
6. Fill in `queryKey` invalidations and toast messages
7. Update `docs/api-wiring-tracker.md` → `✅ Wired`
