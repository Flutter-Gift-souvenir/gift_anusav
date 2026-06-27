class Shop {
  final String id;
  final String name;
  final String area;
  final double distance;
  final double rating;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String icon;
  final String status;
  final List<String> tags;

  const Shop({
    required this.id,
    required this.name,
    required this.area,
    required this.distance,
    required this.rating,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.icon,
    required this.status,
    required this.tags,
  });

  // Convert JSON map to Shop object
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String,
      distance: (json['distance'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      icon: json['icon'] as String,
      status: json['status'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
    );
  }

  // Convert a Supabase row (snake_case) to a Shop object
  factory Shop.fromSupabase(Map<String, dynamic> m) {
    return Shop(
      id: m['id'] as String,
      name: m['name'] as String,
      area: m['area'] as String? ?? '',
      distance: (m['distance'] as num?)?.toDouble() ?? 0,
      rating: (m['rating'] as num?)?.toDouble() ?? 0,
      imageUrl: m['image_url'] as String? ?? '',
      latitude: (m['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (m['longitude'] as num?)?.toDouble() ?? 0,
      icon: m['icon'] as String? ?? '',
      status: m['status'] as String? ?? '',
      tags: List<String>.from(m['tags'] ?? const []),
    );
  }

  // Convert Shop object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'distance': distance,
      'rating': rating,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'icon': icon,
    };
  }
}