# Guide

Welcome to the Shapes API Flutter guide! This guide helps you integrate Shapes Inc AI into your Flutter app using a simple, function-based API.

## What is Flutter Shapes Inc?

A lightweight package providing a function-first API for Shapes Inc agents:
- 🤖 Chat and multimodal (text, image, audio)
- 👤 Public profiles and discovery
- 🔧 Utility commands and helpers

## Key Features

- 🔤 Simple: initialize once, call functions anywhere
- 🖼️ Multimodal: image and audio inputs supported
- 👥 Profiles: fetch public profiles and metadata
- 🧰 Utilities: commands like `!info`, `!help`, web search, `!imagine`

## Quick Navigation

- [Installation](./installation.md) - Get the package installed
- [API Reference](../index.md#complete-function-list) - Full function list
- [Example App](https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc/tree/main/example) - Material 3 demo

## Architecture (Simple)

- `ShapesAPI.initialize(apiKey, userId?, channelId?, baseUrl?)`
- High-level helpers on `ShapesAPI` cover common operations
- Optional: use `ShapesApiClient` directly for advanced control

## Getting Started

1. **Install the package** - Add to your `pubspec.yaml`
2. **Get your API key** - Visit [Shapes Inc Developer Portal](https://shapes.inc/developer)
3. **Initialize** - Call `ShapesAPI.initialize('your-key', userId: 'u', channelId: 'c')`
4. **Chat** - `await ShapesAPI.sendMessage('tenshi', 'Hello!')`

## Best Practices

- Normalize usernames by stripping leading `@`
- Provide `userId` and `channelId` for user-facing apps
- For web, use https URLs for images/audio; handle errors gracefully

## Support

- 📚 **Documentation**: Root README and docs index
- 💬 **Community**: [GitHub Discussions](https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc/issues)
- 📧 **Email**: support@ionicerrrrscode.com

## Examples

See the [example app](https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc/tree/main/example) for a Material 3 UI with:
- Segmented composer (Text/Image/Audio/`!imagine`)
- Public profile search and selection
- Responsive layout and safe avatar fallbacks