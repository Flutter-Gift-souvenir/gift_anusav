class Artisan {
  final String id;
  final String name;
  final String masterTitle;
  final String photoUrl;
  final String specialty;    // e.g. "Silk Weaving", "Wood Carving"
  final String story;        // personal background story
  final String location;     // e.g. "Siem Reap", "Phnom Penh"
  final double rating;
  final int productCount;
  final int yearsOfExperience;
  final List<String> productIds;  // products made by this artisan
  final List<String> skills;      // e.g. ["weaving", "dyeing", "embroidery"]
  final bool isVerified;

  const Artisan({
    required this.id,
    required this.name,
    this.masterTitle = '',
    required this.photoUrl,
    required this.specialty,
    required this.story,
    required this.location,
    required this.rating,
    required this.productCount,
    required this.yearsOfExperience,
    required this.productIds,
    required this.skills,
    required this.isVerified,
  });

  // Convert JSON map to Artisan object
  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'] as String,
      name: json['name'] as String,
      masterTitle: json['masterTitle'] as String? ?? '',
      photoUrl: json['photoUrl'] as String,
      specialty: json['specialty'] as String,
      story: json['story'] as String,
      location: json['location'] as String,
      rating: (json['rating'] as num).toDouble(),
      productCount: json['productCount'] as int,
      yearsOfExperience: json['yearsOfExperience'] as int,
      productIds: List<String>.from(json['productIds'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      isVerified: json['isVerified'] as bool,
    );
  }

  // Convert a Supabase row (snake_case columns) to an Artisan object
  factory Artisan.fromSupabase(Map<String, dynamic> m) {
    return Artisan(
      id: m['id'] as String,
      name: m['name'] as String,
      masterTitle: m['master_title'] as String? ?? '',
      photoUrl: m['photo_url'] as String? ?? '',
      specialty: m['specialty'] as String? ?? '',
      story: m['story'] as String? ?? '',
      location: m['location'] as String? ?? '',
      rating: (m['rating'] as num?)?.toDouble() ?? 0,
      productCount: (m['product_count'] as int?) ?? 0,
      yearsOfExperience: (m['years_of_experience'] as int?) ?? 0,
      productIds: List<String>.from(m['product_ids'] ?? const []),
      skills: List<String>.from(m['skills'] ?? const []),
      isVerified: (m['is_verified'] as bool?) ?? false,
    );
  }

  // Convert Artisan object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'specialty': specialty,
      'story': story,
      'location': location,
      'rating': rating,
      'productCount': productCount,
      'yearsOfExperience': yearsOfExperience,
      'productIds': productIds,
      'skills': skills,
      'isVerified': isVerified,
    };
  }
}