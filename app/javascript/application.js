// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Fetch Interceptor for JWT Refresh
const originalFetch = window.fetch;
let isRefreshing = false;
let refreshQueue = [];

window.fetch = async function(...args) {
  let requestClone;
  // Clone the request if it's a Request object so we can retry it if the body gets consumed
  if (args[0] instanceof Request) {
    requestClone = args[0].clone();
  }

  let response = await originalFetch(...args);

  // If 401 Unauthorized and not already the login or refresh endpoint
  if (response.status === 401 && !response.url.includes('/login') && !response.url.includes('/refresh')) {
    if (!isRefreshing) {
      isRefreshing = true;
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
        const refreshResponse = await originalFetch('/refresh', {
          method: 'POST',
          headers: {
            'X-CSRF-Token': csrfToken || '',
            'Accept': 'application/json'
          }
        });

        if (refreshResponse.ok) {
          isRefreshing = false;
          // Notify queued requests to retry
          refreshQueue.forEach(cb => cb(true));
          refreshQueue = [];
          
          // Retry the original request
          if (requestClone) {
            return originalFetch(requestClone);
          } else {
            return originalFetch(...args);
          }
        } else {
          // Refresh failed, redirect to login
          isRefreshing = false;
          refreshQueue.forEach(cb => cb(false));
          refreshQueue = [];
          window.location.href = '/login';
          return response;
        }
      } catch (error) {
        isRefreshing = false;
        refreshQueue.forEach(cb => cb(false));
        refreshQueue = [];
        window.location.href = '/login';
        return response;
      }
    } else {
      // Queue requests while refreshing
      return new Promise(resolve => {
        refreshQueue.push((success) => {
          if (success) {
            if (requestClone) {
              resolve(originalFetch(requestClone));
            } else {
              resolve(originalFetch(...args));
            }
          } else {
            resolve(response);
          }
        });
      });
    }
  }

  return response;
};
