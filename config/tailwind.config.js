const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{erb,haml,html,slim}'
  ],
  safelist: [
    {
      pattern: /bg-/,
    },
    {
      pattern: /text-/,
    },
    {
      pattern: /border-/,
    },
    {
      pattern: /border-red-500/,
    },
    {
      pattern: /placeholder-gray-400/,
    },
    {
      pattern: /absolute/,
    },
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
