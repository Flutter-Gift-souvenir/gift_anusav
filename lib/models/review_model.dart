class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> photoUrls; // optional review photos

  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.photoUrls,
  });

  // Convert JSON map to Review object
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
    );
  }

  // Convert Review object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'photoUrls': photoUrls,
    };
  }
}