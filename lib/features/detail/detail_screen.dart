import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class DetailScreen extends StatelessWidget {
  final String productId;
  const DetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: Center(
        child: Text('Detail Screen — Product: $productId'),
      ),
    );
  }
}