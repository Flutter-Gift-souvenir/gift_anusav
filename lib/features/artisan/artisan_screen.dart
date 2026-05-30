import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class ArtisanScreen extends StatelessWidget {
  final String artisanId;
  const ArtisanScreen({super.key, required this.artisanId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: Center(
        child: Text('Artisan Screen — Artisan: $artisanId'),
      ),
    );
  }
}