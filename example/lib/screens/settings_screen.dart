import 'package:flutter/material.dart';
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';
import '../services/shapes_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ShapesService _shapesService = ShapesService();
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  bool _isAutoScrollEnabled = true;
  bool _isConnectionStatus = false;
  bool _isCheckingConnection = false;

  // API Settings
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _channelIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkConnectionStatus();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _userIdController.dispose();
    _channelIdController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load saved settings here
    // For now, using default values
    _apiKeyController.text = 'your-shapes-inc-api-key-here';
    _userIdController.text = 'flutter-demo-user';
    _channelIdController.text =
        'demo-session-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _checkConnectionStatus() async {
    if (mounted) {
      setState(() {
        _isCheckingConnection = true;
      });
    }

    try {
      final isConnected = await _shapesService.testConnection();
      if (mounted) {
        setState(() {
          _isConnectionStatus = isConnected;
          _isCheckingConnection = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnectionStatus = false;
          _isCheckingConnection = false;
        });
      }
    }
  }

  Future<void> _testApiConnection() async {
    if (mounted) {
      setState(() {
        _isCheckingConnection = true;
      });
    }

    try {
      final isConnected = await _shapesService.testConnection();
      if (mounted) {
        setState(() {
          _isConnectionStatus = isConnected;
          _isCheckingConnection = false;
        });
      }

      if (mounted) {
        if (isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('API connection successful!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'API connection failed. Please check your API key.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnectionStatus = false;
          _isCheckingConnection = false;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'Shapes Inc API Key',
                hintText: 'Enter your API key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                hintText: 'Enter your user ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _channelIdController,
              decoration: const InputDecoration(
                labelText: 'Channel ID',
                hintText: 'Enter channel ID (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_apiKeyController.text.isNotEmpty) {
                // Update the API configuration
                ShapesAPI.initialize(
                  _apiKeyController.text,
                  userId: _userIdController.text.isNotEmpty
                      ? _userIdController.text
                      : null,
                  channelId: _channelIdController.text.isNotEmpty
                      ? _channelIdController.text
                      : null,
                );

                Navigator.pop(context);

                // Test the new connection
                _testApiConnection();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('API key updated successfully!')),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Shapes Chat',
      applicationVersion: '1.0.1',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.psychology,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      children: [
        const SizedBox(height: 16),
        Text(
          'A beautiful example app showcasing the Flutter Shapes package capabilities.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Text(
          'Features:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        const Text('• Chat with AI shapes'),
        const Text('• Generate images'),
        const Text('• Get weather, news, and more'),
        const Text('• Beautiful Material 3 design'),
        const SizedBox(height: 16),
        Text(
          'Powered by Shapes Inc API',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
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
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Status
            Container(
              margin: EdgeInsets.all(isTablet ? 20 : 16),
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: _isConnectionStatus
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isConnectionStatus ? Icons.check_circle : Icons.error,
                    color: _isConnectionStatus
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isConnectionStatus ? 'Connected' : 'Not Connected',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _isConnectionStatus
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                  ),
                        ),
                        Text(
                          _isConnectionStatus
                              ? 'API connection is working properly'
                              : 'Please check your API key and connection',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _isConnectionStatus
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (_isCheckingConnection)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _testApiConnection,
                      color: _isConnectionStatus
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
                ],
              ),
            ),

            // API Settings
            _buildSectionHeader('API Configuration'),
            _buildSettingTile(
              icon: Icons.key,
              title: 'API Key',
              subtitle: 'Configure your Shapes Inc API key',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showApiKeyDialog,
            ),
            _buildSettingTile(
              icon: Icons.person,
              title: 'User ID',
              subtitle: _userIdController.text,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showApiKeyDialog,
            ),
            _buildSettingTile(
              icon: Icons.chat,
              title: 'Channel ID',
              subtitle: _channelIdController.text,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showApiKeyDialog,
            ),

            // App Settings
            _buildSectionHeader('App Preferences'),
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Toggle between light and dark themes',
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  }
                  _showThemeChangeDialog(value);
                },
              ),
            ),
            _buildSettingTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Enable push notifications',
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _isNotificationsEnabled = value;
                    });
                  }
                },
              ),
            ),
            _buildSettingTile(
              icon: Icons.auto_awesome,
              title: 'Auto-scroll',
              subtitle: 'Automatically scroll to new messages',
              trailing: Switch(
                value: _isAutoScrollEnabled,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _isAutoScrollEnabled = value;
                    });
                  }
                },
              ),
            ),

            // Data & Storage
            _buildSectionHeader('Data & Storage'),
            _buildSettingTile(
              icon: Icons.clear_all,
              title: 'Clear Chat History',
              subtitle: 'Remove all stored conversations',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Chat History'),
                    content: const Text(
                        'Are you sure you want to clear all chat history? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Chat history cleared')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.cached,
              title: 'Clear Cache',
              subtitle: 'Remove cached data and refresh',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _shapesService.clearCache();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              },
            ),

            // Support & Info
            _buildSectionHeader('Support & Information'),
            _buildSettingTile(
              icon: Icons.help_outline,
              title: 'Help & FAQ',
              subtitle: 'Get help and find answers',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showHelpDialog();
              },
            ),
            _buildSettingTile(
              icon: Icons.feedback,
              title: 'Send Feedback',
              subtitle: 'Report bugs or suggest features',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showFeedbackDialog();
              },
            ),
            _buildSettingTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showAboutDialog,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showThemeChangeDialog(bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Change'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              size: 48,
              color: isDarkMode ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              isDarkMode ? 'Dark mode enabled!' : 'Light mode enabled!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Theme switching functionality will be implemented in a future update.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & FAQ'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Getting Started:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('1. Configure your API key in Settings'),
            Text('2. Browse available shapes in the Shapes tab'),
            Text('3. Start chatting with any shape'),
            Text('4. Explore features in the Features tab'),
            SizedBox(height: 16),
            Text('Need more help?',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Contact support or check the documentation.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('We\'d love to hear your feedback!'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Your feedback',
                hintText: 'Tell us what you think...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
