import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'state/theme_provider.dart';
import 'state/favorites_provider.dart';
import 'state/booking_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  // Ensure Flutter is ready before running async code
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved preferences before app starts
  final themeProvider = ThemeProvider();
  final favoritesProvider = FavoritesProvider();

  await themeProvider.loadTheme();
  await favoritesProvider.loadFavorites();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => favoritesProvider),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const GiftAnusavApp(),
    ),
  );
}

class GiftAnusavApp extends StatelessWidget {
  const GiftAnusavApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      // --- App Info ---
      title: 'Gift Anusav',
      debugShowCheckedModeBanner: false,

      // --- Theme ---
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,

      // --- Router ---
      routerConfig: AppRouter.router,
    );
  }
}