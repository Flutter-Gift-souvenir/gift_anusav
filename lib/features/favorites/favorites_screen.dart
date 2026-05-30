import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      body: const Center(
        child: Text('Favorites Screen — Coming Soon'),
      ),
    );
  }
}