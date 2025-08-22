import 'package:flutter/material.dart';
import 'package:flutter_shapes_inc/flutter_shapes_inc.dart';
import '../services/shapes_services.dart';

class ChatScreen extends StatefulWidget {
  final ShapeProfile shape;
  final String? initialMessage;

  const ChatScreen({
    super.key,
    required this.shape,
    this.initialMessage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ShapesService _shapesService = ShapesService();

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _typingAnimationController, curve: Curves.easeInOut),
    );

    if (widget.initialMessage != null) {
      _sendMessage(widget.initialMessage!);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = ChatMessage(
      content: message.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    if (mounted) {
      setState(() {
        _messages.add(userMessage);
        _isTyping = true;
      });
    }

    _messageController.clear();
    _scrollToBottom();

    // Show typing indicator
    if (mounted) {
      _typingAnimationController.repeat();
    }

    try {
      final response = await _shapesService.sendMessage(
          widget.shape.username, message.trim());

      if (mounted) {
        _typingAnimationController.stop();

        final botMessage = ChatMessage(
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.text,
        );

        setState(() {
          _messages.add(botMessage);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        _typingAnimationController.stop();

        final errorMessage = ChatMessage(
          content: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.text,
        );

        setState(() {
          _messages.add(errorMessage);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    }
  }

  Future<void> _sendImageMessage(String imageUrl) async {
    final userMessage = ChatMessage(
      content: 'Sent an image',
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.image,
      imageUrl: imageUrl,
    );

    if (mounted) {
      setState(() {
        _messages.add(userMessage);
        _isTyping = true;
      });
    }

    _scrollToBottom();

    if (mounted) {
      _typingAnimationController.repeat();
    }

    try {
      final response = await _shapesService.sendImageMessage(
        widget.shape.username,
        'Analyze this image',
        imageUrl,
      );

      if (mounted) {
        _typingAnimationController.stop();

        final botMessage = ChatMessage(
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.text,
        );

        setState(() {
          _messages.add(botMessage);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        _typingAnimationController.stop();

        final errorMessage = ChatMessage(
          content: 'Sorry, I couldn\'t process the image. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.text,
        );

        setState(() {
          _messages.add(errorMessage);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    }
  }

  Future<void> _generateImage(String prompt) async {
    final userMessage = ChatMessage(
      content: 'Generate image: $prompt',
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    if (mounted) {
      setState(() {
        _messages.add(userMessage);
        _isTyping = true;
      });
    }

    _scrollToBottom();

    if (mounted) {
      _typingAnimationController.repeat();
    }

    try {
      final response =
          await _shapesService.generateImage(widget.shape.username, prompt);

      if (mounted) {
        _typingAnimationController.stop();

        // Check if we have image URLs
        final List<String> imageUrls = response['imageUrls'] ?? [];
        final String textContent =
            response['text'] ?? 'Here\'s your generated image!';

        if (imageUrls.isNotEmpty) {
          // Create a message with the first image
          final botMessage = ChatMessage(
            content: textContent.isNotEmpty
                ? textContent
                : 'Here\'s your generated image!',
            isUser: false,
            timestamp: DateTime.now(),
            type: MessageType.image,
            imageUrl: imageUrls.first, // Use the first image URL
          );

          setState(() {
            _messages.add(botMessage);
            _isTyping = false;
          });

          // If there are multiple images, add them as separate messages
          for (int i = 1; i < imageUrls.length; i++) {
            final additionalImageMessage = ChatMessage(
              content: '',
              isUser: false,
              timestamp: DateTime.now(),
              type: MessageType.image,
              imageUrl: imageUrls[i],
            );

            setState(() {
              _messages.add(additionalImageMessage);
            });
          }
        } else {
          // No images generated, show text response
          final botMessage = ChatMessage(
            content: textContent,
            isUser: false,
            timestamp: DateTime.now(),
            type: MessageType.text,
          );

          setState(() {
            _messages.add(botMessage);
            _isTyping = false;
          });
        }

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        _typingAnimationController.stop();

        final errorMessage = ChatMessage(
          content: 'Sorry, I couldn\'t generate the image. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.text,
        );

        setState(() {
          _messages.add(errorMessage);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    }
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.shape.avatarUrl),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.image &&
                      message.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        message.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                const Icon(Icons.image_not_supported, size: 48),
                          );
                        },
                      ),
                    ),
                  if (message.content.isNotEmpty) ...[
                    if (message.type == MessageType.image &&
                        message.imageUrl != null)
                      const SizedBox(height: 8),
                    Text(
                      message.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isUser
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    if (!_isTyping) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(widget.shape.avatarUrl),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        final delay = index * 0.2;
        final animationValue = (_typingAnimation.value + delay) % 1.0;

        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3 + (0.7 * animationValue),
                ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: isTablet ? 24 : 18,
              backgroundImage: NetworkImage(widget.shape.avatarUrl),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shape.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '@${widget.shape.username}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsDialog();
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty && !_isTyping
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 8.0),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(widget.shape.avatarUrl),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          const SizedBox(height: 24),
          Text(
            'Start chatting with ${widget.shape.name}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.shape.searchDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.shape.searchTagsV2.take(6).map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                size: isTablet ? 28 : 24,
              ),
              onPressed: () {
                _showAttachmentOptions();
              },
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24.0 : 20.0,
                      vertical: isTablet ? 16.0 : 12.0,
                    ),
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  size: isTablet ? 28 : 24,
                ),
                onPressed: () => _sendMessage(_messageController.text),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Attachment',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.image,
                  label: 'Image URL',
                  onTap: () {
                    Navigator.pop(context);
                    _showImageUrlDialog();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.auto_awesome,
                  label: 'Generate Image',
                  onTap: () {
                    Navigator.pop(context);
                    _showImageGenerationDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.mic,
                  label: 'Voice Message',
                  onTap: () {
                    Navigator.pop(context);
                    _showVoiceRecordingDialog();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.file_copy,
                  label: 'File',
                  onTap: () {
                    Navigator.pop(context);
                    _showFileUploadDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showImageUrlDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Image'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter image URL',
            border: OutlineInputBorder(),
          ),
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
                _sendImageMessage(controller.text);
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showImageGenerationDialog() {
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
                _generateImage(controller.text);
              }
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chat with ${widget.shape.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Shape Profile'),
              onTap: () {
                Navigator.pop(context);
                _showShapeProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Clear Chat'),
              onTap: () {
                Navigator.pop(context);
                _clearChat();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Chat'),
              onTap: () {
                Navigator.pop(context);
                _shareChat();
              },
            ),
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

  void _showShapeProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.shape.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(widget.shape.avatarUrl),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Username: @${widget.shape.username}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(widget.shape.searchDescription),
            const SizedBox(height: 8),
            Text(
              'Tags:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: widget.shape.searchTagsV2.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
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

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text(
            'Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  _messages.clear();
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _shareChat() {
    _showShareOptionsDialog();
  }

  void _showVoiceRecordingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Message'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Voice recording feature is coming soon!'),
            SizedBox(height: 8),
            Text(
              'This will allow you to record and send voice messages to the AI shape.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
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

  void _showFileUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Upload'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_copy, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('File upload feature is coming soon!'),
            SizedBox(height: 8),
            Text(
              'This will allow you to upload and send files to the AI shape for analysis.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
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

  void _showShareOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Chat'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.share, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Chat sharing feature is coming soon!'),
            SizedBox(height: 8),
            Text(
              'This will allow you to share your chat conversations with others.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
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
}
