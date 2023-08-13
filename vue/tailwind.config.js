/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      fontSize:{
        tinysm: "0.54rem"
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
        green400: "#4bde81",
        red400: "#f87171",
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
      }
    },
  },
  plugins: [],
};
