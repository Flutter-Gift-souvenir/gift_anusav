import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _key = 'favoriteIds';

  // Store favorite product IDs as a Set for fast lookup
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  int get count => _favoriteIds.length;

  // Check if a product is already in favorites
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  // Load saved favorites from local storage when app starts
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_key) ?? [];
    _favoriteIds.addAll(saved);
    notifyListeners();
  }

  // Add or remove a product from favorites
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }

    // Save updated list to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _favoriteIds.toList());
    notifyListeners();
  }

  // Remove all favorites at once
  Future<void> clearAll() async {
    _favoriteIds.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    notifyListeners();
  }
}