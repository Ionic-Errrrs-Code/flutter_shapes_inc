import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Flutter Shapes Inc',
  description: 'Lightweight, developer-friendly package for Shapes Inc AI integration',
  lang: 'en-US',

  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    ['meta', { name: 'theme-color', content: '#667eea' }],
    ['meta', { property: 'og:title', content: 'Flutter Shapes Inc' }],
    ['meta', { property: 'og:description', content: 'Lightweight, developer-friendly package for Shapes Inc AI integration' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:url', content: 'https://flutter_shapes.ionicerrrrscode.com' }],
  ],

  themeConfig: {
    logo: '/logo.svg',
    siteTitle: 'Flutter Shapes Inc',

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/guide/' },
      { text: 'GitHub', link: 'https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc' },
    ],

    sidebar: {
      '/guide/': [
        {
          text: 'Getting Started',
          items: [
            { text: 'Introduction', link: '/guide/' },
            { text: 'Installation', link: '/guide/installation' },
          ]
        }
      ]
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc' },
      { icon: 'x', link: 'https://x.com/mu7khbit' },
    ],

    footer: {
      message: 'Released under the BSD 3-Clause License.',
      copyright: 'Copyright © 2025-present Flutter Shapes Inc Team'
    },

    editLink: {
      pattern: 'https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc/edit/main/docs/:path'
    },

    search: {
      provider: 'local'
    }
  },

  markdown: {
    theme: 'material-theme-palenight',
    lineNumbers: true,
    toc: { level: [1, 2, 3] },
  },

  vite: {
    build: {
      target: 'esnext',
      minify: 'terser',
    },
    optimizeDeps: {
      include: ['vue']
    }
  }
})