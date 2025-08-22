import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/shapes_api_models.dart';
import '../exceptions/shapes_api_exceptions.dart';

/// Comprehensive helper utilities for Shapes API
class ShapesApiHelpers {
  /// Convert a string to base64 for file uploads
  static String stringToBase64(String input) {
    return base64Encode(utf8.encode(input));
  }

  /// Convert bytes to base64
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate image URL
  static bool isValidImageUrl(String url) {
    if (!isValidUrl(url)) return false;

    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerUrl = url.toLowerCase();

    return imageExtensions.any((ext) => lowerUrl.contains(ext));
  }

  /// Validate audio URL
  static bool isValidAudioUrl(String url) {
    if (!isValidUrl(url)) return false;

    final audioExtensions = ['.mp3', '.wav', '.ogg', '.m4a', '.aac'];
    final lowerUrl = url.toLowerCase();

    return audioExtensions.any((ext) => lowerUrl.contains(ext));
  }

  /// Format timestamp to readable date
  static String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  /// Format number with K, M, B suffixes
  static String formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) return '${(number / 1000).toStringAsFixed(1)}K';
    if (number < 1000000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  }

  /// Extract text content from message
  static String extractTextContent(ShapesMessage message) {
    if (message.content is String) {
      return message.content as String;
    } else if (message.content is List) {
      final content = message.content as List;
      final textParts = content
          .where((item) =>
              item is ContentPart && item.type == 'text' && item.text != null)
          .map((item) => (item as ContentPart).text!)
          .toList();

      return textParts.join(' ');
    }

    return '';
  }

  /// Extract image URLs from message
  static List<String> extractImageUrls(ShapesMessage message) {
    if (message.content is List) {
      final content = message.content as List;
      return content
          .where((item) =>
              item is ContentPart &&
              item.type == 'image_url' &&
              item.imageUrl != null)
          .map((item) => (item as ContentPart).imageUrl!.url)
          .toList();
    }

    return [];
  }

  /// Extract audio URLs from message
  static List<String> extractAudioUrls(ShapesMessage message) {
    if (message.content is List) {
      final content = message.content as List;
      return content
          .where((item) =>
              item is ContentPart &&
              item.type == 'audio_url' &&
              item.audioUrl != null)
          .map((item) => (item as ContentPart).audioUrl!.url)
          .toList();
    }

    return [];
  }

  /// Check if message contains media
  static bool hasMedia(ShapesMessage message) {
    return extractImageUrls(message).isNotEmpty ||
        extractAudioUrls(message).isNotEmpty;
  }

  /// Get message type (text, image, audio, multimodal)
  static String getMessageType(ShapesMessage message) {
    if (message.content is String) return 'text';

    if (message.content is List) {
      final content = message.content as List;
      final hasImage = content
          .any((item) => item is ContentPart && item.type == 'image_url');
      final hasAudio = content
          .any((item) => item is ContentPart && item.type == 'audio_url');

      if (hasImage && hasAudio) return 'multimodal';
      if (hasImage) return 'image';
      if (hasAudio) return 'audio';
    }

    return 'text';
  }

  /// Create a simple text message
  static ShapesMessage createSimpleMessage(String content, {String? name}) {
    return ShapesMessage.user(content, name: name);
  }

  /// Create a message with image
  static ShapesMessage createImageMessage(String text, String imageUrl,
      {String? name}) {
    final content = [
      ContentPart.text(text),
      ContentPart.image(imageUrl),
    ];
    return ShapesMessage.userMultimodal(content, name: name);
  }

  /// Create a message with audio
  static ShapesMessage createAudioMessage(String text, String audioUrl,
      {String? name}) {
    final content = [
      ContentPart.text(text),
      ContentPart.audio(audioUrl),
    ];
    return ShapesMessage.userMultimodal(content, name: name);
  }

  /// Create a multimodal message
  static ShapesMessage createMultimodalMessage({
    required String text,
    List<String>? imageUrls,
    List<String>? audioUrls,
    String? name,
  }) {
    final content = <ContentPart>[ContentPart.text(text)];

    if (imageUrls != null) {
      for (final imageUrl in imageUrls) {
        content.add(ContentPart.image(imageUrl));
      }
    }

    if (audioUrls != null) {
      for (final audioUrl in audioUrls) {
        content.add(ContentPart.audio(audioUrl));
      }
    }

    return ShapesMessage.userMultimodal(content, name: name);
  }

  /// Build conversation history
  static List<ShapesMessage> buildConversationHistory({
    required List<Map<String, String>> messages,
    String? userName,
  }) {
    final conversation = <ShapesMessage>[];

    for (final message in messages) {
      final role = message['role'] ?? 'user';
      final content = message['content'] ?? '';
      final name = message['name'] ?? userName;

      if (role == 'user') {
        conversation.add(ShapesMessage.user(content, name: name));
      } else if (role == 'assistant') {
        conversation.add(ShapesMessage.assistant(content));
      }
    }

    return conversation;
  }

  /// Parse conversation from JSON
  static List<ShapesMessage> parseConversationFromJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString);
      final messages = json['messages'] as List;

      return messages.map((msg) => ShapesMessage.fromJson(msg)).toList();
    } catch (e) {
      throw ShapesApiUnavailableException('Failed to parse conversation: $e');
    }
  }

  /// Export conversation to JSON
  static String exportConversationToJson(List<ShapesMessage> messages) {
    try {
      final json = {
        'messages': messages.map((msg) => msg.toJson()).toList(),
        'exported_at': DateTime.now().toIso8601String(),
        'total_messages': messages.length,
      };

      return jsonEncode(json);
    } catch (e) {
      throw ShapesApiUnavailableException('Failed to export conversation: $e');
    }
  }

  /// Calculate message token count (approximate)
  static int estimateTokenCount(String text) {
    // Rough estimation: 1 token ≈ 4 characters for English text
    return (text.length / 4).ceil();
  }

  /// Calculate conversation token count
  static int estimateConversationTokens(List<ShapesMessage> messages) {
    int totalTokens = 0;

    for (final message in messages) {
      final content = extractTextContent(message);
      totalTokens += estimateTokenCount(content);

      // Add tokens for media content
      if (hasMedia(message)) {
        totalTokens += 100; // Approximate tokens for media processing
      }
    }

    return totalTokens;
  }

  /// Create a Dio interceptor for logging
  static Interceptor createLoggingInterceptor({
    bool logRequests = true,
    bool logResponses = true,
    bool logErrors = true,
    String? prefix,
  }) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (logRequests) {
          final pre = prefix ?? '🌐 [Shapes API]';
          print('$pre ${options.method} ${options.path}');
          if (options.data != null) {
            print('$pre Data: ${options.data}');
          }
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (logResponses) {
          final pre = prefix ?? '✅ [Shapes API]';
          print('$pre ${response.statusCode} ${response.requestOptions.path}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (logErrors) {
          final pre = prefix ?? '❌ [Shapes API]';
          print('$pre Error: ${error.message}');
          if (error.response != null) {
            print('$pre Status: ${error.response!.statusCode}');
            print('$pre Data: ${error.response!.data}');
          }
        }
        handler.next(error);
      },
    );
  }

  /// Create a Dio interceptor for authentication
  static Interceptor createAuthInterceptor({
    required String apiKey,
    String? userId,
    String? channelId,
    Map<String, String>? additionalHeaders,
  }) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $apiKey';
        if (userId != null) {
          options.headers['X-User-Id'] = userId;
        }
        if (channelId != null) {
          options.headers['X-Channel-Id'] = channelId;
        }
        if (additionalHeaders != null) {
          options.headers.addAll(additionalHeaders);
        }
        handler.next(options);
      },
    );
  }

  /// Create a Dio interceptor for rate limiting
  static Interceptor createRateLimitInterceptor({
    int maxRequestsPerMinute = 20,
    Duration window = const Duration(minutes: 1),
  }) {
    final requestTimes = <DateTime>[];

    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final now = DateTime.now();

        // Remove old requests outside the window
        requestTimes.removeWhere((time) => now.difference(time) > window);

        // Check if we're within rate limit
        if (requestTimes.length >= maxRequestsPerMinute) {
          final oldestRequest = requestTimes.first;
          final timeToWait = window - now.difference(oldestRequest);

          if (timeToWait.isNegative == false) {
            handler.reject(
              DioException(
                requestOptions: options,
                error:
                    'Rate limit exceeded. Try again in ${timeToWait.inSeconds} seconds.',
                type: DioExceptionType.unknown,
              ),
            );
            return;
          }
        }

        requestTimes.add(now);
        handler.next(options);
      },
    );
  }

  /// Create a Dio interceptor for caching
  static Interceptor createCachingInterceptor({
    Duration cacheDuration = const Duration(minutes: 5),
    int maxCacheSize = 100,
  }) {
    final cache = <String, Map<String, dynamic>>{};

    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final cacheKey =
            '${options.method}_${options.path}_${options.data.hashCode}';
        final cached = cache[cacheKey];

        if (cached != null) {
          final cachedTime = DateTime.parse(cached['timestamp']);
          if (DateTime.now().difference(cachedTime) < cacheDuration) {
            // Return cached response
            final response = Response(
              requestOptions: options,
              data: cached['data'],
              statusCode: cached['statusCode'],
            );
            handler.resolve(response);
            return;
          } else {
            // Remove expired cache
            cache.remove(cacheKey);
          }
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        final cacheKey =
            '${response.requestOptions.method}_${response.requestOptions.path}_${response.requestOptions.data.hashCode}';

        // Add to cache
        if (cache.length >= maxCacheSize) {
          // Remove oldest entry
          final oldestKey = cache.keys.first;
          cache.remove(oldestKey);
        }

        cache[cacheKey] = {
          'data': response.data,
          'statusCode': response.statusCode,
          'timestamp': DateTime.now().toIso8601String(),
        };

        handler.next(response);
      },
    );
  }

  /// Create a Dio interceptor for retry logic
  static Interceptor createRetryInterceptor({
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    List<int> retryStatusCodes = const [408, 429, 500, 502, 503, 504],
  }) {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response != null &&
            retryStatusCodes.contains(error.response!.statusCode)) {
          final retryCount = error.requestOptions.extra['retryCount'] ?? 0;

          if (retryCount < maxRetries) {
            // Wait before retrying
            await Future.delayed(retryDelay * (retryCount + 1));

            // Update retry count
            error.requestOptions.extra['retryCount'] = retryCount + 1;

            // Retry the request
            try {
              final response = await Dio().fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              // If retry fails, continue with error
            }
          }
        }

        handler.next(error);
      },
    );
  }

  /// Create a Dio interceptor for request/response transformation
  static Interceptor createTransformInterceptor({
    Map<String, dynamic> Function(Map<String, dynamic>)? transformRequest,
    Map<String, dynamic> Function(Map<String, dynamic>)? transformResponse,
  }) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (transformRequest != null && options.data != null) {
          try {
            final transformed = transformRequest(options.data);
            options.data = transformed;
          } catch (e) {
            // Continue with original data if transformation fails
          }
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (transformResponse != null && response.data != null) {
          try {
            final transformed = transformResponse(response.data);
            response.data = transformed;
          } catch (e) {
            // Continue with original data if transformation fails
          }
        }
        handler.next(response);
      },
    );
  }

  /// Validate API response
  static bool isValidApiResponse(dynamic response) {
    if (response == null) return false;

    try {
      if (response is Map<String, dynamic>) {
        return response.containsKey('choices') &&
            response['choices'] is List &&
            response['choices'].isNotEmpty;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Extract error message from API response
  static String extractErrorMessage(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('error')) {
        final error = response['error'];
        if (error is Map<String, dynamic> && error.containsKey('message')) {
          return error['message'] as String;
        }
        return error.toString();
      }
    }

    return 'Unknown error occurred';
  }

  /// Create a simple HTTP client for basic requests
  static http.Client createHttpClient({
    Duration timeout = const Duration(seconds: 30),
  }) {
    return http.Client();
  }

  /// Make a simple HTTP GET request
  static Future<http.Response> simpleGet(
    String url, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final client = createHttpClient(timeout: timeout);

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );
      return response;
    } finally {
      client.close();
    }
  }

  /// Make a simple HTTP POST request
  static Future<http.Response> simplePost(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final client = createHttpClient(timeout: timeout);

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      return response;
    } finally {
      client.close();
    }
  }

  /// Parse JSON response safely
  static Map<String, dynamic>? parseJsonSafely(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Convert response to string safely
  static String responseToString(dynamic response) {
    if (response is String) return response;
    if (response is Map || response is List) return jsonEncode(response);
    return response.toString();
  }

  /// Check if response indicates success
  static bool isSuccessResponse(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Create a user-friendly error message
  static String createUserFriendlyError(dynamic error) {
    if (error is ShapesApiException) {
      return error.message;
    } else if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.receiveTimeout:
          return 'Request timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 400:
              return 'Invalid request. Please check your input.';
            case 401:
              return 'Authentication failed. Please check your API key.';
            case 403:
              return 'Access denied. Please check your permissions.';
            case 404:
              return 'Resource not found.';
            case 429:
              return 'Too many requests. Please wait a moment and try again.';
            case 500:
              return 'Server error. Please try again later.';
            default:
              return 'An error occurred (Status: $statusCode).';
          }
        default:
          return 'Network error. Please try again.';
      }
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
