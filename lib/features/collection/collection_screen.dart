import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class CollectionScreen extends StatelessWidget {
  final String collectionId;
  const CollectionScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: Center(
        child: Text('Collection Screen — Collection: $collectionId'),
      ),
    );
  }
}