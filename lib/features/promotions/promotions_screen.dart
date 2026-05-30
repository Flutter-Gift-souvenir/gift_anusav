import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: const Center(
        child: Text('Promotions Screen — Coming Soon'),
      ),
    );
  }
}