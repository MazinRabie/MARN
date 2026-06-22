import type { User, UserRole } from '@/types/user'

const CLAIM_ID =
  'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'
const CLAIM_EMAIL =
  'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'
const CLAIM_ROLE =
  'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'
const CLAIM_GIVEN_NAME =
  'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname'
const CLAIM_SURNAME =
  'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname'

// ASP.NET Identity returns role as a plain string when there is one role, or
// as a string[] when the user has multiple roles. Handle both shapes.
function pickRole(raw: string | string[] | undefined): UserRole {
  const roles = Array.isArray(raw)
    ? raw.map((r) => r.toLowerCase())
    : typeof raw === 'string'
      ? [raw.toLowerCase()]
      : []

  // Priority: admin > owner > tenant (server calls it "renter")
  if (roles.includes('admin')) return 'admin'
  if (roles.includes('owner')) return 'owner'
  return 'tenant'
}

function extractRoles(raw: string | string[] | undefined): UserRole[] {
  const roles = Array.isArray(raw)
    ? raw.map((r) => r.toLowerCase())
    : typeof raw === 'string'
      ? [raw.toLowerCase()]
      : []

  const valid: UserRole[] = []
  if (roles.includes('admin')) valid.push('admin')
  if (roles.includes('owner')) valid.push('owner')
  if (roles.includes('tenant') || roles.includes('renter')) valid.push('tenant')
  
  return valid.length > 0 ? valid : ['tenant']
}

export function decodeUserFromToken(token: string): User {
  const payloadB64 = token.split('.')[1]
  const rawPayload = atob(payloadB64)
  const payload = JSON.parse(rawPayload) as Record<
    string,
    string | string[]
  >

  // JSON.parse ignores duplicate keys. ASP.NET often serializes multiple roles as duplicate identical claims.
  // We use regex to extract all occurrences of the role claim from the raw JSON string.
  const rawRoles: string[] = []
  
  // Also collect what JSON.parse found (useful if it's already an array)
  const parsedRole = payload[CLAIM_ROLE] || payload['role'] || payload['roles']
  if (Array.isArray(parsedRole)) {
    rawRoles.push(...parsedRole)
  } else if (typeof parsedRole === 'string') {
    rawRoles.push(parsedRole)
  }

  const roleRegex = /"(?:http:\/\/schemas\.microsoft\.com\/ws\/2008\/06\/identity\/claims\/role|role|roles)"\s*:\s*"([^"]+)"/gi
  let match: RegExpExecArray | null
  while ((match = roleRegex.exec(rawPayload)) !== null) {
    rawRoles.push(match[1])
  }

  const uniqueRoles = Array.from(new Set(rawRoles))
  const finalRoles = uniqueRoles.length > 0 ? uniqueRoles : undefined

  return {
    id: (payload[CLAIM_ID] as string) ?? (payload['sub'] as string) ?? '',
    email: (payload[CLAIM_EMAIL] as string) ?? '',
    role: pickRole(finalRoles),
    roles: extractRoles(finalRoles),
    firstName: (payload[CLAIM_GIVEN_NAME] as string) ?? (payload['given_name'] as string) ?? (payload['name'] as string) ?? '',
    lastName: (payload[CLAIM_SURNAME] as string) ?? (payload['family_name'] as string) ?? '',
  }
}
