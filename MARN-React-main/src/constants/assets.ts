const BASE_URL = (import.meta.env.VITE_API_BASE_URL as string | undefined) || (import.meta.env.PROD ? 'https://marn.runasp.net' : '')

export const AVATAR_PLACEHOLDER =
  'https://plus.unsplash.com/premium_photo-1677252438411-9a930d7a5168?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8YXZhdGFyJTIwcGxhY2Vob2xkZXJ8ZW58MHx8MHx8fDA%3D'

let cacheBuster = Date.now().toString()

export function resetImageCache() {
  cacheBuster = Date.now().toString()
}

export function getImageUrl(path: string | null | undefined): string {
  if (!path) return AVATAR_PLACEHOLDER
  
  let urlStr = path;
  if (!path.startsWith('http')) {
      urlStr = `${BASE_URL}${path}`;
  }
  
  try {
      const url = new URL(urlStr);
      // Only append if it doesn't already have a cache buster
      if (!url.searchParams.has('cb')) {
          url.searchParams.set('cb', cacheBuster);
      }
      return url.toString();
  } catch(e) {
      const separator = urlStr.includes('?') ? '&' : '?';
      return `${urlStr}${separator}cb=${cacheBuster}`;
  }
}
