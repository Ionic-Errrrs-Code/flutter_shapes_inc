import 'package:flutter/material.dart';
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';
import '../config/app_config.dart';
import 'home_screen.dart';

class DemoLauncherScreen extends StatefulWidget {
  const DemoLauncherScreen({super.key});

  @override
  State<DemoLauncherScreen> createState() => _DemoLauncherScreenState();
}

class _DemoLauncherScreenState extends State<DemoLauncherScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _launchApp() {
    // Initialize with the default API key
    ShapesAPI.initialize(
      AppConfig.defaultApiKey,
      userId: 'flutter-demo-user',
      channelId: 'demo-session-${DateTime.now().millisecondsSinceEpoch}',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _launchDemoMode() {
    // Initialize with your API key for demo mode
    ShapesAPI.initialize(
      AppConfig.defaultApiKey,
      userId: 'demo-user',
      channelId: 'demo-session-${DateTime.now().millisecondsSinceEpoch}',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.3),
              Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withValues(alpha: 0.3),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            child: Column(
              children: [
                SizedBox(height: isTablet ? 60 : 40),

                // App Logo and Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.psychology,
                          size: 60,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppConfig.appName,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConfig.appDescription,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Features Preview
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Features',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isTablet ? 4 : 2,
                        crossAxisSpacing: isTablet ? 20 : 16,
                        mainAxisSpacing: isTablet ? 20 : 16,
                        childAspectRatio: isTablet ? 1.0 : 0.8,
                        children: [
                          _buildFeatureCard(
                            icon: Icons.chat_bubble_outline,
                            title: 'AI Chat',
                            description:
                                'Chat with intelligent AI personalities',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          _buildFeatureCard(
                            icon: Icons.auto_awesome,
                            title: 'Image Generation',
                            description: 'Create stunning AI-generated images',
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          _buildFeatureCard(
                            icon: Icons.extension,
                            title: 'Rich Features',
                            description: 'Weather, news, jokes, and more',
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          _buildFeatureCard(
                            icon: Icons.psychology,
                            title: 'Smart Shapes',
                            description: 'Discover unique AI personalities',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Launch Options
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // API Key Input
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter Your API Key',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Get your API key from Shapes Inc to unlock full functionality',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _launchApp,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Launch App'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Demo Mode Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _launchDemoMode,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Try Demo Mode (UI Only)'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Footer
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Powered by Shapes Inc API',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Version ${AppConfig.appVersion}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
