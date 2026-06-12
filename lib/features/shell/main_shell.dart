import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_scaffold.dart'; 

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    if (location.startsWith('/gift')) return 1;
    if (location.startsWith('/map')) return 2;
    if (location.startsWith('/booking')) return 3;
    if (location.startsWith('/settings')) return 4; 
    
    return 0; 
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: _currentIndex(context),
      body: child, 
    );
  }
}