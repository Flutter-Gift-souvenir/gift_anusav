import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: const Center(
        child: Text('Quiz Screen — Coming Soon'),
      ),
    );
  }
}