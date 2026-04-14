/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: '#165DFF',
        secondary: '#4080FF',
        neutral: '#F7F8FC',
        dark: '#1D2129',
        light: '#C9CDD4',
        success: '#00B42A',
        warning: '#FF7D00',
        danger: '#F53F3F',
        info: '#0FC6C2',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      borderRadius: {
        xl: '12px',
        '2xl': '16px',
        '3xl': '20px',
      },
    },
  },
  plugins: [],
}
