import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class ChatScreen extends StatelessWidget {
  final String artisanId;
  const ChatScreen({super.key, required this.artisanId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: Center(
        child: Text('Chat Screen — Artisan: $artisanId'),
      ),
    );
  }
}