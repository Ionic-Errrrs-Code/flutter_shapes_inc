// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shapes_api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShapesMessage _$ShapesMessageFromJson(Map<String, dynamic> json) =>
    ShapesMessage(
      role: json['role'] as String,
      content: json['content'],
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ShapesMessageToJson(ShapesMessage instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
      'name': instance.name,
    };

ContentPart _$ContentPartFromJson(Map<String, dynamic> json) => ContentPart(
      type: json['type'] as String,
      text: json['text'] as String?,
      imageUrl: json['image_url'] == null
          ? null
          : ImageUrl.fromJson(json['image_url'] as Map<String, dynamic>),
      audioUrl: json['audio_url'] == null
          ? null
          : AudioUrl.fromJson(json['audio_url'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContentPartToJson(ContentPart instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'image_url': instance.imageUrl?.toJson(),
      'audio_url': instance.audioUrl?.toJson(),
    };

ImageUrl _$ImageUrlFromJson(Map<String, dynamic> json) => ImageUrl(
      url: json['url'] as String,
      detail: json['detail'] as String?,
    );

Map<String, dynamic> _$ImageUrlToJson(ImageUrl instance) => <String, dynamic>{
      'url': instance.url,
      'detail': instance.detail,
    };

AudioUrl _$AudioUrlFromJson(Map<String, dynamic> json) => AudioUrl(
      url: json['url'] as String,
    );

Map<String, dynamic> _$AudioUrlToJson(AudioUrl instance) => <String, dynamic>{
      'url': instance.url,
    };

ShapesCompletionRequest _$ShapesCompletionRequestFromJson(
        Map<String, dynamic> json) =>
    ShapesCompletionRequest(
      model: json['model'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ShapesMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTokens: json['max_tokens'] as int?,
      stream: json['stream'] as bool?,
    );

Map<String, dynamic> _$ShapesCompletionRequestToJson(
        ShapesCompletionRequest instance) =>
    <String, dynamic>{
      'model': instance.model,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'temperature': instance.temperature,
      'max_tokens': instance.maxTokens,
      'stream': instance.stream,
    };

ShapesCompletionResponse _$ShapesCompletionResponseFromJson(
        Map<String, dynamic> json) =>
    ShapesCompletionResponse(
      id: json['id'] as String,
      object: json['object'] as String,
      created: json['created'] as int,
      model: json['model'] as String,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => CompletionChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      usage: Usage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShapesCompletionResponseToJson(
        ShapesCompletionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'model': instance.model,
      'choices': instance.choices.map((e) => e.toJson()).toList(),
      'usage': instance.usage.toJson(),
    };

CompletionChoice _$CompletionChoiceFromJson(Map<String, dynamic> json) =>
    CompletionChoice(
      index: json['index'] as int,
      message: ShapesMessage.fromJson(json['message'] as Map<String, dynamic>),
      finishReason: json['finish_reason'] as String,
    );

Map<String, dynamic> _$CompletionChoiceToJson(CompletionChoice instance) =>
    <String, dynamic>{
      'index': instance.index,
      'message': instance.message.toJson(),
      'finish_reason': instance.finishReason,
    };

Usage _$UsageFromJson(Map<String, dynamic> json) => Usage(
      promptTokens: json['prompt_tokens'] as int,
      completionTokens: json['completion_tokens'] as int,
      totalTokens: json['total_tokens'] as int,
    );

Map<String, dynamic> _$UsageToJson(Usage instance) => <String, dynamic>{
      'prompt_tokens': instance.promptTokens,
      'completion_tokens': instance.completionTokens,
      'total_tokens': instance.totalTokens,
    };

ShapeProfile _$ShapeProfileFromJson(Map<String, dynamic> json) => ShapeProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      searchDescription: json['search_description'] as String,
      searchTagsV2: (json['search_tags_v2'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdTs: json['created_ts'] as int,
      userCount: json['user_count'] as int,
      messageCount: json['message_count'] as int,
      tagline: json['tagline'] as String,
      typicalPhrases: (json['typical_phrases'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      screenshots: (json['screenshots'] as List<dynamic>)
          .map((e) => Screenshot.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String,
      characterUniverse: json['character_universe'] as String,
      characterBackground: json['character_background'] as String,
      avatarUrl: json['avatar_url'] as String,
      banner: json['banner'] as String?,
      shapeSettings: ShapeSettings.fromJson(
          json['shape_settings'] as Map<String, dynamic>),
      examplePrompts: (json['example_prompts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$ShapeProfileToJson(ShapeProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'search_description': instance.searchDescription,
      'search_tags_v2': instance.searchTagsV2,
      'created_ts': instance.createdTs,
      'user_count': instance.userCount,
      'message_count': instance.messageCount,
      'tagline': instance.tagline,
      'typical_phrases': instance.typicalPhrases,
      'screenshots': instance.screenshots.map((e) => e.toJson()).toList(),
      'category': instance.category,
      'character_universe': instance.characterUniverse,
      'character_background': instance.characterBackground,
      'avatar_url': instance.avatarUrl,
      'banner': instance.banner,
      'shape_settings': instance.shapeSettings.toJson(),
      'example_prompts': instance.examplePrompts,
      'enabled': instance.enabled,
    };

Screenshot _$ScreenshotFromJson(Map<String, dynamic> json) => Screenshot(
      id: json['id'] as int,
      url: json['url'] as String,
      caption: json['caption'] as String,
    );

Map<String, dynamic> _$ScreenshotToJson(Screenshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'caption': instance.caption,
    };

ShapeSettings _$ShapeSettingsFromJson(Map<String, dynamic> json) =>
    ShapeSettings(
      shapeInitialMessage: json['shape_initial_message'] as String,
      statusType: json['status_type'] as String,
      status: json['status'] as String,
      appearance: json['appearance'] as String,
    );

Map<String, dynamic> _$ShapeSettingsToJson(ShapeSettings instance) =>
    <String, dynamic>{
      'shape_initial_message': instance.shapeInitialMessage,
      'status_type': instance.statusType,
      'status': instance.status,
      'appearance': instance.appearance,
    };
