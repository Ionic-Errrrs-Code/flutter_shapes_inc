import 'package:flutter/material.dart';
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';
import '../services/shapes_services.dart';
import '../utils/theme.dart';
import 'chat_screen.dart';

class ShapesBrowserScreen extends StatefulWidget {
  final bool showFab;

  const ShapesBrowserScreen({super.key, this.showFab = true});

  @override
  State<ShapesBrowserScreen> createState() => _ShapesBrowserScreenState();
}

class _ShapesBrowserScreenState extends State<ShapesBrowserScreen>
    with TickerProviderStateMixin {
  final ShapesService _shapesService = ShapesService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<ShapeProfile> _shapes = [];
  List<ShapeProfile> _filteredShapes = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Popular',
    'Entertainment',
    'Education',
    'Assistants',
    'Creative',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadShapes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadShapes() async {
    try {
      final shapes = await _shapesService.getPopularShapes(forceRefresh: true);
      if (mounted) {
        setState(() {
          _shapes = shapes;
          _filteredShapes = shapes;
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

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        _searchQuery = query;
        if (query.isEmpty) {
          _filteredShapes = _shapes;
        } else {
          _filteredShapes = _shapes.where((shape) {
            return shape.name.toLowerCase().contains(query) ||
                shape.username.toLowerCase().contains(query) ||
                shape.searchDescription.toLowerCase().contains(query) ||
                shape.searchTagsV2
                    .any((tag) => tag.toLowerCase().contains(query));
          }).toList();
        }
      });
    }
  }

  Future<void> _searchByUsername(String username) async {
    if (username.isEmpty) return;

    // Remove @ if present
    final cleanUsername =
        username.startsWith('@') ? username.substring(1) : username;
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
    final profile = await _shapesService.getShapeProfile(cleanUsername);

    if (profile != null) {
      if (mounted) {
        setState(() {
          _filteredShapes = [profile];
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _error = 'Shape not found: $cleanUsername';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Shapes'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search by username',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search shapes...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                        },
                        icon: const Icon(Icons.clear_rounded),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories
                  .map((category) => _buildShapesList(category))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.showFab
          ? FloatingActionButton(
              onPressed: () => _showQuickChatDialog(context),
              tooltip: 'Quick Chat',
              child: const Icon(Icons.chat_rounded),
            )
          : null,
    );
  }

  Widget _buildShapesList(String category) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading shapes...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loadShapes,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredShapes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isEmpty
                    ? 'No shapes available'
                    : 'No shapes found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Try a different search term or browse all shapes',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                  child: const Text('Clear Search'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadShapes,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _filteredShapes.length,
        itemBuilder: (context, index) {
          final shape = _filteredShapes[index];
          return _buildShapeCard(shape);
        },
      ),
    );
  }

  Widget _buildShapeCard(ShapeProfile shape) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    return AnimatedCard(
      onTap: () => _navigateToChat(shape),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'shape_avatar_${shape.id}',
                child: CircleAvatar(
                  radius: isTablet ? 50 : 40,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: shape.avatarUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            shape.avatarUrl,
                            width: isTablet ? 100 : 80,
                            height: isTablet ? 100 : 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                shape.name.isNotEmpty
                                    ? shape.name[0].toUpperCase()
                                    : '?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
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
                              .headlineLarge
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                        ),
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Flexible(
                child: Text(
                  shape.name.isNotEmpty ? shape.name : shape.username,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isTablet ? 6 : 4),
              Flexible(
                child: Text(
                  '@${shape.username}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Flexible(
                child: Text(
                  shape.tagline.isNotEmpty
                      ? shape.tagline
                      : shape.searchDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 8 : 6,
                        horizontal: isTablet ? 12 : 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_rounded,
                          size: isTablet ? 16 : 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                        SizedBox(width: isTablet ? 6 : 4),
                        Text(
                          '${shape.userCount}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 8),
                  Container(
                    padding: EdgeInsets.all(isTablet ? 8 : 6),
                    decoration: BoxDecoration(
                      color: shape.enabled
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      shape.enabled ? Icons.check_circle : Icons.cancel,
                      size: isTablet ? 18 : 16,
                      color: shape.enabled ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToChat(ShapeProfile shape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(shape: shape),
      ),
    );
  }

  void _showSearchDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search by Username'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username (with or without @)',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              autofocus: true,
              onSubmitted: (value) {
                Navigator.pop(context);
                _searchByUsername(value);
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Search for a specific shape by their username',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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
              _searchByUsername(controller.text);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showQuickChatDialog(BuildContext context) {
    if (_filteredShapes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No shapes available for quick chat'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Choose a Shape for Quick Chat',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredShapes.length,
                itemBuilder: (context, index) {
                  final shape = _filteredShapes[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: shape.avatarUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                shape.avatarUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
                                    shape.name.isNotEmpty
                                        ? shape.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
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
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                    ),
                    title: Text(
                      shape.name.isNotEmpty ? shape.name : shape.username,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('@${shape.username}'),
                    trailing: const Icon(Icons.chat_rounded),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToChat(shape);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
