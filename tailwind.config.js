/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        "./src/main/webapp/pages/**/*.{jsp,html}",
        "./src/main/webapp/static/**/*.{js,html}",
        "./src/main/webapp/*.jsp"
    ],
    theme: {
        extend: {
            colors: {
                canvas: 'var(--canvas)',
                surface: 'var(--surface)',
                'surface-elevated': 'var(--surface-elevated)',
                primary: 'var(--primary)',
                'primary-glow': 'var(--primary-glow)',
                accent: 'var(--accent)',
                'accent-glow': 'var(--accent-glow)',
                'text-primary': 'var(--text-primary)',
                'text-muted': 'var(--text-muted)',
                'text-dim': 'var(--text-dim)',
                'border-dim': 'var(--border-dim)',
                'border-highlight': 'var(--border-highlight)',
            },
            fontFamily: {
                sans: ['Inter', 'system-ui', 'sans-serif'],
                serif: ['var(--font-serif)', 'serif'],
                heading: ['var(--font-serif)', 'serif'],
            },
            borderRadius: {
                fluid: 'var(--radius-fluid)',
            }
        },
    },
    plugins: [],
}
