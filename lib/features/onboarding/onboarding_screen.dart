import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: const Center(
        child: Text('Onboarding Screen — Coming Soon'),
      ),
    );
  }
}