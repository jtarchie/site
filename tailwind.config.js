/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "written/**/*.{html,md}",
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("daisyui"),
  ],
};
