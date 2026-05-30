import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 2,
      body: const Center(
        child: Text('Nearby Screen — Coming Soon'),
      ),
    );
  }
}