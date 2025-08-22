import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';

class ShapesService {
  static final ShapesService _instance = ShapesService._internal();
  factory ShapesService() => _instance;
  ShapesService._internal();

  // Cache for popular shapes
  List<ShapeProfile>? _cachedPopularShapes;
  DateTime? _lastFetch;

  // Get popular shapes with caching
  Future<List<ShapeProfile>> getPopularShapes(
      {bool forceRefresh = false}) async {
    final now = DateTime.now();

    // Return cached data if it's less than 5 minutes old
    if (!forceRefresh &&
        _cachedPopularShapes != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!).inMinutes < 5) {
      return _cachedPopularShapes!;
    }

    try {
      final shapes = await ShapesAPI.getPopularShapes(limit: 10);
      _cachedPopularShapes = shapes;
      _lastFetch = now;
      return shapes;
    } catch (e) {
      // Return cached data if available, otherwise empty list
      return _cachedPopularShapes ?? [];
    }
  }

  // Get shape profile with error handling
  Future<ShapeProfile?> getShapeProfile(String username) async {
    try {
      return await ShapesAPI.getShapeProfile(username);
    } catch (e) {
      return null;
    }
  }

  // Send message with error handling
  Future<String> sendMessage(String shapeUsername, String message) async {
    try {
      return await ShapesAPI.sendMessage(shapeUsername, message);
    } catch (e) {
      return 'Sorry, I encountered an error: ${e.toString()}';
    }
  }

  // Send image message with error handling
  Future<String> sendImageMessage(
      String shapeUsername, String message, String imageUrl) async {
    try {
      return await ShapesAPI.sendImageMessage(shapeUsername, message, imageUrl);
    } catch (e) {
      return 'Sorry, I encountered an error processing your image: ${e.toString()}';
    }
  }

  // Send audio message with error handling
  Future<String> sendAudioMessage(
      String shapeUsername, String message, String audioUrl) async {
    try {
      return await ShapesAPI.sendAudioMessage(shapeUsername, message, audioUrl);
    } catch (e) {
      return 'Sorry, I encountered an error processing your audio: ${e.toString()}';
    }
  }

  // Generate image with error handling
  Future<Map<String, dynamic>> generateImage(
      String shapeUsername, String prompt) async {
    try {
      final response = await ShapesAPI.generateImage(shapeUsername, prompt);

      // Extract image URLs and text content from the response
      final imageUrls = ShapesAPI.extractImageUrls(response);
      final textContent = ShapesAPI.extractTextContent(response);

      return {
        'text': textContent,
        'imageUrls': imageUrls,
        'fullResponse': response,
      };
    } catch (e) {
      return {
        'text':
            'Sorry, I encountered an error generating the image: ${e.toString()}',
        'imageUrls': [],
        'fullResponse':
            'Sorry, I encountered an error generating the image: ${e.toString()}',
      };
    }
  }

  // Get weather information
  Future<String> getWeather(String shapeUsername, String location) async {
    try {
      return await ShapesAPI.getWeather(shapeUsername, location);
    } catch (e) {
      return 'Sorry, I couldn\'t get weather information: ${e.toString()}';
    }
  }

  // Get news
  Future<String> getNews(String shapeUsername, [String? topic]) async {
    try {
      return await ShapesAPI.getNews(shapeUsername, topic);
    } catch (e) {
      return 'Sorry, I couldn\'t get news information: ${e.toString()}';
    }
  }

  // Get joke
  Future<String> getJoke(String shapeUsername, [String? category]) async {
    try {
      return await ShapesAPI.getJoke(shapeUsername, category);
    } catch (e) {
      return 'Sorry, I couldn\'t get a joke: ${e.toString()}';
    }
  }

  // Get quote
  Future<String> getQuote(String shapeUsername, [String? author]) async {
    try {
      return await ShapesAPI.getQuote(shapeUsername, author);
    } catch (e) {
      return 'Sorry, I couldn\'t get a quote: ${e.toString()}';
    }
  }

  // Get fact
  Future<String> getFact(String shapeUsername, [String? topic]) async {
    try {
      return await ShapesAPI.getFact(shapeUsername, topic);
    } catch (e) {
      return 'Sorry, I couldn\'t get a fact: ${e.toString()}';
    }
  }

  // Get recipe
  Future<String> getRecipe(String shapeUsername, String dish) async {
    try {
      return await ShapesAPI.getRecipe(shapeUsername, dish);
    } catch (e) {
      return 'Sorry, I couldn\'t get the recipe: ${e.toString()}';
    }
  }

  // Get workout plan
  Future<String> getWorkout(String shapeUsername, [String? goal]) async {
    try {
      return await ShapesAPI.getWorkout(shapeUsername, goal);
    } catch (e) {
      return 'Sorry, I couldn\'t get workout information: ${e.toString()}';
    }
  }

  // Translate text
  Future<String> translate(
      String shapeUsername, String text, String targetLanguage) async {
    try {
      return await ShapesAPI.translate(shapeUsername, text, targetLanguage);
    } catch (e) {
      return 'Sorry, I couldn\'t translate the text: ${e.toString()}';
    }
  }

  // Get coding help
  Future<String> getCodingHelp(
      String shapeUsername, String language, String problem) async {
    try {
      return await ShapesAPI.getCodingHelp(shapeUsername, language, problem);
    } catch (e) {
      return 'Sorry, I couldn\'t help with coding: ${e.toString()}';
    }
  }

  // Calculate expression
  Future<String> calculate(String shapeUsername, String expression) async {
    try {
      return await ShapesAPI.calculate(shapeUsername, expression);
    } catch (e) {
      return 'Sorry, I couldn\'t calculate that: ${e.toString()}';
    }
  }

  // Test API connection
  Future<bool> testConnection() async {
    try {
      return await ShapesAPI.testConnection();
    } catch (e) {
      return false;
    }
  }

  // Clear cache
  void clearCache() {
    _cachedPopularShapes = null;
    _lastFetch = null;
  }
}

// Chat message model for UI
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final String? audioUrl;
  final MessageType type;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.audioUrl,
    this.type = MessageType.text,
  });
}

enum MessageType {
  text,
  image,
  audio,
  multimodal,
}

// Feature categories for the app
enum FeatureCategory {
  chat,
  information,
  entertainment,
  learning,
  lifestyle,
  utilities,
}

class Feature {
  final String name;
  final String description;
  final String icon;
  final FeatureCategory category;
  final Function(String shapeUsername, Map<String, String> params) execute;

  Feature({
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.execute,
  });
}

class FeaturesProvider {
  static List<Feature> getAllFeatures() {
    return [
      // Information
      Feature(
        name: 'Weather',
        description: 'Get weather information for any location',
        icon: '🌤️',
        category: FeatureCategory.information,
        execute: (shape, params) =>
            ShapesService().getWeather(shape, params['location'] ?? 'New York'),
      ),
      Feature(
        name: 'News',
        description: 'Get latest news and updates',
        icon: '📰',
        category: FeatureCategory.information,
        execute: (shape, params) =>
            ShapesService().getNews(shape, params['topic']),
      ),

      // Entertainment
      Feature(
        name: 'Jokes',
        description: 'Get funny jokes and humor',
        icon: '😄',
        category: FeatureCategory.entertainment,
        execute: (shape, params) =>
            ShapesService().getJoke(shape, params['category']),
      ),
      Feature(
        name: 'Quotes',
        description: 'Get inspirational quotes',
        icon: '💭',
        category: FeatureCategory.entertainment,
        execute: (shape, params) =>
            ShapesService().getQuote(shape, params['author']),
      ),
      Feature(
        name: 'Facts',
        description: 'Learn interesting facts',
        icon: '🧠',
        category: FeatureCategory.entertainment,
        execute: (shape, params) =>
            ShapesService().getFact(shape, params['topic']),
      ),

      // Learning
      Feature(
        name: 'Coding Help',
        description: 'Get programming assistance',
        icon: '💻',
        category: FeatureCategory.learning,
        execute: (shape, params) => ShapesService().getCodingHelp(
            shape,
            params['language'] ?? 'Python',
            params['problem'] ?? 'General help'),
      ),
      Feature(
        name: 'Translation',
        description: 'Translate text between languages',
        icon: '🌍',
        category: FeatureCategory.learning,
        execute: (shape, params) => ShapesService().translate(
            shape, params['text'] ?? 'Hello', params['language'] ?? 'Spanish'),
      ),

      // Lifestyle
      Feature(
        name: 'Recipes',
        description: 'Get cooking recipes and instructions',
        icon: '👨‍🍳',
        category: FeatureCategory.lifestyle,
        execute: (shape, params) =>
            ShapesService().getRecipe(shape, params['dish'] ?? 'pasta'),
      ),
      Feature(
        name: 'Workouts',
        description: 'Get fitness and exercise plans',
        icon: '💪',
        category: FeatureCategory.lifestyle,
        execute: (shape, params) =>
            ShapesService().getWorkout(shape, params['goal']),
      ),

      // Utilities
      Feature(
        name: 'Calculator',
        description: 'Perform mathematical calculations',
        icon: '🧮',
        category: FeatureCategory.utilities,
        execute: (shape, params) =>
            ShapesService().calculate(shape, params['expression'] ?? '2+2'),
      ),
      Feature(
        name: 'Image Generation',
        description: 'Generate AI images from text',
        icon: '🎨',
        category: FeatureCategory.utilities,
        execute: (shape, params) => ShapesService()
            .generateImage(shape, params['prompt'] ?? 'a beautiful sunset'),
      ),
    ];
  }

  static List<Feature> getFeaturesByCategory(FeatureCategory category) {
    return getAllFeatures()
        .where((feature) => feature.category == category)
        .toList();
  }
}
