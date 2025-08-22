import 'package:flutter/material.dart';
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';
import '../services/shapes_services.dart';
import 'chat_screen.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen>
    with TickerProviderStateMixin {
  final ShapesService _shapesService = ShapesService();
  late TabController _tabController;

  List<ShapeProfile> _popularShapes = [];

  final List<String> _categories = [
    'All',
    'Information',
    'Entertainment',
    'Learning',
    'Lifestyle',
    'Utilities',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadPopularShapes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPopularShapes() async {
    try {
      final shapes = await _shapesService.getPopularShapes();
      if (mounted) {
        setState(() {
          _popularShapes = shapes;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _navigateToChat(ShapeProfile shape, {String? initialMessage}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          shape: shape,
          initialMessage: initialMessage,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(Feature feature, ShapeProfile shape) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _executeFeature(feature, shape),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        feature.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          feature.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _executeFeature(Feature feature, ShapeProfile shape) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Text('Executing ${feature.name}...'),
          ],
        ),
      ),
    );

    try {
      String result;

      switch (feature.name) {
        case 'Weather':
          result = await _shapesService.getWeather(shape.username, 'New York');
          break;
        case 'News':
          result = await _shapesService.getNews(shape.username);
          break;
        case 'Jokes':
          result = await _shapesService.getJoke(shape.username);
          break;
        case 'Quotes':
          result = await _shapesService.getQuote(shape.username);
          break;
        case 'Facts':
          result = await _shapesService.getFact(shape.username);
          break;
        case 'Coding Help':
          result = await _shapesService.getCodingHelp(
              shape.username, 'Python', 'General help');
          break;
        case 'Translation':
          result = await _shapesService.translate(
              shape.username, 'Hello', 'Spanish');
          break;
        case 'Recipes':
          result = await _shapesService.getRecipe(shape.username, 'pasta');
          break;
        case 'Workouts':
          result = await _shapesService.getWorkout(shape.username, 'fitness');
          break;
        case 'Calculator':
          result = await _shapesService.calculate(shape.username, '2+2');
          break;
        case 'Image Generation':
          final response = await _shapesService.generateImage(
              shape.username, 'a beautiful sunset');
          result = response['text'] ??
              response['fullResponse'] ??
              'Image generation completed';
          break;
        default:
          result = 'Feature not implemented yet.';
      }

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Navigate to chat with the result
        _navigateToChat(shape, initialMessage: result);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error executing ${feature.name}: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildQuickActionCard(
                icon: Icons.chat_bubble_outline,
                title: 'Start Chat',
                subtitle: 'Begin a conversation',
                onTap: () {
                  if (_popularShapes.isNotEmpty && mounted) {
                    _navigateToChat(_popularShapes.first);
                  }
                },
              ),
              _buildQuickActionCard(
                icon: Icons.image,
                title: 'Generate Image',
                subtitle: 'Create AI images',
                onTap: () {
                  if (_popularShapes.isNotEmpty && mounted) {
                    _showImageGenerationDialog(_popularShapes.first);
                  }
                },
              ),
              _buildQuickActionCard(
                icon: Icons.search,
                title: 'Find Shapes',
                subtitle: 'Discover new bots',
                onTap: () {
                  // Navigate to shapes browser
                  DefaultTabController.of(context).animateTo(1);
                },
              ),
              _buildQuickActionCard(
                icon: Icons.explore,
                title: 'Explore Features',
                subtitle: 'Try different capabilities',
                onTap: () {
                  // Stay on current tab
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesByCategory(FeatureCategory category) {
    final features = FeaturesProvider.getFeaturesByCategory(category);

    if (_popularShapes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        final shape = _popularShapes[index % _popularShapes.length];
        return _buildFeatureCard(feature, shape);
      },
    );
  }

  void _showImageGenerationDialog(ShapeProfile shape) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Describe the image you want to generate:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'e.g., a beautiful sunset over mountains',
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
                _navigateToChat(shape,
                    initialMessage: 'Generate image: ${controller.text}');
              }
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              scrolledUnderElevation: 1,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Features',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.3),
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: _categories.map((category) {
                  return Tab(text: category);
                }).toList(),
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                indicatorColor: Theme.of(context).colorScheme.primary,
                dividerColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All features
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildQuickActions(),
                        const SizedBox(height: 24),
                        ...FeatureCategory.values.map((category) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  category.name.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                              _buildFeaturesByCategory(category),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  // Information features
                  _buildFeaturesByCategory(FeatureCategory.information),
                  // Entertainment features
                  _buildFeaturesByCategory(FeatureCategory.entertainment),
                  // Learning features
                  _buildFeaturesByCategory(FeatureCategory.learning),
                  // Lifestyle features
                  _buildFeaturesByCategory(FeatureCategory.lifestyle),
                  // Utilities features
                  _buildFeaturesByCategory(FeatureCategory.utilities),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
