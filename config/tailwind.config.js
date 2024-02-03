module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      typography: ({theme}) => ({
        primary: {
          css: {
            '--tw-prose-body': theme('colors.dark'),
            '--tw-prose-headings': theme('colors.dark'),
            '--tw-prose-lead': theme('colors.dark'),
            '--tw-prose-links': theme('colors.primary'),
            '--tw-prose-bold': theme('colors.dark'),
            '--tw-prose-counters': theme('colors.dark'),
            '--tw-prose-bullets': theme('colors.dark'),
            '--tw-prose-hr': theme('colors.dark'),
            '--tw-prose-quotes': theme('colors.dark'),
            '--tw-prose-quote-borders': theme('colors.dark'),
            '--tw-prose-captions': theme('colors.dark'),
            '--tw-prose-code': theme('colors.dark'),
            '--tw-prose-pre-code': theme('colors.dark'),
            '--tw-prose-pre-bg': theme('colors.dark'),
            '--tw-prose-th-borders': theme('colors.dark'),
            '--tw-prose-td-borders': theme('colors.dark'),

            '--tw-prose-invert-body': theme('colors.light'),
            '--tw-prose-invert-headings': theme('colors.light'),
            '--tw-prose-invert-lead': theme('colors.light'),
            '--tw-prose-invert-links': theme('colors.primary'),
            '--tw-prose-invert-bold': theme('colors.light'),
            '--tw-prose-invert-counters': theme('colors.light'),
            '--tw-prose-invert-bullets': theme('colors.light'),
            '--tw-prose-invert-hr': theme('colors.light'),
            '--tw-prose-invert-quotes': theme('colors.light'),
            '--tw-prose-invert-quote-borders': theme('colors.light'),
            '--tw-prose-invert-captions': theme('colors.light'),
            '--tw-prose-invert-code': theme('colors.light'),
            '--tw-prose-invert-pre-code': theme('colors.light'),
            '--tw-prose-invert-pre-bg': theme('colors.light'),
            '--tw-prose-invert-th-borders': theme('colors.light'),
            '--tw-prose-invert-td-borders': theme('colors.light'),
          },
        },
      }),
      colors: {
        'primary': '#099487',
        'secondary': '#00D4BF',
        'tertiary': '#FBE81F',
        'error': '#DC4949',
        'light': '#EFF0F1',
        'light-subtle': '#D0D3D4',
        'dark': '#1F2122',
        'dark-subtle': '#494D4F',
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
