/** Standard envelope returned by every API endpoint.
 *
 * The server sends `code: "SUCCESS"` (string), not a boolean `success` field.
 * `success` is kept as an optional alias for backwards compatibility with any
 * callers that may still reference it, but should not be relied upon.
 */
export interface ApiResponse<T> {
  data: T
  message?: string
  /** e.g. "SUCCESS" — the actual server discriminator field */
  code?: string
  /** @deprecated The server does not send this; use `code === "SUCCESS"` instead */
  success?: boolean
}

/** Paginated variant of the standard envelope. */
export interface PaginatedResponse<T> {
  data: T[]
  total: number
  page: number
  pageSize: number
}

/** Paginated variant used by the Property search endpoint.
 *  Shape: { items: T[], totalCount, page, pageSize, totalPages }
 */
export interface SearchPaginatedResponse<T> {
  items: T[]
  totalCount: number
  page: number
  pageSize: number
  totalPages: number
}

/** Normalized error shape used throughout the app. */
export interface ApiError {
  message: string
  /** HTTP status code, or 0 for network/timeout errors. */
  status: number
  /** Optional machine-readable error code from the server. */
  code?: string
  /** Optional action hint provided by backend for recovery flows. */
  action?: string | null
  /**
   * Field-level validation errors keyed by field name (PascalCase from server).
   * e.g. { "DateOfBirth": ["Date of birth cannot be in the future."] }
   */
  validationErrors?: Record<string, string[]>
  /**
   * Flat list of business-logic error messages from the server.
   * e.g. ["Username '...' is already taken.", "Email '...' is already taken."]
   */
  errors?: string[]
}
