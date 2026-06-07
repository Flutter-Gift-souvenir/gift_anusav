import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
