# Changelog

All notable changes to the Flutter Shapes Inc package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-08-23

### 🛠️ Maintenance & Fixes

- Updated README to use a local GIF and improved HTML centering.
- Excluded demo GIF from pub.dev package.
- Improved .gitignore and .pubignore for pub.dev compliance.
- Minor documentation and metadata updates.

## [1.0.0] - 2025-08-22

### 🎉 Initial Release

This is the first release of the Flutter Shapes package, providing a simple and powerful way to integrate with Shapes Inc AI.

### ✨ Features

#### 🚀 Core API Functions
- **Simple initialization** - `ShapesAPI.initialize(apiKey)` for one-time setup
- **Basic chat** - `sendMessage()`, `quickChat()` for simple text conversations
- **Custom completions** - `createChatCompletion()` for advanced usage

#### 🖼️ Multimodal Support
- **Image messages** - `sendImageMessage()` for image + text conversations
- **Audio messages** - `sendAudioMessage()` for audio + text conversations
- **Multiple images** - `sendMultiImageMessage()` for multiple images
- **Mixed media** - `sendImageAudioMessage()` for image + audio + text
- **Image generation** - `generateImage()` with `!imagine` command

#### 👤 Shape Management
- **Shape profiles** - `getShapeProfile()`, `getShapeProfiles()` for shape information
- **Popular shapes** - `getPopularShapes()` for discovering shapes
- **Shape commands** - `resetShape()`, `getShapeInfo()`, `getHelp()`

#### 🌍 Information & Data
- **Weather** - `getWeather()` for current weather information
- **Time** - `getCurrentTime()` for timezone-aware time
- **News** - `getNews()` for current news and topics
- **Stocks** - `getStockInfo()` for stock market data
- **Cryptocurrency** - `getCryptoInfo()` for crypto prices

#### 🔤 Language & Translation
- **Translation** - `translate()` for text translation
- **Definitions** - `define()` for word definitions
- **Synonyms** - `getSynonyms()` for word alternatives
- **Antonyms** - `getAntonyms()` for word opposites

#### 🧮 Math & Calculations
- **Calculations** - `calculate()` for mathematical expressions
- **Unit conversion** - `convert()` for unit conversions

#### 🎭 Entertainment & Fun
- **Jokes** - `getJoke()` for random jokes
- **Quotes** - `getQuote()` for inspirational quotes
- **Facts** - `getFact()` for interesting facts
- **Trivia** - `getTrivia()` for trivia questions

#### 📺 Media Information
- **Movies** - `getMovieInfo()` for movie details
- **Books** - `getBookInfo()` for book information
- **Songs** - `getSongInfo()` for music details
- **Games** - `getGameInfo()` for game information

#### 🍳 Lifestyle & Health
- **Recipes** - `getRecipe()` for cooking recipes
- **Workouts** - `getWorkout()` for exercise plans
- **Meditation** - `getMeditation()` for mindfulness guidance
- **Travel** - `getTravelRecommendations()` for travel tips

#### 🎓 Learning & Education
- **Language learning** - `learnLanguage()` for language help
- **Coding help** - `getCodingHelp()` for programming assistance
- **Debugging** - `getDebuggingHelp()` for error resolution
- **Code review** - `getCodeReview()` for code feedback
- **Algorithms** - `explainAlgorithm()` for algorithm explanations

#### ✍️ Writing & Content
- **Writing help** - `getWritingHelp()` for writing assistance
- **Grammar check** - `checkGrammar()` for grammar correction
- **Writing suggestions** - `getWritingSuggestions()` for text improvement
- **Design feedback** - `getDesignFeedback()` for design advice

#### 🛠️ Helper Functions
- **Image URL extraction** - `extractImageUrls()` for processing multimodal responses
- **Text content extraction** - `extractTextContent()` for separating text from URLs

### 🔧 Technical Features
- **User identification** - Custom user and channel IDs
- **Error handling** - Proper exception handling
- **Type safety** - Full Dart type safety
- **Lightweight** - Minimal dependencies
- **Web optimized** - Flutter web support with proper error handling

### 📱 Example App
- **Material 3 design** - Modern UI with dynamic color support
- **Responsive layout** - Works on all screen sizes
- **Shape search** - Find and chat with any public shape
- **Multimodal chat** - Support for text, images, and audio
- **Image generation** - Generate AI images with proper display

### 📚 Documentation
- **Complete README** - Comprehensive function reference
- **API documentation** - Detailed function documentation
- **Code examples** - 50+ function examples
- **Quick start guide** - Simple 3-step setup