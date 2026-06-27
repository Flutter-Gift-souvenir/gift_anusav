import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../models/artisan_model.dart';
import '../models/shop_model.dart';
import '../models/collection_model.dart';
import '../models/promotion_model.dart';

class SupabaseRepository {
  static final _db = Supabase.instance.client;

  // Get all products
  static Future<List<Product>> getProducts() async {
    final rows = await _db.from('products').select();
    return (rows as List)
        .map((e) => Product.fromSupabase(e as Map<String, dynamic>))
        .toList();
  }

  // Get one product by its id (for the detail screen)
  static Future<Product?> getProductById(String id) async {
    final row = await _db
        .from('products')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (row == null) return null;
    return Product.fromSupabase(row);
  }

  // ── Artisans ──────────────────────────────────────────────

  // Get all artisans as Artisan objects (for the Home screen)
  static Future<List<Artisan>> getArtisans() async {
    final rows = await _db.from('artisans').select();
    return (rows as List)
        .map((e) => Artisan.fromSupabase(e as Map<String, dynamic>))
        .toList();
  }

  // Get one artisan as an Artisan object (for the Chat header)
  static Future<Artisan?> getArtisanById(String id) async {
    final row =
        await _db.from('artisans').select().eq('id', id).maybeSingle();
    if (row == null) return null;
    return Artisan.fromSupabase(row);
  }

  // Get one artisan as a raw map with the SAME field names the
  // Artisan Profile screen already expects (camelCase keys).
  static Future<Map<String, dynamic>?> getArtisanRawById(String id) async {
    final row = await _db
        .from('artisans')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (row == null) return null;
    return {
      'id': row['id'],
      'name': row['name'],
      'masterTitle': row['master_title'],
      'totalSales': row['total_sales'],
      'photoUrl': row['photo_url'],
      'specialty': row['specialty'],
      'story': row['story'],
      'location': row['location'],
      'rating': row['rating'],
      'productCount': row['product_count'],
      'yearsOfExperience': row['years_of_experience'],
      'productIds': List<String>.from(row['product_ids'] ?? const []),
      'skills': List<String>.from(row['skills'] ?? const []),
      'isVerified': row['is_verified'],
      'atelierGallery': row['atelier_gallery'] ?? const [],
      'collectionIds': List<String>.from(row['collection_ids'] ?? const []),
    };
  }

  // ── Helpers: turn a Supabase row (snake_case) into a camelCase map
  //    that the existing screens already read. ────────────────────
  static Map<String, dynamic> _productRowToMap(Map<String, dynamic> r) => {
        'id': r['id'],
        'name': r['name'],
        'description': r['description'],
        'price': r['price'],
        'imageUrl': r['image_url'],
        'images': r['images'] ?? const [],
        'category': r['category'],
        'artisanId': r['artisan_id'],
        'artisanName': r['artisan_name'],
        'rating': r['rating'],
        'reviewCount': r['review_count'],
        'isAvailable': r['is_available'],
        'origin': r['origin'],
        'tags': r['tags'] ?? const [],
      };

  static Map<String, dynamic> _collectionRowToMap(Map<String, dynamic> r) => {
        'id': r['id'],
        'title': r['title'],
        'description': r['description'],
        'coverImageUrl': r['cover_image_url'],
        'occasion': r['occasion'],
        'productIds': List<String>.from(r['product_ids'] ?? const []),
        'isFeatured': r['is_featured'],
      };

  // Products by a list of ids (camelCase maps) — for the artisan's
  // Signature Collection and the Collection screen's product grid.
  static Future<List<Map<String, dynamic>>> getProductsByIds(
      List<String> ids) async {
    if (ids.isEmpty) return [];
    final rows = await _db.from('products').select().inFilter('id', ids);
    return (rows as List)
        .map((r) => _productRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // One collection by id (camelCase map) — for the Collection screen.
  static Future<Map<String, dynamic>?> getCollectionById(String id) async {
    final row =
        await _db.from('collections').select().eq('id', id).maybeSingle();
    if (row == null) return null;
    return _collectionRowToMap(row);
  }

  // Several collections by ids — for the artisan's Signature Collection.
  static Future<List<Map<String, dynamic>>> getCollectionsByIds(
      List<String> ids) async {
    if (ids.isEmpty) return [];
    final rows = await _db.from('collections').select().inFilter('id', ids);
    return (rows as List)
        .map((r) => _collectionRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // All collections (for the Home "Curated Collections" section)
  static Future<List<Map<String, dynamic>>> getCollections() async {
    final rows = await _db.from('collections').select();
    return (rows as List)
        .map((r) => _collectionRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // All collections as Collection objects (for the Gifts screen)
  static Future<List<Collection>> getCollectionObjects() async {
    final rows = await _db.from('collections').select();
    return (rows as List)
        .map((r) => Collection.fromSupabase(r as Map<String, dynamic>))
        .toList();
  }

  // ── Promotions ────────────────────────────────────────────

  // All promotions (for the Promotions screen)
  static Future<List<Promotion>> getPromotions() async {
    final rows = await _db
        .from('promotions')
        .select()
        .order('start_date', ascending: false);
    return (rows as List)
        .map((r) => Promotion.fromSupabase(r as Map<String, dynamic>))
        .toList();
  }

  // Active promotions only (for the Map banner)
  static Future<List<Promotion>> getActivePromotions() async {
    final rows =
        await _db.from('promotions').select().eq('is_active', true);
    return (rows as List)
        .map((r) => Promotion.fromSupabase(r as Map<String, dynamic>))
        .toList();
  }

  // Featured collections only (for the Home hero carousel)
  static Future<List<Map<String, dynamic>>> getFeaturedCollections() async {
    final rows =
        await _db.from('collections').select().eq('is_featured', true);
    return (rows as List)
        .map((r) => _collectionRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // Distinct product categories (for Home "Browse by Craft")
  static Future<List<String>> getCraftCategories() async {
    final rows = await _db.from('products').select('category');
    final seen = <String>[];
    for (final r in (rows as List)) {
      final c = (r as Map<String, dynamic>)['category'] as String?;
      if (c != null && c.trim().isNotEmpty && !seen.contains(c)) {
        seen.add(c);
      }
    }
    return seen;
  }

  // The atelier gallery list for one artisan — for the Gallery screen.
  // Returns a list of {imageUrl, caption} maps.
  static Future<List<Map<String, dynamic>>> getAtelierGalleryByArtisanId(
      String artisanId) async {
    final row = await _db
        .from('artisans')
        .select('atelier_gallery')
        .eq('id', artisanId)
        .maybeSingle();
    if (row == null || row['atelier_gallery'] == null) return [];
    return (row['atelier_gallery'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ── Shops ─────────────────────────────────────────────────

  // Get all shops (for Map + Nearby screens)
  static Future<List<Shop>> getShops() async {
    final rows = await _db.from('shops').select();
    return (rows as List)
        .map((e) => Shop.fromSupabase(e as Map<String, dynamic>))
        .toList();
  }

  // Get one shop by id
  static Future<Shop?> getShopById(String id) async {
    final row =
        await _db.from('shops').select().eq('id', id).maybeSingle();
    if (row == null) return null;
    return Shop.fromSupabase(row);
  }

  // ── Reviews (user-writable) ───────────────────────────────

  // Turn a Supabase review row into the map shape the screens read.
  static Map<String, dynamic> _reviewRowToMap(Map<String, dynamic> r) => {
        'id': r['id'],
        'name': r['name'] ?? '',
        'initials': r['initials'] ?? '',
        // rating is a numeric column (comes back as double) but the UI
        // treats it as whole stars, so normalise to int here.
        'rating': (r['rating'] as num?)?.round() ?? 0,
        'date': r['date'] ?? '',
        'product': r['product'] ?? '',
        'comment': r['comment'] ?? '',
        'hasPhoto': r['has_photo'] ?? false,
        'helpful': r['helpful'] ?? 0,
      };

  // Reviews for a product (newest first)
  static Future<List<Map<String, dynamic>>> getReviewsByProductId(
      String productId) async {
    final rows = await _db
        .from('reviews')
        .select()
        .eq('product_id', productId)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => _reviewRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // Reviews for an artisan (newest first)
  static Future<List<Map<String, dynamic>>> getReviewsByArtisanId(
      String artisanId) async {
    final rows = await _db
        .from('reviews')
        .select()
        .eq('artisan_id', artisanId)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => _reviewRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // Create a review as the currently logged-in user.
  // Throws if no user is logged in (so the UI can prompt to sign in).
  static Future<void> createReview({
    String? productId,
    String? artisanId,
    required double rating,
    required String comment,
    String? productLabel,
  }) async {
    final user = _db.auth.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to write a review.');
    }

    // Use the profile's full name if available, else the email prefix.
    String name = user.email?.split('@').first ?? 'Customer';
    try {
      final profile = await _db
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();
      final fullName = profile?['full_name'] as String?;
      if (fullName != null && fullName.trim().isNotEmpty) {
        name = fullName.trim();
      }
    } catch (_) {
      // ignore profile lookup errors; fall back to email name
    }

    await _db.from('reviews').insert({
      'product_id': productId,
      'artisan_id': artisanId,
      'product': productLabel,
      'user_id': user.id,
      'name': name,
      'initials': _initialsFrom(name),
      'rating': rating,
      'comment': comment,
      'date': 'Just now',
      'has_photo': false,
      'helpful': 0,
    });
  }

  static String _initialsFrom(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'CU';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // ── Bookings (user-data) ──────────────────────────────────

  // Create a booking as the logged-in user and return the new booking id.
  static Future<String> createBooking({
    required String productId,
    required String productName,
    required String productImageUrl,
    required double price,
    String? recipient,
    String? note,
    String? deliveryDate,
    bool giftWrap = false,
    bool greetingCard = false,
    String status = 'Order Processing',
    double progress = 0.25,
  }) async {
    final user = _db.auth.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to place an order.');
    }

    final row = await _db
        .from('bookings')
        .insert({
          'user_id': user.id,
          'product_id': productId,
          'product_name': productName,
          'product_image_url': productImageUrl,
          'recipient': recipient,
          'note': note,
          'delivery_date': deliveryDate,
          'gift_wrap': giftWrap,
          'greeting_card': greetingCard,
          'price': price,
          'status': status,
          'progress': progress,
        })
        .select('id')
        .single();

    return row['id'].toString();
  }

  // Turn a booking row into the map shape the history screen reads.
  static Map<String, dynamic> _bookingRowToMap(Map<String, dynamic> r) => {
        'id': r['id'],
        'name': r['product_name'] ?? '',
        'imageUrl': r['product_image_url'] ?? '',
        'status': r['status'] ?? 'Order Processing',
        'date': r['delivery_date'] ?? '',
        'price': (r['price'] as num?)?.toDouble() ?? 0,
        'progress': (r['progress'] as num?)?.toDouble() ?? 0.75,
        'recipient': r['recipient'] ?? '',
        'note': r['note'] ?? '',
        'giftWrap': r['gift_wrap'] ?? false,
        'greetingCard': r['greeting_card'] ?? false,
        'productId': r['product_id'] ?? '',
      };

  // All bookings for the logged-in user (newest first).
  static Future<List<Map<String, dynamic>>> getMyBookings() async {
    final user = _db.auth.currentUser;
    if (user == null) return [];
    final rows = await _db
        .from('bookings')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => _bookingRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // One booking by id for the logged-in user.
  static Future<Map<String, dynamic>?> getBookingById(String id) async {
    final user = _db.auth.currentUser;
    if (user == null) return null;
    final row = await _db
        .from('bookings')
        .select()
        .eq('id', id)
        .eq('user_id', user.id)
        .maybeSingle();
    if (row == null) return null;
    return _bookingRowToMap(row);
  }

  // Cancel one booking owned by the logged-in user.
  static Future<void> cancelBooking(String id) async {
    final user = _db.auth.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to cancel an order.');
    }

    await _db
        .from('bookings')
        .update({
          'status': 'Cancelled',
          'progress': 1.0,
        })
        .eq('id', id)
        .eq('user_id', user.id);
  }

  // ── Chat messages (user-data) ─────────────────────────────

  static Map<String, dynamic> _messageRowToMap(Map<String, dynamic> r) => {
        'text': r['text'] ?? '',
        'isMe': r['is_me'] ?? true,
        'time': r['time'] ?? '',
        'status': r['status'] ?? '',
      };

  // All messages between the logged-in user and an artisan (oldest first).
  static Future<List<Map<String, dynamic>>> getMessagesByArtisanId(
      String artisanId) async {
    final user = _db.auth.currentUser;
    if (user == null) return [];
    final rows = await _db
        .from('chat_messages')
        .select()
        .eq('user_id', user.id)
        .eq('artisan_id', artisanId)
        .order('created_at', ascending: true);
    return (rows as List)
        .map((r) => _messageRowToMap(r as Map<String, dynamic>))
        .toList();
  }

  // Send (insert) a message. is_me=true for the user, false for the
  // artisan reply. Both rows are owned by the current user.
  static Future<void> sendMessage({
    required String artisanId,
    required String text,
    bool isMe = true,
    String? time,
    String status = '',
  }) async {
    final user = _db.auth.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to send a message.');
    }
    await _db.from('chat_messages').insert({
      'user_id': user.id,
      'artisan_id': artisanId,
      'text': text,
      'is_me': isMe,
      'time': time,
      'status': status,
    });
  }

  // OPTIONAL — live updates via Supabase Realtime.
  // Not wired into the chat screen by default; you can switch the
  // screen to a StreamBuilder using this later if you want live chat.
  static Stream<List<Map<String, dynamic>>> watchMessagesByArtisanId(
      String artisanId) {
    final user = _db.auth.currentUser;
    return _db
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('artisan_id', artisanId)
        .order('created_at')
        .map((rows) => rows
            .where((r) => r['user_id'] == user?.id)
            .map((r) => _messageRowToMap(r))
            .toList());
  }
}