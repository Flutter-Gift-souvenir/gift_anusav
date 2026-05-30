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