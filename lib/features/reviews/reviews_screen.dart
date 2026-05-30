import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class ReviewsScreen extends StatelessWidget {
  final String productId;
  const ReviewsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: Center(
        child: Text('Reviews Screen — Product: $productId'),
      ),
    );
  }
}