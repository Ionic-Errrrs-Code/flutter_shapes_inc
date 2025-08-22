# Shapes Chat - Flutter Example App

A beautiful, sophisticated Material 3 example app showcasing the full capabilities of the Flutter Shapes package. This app demonstrates how to integrate with the Shapes Inc API to create an engaging chatbot experience with multiple screens and features.

## ✨ Features

### 🎨 Beautiful Material 3 Design
- Modern, aesthetic UI following Material 3 guidelines
- Dynamic color support with system theme integration
- Smooth animations and transitions
- Responsive design for different screen sizes

### 💬 Chat Functionality
- **Real-time Chat**: Chat with any AI shape from the Shapes Inc platform
- **Message Types**: Support for text, images, and multimodal content
- **Typing Indicators**: Animated typing indicators for better UX
- **Message History**: Persistent chat history with clear functionality
- **Attachment Support**: Send images via URL or generate AI images

### 🤖 AI Shape Integration
- **Shape Browser**: Discover and search through available AI shapes
- **Popular Shapes**: Curated list of trending and popular shapes
- **Shape Profiles**: Detailed information about each AI personality
- **Category Filtering**: Browse shapes by category (Entertainment, Education, etc.)

### 🚀 Advanced Features
- **Image Generation**: Create AI-generated images from text descriptions
- **Weather Information**: Get real-time weather data for any location
- **News Updates**: Access latest news and current events
- **Entertainment**: Jokes, quotes, facts, and more
- **Learning Tools**: Coding help, translation, and educational content
- **Lifestyle**: Recipes, workout plans, and wellness tips
- **Utilities**: Calculator, file processing, and productivity tools

### ⚙️ App Management
- **Settings Panel**: Configure API keys, preferences, and app behavior
- **Connection Status**: Real-time API connection monitoring
- **Cache Management**: Clear cache and refresh data
- **Theme Support**: Light/dark mode and system theme integration

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- Shapes Inc API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_shapes/example
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   - Open `lib/main.dart`
   - Replace `'your-shapes-inc-api-key-here'` with your actual Shapes Inc API key
   - Optionally customize `userId` and `channelId`

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔑 API Configuration

The app requires a valid Shapes Inc API key to function. You can configure this in several ways:

### Method 1: Direct in Code
```dart
const String apiKey = 'your-actual-api-key-here';
```

### Method 2: Through Settings
1. Navigate to the Settings tab
2. Tap on "API Key"
3. Enter your API key and other configuration
4. Test the connection

### Required Parameters
- **API Key**: Your Shapes Inc API key (required)
- **User ID**: Unique identifier for the user (optional)
- **Channel ID**: Session identifier (optional, auto-generated if not provided)

## 📱 App Structure

### Screens
1. **Dashboard**: Welcome screen with quick actions and popular shapes
2. **Shapes Browser**: Discover and search AI shapes
3. **Features**: Explore different API capabilities
4. **Settings**: App configuration and API management
5. **Chat**: Individual chat sessions with AI shapes

### Navigation
- Bottom navigation bar for main sections
- Floating action button for quick chat access
- Tab-based organization within screens
- Smooth page transitions and animations

## 🎯 Usage Examples

### Starting a Chat
1. Navigate to the Shapes tab
2. Browse available shapes or search for specific ones
3. Tap on a shape to start chatting
4. Send messages and receive AI responses

### Generating Images
1. In any chat, tap the attachment button (+)
2. Select "Generate Image"
3. Describe the image you want
4. Wait for AI-generated image

### Using Quick Actions
1. From the Dashboard, use the Quick Actions grid
2. Try different features like weather, news, or jokes
3. Each action demonstrates a specific API capability

### Exploring Features
1. Navigate to the Features tab
2. Browse features by category
3. Tap on any feature to test it
4. Results open in a chat session

## 🎨 Customization

### Themes
The app supports Material 3 theming with:
- Dynamic color support
- Light/dark mode
- Custom color schemes
- System theme integration

### UI Components
- `GradientContainer`: Beautiful gradient backgrounds
- `AnimatedCard`: Interactive cards with animations
- Custom Material 3 components
- Responsive layouts

### Adding New Features
1. Extend the `FeaturesProvider` class
2. Add new feature definitions
3. Implement feature execution logic
4. Update the UI to display new features

## 🔧 Development

### Project Structure
```
lib/
├── main.dart              # App entry point and configuration
├── screens/               # UI screens
│   ├── home_screen.dart   # Main navigation and dashboard
│   ├── chat_screen.dart   # Chat interface
│   ├── features_screen.dart # Feature showcase
│   ├── settings_screen.dart # App settings
│   └── shape_browser_screen.dart # Shape discovery
├── services/              # Business logic
│   └── shapes_service.dart # API integration
└── utils/                 # Utilities
    └── theme.dart         # Theme and UI components
```

### Key Classes
- **ShapesService**: Handles all API interactions
- **Feature**: Represents individual API capabilities
- **ChatMessage**: Chat message data structure
- **ShapeProfile**: AI shape information

### Error Handling
- Comprehensive error handling for API calls
- User-friendly error messages
- Fallback mechanisms for failed requests
- Connection status monitoring

## 🐛 Troubleshooting

### Common Issues

**API Connection Failed**
- Verify your API key is correct
- Check internet connectivity
- Ensure the API key has proper permissions

**Shapes Not Loading**
- Check API connection status
- Verify API key configuration
- Clear app cache and retry

**Chat Not Working**
- Ensure you're connected to the internet
- Check if the specific shape is available
- Try refreshing the shapes list

### Debug Mode
Enable debug mode for detailed logging:
```dart
// In main.dart
debugShowCheckedModeBanner: true,
```

## 📚 API Reference

This example app demonstrates the following Shapes Inc API endpoints:

- `getPopularShapes()` - Fetch trending shapes
- `getShapeProfile()` - Get shape details
- `sendMessage()` - Send text messages
- `sendImageMessage()` - Send image messages
- `generateImage()` - Generate AI images
- `getWeather()` - Weather information
- `getNews()` - News updates
- `getJoke()` - Entertainment content
- `getQuote()` - Inspirational quotes
- `getFact()` - Educational facts
- `getRecipe()` - Cooking recipes
- `getWorkout()` - Fitness plans
- `translate()` - Language translation
- `getCodingHelp()` - Programming assistance
- `calculate()` - Mathematical calculations

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:

- Bug fixes
- New features
- UI/UX improvements
- Documentation updates
- Performance optimizations

## 📄 License

This example app is part of the Flutter Shapes package and follows the same license terms.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the troubleshooting section above
2. Review the API documentation
3. Open an issue on GitHub
4. Contact Shapes Inc support for API-related issues

---

**Happy Chatting! 🚀✨**

This example app showcases the power and flexibility of the Flutter Shapes package. Use it as a reference for building your own AI-powered applications or as a starting point for custom implementations.
