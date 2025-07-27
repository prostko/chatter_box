import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null,
    isAuthenticated: false,
    loading: false,
    error: null
  }),

  getters: {
    currentUser: (state) => state.user,
    isLoggedIn: (state) => state.isAuthenticated,
    hasUser: (state) => !!state.user
  },

  actions: {
    setUser(user) {
      this.user = user
      this.isAuthenticated = !!user
      this.error = null
    },

    clearUser() {
      this.user = null
      this.isAuthenticated = false
      this.error = null
    },

    setLoading(loading) {
      this.loading = loading
    },

    setError(error) {
      this.error = error
    },

    async fetchCurrentUser() {
      this.setLoading(true)
      try {
        // You can replace this with your actual API call
        const response = await fetch('/api/current_user', {
          credentials: 'include'
        })
        
        if (response.ok) {
          const user = await response.json()
          this.setUser(user)
        } else {
          this.clearUser()
        }
      } catch (error) {
        this.setError(error.message)
        this.clearUser()
      } finally {
        this.setLoading(false)
      }
    },

    async login(credentials) {
      this.setLoading(true)
      try {
        const response = await fetch('/api/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          credentials: 'include',
          body: JSON.stringify(credentials)
        })

        if (response.ok) {
          const user = await response.json()
          this.setUser(user)
          return { success: true }
        } else {
          const error = await response.json()
          this.setError(error.message || 'Login failed')
          return { success: false, error: error.message }
        }
      } catch (error) {
        this.setError(error.message)
        return { success: false, error: error.message }
      } finally {
        this.setLoading(false)
      }
    },

    async logout() {
      this.setLoading(true)
      try {
        await fetch('/sign_out', {
          method: 'GET',
          credentials: 'include'
        })
      } catch (error) {
        console.error('Logout error:', error)
      } finally {
        this.clearUser()
        this.setLoading(false)
      }
    }
  }
}) 