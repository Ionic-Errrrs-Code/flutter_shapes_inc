/// App configuration constants
class AppConfig {
  // API Configuration
  static const String defaultApiKey =
      'KIIGYWIPFCMX5XB5QF731GOBXWWUFSPPKZXKAECTHNG';
  static const String defaultUserId = 'flutter-demo-user';
  static const String defaultChannelId = 'demo-session';

  // App Settings
  static const String appName = 'Shapes Chat';
  static const String appVersion = '1.0.1';
  static const String appDescription =
      'A beautiful example app showcasing the Flutter Shapes package';

  // Feature Flags
  static const bool enableImageGeneration = true;
  static const bool enableVoiceMessages = false;
  static const bool enableFileUploads = false;
  static const bool enablePushNotifications = false;

  // UI Configuration
  static const double defaultBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Cache Configuration
  static const int cacheExpiryMinutes = 5;
  static const int maxCachedShapes = 50;

  // Chat Configuration
  static const int maxMessageLength = 1000;
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];

  // Error Messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String apiErrorMessage =
      'API error. Please check your configuration.';

  // Success Messages
  static const String messageSentMessage = 'Message sent successfully!';
  static const String imageGeneratedMessage = 'Image generated successfully!';
  static const String settingsSavedMessage = 'Settings saved successfully!';

  // Quick Actions
  static const List<Map<String, dynamic>> quickActions = [
    {
      'title': 'Start Chat',
      'icon': 'chat_bubble_outline',
      'description': 'Begin a conversation with an AI shape',
      'action': 'navigate_to_shapes',
    },
    {
      'title': 'Generate Image',
      'icon': 'palette',
      'description': 'Create AI-generated images from text',
      'action': 'generate_image',
    },
    {
      'title': 'Explore Features',
      'icon': 'extension',
      'description': 'Try different API capabilities',
      'action': 'navigate_to_features',
    },
    {
      'title': 'Quick Help',
      'icon': 'help',
      'description': 'Get help and learn how to use the app',
      'action': 'show_help',
    },
  ];

  // Feature Categories
  static const List<Map<String, dynamic>> featureCategories = [
    {
      'name': 'Information',
      'icon': 'info',
      'description': 'Get real-time information and updates',
      'color': 'primary',
    },
    {
      'name': 'Entertainment',
      'icon': 'entertainment',
      'description': 'Fun and engaging content',
      'color': 'secondary',
    },
    {
      'name': 'Learning',
      'icon': 'school',
      'description': 'Educational tools and resources',
      'color': 'tertiary',
    },
    {
      'name': 'Lifestyle',
      'icon': 'fitness_center',
      'description': 'Health, fitness, and lifestyle tips',
      'color': 'primary',
    },
    {
      'name': 'Utilities',
      'icon': 'build',
      'description': 'Practical tools and calculators',
      'color': 'secondary',
    },
  ];

  // Demo Messages
  static const List<String> demoMessages = [
    'Hello! How can I help you today?',
    'Tell me about yourself',
    'What would you like to know?',
    'I\'m here to assist you with anything you need',
    'Let\'s start a conversation!',
  ];

  // Help Content
  static const Map<String, String> helpContent = {
    'getting_started': '''
Getting Started:
1. Configure your API key in Settings
2. Browse available shapes in the Shapes tab
3. Start chatting with any shape
4. Explore features in the Features tab
5. Customize settings as needed
''',
    'special_commands': '''
Special Commands:
• !imagine [description] - Generate an image
• !weather [location] - Get weather info
• !news [topic] - Get latest news
• !joke [category] - Get a joke
• !quote [author] - Get a quote
• !fact [topic] - Get a fact
• !recipe [dish] - Get a recipe
• !workout [goal] - Get workout plan
• !translate [text] [language] - Translate text
• !code [language] [problem] - Get coding help
• !calculate [expression] - Calculate math
''',
    'troubleshooting': '''
Troubleshooting:
• Check your API key configuration
• Ensure internet connectivity
• Clear cache if shapes don't load
• Restart the app if issues persist
• Check the connection status in Settings
''',
  };
}
