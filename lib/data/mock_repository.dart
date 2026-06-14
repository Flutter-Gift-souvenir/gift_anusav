import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../models/artisan_model.dart';
import '../models/review_model.dart';
import '../models/collection_model.dart';
import '../models/promotion_model.dart';
import '../models/shop_model.dart';

class MockRepository {
  MockRepository._(); // prevent instantiation

  // --- Load raw JSON string from assets folder ---
  static Future<String> _loadJson(String path) async {
    return await rootBundle.loadString(path);
  }

  // --- Products ---
  static Future<List<Product>> getProducts() async {
    final jsonString = await _loadJson('assets/mock/items.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Product.fromJson(e)).toList();
  }

  static Future<Product?> getProductById(String id) async {
    final products = await getProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    final products = await getProducts();
    return products.where((p) => p.category == category).toList();
  }

  static Future<List<Product>> getProductsByArtisan(String artisanId) async {
    final products = await getProducts();
    return products.where((p) => p.artisanId == artisanId).toList();
  }

  static Future<List<Product>> searchProducts(String query) async {
    final products = await getProducts();
    final q = query.toLowerCase();
    return products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q)) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }

  // --- Artisans ---
  static Future<List<Artisan>> getArtisans() async {
    final jsonString = await _loadJson('assets/mock/artisans.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Artisan.fromJson(e)).toList();
  }

  static Future<Artisan?> getArtisanById(String id) async {
    final artisans = await getArtisans();
    try {
      return artisans.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- Reviews ---
  static Future<List<Review>> getReviews() async {
    final jsonString = await _loadJson('assets/mock/reviews.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Review.fromJson(e)).toList();
  }

  static Future<List<Review>> getReviewsByProduct(String productId) async {
    final reviews = await getReviews();
    return reviews.where((r) => r.productId == productId).toList();
  }

  // --- Collections ---
  static Future<List<Collection>> getCollections() async {
    final jsonString = await _loadJson('assets/mock/collections.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Collection.fromJson(e)).toList();
  }

  static Future<List<Collection>> getFeaturedCollections() async {
    final collections = await getCollections();
    return collections.where((c) => c.isFeatured).toList();
  }

  static Future<Collection?> getCollectionById(String id) async {
    final collections = await getCollections();
    try {
      return collections.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getRawCollections() async {
    final jsonString = await _loadJson('assets/mock/collections.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map<Map<String, dynamic>>((e) {
      return {
        'id': e['id'] ?? '',
        'artisanId': e['artisanId'] ?? '',
        'artisanIds': e['artisanIds'] ?? [],
        'title': e['title'] ?? e['name'] ?? '',
        'description': e['description'] ?? '',
        'coverImageUrl': e['coverImageUrl'] ?? e['imageUrl'] ?? '',
        'occasion': e['occasion'] ?? '',
        'productIds': e['productIds'] ?? [],
        'isFeatured': e['isFeatured'] ?? false,
        'validUntil': e['validUntil'],
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getRawCollectionsByArtisan(String artisanId) async {
    final collections = await getRawCollections();

    final artisanString = await _loadJson('assets/mock/artisans.json');
    final List<dynamic> artisanList = json.decode(artisanString);

    final Map<String, dynamic> artisan = artisanList
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .firstWhere(
          (item) => item['id'] == artisanId,
          orElse: () => <String, dynamic>{},
        );

    final Set<String> artisanProductIds = artisan['productIds'] is List
        ? (artisan['productIds'] as List).map((id) => id.toString()).toSet()
        : <String>{};

    return collections.where((collection) {
      if (collection['artisanId'] == artisanId) return true;

      final artisanIds = collection['artisanIds'];
      if (artisanIds is List && artisanIds.contains(artisanId)) return true;

      final productIds = collection['productIds'];
      if (productIds is List && artisanProductIds.isNotEmpty) {
        return productIds.any((id) => artisanProductIds.contains(id.toString()));
      }

      return false;
    }).toList();
  }

  static Future<Map<String, dynamic>?> getFirstRawCollectionByArtisan(String artisanId) async {
    final collections = await getRawCollectionsByArtisan(artisanId);
    if (collections.isEmpty) return null;
    return collections.first;
  }

  // --- Promotions ---
  static Future<List<Promotion>> getPromotions() async {
    final jsonString = await _loadJson('assets/mock/promotions.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Promotion.fromJson(e)).toList();
  }

  static Future<List<Promotion>> getActivePromotions() async {
    final promotions = await getPromotions();
    return promotions.where((p) => p.isActive).toList();
  }

  static Future<Promotion?> getPromotionByCoupon(String code) async {
    final promotions = await getPromotions();
    try {
      return promotions.firstWhere(
        (p) => p.couponCode.toLowerCase() == code.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // --- Categories ---
  static Future<List<String>> getCategories() async {
    final products = await getProducts();
    final categories = products.map((p) => p.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // --- Shops ---
  static Future<List<Shop>> getShops() async {
    final jsonString = await _loadJson('assets/mock/shops.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Shop.fromJson(e)).toList();
  }

  // --- Chat messages (simple map-based messages) ---
  static Future<List<Map<String, dynamic>>> getChatMessages() async {
    final jsonString = await _loadJson('assets/mock/chat_messages.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    // Ensure keys and types are consistent with UI expectations
    return jsonList.map<Map<String, dynamic>>((e) {
      return {
        'id': e['id'] ?? '',
        'artisanId': e['artisanId'] ?? '',
        'text': e['text'] ?? '',
        'isMe': e['isMe'] ?? false,
        'time': e['time'] ?? '',
        'status': e['status'] ?? '',
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getChatMessagesByArtisan(String artisanId) async {
    final messages = await getChatMessages();
    return messages.where((m) => m['artisanId'] == artisanId).toList();
  }

  // --- Gallery ---
  static Future<List<Map<String, dynamic>>> getGalleryItems() async {
    final jsonString = await _loadJson('assets/mock/gallery.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map<Map<String, dynamic>>((e) {
      return {
        'id': e['id'] ?? '',
        'artisanId': e['artisanId'] ?? '',
        'type': e['type'] ?? 'photo',
        'title': e['title'] ?? '',
        'subtitle': e['subtitle'] ?? '',
        'image': e['image'] ?? '',
        'thumbnail': e['thumbnail'] ?? e['image'] ?? '',
        'duration': e['duration'] ?? '',
        'videoUrl': e['videoUrl'] ?? '',
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getGalleryByArtisan(String artisanId) async {
    final items = await getGalleryItems();
    return items.where((i) => i['artisanId'] == artisanId).toList();
  }

  static Future<List<Map<String, dynamic>>> getGalleryByArtisanAndType(String artisanId, String type) async {
    final items = await getGalleryByArtisan(artisanId);
    return items.where((i) => i['type'] == type).toList();
  }

  // --- Raw reviews (map-based) ---
  static Future<List<Map<String, dynamic>>> getRawReviews() async {
    final jsonString = await _loadJson('assets/mock/reviews.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map<Map<String, dynamic>>((e) {
      return {
        'id': e['id'] ?? '',
        'productId': e['productId'] ?? '',
        'artisanId': e['artisanId'] ?? '',
        'product': e['product'] ?? '',
        'artisanName': e['artisanName'] ?? '',
        'name': e['name'] ?? '',
        'initials': e['initials'] ?? '',
        'rating': e['rating'] ?? 0,
        'date': e['date'] ?? '',
        'comment': e['comment'] ?? '',
        'hasPhoto': e['hasPhoto'] ?? false,
        'helpful': e['helpful'] ?? 0,
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getRawReviewsByProduct(String productId) async {
    final reviews = await getRawReviews();
    return reviews.where((r) => r['productId'] == productId).toList();
  }

  static Future<List<Map<String, dynamic>>> getRawReviewsByArtisan(String artisanId) async {
    final reviews = await getRawReviews();
    return reviews.where((r) => r['artisanId'] == artisanId).toList();
  }
}