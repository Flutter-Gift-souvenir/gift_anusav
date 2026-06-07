import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/detail/detail_screen.dart';
import '../features/artisan/artisan_screen.dart';
import '../features/collection/collection_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/reviews/reviews_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/map/map_screen.dart';
import '../features/nearby/nearby_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/promotions/promotions_screen.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/shell/main_shell.dart';

class AppRouter {
  AppRouter._(); // prevent instantiation

  // --- Route Names ---
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String detail = '/detail';
  static const String artisan = '/artisan';
  static const String collection = '/collection';
  static const String booking = '/booking';
  static const String chat = '/chat';
  static const String reviews = '/reviews';
  static const String gallery = '/gallery';
  static const String map = '/map';
  static const String nearby = '/nearby';
  static const String favorites = '/favorites';
  static const String promotions = '/promotions';
  static const String quiz = '/quiz';

  // --- Router Config ---
  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      // ─── Onboarding (no bottom nav) ──────────────────────────────────────
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ─── Shell (screens WITH bottom nav bar) ─────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          // Map
          GoRoute(
            path: map,
            name: 'map',
            builder: (context, state) => const MapScreen(),
          ),

          // Favorites
          GoRoute(
            path: favorites,
            name: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),

          // Promotions
          GoRoute(
            path: promotions,
            name: 'promotions',
            builder: (context, state) => const PromotionsScreen(),
          ),

          // Quiz
          GoRoute(
            path: quiz,
            name: 'quiz',
            builder: (context, state) => const QuizScreen(),
          ),

          // ← MOVED INSIDE ShellRoute: Artisan Profile (WITH header + footer)
          // GoRoute(
          //   path: '$artisan/:artisanId',
          //   name: 'artisan',
          //   builder: (context, state) {
          //     final artisanId = state.pathParameters['artisanId']!;
          //     return ArtisanScreen(artisanId: artisanId);
          //   },
          // ),
        ],
      ),

      // ─── Detail screens (NO bottom nav bar) ──────────────────────────────

      // Product Detail
      // Usage: context.push('/detail/p001')
      GoRoute(
        path: '$detail/:productId',
        name: 'detail',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return DetailScreen(productId: productId);
        },
      ),

      // Collection Detail
      // Usage: context.push('/collection/c001')
      GoRoute(
        path: '$collection/:collectionId',
        name: 'collection',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          return CollectionScreen(collectionId: collectionId);
        },
      ),

      // Booking
      // Usage: context.push('/booking/p001')
      GoRoute(
        path: '$booking/:productId',
        name: 'booking',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return BookingScreen(productId: productId);
        },
      ),

      // Chat
      // Usage: context.push('/chat/a001')
      GoRoute(
        path: '$chat/:artisanId',
        name: 'chat',
        builder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return ChatScreen(artisanId: artisanId);
        },
      ),

      // Reviews
      // Usage: context.push('/reviews/p001')
      GoRoute(
        path: '$reviews/:productId',
        name: 'reviews',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return ReviewsScreen(productId: productId);
        },
      ),

      // Gallery
      // Usage: context.push('/gallery/a001')
      GoRoute(
        path: '$gallery/:artisanId',
        name: 'gallery',
        builder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return GalleryScreen(artisanId: artisanId);
        },
      ),

      // Nearby (no bottom nav — opened from Map screen)
      GoRoute(
        path: nearby,
        name: 'nearby',
        builder: (context, state) => const NearbyScreen(),
      ),

      // Artisan Profile (no bottom nav)
      GoRoute(
        path: '$artisan/:artisanId',
        name: 'artisan',
        builder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return ArtisanScreen(artisanId: artisanId);
        },
      ),
    ],
    // --- Error Page ---
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
