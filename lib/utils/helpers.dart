import 'package:flutter/material.dart';
import 'constants.dart';

class AppHelpers {
  AppHelpers._(); // prevent instantiation

  // --- Format price to string ---
  // e.g. 12.5 → "$12.50"
  static String formatPrice(double price) {
    return '${AppConstants.currencySymbol}${price.toStringAsFixed(2)}';
  }

  // --- Format rating to string ---
  // e.g. 4.8333 → "4.8"
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  // --- Format review count ---
  // e.g. 1200 → "1.2k reviews"
  static String formatReviewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k reviews';
    }
    return '$count reviews';
  }

  // --- Format date to readable string ---
  // e.g. DateTime(2024, 12, 25) → "Dec 25, 2024"
  static String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // --- Format delivery date range ---
  // returns earliest and latest delivery date from today
  static String formatDeliveryRange() {
    final now = DateTime.now();
    final earliest = now.add(
      const Duration(days: AppConstants.minDeliveryDays),
    );
    final latest = now.add(
      const Duration(days: AppConstants.maxDeliveryDays),
    );
    return '${formatDate(earliest)} – ${formatDate(latest)}';
  }

  // --- Check if a date is in the past ---
  static bool isExpired(DateTime date) {
    return DateTime.now().isAfter(date);
  }

  // --- Calculate days remaining until a date ---
  static int daysRemaining(DateTime date) {
    final now = DateTime.now();
    return date.difference(now).inDays;
  }

  // --- Capitalize first letter of a string ---
  // e.g. "handmade" → "Handmade"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // --- Truncate long text with ellipsis ---
  // e.g. "This is a very long..." (max 50 chars)
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // --- Show a snackbar message ---
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.defaultPadding),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- Show a confirmation dialog ---
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // --- Get greeting based on time of day ---
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // --- Get star list from rating ---
  // e.g. 4.3 → [full, full, full, full, half, empty]
  static List<String> getStarList(double rating) {
    final List<String> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add('full');
      } else if (rating >= i - 0.5) {
        stars.add('half');
      } else {
        stars.add('empty');
      }
    }
    return stars;
  }
}