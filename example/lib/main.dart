import 'package:flutter/material.dart';

import 'screens/demo_launcher_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const ShapesExampleApp());
}

class ShapesExampleApp extends StatelessWidget {
  const ShapesExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shapes Chat',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DemoLauncherScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Add responsive design support
        final mediaQuery = MediaQuery.of(context);
        final textScaler = mediaQuery.textScaler
            .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.4);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: textScaler,
          ),
          child: child!,
        );
      },
    );
  }
}
