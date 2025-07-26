module.exports = {
    env: {
      browser: true,
      es2021: true,
      node: true,
    },
    extends: [
      'plugin:vue/base',
      'plugin:vue/vue3-essential',
      'plugin:vue/vue3-strongly-recommended',
      'plugin:vue/vue3-recommended',
      'plugin:import/recommended',
      'prettier',
    ],
    parserOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
    },
    plugins: ['vue'],
    rules: {
      'vue/attributes-order': 'error',
      'vue/order-in-components': 'error',
      'vue/require-default-prop': 'error',
    },
    settings: {
      'import/resolver': {
        'eslint-import-resolver-custom-alias': {
          alias: {
            '@': './app/javascript',
          },
          extensions: ['.js', '.jsx', '.ts', '.tsx', '.vue'],
        },
      },
    },
  };