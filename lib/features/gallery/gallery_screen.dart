import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class GalleryScreen extends StatelessWidget {
  final String artisanId;
  const GalleryScreen({super.key, required this.artisanId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: Center(
        child: Text('Gallery Screen — Artisan: $artisanId'),
      ),
    );
  }
}