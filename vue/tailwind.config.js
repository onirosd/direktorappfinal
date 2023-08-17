/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}", "./node_modules/flowbite/**/*.js"],
  theme: {
    extend: {
      spacing: {
        '1': '0.25rem',     // 4px
        '2': '0.5rem',      // 8px
        '3': '0.75rem',     // 12px
        '4': '1rem',        // 16px
        '5': '1.25rem',     // 20px
        '6': '1.5rem',      // 24px
        '8': '2rem',        // 32px
        // ... puedes continuar agregando o modificando espacios según lo necesites
      },
      fontSize: {
        'xxs': '0.68rem',
        'xs': '0.75rem',     // 12px
        'sm': '0.875rem',    // 14px
        'base': '1rem',      // 16px
        'lg': '1.125rem',    // 18px
        'xl': '1.25rem',     // 20px
        // ... puedes continuar agregando o modificando tamaños según lo necesites
      },
      height: {
        14: "3.5rem",
      },
      width: {
        'content': 'calc(100% - 256px)'
      },
      colors: {
        main: "#002B6B",
        orange: "#EB5D00",
        orange400: "#fb923c",
        orangebold: "#e37012",
        green400: "#3ac189",
        greenbold: "#20a36d",
        red400: "#d13a3a",
        redbold: "#851616",
        side: "#E5EBFB",
        activeText: "#212530",
        inactiveText: "#616E8E",
      },
      boxShadow: {
        'tooltip': '0px 4px 16px rgba(23, 71, 194, 0.18)',
        'hint': '0px 8px 24px rgba(96, 120, 184, 0.12)',
      },
      content: {
        'pointsActive': 'url(assets/points-active.svg)',
        'addActive': 'url(assets/tooltip-person-add-active.svg)',
        'editActive': 'url(assets/tooltip-edit-active.svg)',
        'deleteActive': 'url(assets/tooltip-delete-active.svg)',
        'phoneLogo': 'url(assets/phone-logo.png)',
        'phoneBell': 'url(assets/phone-bell.svg)',
        'phoneSearch': 'url(assets/phone-search.svg)',
        'phoneMenu': 'url(assets/phone-menu.svg)',
      },
      screens: {
        'sm': {'max': '750px'},
        'lg': {'max': '1366px'}
      }
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
};
