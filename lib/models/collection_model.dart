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