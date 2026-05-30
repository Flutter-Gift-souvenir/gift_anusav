import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  // --- Booking State ---
  String? _productId;
  String? _productName;
  double? _productPrice;

  String _giftMessage = '';
  bool _isGiftWrapped = false;
  DateTime? _deliveryDate;
  int _quantity = 1;

  // --- Getters ---
  String? get productId => _productId;
  String? get productName => _productName;
  double? get productPrice => _productPrice;
  String get giftMessage => _giftMessage;
  bool get isGiftWrapped => _isGiftWrapped;
  DateTime? get deliveryDate => _deliveryDate;
  int get quantity => _quantity;

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
}