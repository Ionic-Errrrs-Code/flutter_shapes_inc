import 'client/shapes_api_client.dart';
import 'models/shapes_api_models.dart';
import 'exceptions/shapes_api_exceptions.dart';

/// Simple functions for easy Shapes API integration
class ShapesAPI {
  static ShapesApiClient? _client;

  /// Initialize the API with your key
  static void initialize(
    String apiKey, {
    String? userId,
    String? channelId,
    String baseUrl = 'https://api.shapes.inc/v1',
  }) {
    _client = ShapesApiClient(ShapesApiConfig(
      apiKey: apiKey,
      userId: userId,
      channelId: channelId,
      baseUrl: baseUrl,
    ));
  }

  /// Get a shape's profile
  static Future<ShapeProfile> getShapeProfile(String username) async {
    _checkInitialized();
    return await _client!.getShapeProfile(username);
  }

  /// Send a text message to a shape
  static Future<String> sendMessage(
      String shapeUsername, String message) async {
    _checkInitialized();
    final response = await _client!.sendTextMessage(
      shapeUsername: shapeUsername,
      message: message,
    );

    if (response.choices.isNotEmpty) {
      final content = response.choices.first.message.content;
      if (content is String) {
        return content;
      } else if (content is List) {
        // Handle multimodal content (e.g., text + image)
        final parts = content;
        final textParts = parts
            .where((part) => part is ContentPart && part.type == 'text')
            .toList();
        final imageParts = parts
            .where((part) => part is ContentPart && part.type == 'image_url')
            .toList();

        String result = '';
        if (textParts.isNotEmpty) {
          result +=
              textParts.map((part) => (part as ContentPart).text).join(' ');
        }
        if (imageParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Generated images:\n';
          result += imageParts
              .map((part) => (part as ContentPart).imageUrl?.url)
              .join('\n');
        }
        return result;
      }
    }

    return 'No response received';
  }

  /// Send a message with an image
  static Future<String> sendImageMessage(
      String shapeUsername, String message, String imageUrl) async {
    _checkInitialized();
    final response = await _client!.sendImageMessage(
      shapeUsername: shapeUsername,
      message: message,
      imageUrl: imageUrl,
    );

    if (response.choices.isNotEmpty) {
      final content = response.choices.first.message.content;
      if (content is String) {
        return content;
      } else if (content is List) {
        // Handle multimodal content (e.g., text + image)
        final parts = content;
        final textParts = parts
            .where((part) => part is ContentPart && part.type == 'text')
            .toList();
        final imageParts = parts
            .where((part) => part is ContentPart && part.type == 'image_url')
            .toList();

        String result = '';
        if (textParts.isNotEmpty) {
          result +=
              textParts.map((part) => (part as ContentPart).text).join(' ');
        }
        if (imageParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Images in response:\n';
          result += imageParts
              .map((part) => (part as ContentPart).imageUrl?.url)
              .join('\n');
        }
        return result;
      }
    }

    return 'No response received';
  }

  /// Send a message with audio
  static Future<String> sendAudioMessage(
      String shapeUsername, String message, String audioUrl) async {
    _checkInitialized();
    final response = await _client!.sendAudioMessage(
      shapeUsername: shapeUsername,
      message: message,
      audioUrl: audioUrl,
    );

    if (response.choices.isNotEmpty) {
      final content = response.choices.first.message.content;
      if (content is String) {
        return content;
      } else if (content is List) {
        // Handle multimodal content (e.g., text + audio)
        final parts = content;
        final textParts = parts
            .where((part) => part is ContentPart && part.type == 'text')
            .toList();
        final audioParts = parts
            .where((part) => part is ContentPart && part.type == 'audio_url')
            .toList();

        String result = '';
        if (textParts.isNotEmpty) {
          result +=
              textParts.map((part) => (part as ContentPart).text).join(' ');
        }
        if (audioParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Audio in response:\n';
          result += audioParts
              .map((part) => (part as ContentPart).audioUrl?.url)
              .join('\n');
        }
        return result;
      }
    }

    return 'No response received';
  }

  /// Send a message with multiple images
  static Future<String> sendMultiImageMessage(
      String shapeUsername, String message, List<String> imageUrls) async {
    _checkInitialized();
    final content = [
      ContentPart.text(message),
      ...imageUrls.map((url) => ContentPart.image(url)),
    ];

    final messages = [ShapesMessage.userMultimodal(content)];
    final response = await _client!.createChatCompletion(
      shapeUsername: shapeUsername,
      messages: messages,
    );

    if (response.choices.isNotEmpty) {
      final content = response.choices.first.message.content;
      if (content is String) {
        return content;
      } else if (content is List) {
        // Handle multimodal content (e.g., text + image)
        final parts = content;
        final textParts = parts
            .where((part) => part is ContentPart && part.type == 'text')
            .toList();
        final imageParts = parts
            .where((part) => part is ContentPart && part.type == 'image_url')
            .toList();

        String result = '';
        if (textParts.isNotEmpty) {
          result +=
              textParts.map((part) => (part as ContentPart).text).join(' ');
        }
        if (imageParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Images in response:\n';
          result += imageParts
              .map((part) => (part as ContentPart).imageUrl?.url)
              .join('\n');
        }
        return result;
      }
    }

    return 'No response received';
  }

  /// Send a message with image and audio
  static Future<String> sendImageAudioMessage(String shapeUsername,
      String message, String imageUrl, String audioUrl) async {
    _checkInitialized();
    final content = [
      ContentPart.text(message),
      ContentPart.image(imageUrl),
      ContentPart.audio(audioUrl),
    ];

    final messages = [ShapesMessage.userMultimodal(content)];
    final response = await _client!.createChatCompletion(
      shapeUsername: shapeUsername,
      messages: messages,
    );

    if (response.choices.isNotEmpty) {
      final content = response.choices.first.message.content;
      if (content is String) {
        return content;
      } else if (content is List) {
        // Handle multimodal content (e.g., text + image + audio)
        final parts = content;
        final textParts = parts
            .where((part) => part is ContentPart && part.type == 'text')
            .toList();
        final imageParts = parts
            .where((part) => part is ContentPart && part.type == 'image_url')
            .toList();
        final audioParts = parts
            .where((part) => part is ContentPart && part.type == 'audio_url')
            .toList();

        String result = '';
        if (textParts.isNotEmpty) {
          result +=
              textParts.map((part) => (part as ContentPart).text).join(' ');
        }
        if (imageParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Images in response:\n';
          result += imageParts
              .map((part) => (part as ContentPart).imageUrl?.url)
              .join('\n');
        }
        if (audioParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Audio in response:\n';
          result += audioParts
              .map((part) => (part as ContentPart).audioUrl?.url)
              .join('\n');
        }
        return result;
      }
    }

    return 'No response received';
  }

  /// Create a custom chat completion with multiple messages
  static Future<String> createChatCompletion(
      String shapeUsername, List<ShapesMessage> messages) async {
    _checkInitialized();
    final response = await _client!.createChatCompletion(
      shapeUsername: shapeUsername,
      messages: messages,
    );

    if (response.choices.isNotEmpty) {
      final content = response.choices.first.message.content;
      if (content is String) {
        return content;
      } else if (content is List) {
        // Handle multimodal content (e.g., text + image + audio)
        final parts = content;
        final textParts = parts
            .where((part) => part is ContentPart && part.type == 'text')
            .toList();
        final imageParts = parts
            .where((part) => part is ContentPart && part.type == 'image_url')
            .toList();
        final audioParts = parts
            .where((part) => part is ContentPart && part.type == 'audio_url')
            .toList();

        String result = '';
        if (textParts.isNotEmpty) {
          result +=
              textParts.map((part) => (part as ContentPart).text).join(' ');
        }
        if (imageParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Images in response:\n';
          result += imageParts
              .map((part) => (part as ContentPart).imageUrl?.url)
              .join('\n');
        }
        if (audioParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Audio in response:\n';
          result += audioParts
              .map((part) => (part as ContentPart).audioUrl?.url)
              .join('\n');
        }
        return result;
      }
    }

    return 'No response received';
  }

  /// Get multiple shape profiles at once
  static Future<List<ShapeProfile>> getShapeProfiles(
      List<String> usernames) async {
    _checkInitialized();
    return await _client!.getShapeProfiles(usernames);
  }

  /// Test the API connection
  static Future<bool> testConnection() async {
    _checkInitialized();
    return await _client!.testConnection();
  }

  /// Get API usage statistics
  static Future<Map<String, dynamic>> getUsageStats() async {
    _checkInitialized();
    return await _client!.getUsageStats();
  }

  /// Get popular shapes
  static Future<List<ShapeProfile>> getPopularShapes({int limit = 20}) async {
    _checkInitialized();
    return await _client!.getPopularShapes(limit: limit);
  }

  /// Quick chat - simplest way to chat with a shape
  static Future<String> quickChat(String shapeUsername, String message) async {
    _checkInitialized();
    return await _client!.quickChat(shapeUsername, message);
  }

  /// Reset a shape's memory
  static Future<String> resetShape(String shapeUsername) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!reset');
  }

  /// Get shape info
  static Future<String> getShapeInfo(String shapeUsername) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!info');
  }

  /// Search the web with a shape
  static Future<String> searchWeb(String shapeUsername, String query) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!web $query');
  }

  /// Generate an image with a shape
  static Future<String> generateImage(
      String shapeUsername, String prompt) async {
    _checkInitialized();
    final response = await _client!.sendTextMessage(
      shapeUsername: shapeUsername,
      message: '!imagine $prompt',
    );

    if (response.choices.isNotEmpty) {
      final content = response.choices.first.message.content;
      if (content is String) {
        return content;
      } else if (content is List) {
        // Handle multimodal content that may contain image URLs
        final parts = content;
        final textParts = parts
            .where((part) => part is ContentPart && part.type == 'text')
            .toList();
        final imageParts = parts
            .where((part) => part is ContentPart && part.type == 'image_url')
            .toList();

        String result = '';
        if (textParts.isNotEmpty) {
          result +=
              textParts.map((part) => (part as ContentPart).text).join(' ');
        }
        if (imageParts.isNotEmpty) {
          if (result.isNotEmpty) result += '\n\n';
          result += 'Generated images:\n';
          result += imageParts
              .map((part) => (part as ContentPart).imageUrl?.url)
              .join('\n');
        }
        return result;
      }
    }

    return 'No response received';
  }

  /// Get help from a shape
  static Future<String> getHelp(String shapeUsername) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!help');
  }

  /// Get weather information with a shape
  static Future<String> getWeather(
      String shapeUsername, String location) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!weather $location');
  }

  /// Get current time with a shape
  static Future<String> getCurrentTime(String shapeUsername,
      [String? timezone]) async {
    _checkInitialized();
    final command = timezone != null ? '!time $timezone' : '!time';
    return await sendMessage(shapeUsername, command);
  }

  /// Get news with a shape
  static Future<String> getNews(String shapeUsername, [String? topic]) async {
    _checkInitialized();
    final command = topic != null ? '!news $topic' : '!news';
    return await sendMessage(shapeUsername, command);
  }

  /// Get stock information with a shape
  static Future<String> getStockInfo(
      String shapeUsername, String symbol) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!stock $symbol');
  }

  /// Get cryptocurrency information with a shape
  static Future<String> getCryptoInfo(
      String shapeUsername, String symbol) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!crypto $symbol');
  }

  /// Get translation with a shape
  static Future<String> translate(
      String shapeUsername, String text, String targetLanguage) async {
    _checkInitialized();
    return await sendMessage(
        shapeUsername, '!translate $text to $targetLanguage');
  }

  /// Get math calculation with a shape
  static Future<String> calculate(
      String shapeUsername, String expression) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!calculate $expression');
  }

  /// Get unit conversion with a shape
  static Future<String> convert(String shapeUsername, String value,
      String fromUnit, String toUnit) async {
    _checkInitialized();
    return await sendMessage(
        shapeUsername, '!convert $value $fromUnit to $toUnit');
  }

  /// Get definition of a word with a shape
  static Future<String> define(String shapeUsername, String word) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!define $word');
  }

  /// Get synonyms of a word with a shape
  static Future<String> getSynonyms(String shapeUsername, String word) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!synonyms $word');
  }

  /// Get antonyms of a word with a shape
  static Future<String> getAntonyms(String shapeUsername, String word) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!antonyms $word');
  }

  /// Get random joke with a shape
  static Future<String> getJoke(String shapeUsername,
      [String? category]) async {
    _checkInitialized();
    final command = category != null ? '!joke $category' : '!joke';
    return await sendMessage(shapeUsername, command);
  }

  /// Get random quote with a shape
  static Future<String> getQuote(String shapeUsername, [String? author]) async {
    _checkInitialized();
    final command = author != null ? '!quote $author' : '!quote';
    return await sendMessage(shapeUsername, command);
  }

  /// Get random fact with a shape
  static Future<String> getFact(String shapeUsername, [String? topic]) async {
    _checkInitialized();
    final command = topic != null ? '!fact $topic' : '!fact';
    return await sendMessage(shapeUsername, command);
  }

  /// Get random trivia with a shape
  static Future<String> getTrivia(String shapeUsername,
      [String? category]) async {
    _checkInitialized();
    final command = category != null ? '!trivia $category' : '!trivia';
    return await sendMessage(shapeUsername, command);
  }

  /// Get movie information with a shape
  static Future<String> getMovieInfo(String shapeUsername, String title) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!movie $title');
  }

  /// Get book information with a shape
  static Future<String> getBookInfo(String shapeUsername, String title) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!book $title');
  }

  /// Get song information with a shape
  static Future<String> getSongInfo(String shapeUsername, String title) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!song $title');
  }

  /// Get game information with a shape
  static Future<String> getGameInfo(String shapeUsername, String title) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!game $title');
  }

  /// Get recipe with a shape
  static Future<String> getRecipe(String shapeUsername, String dish) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!recipe $dish');
  }

  /// Get workout plan with a shape
  static Future<String> getWorkout(String shapeUsername, [String? goal]) async {
    _checkInitialized();
    final command = goal != null ? '!workout $goal' : '!workout';
    return await sendMessage(shapeUsername, command);
  }

  /// Get meditation guidance with a shape
  static Future<String> getMeditation(String shapeUsername,
      [String? type]) async {
    _checkInitialized();
    final command = type != null ? '!meditation $type' : '!meditation';
    return await sendMessage(shapeUsername, command);
  }

  /// Get travel recommendations with a shape
  static Future<String> getTravelRecommendations(
      String shapeUsername, String destination) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!travel $destination');
  }

  /// Get language learning help with a shape
  static Future<String> learnLanguage(
      String shapeUsername, String language, String phrase) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!learn $language: $phrase');
  }

  /// Get coding help with a shape
  static Future<String> getCodingHelp(
      String shapeUsername, String language, String problem) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!code $language: $problem');
  }

  /// Get debugging help with a shape
  static Future<String> getDebuggingHelp(
      String shapeUsername, String error) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!debug $error');
  }

  /// Get code review with a shape
  static Future<String> getCodeReview(String shapeUsername, String code) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!review $code');
  }

  /// Get algorithm explanation with a shape
  static Future<String> explainAlgorithm(
      String shapeUsername, String algorithm) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!algorithm $algorithm');
  }

  /// Get design feedback with a shape
  static Future<String> getDesignFeedback(
      String shapeUsername, String description) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!design $description');
  }

  /// Get writing help with a shape
  static Future<String> getWritingHelp(String shapeUsername, String text,
      [String? type]) async {
    _checkInitialized();
    final command = type != null ? '!write $type: $text' : '!write: $text';
    return await sendMessage(shapeUsername, command);
  }

  /// Get grammar check with a shape
  static Future<String> checkGrammar(String shapeUsername, String text) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!grammar $text');
  }

  /// Get writing suggestions with a shape
  static Future<String> getWritingSuggestions(
      String shapeUsername, String text) async {
    _checkInitialized();
    return await sendMessage(shapeUsername, '!suggest $text');
  }

  /// Extract image URLs from a multimodal response
  static List<String> extractImageUrls(String response) {
    final List<String> imageUrls = [];

    // Split response into lines and look for URLs
    final lines = response.split('\n');

    for (String line in lines) {
      final trimmedLine = line.trim();

      // Check if the line looks like a URL (starts with http:// or https://)
      if (trimmedLine.startsWith('http://') ||
          trimmedLine.startsWith('https://')) {
        // Additional validation: check if it ends with common image extensions
        if (trimmedLine.contains('.png') ||
            trimmedLine.contains('.jpg') ||
            trimmedLine.contains('.jpeg') ||
            trimmedLine.contains('.gif') ||
            trimmedLine.contains('.webp') ||
            trimmedLine.contains('files.shapes.inc/')) {
          // Specific to Shapes API
          imageUrls.add(trimmedLine);
        }
      }
    }

    return imageUrls;
  }

  /// Extract text content from a multimodal response
  static String extractTextContent(String response) {
    // Split response into lines
    final lines = response.split('\n');
    final List<String> textLines = [];

    for (String line in lines) {
      final trimmedLine = line.trim();

      // Skip empty lines and URL lines
      if (trimmedLine.isEmpty) continue;
      if (trimmedLine.startsWith('http://') ||
          trimmedLine.startsWith('https://')) continue;

      // Add non-URL lines to text content
      textLines.add(trimmedLine);
    }

    return textLines.join(' ').trim();
  }

  static void _checkInitialized() {
    if (_client == null) {
      throw ShapesApiUnavailableException(
          'ShapesAPI not initialized. Call ShapesAPI.initialize(apiKey) first.');
    }
  }
}
