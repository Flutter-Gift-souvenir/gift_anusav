// import 'package:flutter/material.dart';
// import '../../widgets/app_scaffold.dart';

// class BookingScreen extends StatelessWidget {
//   final String productId;
//   const BookingScreen({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       currentIndex: 3,
//       body: Center(
//         child: Text('Booking Screen — Product: $productId'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final String productId;
  const BookingScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Change AppScaffold to a standard Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Booking'),
      ),
      body: Center(
        child: Text('Booking Screen — Product: $productId'),
      ),
    );
  }
}