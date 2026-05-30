class AppConstants {
  AppConstants._(); // prevent instantiation

  // --- App Info ---
  static const String appName = 'Gift Anusav';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Authentic Cambodian Handmade Gifts';

  // --- Asset Paths ---
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  static const String mockPath = 'assets/mock/';

  // --- Mock Data File Names ---
  static const String itemsJson = '${mockPath}items.json';
  static const String artisansJson = '${mockPath}artisans.json';
  static const String reviewsJson = '${mockPath}reviews.json';
  static const String collectionsJson = '${mockPath}collections.json';
  static const String promotionsJson = '${mockPath}promotions.json';

  // --- Shared Preferences Keys ---
  static const String keyIsDarkMode = 'isDarkMode';
  static const String keyFavoriteIds = 'favoriteIds';
  static const String keyHasSeenOnboarding = 'hasSeenOnboarding';

  // --- Product Categories ---
  static const List<String> categories = [
    'All',
    'Textiles',
    'Silverware',
    'Paintings',
    'Wood Carvings',
    'Ceramics',
    'Food & Spices',
    'Souvenirs',
  ];

  // --- Category Icons (Material Icons names) ---
  static const Map<String, String> categoryIcons = {
    'All': 'grid_view',
    'Textiles': 'style',
    'Silverware': 'diamond',
    'Paintings': 'palette',
    'Wood Carvings': 'forest',
    'Ceramics': 'sports_bar',
    'Food & Spices': 'restaurant',
    'Souvenirs': 'card_giftcard',
  };

  // --- Booking ---
  static const double giftWrappingFee = 2.0;
  static const int minDeliveryDays = 3;
  static const int maxDeliveryDays = 14;
  static const int maxGiftMessageLength = 150;
  static const int maxQuantity = 10;

  // --- Map ---
  static const double defaultLatitude = 11.5564;   // Phnom Penh
  static const double defaultLongitude = 104.9282;
  static const double defaultZoom = 13.0;

  // --- UI ---
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // --- Animation Durations ---
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // --- Shimmer ---
  static const int shimmerItemCount = 6;

  // --- Quiz ---
  static const int quizTotalQuestions = 5;

  // --- Currency ---
  static const String currencySymbol = '\$';
  static const String currencyCode = 'USD';
}