import { defineConfig } from 'vite'
import path from 'path'
import vue from '@vitejs/plugin-vue'
import RubyPlugin from 'vite-plugin-ruby'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  resolve: {
    alias: [
      {
        find: '@',
        replacement: path.resolve(__dirname, 'app', 'javascript'),
      },
    ],
    extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
  },
  plugins: [vue(), RubyPlugin(), tailwindcss()],
})
