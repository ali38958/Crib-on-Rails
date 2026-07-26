// Simple fetch wrapper with auto-refresh
async function apiCall(url, options = {}) {
  let response = await fetch(url, {
    ...options,
    credentials: 'include' // Always send cookies
  });
  
  // If unauthorized, try refresh
  if (response.status === 401) {
    const refreshResponse = await fetch('/refresh', {
      method: 'POST',
      credentials: 'include'
    });
    
    if (refreshResponse.ok) {
      // Retry original request
      response = await fetch(url, {
        ...options,
        credentials: 'include'
      });
    } else {
      // Refresh failed, redirect to login
      window.location.href = '/login';
      throw new Error('Session expired');
    }
  }
  
  return response;
}

// Usage examples:
// apiCall('/dashboard', { method: 'GET' })
// apiCall('/products', { method: 'POST', body: JSON.stringify(data) })