import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';

void main() {
  group('Flutter Shapes Tests', () {
    test('ShapesMessage creation', () {
      final message = ShapesMessage.user('Hello, world!');
      expect(message.role, equals('user'));
      expect(message.content, equals('Hello, world!'));
      expect(message.name, isNull);
    });

    test('ShapesMessage with name', () {
      final message = ShapesMessage.user('Hello, world!', name: 'test_user');
      expect(message.role, equals('user'));
      expect(message.content, equals('Hello, world!'));
      expect(message.name, equals('test_user'));
    });

    test('ContentPart creation', () {
      final textPart = ContentPart.text('Hello');
      expect(textPart.type, equals('text'));
      expect(textPart.text, equals('Hello'));
      expect(textPart.imageUrl, isNull);
      expect(textPart.audioUrl, isNull);

      final imagePart = ContentPart.image('https://example.com/image.jpg');
      expect(imagePart.type, equals('image_url'));
      expect(imagePart.text, isNull);
      expect(imagePart.imageUrl?.url, equals('https://example.com/image.jpg'));
      expect(imagePart.audioUrl, isNull);

      final audioPart = ContentPart.audio('https://example.com/audio.mp3');
      expect(audioPart.type, equals('audio_url'));
      expect(audioPart.text, isNull);
      expect(audioPart.audioUrl?.url, equals('https://example.com/audio.mp3'));
    });

    test('ShapesApiConfig creation', () {
      final config = ShapesApiConfig(
        apiKey: 'test_key',
        baseUrl: 'https://test.api.com',
        userId: 'user123',
        channelId: 'channel456',
        timeoutSeconds: 60,
        maxRetries: 5,
      );

      expect(config.apiKey, equals('test_key'));
      expect(config.baseUrl, equals('https://test.api.com'));
      expect(config.userId, equals('user123'));
      expect(config.channelId, equals('channel456'));
      expect(config.timeoutSeconds, equals(60));
      expect(config.maxRetries, equals(5));
    });

    test('ShapesApiConfig defaults', () {
      final config = ShapesApiConfig(apiKey: 'test_key');
      expect(config.apiKey, equals('test_key'));
      expect(config.baseUrl, equals('https://api.shapes.inc/v1'));
      expect(config.userId, isNull);
      expect(config.channelId, isNull);
      expect(config.timeoutSeconds, equals(30));
      expect(config.maxRetries, equals(3));
    });

    test('Exception classes', () {
      final apiException = ShapesApiUnavailableException('Test error');
      expect(apiException.message, equals('Test error'));

      final networkException = ShapesApiUnavailableException('Network error');
      expect(networkException.message, equals('Network error'));

      final invalidKeyException =
          ShapesApiAuthenticationException('Invalid key');
      expect(invalidKeyException.message, equals('Invalid key'));

      final rateLimitException = ShapesApiRateLimitException(
        'Rate limit exceeded',
        retryAfter: const Duration(seconds: 60),
      );
      expect(rateLimitException.message, equals('Rate limit exceeded'));
      expect(
          rateLimitException.retryAfter, equals(const Duration(seconds: 60)));
    });

    test('Helper functions', () {
      // Test message creation helpers
      final simpleMessage = ShapesMessage.user('Hello');
      expect(simpleMessage.content, equals('Hello'));

      final imageMessage = ShapesMessage.userMultimodal([
        ContentPart.text('Look at this'),
        ContentPart.image('https://example.com/image.jpg'),
      ]);

      // Check that the content is a list of ContentPart objects
      expect(imageMessage.content, isA<List<ContentPart>>());
      final contentList = imageMessage.content as List<ContentPart>;

      // Check that the first part contains the text
      expect(contentList[0].text, equals('Look at this'));
      expect(contentList[0].type, equals('text'));

      // Check that the second part contains the image URL
      expect(contentList[1].type, equals('image_url'));
      expect(contentList[1].imageUrl?.url,
          equals('https://example.com/image.jpg'));
    });

    test('ShapesAPI initialization', () {
      expect(() => ShapesAPI.getShapeProfile('test'),
          throwsA(isA<ShapesApiUnavailableException>()));
    });

    test('Helper functions for multimodal content', () {
      // Test image URL extraction
      final responseWithImages =
          'Here is your generated image!\nhttps://example.com/image1.jpg\nhttps://example.com/image2.png';
      final imageUrls = ShapesAPI.extractImageUrls(responseWithImages);
      expect(imageUrls.length, equals(2));
      expect(imageUrls[0], equals('https://example.com/image1.jpg'));
      expect(imageUrls[1], equals('https://example.com/image2.png'));

      // Test text content extraction
      final textContent = ShapesAPI.extractTextContent(responseWithImages);
      expect(textContent, equals('Here is your generated image!'));

      // Test with Shapes API specific URLs
      final responseWithShapesUrls =
          'Look at this cat!\nhttps://files.shapes.inc/f4098070.png';
      final shapesImageUrls =
          ShapesAPI.extractImageUrls(responseWithShapesUrls);
      expect(shapesImageUrls.length, equals(1));
      expect(
          shapesImageUrls[0], equals('https://files.shapes.inc/f4098070.png'));

      final shapesTextContent =
          ShapesAPI.extractTextContent(responseWithShapesUrls);
      expect(shapesTextContent, equals('Look at this cat!'));

      // Test with no images
      final responseNoImages = 'Just some text response';
      final noImageUrls = ShapesAPI.extractImageUrls(responseNoImages);
      expect(noImageUrls.length, equals(0));

      final textContentNoImages =
          ShapesAPI.extractTextContent(responseNoImages);
      expect(textContentNoImages, equals('Just some text response'));

      // Test with mixed content
      final mixedResponse =
          'Here\'s the cat you wanted, look at that fluff!\nhttps://files.shapes.inc/f4098070.png';
      final mixedImageUrls = ShapesAPI.extractImageUrls(mixedResponse);
      expect(mixedImageUrls.length, equals(1));
      expect(
          mixedImageUrls[0], equals('https://files.shapes.inc/f4098070.png'));

      final mixedTextContent = ShapesAPI.extractTextContent(mixedResponse);
      expect(mixedTextContent,
          equals('Here\'s the cat you wanted, look at that fluff!'));
    });
  });
}
