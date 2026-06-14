import 'package:flutter/material.dart';
import 'package:gift_anusav/features/gallery/gallery_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/detail/detail_screen.dart'; 
import '../features/artisan/artisan_screen.dart';
import '../features/collection/collection_screen.dart'; 
import '../features/booking/booking_screen.dart'; 
import '../features/chat/chat_screen.dart';
import '../features/reviews/reviews_screen.dart'; 
// import '../features/gallery/gallery_screen.dart'; 
import '../features/map/map_screen.dart';
import '../features/nearby/nearby_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/promotions/promotions_screen.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/gifts/gifts_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/edit_profile_screen.dart';
import '../features/settings/saved_addresses_screen.dart';
import '../features/settings/add_address_screen.dart';
import '../features/booking/booking_history_screen.dart';
import '../features/settings/help_support_screen.dart';
import '../features/settings/payment_methods_screen.dart';
import '../features/settings/about_screen.dart';

class AppRouter {
  AppRouter._(); 


  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String detail = '/detail';
  static const String artisan = '/artisan';
  static const String collection = '/collection';
  static const String gifts = '/gifts';
  static const String booking = '/booking';
  static const String chat = '/chat';
  static const String reviews = '/reviews';
  static const String gallery = '/gallery';
  static const String map = '/map';
  static const String nearby = '/nearby';
  static const String favorites = '/favorites';
  static const String promotions = '/promotions';
  static const String quiz = '/quiz';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String savedAddresses = '/saved-addresses';
  static const String addAddress = '/add-address';
  static const String helpSupport = '/help-support';
  static const String paymentMethods = '/payment-methods';
  static const String aboutAnusav = '/about';

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
          // Gifts
          GoRoute(
            path: gifts,
            name: 'gifts',
            builder: (context, state) => const GiftsScreen(),
          ),
          // Map
          GoRoute(
            path: map,
            name: 'map',
            builder: (context, state) => const MapScreen(),
          ),
          // Favorites (Uncommented for Vatanak's task integration)
          GoRoute(
            path: favorites,
            name: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          
          
          GoRoute(
            path: booking,
            name: 'booking_history',
            builder: (context, state) => const BookingHistoryScreen(),
          ),
        ],
      ),
      // Help & Support (no bottom nav — opened from Settings)
GoRoute(
  path: helpSupport,
  name: 'helpSupport',
  builder: (context, state) => const HelpSupportScreen(),
),
// Payment Methods (no bottom nav — opened from Settings)
GoRoute(
  path: paymentMethods,
  name: 'paymentMethods',
  builder: (context, state) => const PaymentMethodsScreen(),
),
// About Anusav (no bottom nav — opened from Settings)
GoRoute(
  path: aboutAnusav,
  name: 'aboutAnusav',
  builder: (context, state) => const AboutScreen(),
),

      // ─── Stack Screens (NO bottom nav bar) ───────────────────────────────
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: savedAddresses,
        name: 'savedAddresses',
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      GoRoute(
        path: addAddress,
        name: 'addAddress',
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: nearby,
        name: 'nearby',
        builder: (context, state) => const NearbyScreen(),
      ),

      // --- Cleaned Variable Route Configurations (Dynamic Parameter Sub-paths) ---
      
      // Product Detail (Usage: context.push('/detail/p001'))
      GoRoute(
        path: '$detail/:productId', // Resolved properly: translates to '/detail/:productId'
        name: 'detail',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return DetailScreen(productId: productId);
        },
      ),

      // Collection Detail (Usage: context.push('/collection/c001'))
      GoRoute(
        path: '$collection/:collectionId',
        name: 'collection',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          return CollectionScreen(collectionId: collectionId);
        },
      ),

      // Booking
      GoRoute(
        path: '$booking/:productId',
        name: 'booking',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return BookingScreen(productId: productId);
        },
      ),

      // Reviews
      GoRoute(
        path: '$reviews/:productId',
        name: 'reviews',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return ReviewsScreen(productId: productId);
        },
      ),

      // Gallery
      GoRoute(
        path: '$gallery/:artisanId',
        name: 'gallery',
        builder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return GalleryScreen(artisanId: artisanId);
        },
      ),

      // Artisan Profile
      GoRoute(
        path: '$artisan/:artisanId',
        name: 'artisan',
        builder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return ArtisanScreen(artisanId: artisanId);
        },
      ),

      // Chat Configuration with Customized Key transitions
    

      GoRoute(
        path: '$chat/:artisanId',
        name: 'chat',
        pageBuilder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return MaterialPage(
            key: UniqueKey(),
            child: ChatScreen(artisanId: artisanId),
          );
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