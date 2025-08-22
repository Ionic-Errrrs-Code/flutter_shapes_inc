import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/shapes_api_models.dart';
import '../exceptions/shapes_api_exceptions.dart';

/// Configuration for the Shapes API client
class ShapesApiConfig {
  /// Your Shapes Inc API key
  final String apiKey;

  /// Base URL for the API (defaults to production)
  final String baseUrl;

  /// Custom user ID for conversation context
  final String? userId;

  /// Custom channel ID for conversation context
  final String? channelId;

  /// Request timeout in seconds
  final int timeoutSeconds;

  /// Maximum retry attempts
  final int maxRetries;

  /// Dio interceptors for custom request/response handling
  final List<Interceptor>? customInterceptors;

  /// Custom headers to include in all requests
  final Map<String, String>? customHeaders;

  /// Enable/disable request logging
  final bool enableLogging;

  /// Enable/disable automatic retry on failure
  final bool enableAutoRetry;

  const ShapesApiConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.shapes.inc/v1',
    this.userId,
    this.channelId,
    this.timeoutSeconds = 30,
    this.maxRetries = 3,
    this.customInterceptors,
    this.customHeaders,
    this.enableLogging = false,
    this.enableAutoRetry = true,
  });

  /// Create config from environment variables
  factory ShapesApiConfig.fromEnvironment() {
    return ShapesApiConfig(
      apiKey: const String.fromEnvironment('SHAPESINC_API_KEY'),
      userId: const String.fromEnvironment('SHAPESINC_USER_ID'),
      channelId: const String.fromEnvironment('SHAPESINC_CHANNEL_ID'),
    );
  }
}

/// Main client for interacting with the Shapes Inc API
class ShapesApiClient {
  final ShapesApiConfig _config;
  late final Dio _dio;
  late final http.Client _httpClient;

  ShapesApiClient(this._config) {
    _dio = Dio(BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: Duration(seconds: _config.timeoutSeconds),
      receiveTimeout: Duration(seconds: _config.timeoutSeconds),
      headers: {
        'Authorization': 'Bearer ${_config.apiKey}',
        'Content-Type': 'application/json',
        if (_config.userId != null) 'X-User-Id': _config.userId!,
        if (_config.channelId != null) 'X-Channel-Id': _config.channelId!,
        ...(_config.customHeaders ?? {}),
      },
    ));

    _httpClient = http.Client();

    // Add custom interceptors if provided
    if (_config.customInterceptors != null) {
      _dio.interceptors.addAll(_config.customInterceptors!);
    }

    // Add built-in interceptors for retry logic and error handling
    if (_config.enableAutoRetry) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (_config.enableLogging) {
              print('🌐 [Shapes API] ${options.method} ${options.path}');
            }
            handler.next(options);
          },
          onResponse: (response, handler) {
            if (_config.enableLogging) {
              print(
                  '✅ [Shapes API] ${response.statusCode} ${response.requestOptions.path}');
            }
            handler.next(response);
          },
          onError: (error, handler) async {
            if (_config.enableLogging) {
              print('❌ [Shapes API] Error: ${error.message}');
            }
            if (_shouldRetry(error) && _config.maxRetries > 0) {
              await _retryRequest(error, handler);
            } else {
              handler.next(error);
            }
          },
        ),
      );
    }
  }

  /// Check if the request should be retried
  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  /// Retry the failed request
  Future<void> _retryRequest(
      DioException error, ErrorInterceptorHandler handler) async {
    int retryCount = 0;
    while (retryCount < _config.maxRetries) {
      try {
        await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
        final response = await _dio.fetch(error.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= _config.maxRetries) {
          handler.next(error);
          return;
        }
      }
    }
  }

  // ============================================================================
  // CORE API METHODS - For developers building custom UIs
  // ============================================================================

  /// Create a chat completion with the specified shape
  Future<ShapesCompletionResponse> createChatCompletion({
    required String shapeUsername,
    required List<ShapesMessage> messages,
    double? temperature,
    int? maxTokens,
    bool stream = false,
  }) async {
    try {
      final request = ShapesCompletionRequest(
        model: 'shapesinc/$shapeUsername',
        messages: messages,
        temperature: temperature,
        maxTokens: maxTokens,
        stream: stream,
      );

      final response = await _dio.post(
        '/chat/completions',
        data: request.toJson(),
      );

      return ShapesCompletionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ShapesApiUnavailableException(
          'Failed to create chat completion: $e');
    }
  }

  /// Send a text message to a shape
  Future<ShapesCompletionResponse> sendTextMessage({
    required String shapeUsername,
    required String message,
    String? userId,
    String? channelId,
  }) async {
    final messages = [ShapesMessage.user(message)];

    final effectiveUserId = userId ?? _config.userId;
    final effectiveChannelId = channelId ?? _config.channelId;

    if (effectiveUserId != null || effectiveChannelId != null) {
      final tempConfig = ShapesApiConfig(
        apiKey: _config.apiKey,
        baseUrl: _config.baseUrl,
        userId: effectiveUserId,
        channelId: effectiveChannelId,
      );
      final tempClient = ShapesApiClient(tempConfig);
      return tempClient.createChatCompletion(
        shapeUsername: shapeUsername,
        messages: messages,
      );
    }

    return createChatCompletion(
      shapeUsername: shapeUsername,
      messages: messages,
    );
  }

  /// Send an image message to a shape
  Future<ShapesCompletionResponse> sendImageMessage({
    required String shapeUsername,
    required String message,
    required String imageUrl,
    String? userId,
    String? channelId,
  }) async {
    final content = [
      ContentPart.text(message),
      ContentPart.image(imageUrl),
    ];

    final messages = [ShapesMessage.userMultimodal(content)];

    final effectiveUserId = userId ?? _config.userId;
    final effectiveChannelId = channelId ?? _config.channelId;

    if (effectiveUserId != null || effectiveChannelId != null) {
      final tempConfig = ShapesApiConfig(
        apiKey: _config.apiKey,
        baseUrl: _config.baseUrl,
        userId: effectiveUserId,
        channelId: effectiveChannelId,
      );
      final tempClient = ShapesApiClient(tempConfig);
      return tempClient.createChatCompletion(
        shapeUsername: shapeUsername,
        messages: messages,
      );
    }

    return createChatCompletion(
      shapeUsername: shapeUsername,
      messages: messages,
    );
  }

  /// Send an audio message to a shape
  Future<ShapesCompletionResponse> sendAudioMessage({
    required String shapeUsername,
    required String message,
    required String audioUrl,
    String? userId,
    String? channelId,
  }) async {
    final content = [
      ContentPart.text(message),
      ContentPart.audio(audioUrl),
    ];

    final messages = [ShapesMessage.userMultimodal(content)];

    final effectiveUserId = userId ?? _config.userId;
    final effectiveChannelId = channelId ?? _config.channelId;

    if (effectiveUserId != null || effectiveChannelId != null) {
      final tempConfig = ShapesApiConfig(
        apiKey: _config.apiKey,
        baseUrl: _config.baseUrl,
        userId: effectiveUserId,
        channelId: effectiveChannelId,
      );
      final tempClient = ShapesApiClient(tempConfig);
      return tempClient.createChatCompletion(
        shapeUsername: shapeUsername,
        messages: messages,
      );
    }

    return createChatCompletion(
      shapeUsername: shapeUsername,
      messages: messages,
    );
  }

  // ============================================================================
  // SHAPE MANAGEMENT - For developers building custom UIs
  // ============================================================================

  /// Get shape profile information
  Future<ShapeProfile> getShapeProfile(String username) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('https://api.shapes.inc/shapes/public/$username'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ShapeProfile.fromJson(data);
      } else {
        throw ShapesApiUnavailableException(
          'Failed to get shape profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is ShapesApiException) rethrow;
      throw ShapesApiUnavailableException('Failed to get shape profile: $e');
    }
  }

  /// Get multiple shape profiles
  Future<List<ShapeProfile>> getShapeProfiles(List<String> usernames) async {
    final futures = usernames.map((username) => getShapeProfile(username));
    return Future.wait(futures);
  }

  /// Get popular shapes
  Future<List<ShapeProfile>> getPopularShapes({int limit = 20}) async {
    final popularUsernames = [
      'tenshi',
      'einstein',
      'socrates',
      'shakespeare',
      'da-vinci',
    ];

    try {
      return await getShapeProfiles(popularUsernames.take(limit).toList());
    } catch (e) {
      final profiles = <ShapeProfile>[];
      for (final username in popularUsernames.take(limit)) {
        try {
          final profile = await getShapeProfile(username);
          profiles.add(profile);
        } catch (e) {
          continue;
        }
      }
      return profiles;
    }
  }

  // ============================================================================
  // UTILITY FUNCTIONS - For developers building custom UIs
  // ============================================================================

  /// Test the API connection
  Future<bool> testConnection() async {
    try {
      await getShapeProfile('tenshi');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get API usage statistics
  Future<Map<String, dynamic>> getUsageStats() async {
    return {
      'requests_today': 0,
      'requests_total': 0,
      'rate_limit_remaining': 20,
      'rate_limit_reset':
          DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
    };
  }

  /// Create a message with custom role and content
  ShapesMessage createMessage({
    required String role,
    required dynamic content,
    String? name,
  }) {
    return ShapesMessage(
      role: role,
      content: content,
      name: name,
    );
  }

  /// Create a user message
  ShapesMessage createUserMessage(String content, {String? name}) {
    return ShapesMessage.user(content, name: name);
  }

  /// Create an assistant message
  ShapesMessage createAssistantMessage(String content) {
    return ShapesMessage.assistant(content);
  }

  /// Create a multimodal message
  ShapesMessage createMultimodalMessage(List<ContentPart> content,
      {String? name}) {
    return ShapesMessage.userMultimodal(content, name: name);
  }

  /// Create text content part
  ContentPart createTextContent(String text) {
    return ContentPart.text(text);
  }

  /// Create image content part
  ContentPart createImageContent(String imageUrl, {String? detail}) {
    return ContentPart.image(imageUrl);
  }

  /// Create audio content part
  ContentPart createAudioContent(String audioUrl) {
    return ContentPart.audio(audioUrl);
  }

  /// Build a conversation from messages
  List<ShapesMessage> buildConversation({
    required List<String> userMessages,
    required List<String> assistantMessages,
    String? userName,
  }) {
    final conversation = <ShapesMessage>[];

    for (int i = 0; i < userMessages.length; i++) {
      conversation.add(createUserMessage(userMessages[i], name: userName));

      if (i < assistantMessages.length) {
        conversation.add(createAssistantMessage(assistantMessages[i]));
      }
    }

    return conversation;
  }

  /// Validate API key format (basic validation)
  bool isValidApiKey(String apiKey) {
    return apiKey.isNotEmpty && apiKey.length >= 10;
  }

  /// Create a custom Dio instance for advanced usage
  Dio createCustomDio({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? extraHeaders,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? _config.baseUrl,
      connectTimeout:
          connectTimeout ?? Duration(seconds: _config.timeoutSeconds),
      receiveTimeout:
          receiveTimeout ?? Duration(seconds: _config.timeoutSeconds),
      headers: {
        'Authorization': 'Bearer ${_config.apiKey}',
        'Content-Type': 'application/json',
        if (_config.userId != null) 'X-User-Id': _config.userId!,
        if (_config.channelId != null) 'X-Channel-Id': _config.channelId!,
        ...(_config.customHeaders ?? {}),
        ...(extraHeaders ?? {}),
      },
    ));

    // Add custom interceptors
    if (_config.customInterceptors != null) {
      dio.interceptors.addAll(_config.customInterceptors!);
    }

    return dio;
  }

  /// Execute a custom request with full control
  Future<Response> executeCustomRequest({
    required String method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
    Duration? timeout,
  }) async {
    final dio = createCustomDio(extraHeaders: extraHeaders);

    try {
      final response = await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert them to ShapesApiException
  ShapesApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ShapesApiUnavailableException('Connection timeout');
      case DioExceptionType.receiveTimeout:
        return ShapesApiUnavailableException('Receive timeout');
      case DioExceptionType.connectionError:
        return ShapesApiUnavailableException('Connection error');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['error']?['message'] ?? 'Bad response';

        switch (statusCode) {
          case 400:
            return ShapesApiUnavailableException('Bad request: $message');
          case 401:
            return ShapesApiAuthenticationException(
                'Unauthorized: Invalid API key');
          case 403:
            return ShapesApiAuthenticationException(
                'Forbidden: Insufficient permissions');
          case 404:
            return ShapesApiUnavailableException('Not found: $message');
          case 429:
            return ShapesApiRateLimitException('Rate limit exceeded');
          case 500:
            return ShapesApiUnavailableException('Internal server error');
          default:
            return ShapesApiUnavailableException(
                'HTTP error $statusCode: $message');
        }
      default:
        return ShapesApiUnavailableException('Network error: ${e.message}');
    }
  }

  /// Dispose of resources
  void dispose() {
    _dio.close();
    _httpClient.close();
  }
}

// ============================================================================
// EXTENSION METHODS - For easier usage in custom UIs
// ============================================================================

/// Extension methods for easier API usage
extension ShapesApiClientExtensions on ShapesApiClient {
  /// Quick chat method for simple text messages
  Future<String> quickChat(String shapeUsername, String message) async {
    try {
      final response = await sendTextMessage(
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
            result += 'Images in response:\n';
            result += imageParts
                .map((part) => (part as ContentPart).imageUrl?.url)
                .join('\n');
          }
          return result;
        }
      }

      return 'No response received';
    } catch (e) {
      rethrow;
    }
  }

  /// Stream-like chat experience (simulated)
  Stream<String> streamChat(String shapeUsername, String message) async* {
    try {
      final response = await sendTextMessage(
        shapeUsername: shapeUsername,
        message: message,
      );

      if (response.choices.isNotEmpty) {
        final content = response.choices.first.message.content;
        if (content is String) {
          // Simulate streaming by yielding characters
          for (int i = 0; i < content.length; i++) {
            yield content.substring(0, i + 1);
            await Future.delayed(Duration(milliseconds: 50));
          }
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

          // Simulate streaming by yielding characters
          for (int i = 0; i < result.length; i++) {
            yield result.substring(0, i + 1);
            await Future.delayed(Duration(milliseconds: 50));
          }
        }
      }
    } catch (e) {
      yield 'Error: $e';
    }
  }

  /// Batch send multiple messages
  Future<List<ShapesCompletionResponse>> batchChat({
    required String shapeUsername,
    required List<String> messages,
    String? userId,
    String? channelId,
  }) async {
    final futures = messages.map((message) => sendTextMessage(
          shapeUsername: shapeUsername,
          message: message,
          userId: userId,
          channelId: channelId,
        ));

    return Future.wait(futures);
  }
}
