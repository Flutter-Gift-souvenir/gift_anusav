import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_repository.dart';
import '../../models/artisan_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ChatScreen extends StatefulWidget {
  final String artisanId;
  const ChatScreen({super.key, required this.artisanId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Artisan? _artisan;
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadArtisan();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadArtisan() async {
    try {
      final artisan = await MockRepository.getArtisanById(widget.artisanId);

      if (!mounted) return;

      // Load messages for this artisan from mock JSON
      final messages = await MockRepository.getChatMessagesByArtisan(widget.artisanId);

      if (!mounted) return;

      setState(() {
        _artisan = artisan;
        _messages.clear();
        _messages.addAll(messages);
        _isLoading = false;
        _errorMessage = null;
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load artisan profile.';
      });
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': 'Just now',
        'status': 'Sending...',
      });
    });

    _textController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || _messages.isEmpty) return;

      setState(() {
        _messages[_messages.length - 1]['status'] = 'Sent';
      });
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      setState(() {
        _messages.add({
          'text':
              'Thank you for your message. I will prepare the details and reply to you soon.',
          'isMe': false,
          'time': 'Just now',
          'status': '',
        });
      });

      _scrollToBottom();
    });
  }

  void _sendQuickMessage(String message) {
    _textController.text = message;
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null || _artisan == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: _buildErrorState(context),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F5F0),
      appBar: _buildChatAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildConversationInfoBanner(context),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: _messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildDateDivider(context);
                    }

                    final message = _messages[index - 1];

                    return _buildMessageBubble(
                      text: message['text'],
                      isMe: message['isMe'],
                      time: message['time'],
                      status: message['status'] ?? '',
                    );
                  },
                ),
              ),
            ),
            _buildQuickReplies(context),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            const Gap(16),
            Text(
              'Chat unavailable',
              style: AppTextStyles.titleMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              _errorMessage ?? 'Please try again later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
                height: 1.5,
              ),
            ),
            const Gap(20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadArtisan();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildChatAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerTextColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: headerTextColor, size: 20),
        onPressed: () => context.pop(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                backgroundImage: CachedNetworkImageProvider(_artisan!.photoUrl),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.surfaceDark : AppColors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _artisan!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: headerTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(2),
                Row(
                  children: [
                    Text(
                      'Online',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.grey600,
                      ),
                    ),
                    Text(
                      ' • Usually replies fast',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call_outlined, color: headerTextColor),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: headerTextColor),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? AppColors.grey800 : AppColors.grey100,
        ),
      ),
    );
  }

  Widget _buildConversationInfoBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFE8DFD5),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.handshake_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              'Ask about custom gifts, wrapping, delivery date, or artisan story.',
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: isDark ? AppColors.grey800 : const Color(0xFFE0D8D0),
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Today',
              style: AppTextStyles.labelSmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Divider(
              color: isDark ? AppColors.grey800 : const Color(0xFFE0D8D0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required bool isMe,
    required String time,
    required String status,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor =
        isMe ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.white);
    final textColor =
        isMe ? AppColors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe) ...[
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    backgroundImage: CachedNetworkImageProvider(_artisan!.photoUrl),
                  ),
                  const Gap(8),
                ],
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 6),
                        bottomRight: Radius.circular(isMe ? 6 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: isDark ? 0.16 : 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(5),
            Padding(
              padding: EdgeInsets.only(left: isMe ? 0 : 34),
              child: Text(
                isMe && status.isNotEmpty ? '$time • $status' : time,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.grey400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final suggestions = [
      'Can you customize it?',
      'How long to make?',
      'Do you gift wrap?',
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => const Gap(8),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ActionChip(
            onPressed: () => _sendQuickMessage(suggestion),
            label: Text(suggestion),
            labelStyle: AppTextStyles.labelSmall.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
            side: BorderSide(
              color: isDark ? AppColors.grey800 : const Color(0xFFE0D8D0),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom > 0 ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 110),
              child: TextField(
                controller: _textController,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.grey400,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
