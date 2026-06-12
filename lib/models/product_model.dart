class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> images;
  final String category;
  final String artisanId;
  final String artisanName;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String origin;       // e.g. "Siem Reap", "Kampot"
  final List<String> tags;   // e.g. ["silk", "handmade", "traditional"]

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.images,
    required this.category,
    required this.artisanId,
    required this.artisanName,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.origin,
    required this.tags,
  });

  // Convert JSON map to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] as String,
      artisanId: json['artisanId'] as String,
      artisanName: json['artisanName'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isAvailable: json['isAvailable'] as bool,
      origin: json['origin'] as String,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  // Convert Product object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'artisanId': artisanId,
      'artisanName': artisanName,
      'rating': rating,
      'reviewCount': reviewCount,
      'isAvailable': isAvailable,
      'origin': origin,
      'tags': tags,
    };
  }
}