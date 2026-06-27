import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  // --- Booking State (in-progress draft) ---
  String? _productId;
  String? _productName;
  double? _productPrice;

  String _giftMessage = '';
  bool _isGiftWrapped = false;
  DateTime? _deliveryDate;
  int _quantity = 1;

  // --- Orders / notification badge state ---
  // Tracks how many newly placed orders the user hasn't viewed yet.
  // Used to show a badge on the cart icon (AppBar) and Orders icon (footer).
  int _unseenOrdersCount = 0;

  // --- Getters ---
  String? get productId => _productId;
  String? get productName => _productName;
  double? get productPrice => _productPrice;
  String get giftMessage => _giftMessage;
  bool get isGiftWrapped => _isGiftWrapped;
  DateTime? get deliveryDate => _deliveryDate;
  int get quantity => _quantity;
  int get unseenOrdersCount => _unseenOrdersCount;
  bool get hasUnseenOrders => _unseenOrdersCount > 0;

  // Calculate total price
  double get totalPrice {
    final base = (_productPrice ?? 0) * _quantity;
    final wrappingFee = _isGiftWrapped ? 2.0 : 0.0;
    return base + wrappingFee;
  }

  // Check if booking is ready to confirm
  bool get isReadyToConfirm {
    return _productId != null && _deliveryDate != null && _quantity > 0;
  }

  // --- Setters ---

  // Start a new booking with a product
  void startBooking({
    required String productId,
    required String productName,
    required double productPrice,
  }) {
    _productId = productId;
    _productName = productName;
    _productPrice = productPrice;
    _quantity = 1;
    _giftMessage = '';
    _isGiftWrapped = false;
    _deliveryDate = null;
    notifyListeners();
  }

  void setGiftMessage(String message) {
    _giftMessage = message;
    notifyListeners();
  }

  void toggleGiftWrapping() {
    _isGiftWrapped = !_isGiftWrapped;
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    _deliveryDate = date;
    notifyListeners();
  }

  void setQuantity(int quantity) {
    if (quantity < 1) return; // prevent 0 or negative
    _quantity = quantity;
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  // Reset everything after order is confirmed
  void clearBooking() {
    _productId = null;
    _productName = null;
    _productPrice = null;
    _giftMessage = '';
    _isGiftWrapped = false;
    _deliveryDate = null;
    _quantity = 1;
    notifyListeners();
  }

  // --- Orders / notification badge ---

  // Call this right after an order is successfully placed
  // (e.g. after the Supabase insert into your orders table succeeds).
  void markOrderPlaced() {
    _unseenOrdersCount++;
    notifyListeners();
  }

  // Call this when the user opens the My Orders screen,
  // so the badge clears once they've seen their orders.
  void markOrdersSeen() {
    if (_unseenOrdersCount == 0) return;
    _unseenOrdersCount = 0;
    notifyListeners();
  }
}