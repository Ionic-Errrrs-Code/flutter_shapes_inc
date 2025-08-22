import 'package:flutter/material.dart';
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';
import '../services/shapes_services.dart';
import '../utils/theme.dart';
import 'shape_browser_screen.dart';
import 'chat_screen.dart';
import 'features_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final ShapesService _shapesService = ShapesService();
  bool _isConnected = false;
  bool _isCheckingConnection = true;

  final List<Widget> _screens = [
    const DashboardTab(),
    const ShapesBrowserScreen(),
    const FeaturesScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_rounded),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.psychology_rounded),
      label: 'Shapes',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.extension_rounded),
      label: 'Features',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    _checkApiConnection();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _checkApiConnection() async {
    final connected = await _shapesService.testConnection();
    if (mounted) {
      setState(() {
        _isConnected = connected;
        _isCheckingConnection = false;
      });

      if (connected) {
        _fabAnimationController.forward();
      }
    }
  }

  void _onTabTapped(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (mounted) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: _navItems
            .map((item) => NavigationDestination(
                  icon: item.icon,
                  label: item.label!,
                ))
            .toList(),
      ),
      floatingActionButton: _isCheckingConnection
          ? null
          : _isConnected
              ? ScaleTransition(
                  scale: _fabAnimation,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ShapesBrowserScreen(showFab: false),
                        ),
                      );
                    },
                    heroTag: 'quickChat',
                    child: const Icon(Icons.chat_rounded),
                  ),
                )
              : FloatingActionButton(
                  onPressed: _checkApiConnection,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  heroTag: 'retry',
                  child: const Icon(Icons.refresh_rounded),
                ),
    );
  }
}

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab>
    with AutomaticKeepAliveClientMixin {
  final ShapesService _shapesService = ShapesService();
  List<ShapeProfile> _popularShapes = [];
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadPopularShapes();
  }

  Future<void> _loadPopularShapes() async {
    try {
      final shapes = await _shapesService.getPopularShapes();
      if (mounted) {
        setState(() {
          _popularShapes = shapes;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshShapes() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    final shapes = await _shapesService.getPopularShapes(forceRefresh: true);
    if (mounted) {
      setState(() {
        _popularShapes = shapes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Shapes Chat'),
          expandedHeight: isTablet ? 160 : 120,
          floating: true,
          snap: true,
          flexibleSpace: FlexibleSpaceBar(
            background: GradientContainer(
              colors: [
                Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3),
                Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withValues(alpha: 0.3),
              ],
              child: Container(),
            ),
          ),
          actions: [
            IconButton(
              onPressed: _refreshShapes,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(context),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildPopularShapesSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return GradientContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Shapes',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chat with AI personalities, get help, and explore endless possibilities',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final quickActions = [
      {
        'title': 'Start Chat',
        'icon': Icons.chat_rounded,
        'color': Theme.of(context).colorScheme.primary,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const ShapesBrowserScreen(showFab: false)),
            ),
      },
      {
        'title': 'Features',
        'icon': Icons.extension_rounded,
        'color': Theme.of(context).colorScheme.secondary,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeaturesScreen()),
            ),
      },
      {
        'title': 'Generate Image',
        'icon': Icons.palette_rounded,
        'color': Theme.of(context).colorScheme.tertiary,
        'onTap': () => _showImageGenerationDialog(context),
      },
      {
        'title': 'Quick Help',
        'icon': Icons.help_rounded,
        'color': Theme.of(context).colorScheme.error,
        'onTap': () => _showQuickHelpDialog(context),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final crossAxisCount = screenWidth > 600 ? 4 : 2;
            final childAspectRatio = screenWidth > 600 ? 1.8 : 1.3;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: quickActions.length,
              itemBuilder: (context, index) {
                final action = quickActions[index];
                return AnimatedCard(
                  onTap: action['onTap'] as VoidCallback,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth > 600 ? 16 : 12),
                        decoration: BoxDecoration(
                          color:
                              (action['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: screenWidth > 600 ? 32 : 28,
                        ),
                      ),
                      SizedBox(height: screenWidth > 600 ? 12 : 8),
                      Flexible(
                        child: Text(
                          action['title'] as String,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPopularShapesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Shapes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ShapesBrowserScreen()),
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_error != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load shapes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _loadPopularShapes,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if (_popularShapes.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('No shapes available'),
              ),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _popularShapes.length,
              itemBuilder: (context, index) {
                final shape = _popularShapes[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: AnimatedCard(
                    onTap: () => _navigateToChat(context, shape),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: shape.avatarUrl.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    shape.avatarUrl,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        shape.name.isNotEmpty
                                            ? shape.name[0].toUpperCase()
                                            : '?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                      );
                                    },
                                  ),
                                )
                              : Text(
                                  shape.name.isNotEmpty
                                      ? shape.name[0].toUpperCase()
                                      : '?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          shape.name.isNotEmpty ? shape.name : shape.username,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            shape.tagline.isNotEmpty
                                ? shape.tagline
                                : shape.searchDescription,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_rounded,
                              size: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${shape.userCount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _navigateToChat(BuildContext context, ShapeProfile shape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(shape: shape),
      ),
    );
  }

  void _showImageGenerationDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Describe your image',
                hintText: 'e.g., a sunset over mountains',
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
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              if (controller.text.isNotEmpty && _popularShapes.isNotEmpty) {
                _navigateToImageGeneration(context, controller.text);
              }
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _navigateToImageGeneration(BuildContext context, String prompt) {
    if (_popularShapes.isNotEmpty) {
      final shape = _popularShapes.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            shape: shape,
            initialMessage: '!imagine $prompt',
          ),
        ),
      );
    }
  }

  void _showQuickHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Getting Started:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('1. Browse and select a Shape from the Shapes tab'),
            Text('2. Start chatting by sending a message'),
            Text('3. Try special commands like !imagine for images'),
            Text('4. Explore Features tab for specific tools'),
            SizedBox(height: 16),
            Text('Special Commands:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('!imagine - Generate images'),
            Text('!weather - Get weather info'),
            Text('!news - Get latest news'),
            Text('!joke - Get a joke'),
            Text('!help - Get shape-specific help'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
