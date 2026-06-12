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
  
  
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! I am interested in a custom silk scarf for a gift.',
      'isMe': true,
      'time': '10:00 AM'
    },
    {
      'text': 'Hi there! Thank you for reaching out. I would be happy to craft one for you. Did you have a specific color in mind?',
      'isMe': false,
      'time': '10:05 AM'
    },
    {
      'text': 'I was thinking a deep emerald green, maybe with some gold threading?',
      'isMe': true,
      'time': '10:08 AM'
    },
  ];

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
    
    final artisan = await MockRepository.getArtisanById(widget.artisanId);
    setState(() {
      _artisan = artisan;
      _isLoading = false;
    });
  }

 
  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _textController.text.trim(),
        'isMe': true,
        'time': 'Just now'
      });
    });

    _textController.clear();

   
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading || _artisan == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F5F0),
      appBar: _buildChatAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(
                    text: message['text'],
                    isMe: message['isMe'],
                    time: message['time'],
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildChatAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: headerTextColor, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(_artisan!.photoUrl),
            radius: 18,
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _artisan!.name,
                style: AppTextStyles.titleMedium.copyWith(color: headerTextColor),
              ),
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                  ),
                  const Gap(4),
                  Text(
                    'Online', 
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey600
                    )
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: headerTextColor),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageBubble({required String text, required bool isMe, required String time}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isMe ? AppColors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  height: 1.4,
                ),
              ),
            ),
            const Gap(4),
            Text(
              time, 
              style: AppTextStyles.labelSmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey400
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate_outlined, color: isDark ? AppColors.textSecondaryDark : AppColors.grey600),
            onPressed: () {},
          ),
          const Gap(8),
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null, 
              style: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.grey400),
                filled: true,
                fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}