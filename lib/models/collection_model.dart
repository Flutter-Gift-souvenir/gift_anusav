class Collection {
  final String id;
  final String title;
  final String description;
  final String coverImageUrl;
  final String occasion;      // e.g. "Khmer New Year", "Wedding", "Pchum Ben"
  final List<String> productIds;
  final bool isFeatured;
  final DateTime? validUntil; // null means no expiry

  const Collection({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageUrl,
    required this.occasion,
    required this.productIds,
    required this.isFeatured,
    this.validUntil,
  });

  // Convert JSON map to Collection object
  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      occasion: json['occasion'] as String,
      productIds: List<String>.from(json['productIds'] ?? []),
      isFeatured: json['isFeatured'] as bool,
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'] as String)
          : null,
    );
  }

  // Convert a Supabase row (snake_case) to a Collection object
  factory Collection.fromSupabase(Map<String, dynamic> m) {
    return Collection(
      id: m['id'] as String,
      title: m['title'] as String? ?? '',
      description: m['description'] as String? ?? '',
      coverImageUrl: m['cover_image_url'] as String? ?? '',
      occasion: m['occasion'] as String? ?? '',
      productIds: List<String>.from(m['product_ids'] ?? const []),
      isFeatured: (m['is_featured'] as bool?) ?? false,
      validUntil: m['valid_until'] != null
          ? DateTime.tryParse(m['valid_until'].toString())
          : null,
    );
  }

  // Convert Collection object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'occasion': occasion,
      'productIds': productIds,
      'isFeatured': isFeatured,
      'validUntil': validUntil?.toIso8601String(),
    };
  }
}