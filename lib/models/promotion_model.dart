class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String couponCode;
  final double discountPercent;   // e.g. 20.0 means 20% off
  final double? minimumOrder;     // minimum order amount to apply coupon
  final String occasion;          // e.g. "Khmer New Year", "Pchum Ben"
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.couponCode,
    required this.discountPercent,
    this.minimumOrder,
    required this.occasion,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  // Check if promotion is still valid today
  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  // Calculate discounted price
  double discountedPrice(double originalPrice) {
    return originalPrice * (1 - discountPercent / 100);
  }

  // Convert JSON map to Promotion object
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      couponCode: json['couponCode'] as String,
      discountPercent: (json['discountPercent'] as num).toDouble(),
      minimumOrder: json['minimumOrder'] != null
          ? (json['minimumOrder'] as num).toDouble()
          : null,
      occasion: json['occasion'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
    );
  }

  // Convert Promotion object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'couponCode': couponCode,
      'discountPercent': discountPercent,
      'minimumOrder': minimumOrder,
      'occasion': occasion,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
    };
  }
}