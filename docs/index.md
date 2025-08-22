---
title: Flutter Shapes Inc
description: Lightweight, developer-friendly package for Shapes Inc AI integration
head:
  - - meta
    - name: description
      content: Flutter Shapes Inc - A lightweight, developer-friendly package for integrating with Shapes Inc AI chat bots
  - - meta
    - name: keywords
      content: flutter, shapes, ai, chat, multimodal
  - - meta
    - property: og:title
      content: Flutter Shapes Inc - Simple API for Shapes Inc
  - - meta
    - property: og:description
      content: Function-based API, multimodal (text/image/audio), shape profiles, and utilities.
  - - meta
    - property: og:type
      content: website
  - - meta
    - property: og:url
      content: https://flutter_shapes.ionicerrrrscode.com
---

# Flutter Shapes Inc

A lightweight, function-based Flutter package for integrating with Shapes Inc agents. No widget boilerplate — just initialize once and call simple functions for chat, multimodal, and utilities.

> **First Release**: This is the initial release of Flutter Shapes Inc, providing a complete set of functions for integrating with Shapes Inc AI services.

## Quick Start

```dart
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';

void main() {
  ShapesAPI.initialize(
    'your-api-key',
    userId: 'your-app-user-id',     // X-User-Id (recommended)
    channelId: 'conversation-1234', // X-Channel-Id (recommended)
  );
}

Future<void> chat() async {
  final reply = await ShapesAPI.sendMessage('tenshi', 'Hello!');
  debugPrint(reply);
}
```

## Core Concepts

- Initialization: one-time `ShapesAPI.initialize(apiKey, userId?, channelId?, baseUrl?)`
- Model format: `shapesinc/<username>` (handled internally)
- Public profiles: `getShapeProfile(username)` fetches `https://api.shapes.inc/shapes/public/{username}`
- Multimodal: send text with image or audio URLs; `!imagine` via `generateImage`

## Complete Function List

### Chat & Multimodal

- `sendMessage(shapeUsername, message)`
- `sendImageMessage(shapeUsername, message, imageUrl)`
- `sendAudioMessage(shapeUsername, message, audioUrl)`
- `sendMultiImageMessage(shapeUsername, message, imageUrls)`
- `sendImageAudioMessage(shapeUsername, message, imageUrl, audioUrl)`
- `createChatCompletion(shapeUsername, List<ShapesMessage>)`
- `quickChat(shapeUsername, message)`

### Shape Profiles & Discovery

- `getShapeProfile(username)`
- `getShapeProfiles(List<String> usernames)`
- `getPopularShapes({limit = 20})`

### Shape Commands

- `resetShape(shapeUsername)`
- `getShapeInfo(shapeUsername)`
- `getHelp(shapeUsername)`
- `searchWeb(shapeUsername, query)`
- `generateImage(shapeUsername, prompt)` - Multimodal response support

### Helper Functions

- `extractImageUrls(response)` - Extract image URLs from multimodal responses
- `extractTextContent(response)` - Extract text content from multimodal responses

### Information & Data

- `getWeather(shapeUsername, location)`
- `getCurrentTime(shapeUsername, [timezone])`
- `getNews(shapeUsername, [topic])`
- `getStockInfo(shapeUsername, symbol)`
- `getCryptoInfo(shapeUsername, symbol)`

### Language & Translation

- `translate(shapeUsername, text, targetLanguage)`
- `define(shapeUsername, word)`
- `getSynonyms(shapeUsername, word)`
- `getAntonyms(shapeUsername, word)`

### Math & Conversion

- `calculate(shapeUsername, expression)`
- `convert(shapeUsername, value, fromUnit, toUnit)`

### Media & Entertainment

- `getMovieInfo(shapeUsername, title)`
- `getBookInfo(shapeUsername, title)`
- `getSongInfo(shapeUsername, title)`
- `getGameInfo(shapeUsername, title)`
- `getJoke(shapeUsername, [category])`
- `getQuote(shapeUsername, [author])`
- `getFact(shapeUsername, [topic])`
- `getTrivia(shapeUsername, [category])`

### Lifestyle & Learning

- `getRecipe(shapeUsername, dish)`
- `getWorkout(shapeUsername, [goal])`
- `getMeditation(shapeUsername, [type])`
- `learnLanguage(shapeUsername, language, phrase)`
- `getCodingHelp(shapeUsername, language, problem)`
- `getDebuggingHelp(shapeUsername, error)`
- `getCodeReview(shapeUsername, code)`
- `explainAlgorithm(shapeUsername, algorithm)`
- `getDesignFeedback(shapeUsername, description)`
- `getWritingHelp(shapeUsername, text, [type])`
- `checkGrammar(shapeUsername, text)`
- `getWritingSuggestions(shapeUsername, text)`

### Utilities

- `testConnection()`
- `getUsageStats()`

## Image Generation

The `generateImage()` function provides support for multimodal responses:

### Smart Response Parsing

```dart
// Generate an image
final response = await ShapesAPI.generateImage('tenshi', 'a beautiful cat');

// Extract components
final imageUrls = ShapesAPI.extractImageUrls(response);
final textContent = ShapesAPI.extractTextContent(response);

// Use in your UI
if (imageUrls.isNotEmpty) {
  // Display the first image
  Image.network(imageUrls.first);
  // Show the text response
  Text(textContent);
}
```

### Response Format

The API returns responses in this format:

```
Here's your generated image description!
https://files.shapes.inc/f4098070.png
```

### Helper Functions

- **`extractImageUrls(response)`**: Extracts all image URLs from the response
- **`extractTextContent(response)`**: Extracts just the text content, excluding URLs

### Multiple Images

When multiple images are generated, they're returned as separate URLs on new lines, making it easy to display them in sequence.

## Models (for advanced usage)

```dart
// Message models
class ShapesMessage {
  final String role;         // 'user' | 'assistant' | 'system'
  final dynamic content;     // String | List<ContentPart>
  final String? name;
}

class ContentPart {
  final String type;         // 'text' | 'image_url' | 'audio_url'
  final String? text;
  final ImageUrl? imageUrl;  // ImageUrl(url)
  final AudioUrl? audioUrl;  // AudioUrl(url)
}

class ShapeProfile {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;    // falls back to avatar or empty
  final bool enabled;
  // plus: searchDescription, tags, screenshots, settings, stats
}
```

## Public Profiles (HTTP reference)

- Endpoint: `GET https://api.shapes.inc/shapes/public/{username}`
- No auth required
- Used internally by `getShapeProfile`

## Best Practices

- Always normalize usernames (strip leading `@`) before sending
- Provide `userId` and `channelId` in `initialize` for user-facing apps
- On web, use valid https URLs for images/audio; the example includes safe fallbacks

## Example App (Material 3)

The `example/` app demonstrates:

- Segmented composer for text, image, audio, and `!imagine`
- Shape search and selection using public profiles
- Responsive layout with SingleChildScrollView
- Safe avatar rendering with initials fallback

Run:

```bash
cd ../example
flutter pub get
flutter run
```

## 📚 Documentation

- **📖 [Full Documentation](https://flutter_shapes.ionicerrrrscode.com)** - Complete API reference
- **🎯 [Examples](https://github.com/Ionic-Errrrs-Code/flutter_shapes_inctree/main/example)** - Working example app with Material 3
- **🔧 [API Reference](https://flutter_shapes.ionicerrrrscode.com/#/)** - Detailed function documentation
