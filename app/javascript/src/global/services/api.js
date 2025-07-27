import axios from 'axios';
import { getCSRFToken, setupCSRFHeaders } from '@/src/global/utils/csrf';

// Create axios instance with default configuration
const api = axios.create({
  baseURL: '/',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Request interceptor to add CSRF token to all requests
api.interceptors.request.use(
  (config) => {
    const token = getCSRFToken();
    if (token) {
      config.headers['X-CSRF-Token'] = token;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle common errors
api.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response?.status === 422) {
      // Handle validation errors
      console.error('Validation error:', error.response.data);
    } else if (error.response?.status === 401) {
      // Handle unauthorized
      console.error('Unauthorized');
    }
    return Promise.reject(error);
  }
);

export default api; 