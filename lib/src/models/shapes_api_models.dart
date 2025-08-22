import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'shapes_api_models.g.dart';

/// Reference to generated function to prevent unused warnings in generated code
// ignore: unused_element
final _keepShapeProfileFromJson = _$ShapeProfileFromJson;

/// Represents a message in the chat conversation
@JsonSerializable()
class ShapesMessage extends Equatable {
  /// The role of the message sender (user, assistant, system)
  final String role;

  /// The content of the message (can be text or multimodal content)
  final dynamic content;

  /// Optional name for the message sender
  @JsonKey(includeIfNull: false)
  final String? name;

  const ShapesMessage({
    required this.role,
    required this.content,
    this.name,
  });

  factory ShapesMessage.fromJson(Map<String, dynamic> json) =>
      _$ShapesMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ShapesMessageToJson(this);

  /// Create a user message with text content
  factory ShapesMessage.user(String content, {String? name}) =>
      ShapesMessage(role: 'user', content: content, name: name);

  /// Create a user message with multimodal content
  factory ShapesMessage.userMultimodal(List<ContentPart> content,
          {String? name}) =>
      ShapesMessage(role: 'user', content: content, name: name);

  /// Create an assistant message
  factory ShapesMessage.assistant(String content) =>
      ShapesMessage(role: 'assistant', content: content);

  /// Create a system message
  factory ShapesMessage.system(String content) =>
      ShapesMessage(role: 'system', content: content);

  @override
  List<Object?> get props => [role, content, name];
}

/// Represents a content part for multimodal messages
@JsonSerializable()
class ContentPart extends Equatable {
  /// The type of content (text, image_url, audio_url)
  final String type;

  /// The text content (for text type)
  @JsonKey(includeIfNull: false)
  final String? text;

  /// The image URL (for image_url type)
  @JsonKey(includeIfNull: false)
  final ImageUrl? imageUrl;

  /// The audio URL (for audio_url type)
  @JsonKey(includeIfNull: false)
  final AudioUrl? audioUrl;

  const ContentPart({
    required this.type,
    this.text,
    this.imageUrl,
    this.audioUrl,
  });

  factory ContentPart.fromJson(Map<String, dynamic> json) =>
      _$ContentPartFromJson(json);

  Map<String, dynamic> toJson() => _$ContentPartToJson(this);

  /// Create a text content part
  factory ContentPart.text(String text) =>
      ContentPart(type: 'text', text: text);

  /// Create an image content part
  factory ContentPart.image(String url) =>
      ContentPart(type: 'image_url', imageUrl: ImageUrl(url: url));

  /// Create an audio content part
  factory ContentPart.audio(String url) =>
      ContentPart(type: 'audio_url', audioUrl: AudioUrl(url: url));

  @override
  List<Object?> get props => [type, text, imageUrl, audioUrl];
}

/// Represents an image URL for multimodal content
@JsonSerializable()
class ImageUrl extends Equatable {
  /// The URL of the image
  final String url;

  /// Optional detail level for the image
  @JsonKey(includeIfNull: false)
  final String? detail;

  const ImageUrl({required this.url, this.detail});

  factory ImageUrl.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUrlToJson(this);

  @override
  List<Object?> get props => [url, detail];
}

/// Represents an audio URL for multimodal content
@JsonSerializable()
class AudioUrl extends Equatable {
  /// The URL of the audio file
  final String url;

  const AudioUrl({required this.url});

  factory AudioUrl.fromJson(Map<String, dynamic> json) =>
      _$AudioUrlFromJson(json);

  Map<String, dynamic> toJson() => _$AudioUrlToJson(this);

  @override
  List<Object?> get props => [url];
}

/// Request model for chat completions
@JsonSerializable()
class ShapesCompletionRequest extends Equatable {
  /// The model to use (format: shapesinc/<shape-username>)
  final String model;

  /// The messages in the conversation
  final List<ShapesMessage> messages;

  /// Optional temperature for response generation
  @JsonKey(includeIfNull: false)
  final double? temperature;

  /// Optional maximum tokens for the response
  @JsonKey(includeIfNull: false)
  final int? maxTokens;

  /// Optional stream flag
  @JsonKey(includeIfNull: false)
  final bool? stream;

  const ShapesCompletionRequest({
    required this.model,
    required this.messages,
    this.temperature,
    this.maxTokens,
    this.stream,
  });

  factory ShapesCompletionRequest.fromJson(Map<String, dynamic> json) =>
      _$ShapesCompletionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShapesCompletionRequestToJson(this);

  @override
  List<Object?> get props => [model, messages, temperature, maxTokens, stream];
}

/// Response model for chat completions
@JsonSerializable()
class ShapesCompletionResponse extends Equatable {
  /// Unique identifier for the completion
  final String id;

  /// The object type
  final String object;

  /// Creation timestamp
  final int created;

  /// The model used
  final String model;

  /// The completion choices
  final List<CompletionChoice> choices;

  /// Usage statistics
  final Usage usage;

  const ShapesCompletionResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });

  factory ShapesCompletionResponse.fromJson(Map<String, dynamic> json) =>
      _$ShapesCompletionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShapesCompletionResponseToJson(this);

  @override
  List<Object?> get props => [id, object, created, model, choices, usage];
}

/// Represents a completion choice
@JsonSerializable()
class CompletionChoice extends Equatable {
  /// The index of the choice
  final int index;

  /// The message content
  final ShapesMessage message;

  /// The finish reason
  final String finishReason;

  const CompletionChoice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  factory CompletionChoice.fromJson(Map<String, dynamic> json) =>
      _$CompletionChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$CompletionChoiceToJson(this);

  @override
  List<Object?> get props => [index, message, finishReason];
}

/// Represents usage statistics
@JsonSerializable()
class Usage extends Equatable {
  /// Number of prompt tokens
  final int promptTokens;

  /// Number of completion tokens
  final int completionTokens;

  /// Total number of tokens
  final int totalTokens;

  const Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);

  Map<String, dynamic> toJson() => _$UsageToJson(this);

  @override
  List<Object?> get props => [promptTokens, completionTokens, totalTokens];
}

/// Shape profile information
@JsonSerializable()
class ShapeProfile extends Equatable {
  /// Unique identifier for the shape
  final String id;

  /// Display name of the shape
  final String name;

  /// Username for API calls
  final String username;

  /// Shape description
  @JsonKey(name: 'search_description')
  final String searchDescription;

  /// Searchable tags
  @JsonKey(name: 'search_tags_v2')
  final List<String> searchTagsV2;

  /// Creation timestamp
  @JsonKey(name: 'created_ts')
  final int createdTs;

  /// Number of users who have interacted
  @JsonKey(name: 'user_count')
  final int userCount;

  /// Total messages sent by the shape
  @JsonKey(name: 'message_count')
  final int messageCount;

  /// Custom tagline/bio
  final String tagline;

  /// Characteristic phrases
  final List<String> typicalPhrases;

  /// Screenshots with captions
  final List<Screenshot> screenshots;

  /// Shape category
  final String category;

  /// Source universe/franchise
  @JsonKey(name: 'character_universe')
  final String characterUniverse;

  /// Background story/lore
  @JsonKey(name: 'character_background')
  final String characterBackground;

  /// Profile image URL
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  /// Banner image URL
  final String? banner;

  /// Shape settings
  @JsonKey(name: 'shape_settings')
  final ShapeSettings shapeSettings;

  /// Suggested conversation starters
  @JsonKey(name: 'example_prompts')
  final List<String> examplePrompts;

  /// Whether the shape is currently active
  final bool enabled;

  const ShapeProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.searchDescription,
    required this.searchTagsV2,
    required this.createdTs,
    required this.userCount,
    required this.messageCount,
    required this.tagline,
    required this.typicalPhrases,
    required this.screenshots,
    required this.category,
    required this.characterUniverse,
    required this.characterBackground,
    required this.avatarUrl,
    this.banner,
    required this.shapeSettings,
    required this.examplePrompts,
    required this.enabled,
  });

  // Custom null-safe parser to handle missing/nullable fields from the public endpoint
  factory ShapeProfile.fromJson(Map<String, dynamic> json) {
    final List<Screenshot> parsedScreenshots = (json['screenshots'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((e) => Screenshot.fromLooseJson(e))
            .toList() ??
        const [];

    final List<String> parsedTags =
        (json['search_tags_v2'] as List?)?.map((e) => e.toString()).toList() ??
            const [];

    final List<String> parsedTypicalPhrases =
        (json['typical_phrases'] as List?)?.map((e) => e.toString()).toList() ??
            const [];

    final List<String> parsedExamplePrompts =
        (json['example_prompts'] as List?)?.map((e) => e.toString()).toList() ??
            const [];

    final Map<String, dynamic> ss =
        (json['shape_settings'] as Map?)?.cast<String, dynamic>() ?? const {};

    final String fallbackAvatar =
        (json['avatar_url'] ?? json['avatar'] ?? '').toString();

    return ShapeProfile(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['username'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      searchDescription: (json['search_description'] ?? '').toString(),
      searchTagsV2: parsedTags,
      createdTs: (json['created_ts'] as num?)?.toInt() ?? 0,
      userCount: (json['user_count'] as num?)?.toInt() ?? 0,
      messageCount: (json['message_count'] as num?)?.toInt() ?? 0,
      tagline: (json['tagline'] ?? '').toString(),
      typicalPhrases: parsedTypicalPhrases,
      screenshots: parsedScreenshots,
      category: (json['category'] ?? '').toString(),
      characterUniverse: (json['character_universe'] ?? '').toString(),
      characterBackground: (json['character_background'] ?? '').toString(),
      avatarUrl: fallbackAvatar,
      banner: json['banner']?.toString(),
      shapeSettings: ShapeSettings.fromLooseJson(ss),
      examplePrompts: parsedExamplePrompts,
      enabled: (json['enabled'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() => _$ShapeProfileToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        searchDescription,
        searchTagsV2,
        createdTs,
        userCount,
        messageCount,
        tagline,
        typicalPhrases,
        screenshots,
        category,
        characterUniverse,
        characterBackground,
        avatarUrl,
        banner,
        shapeSettings,
        examplePrompts,
        enabled
      ];
}

/// Screenshot with caption
@JsonSerializable()
class Screenshot extends Equatable {
  /// Screenshot ID
  final int id;

  /// Screenshot URL
  final String url;

  /// Caption for the screenshot
  final String caption;

  const Screenshot({
    required this.id,
    required this.url,
    required this.caption,
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotFromJson(json);

  // Loose parser that tolerates missing fields
  factory Screenshot.fromLooseJson(Map<String, dynamic> json) {
    return Screenshot(
      id: (json['id'] as num?)?.toInt() ?? 0,
      url: (json['url'] ?? '').toString(),
      caption: (json['caption'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => _$ScreenshotToJson(this);

  @override
  List<Object?> get props => [id, url, caption];
}

/// Shape settings configuration
@JsonSerializable()
class ShapeSettings extends Equatable {
  /// Initial message template
  @JsonKey(name: 'shape_initial_message')
  final String shapeInitialMessage;

  /// Status type
  @JsonKey(name: 'status_type')
  final String statusType;

  /// Custom status
  final String status;

  /// Appearance settings
  final String appearance;

  const ShapeSettings({
    required this.shapeInitialMessage,
    required this.statusType,
    required this.status,
    required this.appearance,
  });

  factory ShapeSettings.fromJson(Map<String, dynamic> json) =>
      _$ShapeSettingsFromJson(json);

  // Loose parser that provides defaults when data is missing
  factory ShapeSettings.fromLooseJson(Map<String, dynamic> json) {
    return ShapeSettings(
      shapeInitialMessage: (json['shape_initial_message'] ?? '').toString(),
      statusType: (json['status_type'] ?? 'custom').toString(),
      status: (json['status'] ?? '').toString(),
      appearance: (json['appearance'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => _$ShapeSettingsToJson(this);

  @override
  List<Object?> get props =>
      [shapeInitialMessage, statusType, status, appearance];
}
