import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/artisan/artisan_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/reset_password_screen.dart';
import '../features/auth/reset_success_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/verify_code_screen.dart';
import '../features/booking/booking_history_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/booking/order_detail_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/collection/collection_screen.dart' as collection_screen;
import '../features/detail/detail_screen.dart' as detail_screen;
import '../features/gallery/gallery_screen.dart';
import '../features/gifts/gifts_screen.dart';
import '../features/home/home_screen.dart';
import '../features/map/map_screen.dart';
import '../features/nearby/nearby_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/promotions/promotions_screen.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/reviews/reviews_screen.dart';
import '../features/settings/about_screen.dart';
import '../features/settings/add_address_screen.dart';
import '../features/settings/edit_profile_screen.dart';
import '../features/settings/help_support_screen.dart';
import '../features/settings/payment_methods_screen.dart';
import '../features/settings/saved_addresses_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/main_shell.dart';

class AppRouter {
  AppRouter._();

  // Bottom-tab routes
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String gifts = '/gifts';
  static const String map = '/map';
  static const String orders = '/orders';
  static const String booking = '/booking'; // old path kept as My Orders tab
  static const String settings = '/settings';

  // Stack/detail routes
  static const String detail = '/detail';
  static const String artisan = '/artisan';
  static const String collection = '/collection';
  static const String chat = '/chat';
  static const String reviews = '/reviews';
  static const String gallery = '/gallery';
  static const String nearby = '/nearby';
  static const String promotions = '/promotions';
  static const String quiz = '/quiz';

  // Settings/auth routes
  static const String editProfile = '/edit-profile';
  static const String savedAddresses = '/saved-addresses';
  static const String addAddress = '/add-address';
  static const String helpSupport = '/help-support';
  static const String paymentMethods = '/payment-methods';
  static const String aboutAnusav = '/about';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyCode = '/verify-code';
  static const String resetPassword = '/reset-password';
  static const String resetSuccess = '/reset-success';

  // Path helpers keep navigation consistent across the app.
  static String productDetailPath(String productId) => '$detail/$productId';
  static String bookingPath(String productId) => '$booking/$productId';
  static String orderDetailPath(String orderId) => '$orders/$orderId';
  static String artisanPath(String artisanId) => '$artisan/$artisanId';
  static String collectionPath(String collectionId) => '$collection/$collectionId';
  static String chatPath(String artisanId) => '$chat/$artisanId';
  static String reviewsPath(String id) => '$reviews/$id';
  static String galleryPath(String artisanId) => '$gallery/$artisanId';
  static String verifyCodePath(String email) => '$verifyCode/$email';

  static final GoRouter router = GoRouter(
    initialLocation: Supabase.instance.client.auth.currentSession != null
        ? home
        : onboarding,
    debugLogDiagnostics: true,
    routes: [
      // Public/auth flow — no bottom navigation.
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '$verifyCode/:email',
        name: 'verifyCode',
        builder: (context, state) {
          final email = state.pathParameters['email']!;
          return VerifyCodeScreen(email: email);
        },
      ),
      GoRoute(
        path: resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: resetSuccess,
        name: 'resetSuccess',
        builder: (context, state) => const ResetSuccessScreen(),
      ),

      // Main app tabs — these keep the bottom navigation visible.
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: gifts,
            name: 'gifts',
            builder: (context, state) => const GiftsScreen(),
          ),
          GoRoute(
            path: map,
            name: 'map',
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: booking,
            name: 'bookingHistory',
            builder: (context, state) => const BookingHistoryScreen(),
          ),
          // Alias: /orders also opens My Orders.
          GoRoute(
            path: orders,
            name: 'orders',
            builder: (context, state) => const BookingHistoryScreen(),
          ),
          GoRoute(
            path: settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // Core e-commerce flow — stack pages opened from tabs.
      GoRoute(
        path: '$detail/:productId',
        name: 'productDetail',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return detail_screen.DetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '$booking/:productId',
        name: 'bookingCreate',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return BookingScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '$orders/:orderId',
        name: 'orderDetail',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return OrderDetailScreen(orderId: orderId);
        },
      ),

      // Discovery/supporting feature pages.
      GoRoute(
        path: '$collection/:collectionId',
        name: 'collectionDetail',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId']!;
          return collection_screen.CollectionScreen(
            collectionId: collectionId,
          );
        },
      ),
      GoRoute(
        path: '$artisan/:artisanId',
        name: 'artisanDetail',
        builder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return ArtisanScreen(artisanId: artisanId);
        },
      ),
      GoRoute(
        path: '$reviews/:id',
        name: 'reviews',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ReviewsScreen(productId: id);
        },
      ),
      GoRoute(
        path: '$chat/:artisanId',
        name: 'chat',
        pageBuilder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return MaterialPage(
            key: ValueKey('chat-$artisanId'),
            child: ChatScreen(artisanId: artisanId),
          );
        },
      ),
      GoRoute(
        path: '$gallery/:artisanId',
        name: 'gallery',
        builder: (context, state) {
          final artisanId = state.pathParameters['artisanId']!;
          return GalleryScreen(artisanId: artisanId);
        },
      ),
      GoRoute(
        path: nearby,
        name: 'nearby',
        builder: (context, state) => const NearbyScreen(),
      ),
      GoRoute(
        path: promotions,
        name: 'promotions',
        builder: (context, state) => const PromotionsScreen(),
      ),
      GoRoute(
        path: quiz,
        name: 'quiz',
        builder: (context, state) => const QuizScreen(),
      ),

      // Settings sub-pages — opened from Account tab.
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
        path: helpSupport,
        name: 'helpSupport',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: paymentMethods,
        name: 'paymentMethods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: aboutAnusav,
        name: 'aboutAnusav',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              Text(
                state.error.toString(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}