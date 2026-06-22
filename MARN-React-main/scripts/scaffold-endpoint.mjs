#!/usr/bin/env node
/**
 * Scaffold boilerplate for a new API endpoint.
 *
 * Usage:
 *   node scripts/scaffold-endpoint.mjs --method GET   --path "/api/Admin/stats/revenue"      --name adminRevenue
 *   node scripts/scaffold-endpoint.mjs --method POST  --path "/api/Payment/start-payment"    --name startPayment
 *   node scripts/scaffold-endpoint.mjs --method PATCH --path "/api/Admin/users/{userId}/ban" --name banUser
 */

import { readFileSync } from 'fs'
import { resolve } from 'path'

// ── CLI args ──────────────────────────────────────────────────────────────────
const args   = process.argv.slice(2)
const flag   = (f) => { const i = args.indexOf(f); return i !== -1 ? args[i + 1] ?? null : null }

const method  = (flag('--method') ?? 'GET').toUpperCase()
const apiPath = flag('--path')
const name    = flag('--name')

if (!apiPath || !name) {
  console.error([
    '',
    'Usage: node scripts/scaffold-endpoint.mjs --method <METHOD> --path "<path>" --name <name>',
    '',
    'Examples:',
    '  node scripts/scaffold-endpoint.mjs --method GET   --path "/api/Admin/stats/revenue"      --name adminRevenue',
    '  node scripts/scaffold-endpoint.mjs --method POST  --path "/api/Payment/start-payment"    --name startPayment',
    '  node scripts/scaffold-endpoint.mjs --method PATCH --path "/api/Admin/users/{userId}/ban" --name banUser',
    '',
  ].join('\n'))
  process.exit(1)
}

// ── Load generated types ──────────────────────────────────────────────────────
const typesFile = resolve(process.cwd(), 'src/types/api.generated.ts')
let src
try {
  src = readFileSync(typesFile, 'utf-8')
} catch {
  console.error([
    '',
    '❌  src/types/api.generated.ts not found.',
    '   Run:  npm run types:generate',
    '',
  ].join('\n'))
  process.exit(1)
}

// ── Low-level helpers ─────────────────────────────────────────────────────────

/** Return a brace-balanced slice starting at `start` (the opening `{`). */
function sliceBraces(source, start) {
  let depth = 0, i = start
  for (; i < source.length; i++) {
    if (source[i] === '{') depth++
    if (source[i] === '}') { depth--; if (depth === 0) return source.slice(start, i + 1) }
  }
  return source.slice(start)
}

/** Slice the top-level path block for a given swagger path string. */
function slicePathBlock(source, path) {
  const needle = `"${path}":`
  const keyIdx = source.indexOf(needle)
  if (keyIdx === -1) return null
  const braceIdx = source.indexOf('{', keyIdx)
  if (braceIdx === -1) return null
  return sliceBraces(source, braceIdx)
}

/**
 * Within `block`, find the sub-block for `httpMethod:` and then within that
 * find the brace-balanced block for `statusCode:`, returning it or null.
 */
function sliceStatusBlock(block, httpMethod, statusCode) {
  const lower = httpMethod.toLowerCase()
  const methodIdx = block.search(new RegExp(`(?<![\\w])${lower}\\s*:`))
  if (methodIdx === -1) return null
  const afterMethod = block.slice(methodIdx)

  const statusRe = new RegExp(`(?<![\\d])${statusCode}\\s*:`)
  const statusIdx = afterMethod.search(statusRe)
  if (statusIdx === -1) return null
  const afterStatus = afterMethod.slice(statusIdx)

  const braceIdx = afterStatus.indexOf('{')
  if (braceIdx === -1) return null
  return sliceBraces(afterStatus, braceIdx)
}

/**
 * Within `block`, find the `requestBody` sub-block for `httpMethod:`,
 * stopping before `responses:` to avoid reading error schemas.
 */
function sliceRequestBodyBlock(block, httpMethod) {
  const lower = httpMethod.toLowerCase()
  const methodIdx = block.search(new RegExp(`(?<![\\w])${lower}\\s*:`))
  if (methodIdx === -1) return null
  const afterMethod = block.slice(methodIdx)

  const reqIdx = afterMethod.indexOf('requestBody')
  const respIdx = afterMethod.indexOf('responses')
  // requestBody must come before responses
  if (reqIdx === -1 || (respIdx !== -1 && reqIdx > respIdx)) return null

  const afterReq = afterMethod.slice(reqIdx)
  // requestBody?: never
  if (/^requestBody\s*\??\s*:\s*never/.test(afterReq.trim())) return null

  const braceIdx = afterReq.indexOf('{')
  if (braceIdx === -1) return null
  return sliceBraces(afterReq, braceIdx)
}

/**
 * Find the method-level parameters.query block and extract named param keys,
 * skipping structural keys (query, header, path, cookie).
 */
function extractQueryParams(block, httpMethod) {
  const lower = httpMethod.toLowerCase()
  const methodIdx = block.search(new RegExp(`(?<![\\w])${lower}\\s*:`))
  if (methodIdx === -1) return []
  const afterMethod = block.slice(methodIdx)

  // Find `parameters:` inside the method block
  const paramIdx = afterMethod.indexOf('parameters:')
  if (paramIdx === -1) return []
  const afterParam = afterMethod.slice(paramIdx)

  const paramBrace = afterParam.indexOf('{')
  if (paramBrace === -1) return []
  const paramBlock = sliceBraces(afterParam, paramBrace)

  // Inside parameters, find `query:`
  const qIdx = paramBlock.search(/\bquery\s*\??\s*:/)
  if (qIdx === -1) return []
  const afterQ = paramBlock.slice(qIdx)

  if (/^query\s*\??\s*:\s*never/.test(afterQ.trim())) return []

  const qBrace = afterQ.indexOf('{')
  if (qBrace === -1) return []
  const qBlock = sliceBraces(afterQ, qBrace)

  // Extract param key names (skip structural nesting keys)
  const skip = new Set(['query', 'header', 'path', 'cookie'])
  const names = []
  const re = /^\s{8,}(\w+)\??\s*:/gm
  let m
  while ((m = re.exec(qBlock)) !== null) {
    if (!skip.has(m[1])) names.push(m[1])
  }
  return names
}

/** Extract the first `components["schemas"]["X"]` name from any string. */
function firstSchema(str) {
  if (!str) return null
  const m = str.match(/components\["schemas"\]\["([^"]+)"\]/)
  return m ? m[1] : null
}

// ── Run parsers ───────────────────────────────────────────────────────────────
const pathBlock      = slicePathBlock(src, apiPath)
const status200Block = pathBlock ? sliceStatusBlock(pathBlock, method, 200) : null
const reqBodyBlock   = ['POST', 'PUT', 'PATCH'].includes(method)
                         ? sliceRequestBodyBlock(pathBlock, method)
                         : null

const responseSchema = firstSchema(status200Block)
const requestSchema  = firstSchema(reqBodyBlock)
const queryParams    = method === 'GET' ? extractQueryParams(pathBlock ?? '', method) : []
const pathParams     = [...apiPath.matchAll(/\{([^}]+)\}/g)].map(m => m[1])
const hasPathParams  = pathParams.length > 0
const hasQP          = queryParams.length > 0

// ── Names ─────────────────────────────────────────────────────────────────────
const pascal  = name.charAt(0).toUpperCase() + name.slice(1)
const isQuery = method === 'GET'

// ── Service / hook file mapping ───────────────────────────────────────────────
const SERVICE_MAP = {
  '/api/Admin':          { file: 'adminService',       note: '' },
  '/api/Account':        { file: 'authService',        note: '' },
  '/api/Profile':        { file: 'userService',        note: '' },
  '/api/Property':       { file: 'propertyService',    note: '' },
  '/api/properties':     { file: 'propertyService',    note: '' },
  '/api/BookingRequest': { file: 'rentalService',      note: '' },
  '/api/contracts':      { file: 'rentalService',      note: '' },
  '/api/Chat':           { file: 'messageService',     note: '' },
  '/api/Payment':        { file: 'paymentService',     note: '⚠️  create this service file' },
  '/api/Notification':   { file: 'notificationService',note: '⚠️  create this service file' },
  '/api/Roommate':       { file: 'roommateService',    note: '⚠️  create this service file' },
  '/api/Reports':        { file: 'reportService',      note: '⚠️  create this service file' },
  '/api/Support':        { file: 'supportService',     note: '⚠️  create this service file' },
}

const HOOK_MAP = {
  '/api/Admin':          { file: 'useAdminStats',    note: '' },
  '/api/Account':        { file: 'useAuth',           note: '' },
  '/api/Profile':        { file: 'useProfile',        note: '' },
  '/api/Property':       { file: 'useProperties',     note: '' },
  '/api/properties':     { file: 'useProperty',       note: '' },
  '/api/BookingRequest': { file: 'useBookingRequests',note: '' },
  '/api/contracts':      { file: 'useContracts',      note: '' },
  '/api/Chat':           { file: 'useConversations',  note: '' },
  '/api/Payment':        { file: 'usePayment',        note: '⚠️  create this hook file' },
  '/api/Notification':   { file: 'useNotifications',  note: '⚠️  create this hook file' },
  '/api/Roommate':       { file: 'useRoommate',       note: '⚠️  create this hook file' },
  '/api/Reports':        { file: 'useReports',        note: '⚠️  create this hook file' },
  '/api/Support':        { file: 'useSupportContact', note: '⚠️  create this hook file' },
}

const svcEntry   = Object.entries(SERVICE_MAP).find(([k]) => apiPath.startsWith(k))
const serviceFile = svcEntry?.[1]?.file ?? 'TODO_service'
const svcNote     = svcEntry?.[1]?.note ?? ''
const hookEntry   = Object.entries(HOOK_MAP).find(([k]) => apiPath.startsWith(k))
const hookFile    = hookEntry?.[1]?.file ?? 'TODO_hook'
const hookNote    = hookEntry?.[1]?.note ?? ''

// ── Type strings ──────────────────────────────────────────────────────────────
const responseType = responseSchema
  ? `components['schemas']['${responseSchema}']`
  : `TODO_${pascal}Response /* ⚠️  no schema in generated types — define manually */`

const requestType = requestSchema
  ? `components['schemas']['${requestSchema}']`
  : null

// ── URL string (template literal for path params) ─────────────────────────────
const urlStr = hasPathParams
  ? '`' + apiPath.replace(/\{([^}]+)\}/g, '${$1}') + '`'
  : `'${apiPath}'`

// ── Service fn signature ──────────────────────────────────────────────────────
const serviceFnArgs = [
  ...pathParams.map(p => `${p}: string`),
  ...(!isQuery && requestType ? [`payload: ${requestType}`] : []),
  ...(hasQP ? ['page = 1', 'pageSize = 20'] : []),
].join(', ')

const apiCallArgs = [
  urlStr,
  ...(!isQuery && requestType ? ['payload'] : []),
].join(', ')

// ── Hook fn signature & query key ────────────────────────────────────────────
// arg names only (no defaults) for use inside the hook body
const hookArgNames = [
  ...pathParams,
  ...(hasQP ? ['page', 'pageSize'] : []),
]
const hookArgDefs = [
  ...pathParams.map(p => `${p}: string`),
  ...(hasQP ? ['page = 1', 'pageSize = 20'] : []),
]
const queryKey = [`'${name}'`, ...pathParams, ...(hasQP ? ['page', 'pageSize'] : [])].join(', ')

// ── Render ────────────────────────────────────────────────────────────────────
const L  = '─'.repeat(64)
const S  = '─'.repeat(32)

console.log(`\n${L}`)
console.log(`  ${method}  ${apiPath}`)
console.log(`  name: ${name}    service: ${serviceFile}.ts    hook: ${hookFile}.ts`)
if (svcNote)  console.log(`  ${svcNote}`)
if (hookNote) console.log(`  ${hookNote}`)
console.log(L)

// Detection report
if (!pathBlock) {
  console.log(`\n⚠️   Path "${apiPath}" NOT found in generated types.`)
  console.log(`    Re-run npm run types:generate, or the swagger path may differ.`)
} else {
  console.log(responseSchema
    ? `\n✅  Response 200  →  components['schemas']['${responseSchema}']`
    : `\n⚠️   Response 200 has no schema (content?: never) — define the response type manually.`)
  if (requestSchema)
    console.log(`✅  Request body  →  components['schemas']['${requestSchema}']`)
  if (hasQP)
    console.log(`✅  Query params  →  ${queryParams.join(', ')}`)
}

// ── IMPORTS ───────────────────────────────────────────────────────────────────
console.log(`\n${S} IMPORTS`)
console.log(`import type { components } from '@/types/api.generated'`)
if (responseSchema)
  console.log(`type ${pascal}Response = components['schemas']['${responseSchema}']`)
if (requestSchema)
  console.log(`type ${pascal}Payload  = components['schemas']['${requestSchema}']`)

// ── SERVICE ───────────────────────────────────────────────────────────────────
console.log(`\n${S} SERVICE  →  src/services/${serviceFile}.ts`)
const qpComment = hasQP
  ? `\n    // Detected query params: ${queryParams.join(', ')}`
  : ''
console.log(
`  ${name}: (${serviceFnArgs}) =>${qpComment}
    apiClient.${method.toLowerCase()}<ApiResponse<${responseType}>>(${apiCallArgs}),`
)

// ── HOOK ──────────────────────────────────────────────────────────────────────
console.log(`\n${S} HOOK  →  src/hooks/${hookFile}.ts`)

if (isQuery) {
  console.log(
`export function use${pascal}(${hookArgDefs.join(', ')}) {
  return useQuery({
    queryKey: [${queryKey}],
    queryFn: () => ${serviceFile}.${name}(${hookArgNames.join(', ')}),${hasPathParams ? `\n    enabled: ${pathParams.map(p => `!!${p}`).join(' && ')},` : ''}
  })
}`
  )
} else {
  const mutArg  = requestType ? `payload: ${requestType}` : hasPathParams ? `${pathParams[0]}: string` : ''
  const mutCall = [
    ...pathParams,
    ...(requestType ? ['payload'] : []),
  ].join(', ')

  console.log(
`export function use${pascal}() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (${mutArg}) =>
      ${serviceFile}.${name}(${mutCall}),
    onSuccess: () => {
      toast.success('TODO: success message')
      queryClient.invalidateQueries({ queryKey: ['TODO'] })
    },
    onError: () => toast.error('TODO: error message'),
  })
}`
  )
}

// ── TRACKER ───────────────────────────────────────────────────────────────────
console.log(`\n${S} TRACKER  →  docs/api-wiring-tracker.md`)
console.log(`  Change:  ❌ Missing  →  ✅ Wired`)
console.log(`  Service: ${serviceFile}.${name}()`)
console.log(`  Hook:    use${pascal}`)
console.log()
