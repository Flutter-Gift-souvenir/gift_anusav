import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../models/artisan_model.dart';
import '../models/review_model.dart';
import '../models/collection_model.dart';
import '../models/promotion_model.dart';

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
}