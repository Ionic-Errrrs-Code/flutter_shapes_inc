import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Flutter Shapes',
  description: 'Lightweight, developer-friendly package for Shapes Inc AI integration',
  lang: 'en-US',

  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    ['meta', { name: 'theme-color', content: '#667eea' }],
    ['meta', { property: 'og:title', content: 'Flutter Shapes' }],
    ['meta', { property: 'og:description', content: 'Lightweight, developer-friendly package for Shapes Inc AI integration' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:url', content: 'https://flutter_shapes.ionicerrrrscode.com' }],
  ],

  themeConfig: {
    logo: '/logo.svg',
    siteTitle: 'Flutter Shapes',

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/guide/' },
      { text: 'GitHub', link: 'https://github.com/Ionic-Errrrs-Code/flutter_shapes' },
    ],

    sidebar: {
      '/guide/': [
        {
          text: 'Getting Started',
          items: [
            { text: 'Introduction', link: '/guide/' },
            { text: 'Installation', link: '/guide/installation' },
            { text: 'Quick Start', link: '/guide/quick-start' },
            { text: 'Configuration', link: '/guide/configuration' },
          ]
        },
        {
          text: 'Core Concepts',
          items: [
            { text: 'API Client', link: '/guide/api-client' },
            { text: 'Messages', link: '/guide/messages' },
            { text: 'Shapes', link: '/guide/shapes' },
            { text: 'Error Handling', link: '/guide/error-handling' },
          ]
        },
        {
          text: 'Advanced',
          items: [
            { text: 'Custom Interceptors', link: '/guide/interceptors' },
            { text: 'Rate Limiting', link: '/guide/rate-limiting' },
            { text: 'Caching', link: '/guide/caching' },
            { text: 'Streaming', link: '/guide/streaming' },
          ]
        }
      ]
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/Ionic-Errrrs-Code/flutter_shapes' },
      { icon: 'twitter', link: 'https://twitter.com/shapesinc' },
    ],

    footer: {
      message: 'Released under the BSD 3-Clause License.',
      copyright: 'Copyright © 2025-present Flutter Shapes Team'
    },

    editLink: {
      pattern: 'https://github.com/Ionic-Errrrs-Code/flutter_shapes/edit/main/docs/:path'
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