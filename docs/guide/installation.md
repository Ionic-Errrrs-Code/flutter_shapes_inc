# Installation

Get started with Flutter Shapes Inc in a few simple steps.

## Prerequisites

- **Flutter SDK**: 3.10.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **API Key**: From [Shapes Inc Developer Portal](https://shapes.inc/developer)

## 1. Add Dependency

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_shapes_inc: ^1.0.0
```

## 2. Install

```bash
flutter pub get
```

## 3. Import

```dart
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';
```

## 4. Initialize

```dart
void main() {
  ShapesAPI.initialize(
    'your-api-key',
    userId: 'your-app-user-id',     // X-User-Id (recommended)
    channelId: 'conversation-1234', // X-Channel-Id (recommended)
  );
  
  runApp(MyApp());
}
```

## 5. Test Connection

```dart
Future<void> testConnection() async {
  try {
    final profile = await ShapesAPI.getShapeProfile('tenshi');
    print('Connected successfully!');
  } catch (e) {
    print('Connection failed: $e');
  }
}
```

## Next Steps

- [Introduction](./index.md) - Learn about the package features
- [API Reference](../index.md#complete-function-list) - Complete function documentation
- [Example App](https://github.com/Ionic-Errrrs-Code/flutter_shapes_inc/tree/main/example) - See it in action