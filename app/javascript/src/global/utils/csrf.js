export function getCSRFToken() {
  // Get the CSRF token from the meta tag
  const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  return token;
}

export function setupCSRFHeaders(headers = {}) {
  const token = getCSRFToken();
  if (token) {
    headers['X-CSRF-Token'] = token;
  }
  return headers;
}

// Default headers for all requests
export const defaultHeaders = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  ...setupCSRFHeaders()
}; 