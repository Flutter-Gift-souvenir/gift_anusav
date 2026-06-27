import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../data/supabase_repository.dart';
import '../../models/product_model.dart';
import '../../theme/app_colors.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? _order;
  Product? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final order = await SupabaseRepository.getBookingById(widget.orderId);
      Product? product;

      final productId = order?['productId']?.toString() ?? '';
      if (productId.isNotEmpty) {
        product = await SupabaseRepository.getProductById(productId);
      }

      if (!mounted) return;
      setState(() {
        _order = order;
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load this order. Please try again.';
        _isLoading = false;
      });
    }
  }

  double _asDouble(dynamic value) => (value as num?)?.toDouble() ?? 0.0;

  bool _isCancelled(String status) => status.toLowerCase().contains('cancel');
  bool _isDelivered(String status) => status.toLowerCase().contains('delivered');

  Color _statusColor(String status) {
    if (_isCancelled(status)) return AppColors.error;
    if (_isDelivered(status)) return AppColors.success;
    if (status.toLowerCase().contains('wrap')) return AppColors.goldDark;
    return AppColors.primary;
  }

  Future<void> _cancelOrder() async {
    final order = _order;
    if (order == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel order?'),
        content: const Text(
          'This will mark the order as cancelled. You can still view it in My Orders.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await SupabaseRepository.cancelBooking(widget.orderId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled.')),
      );
      await _loadOrder();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not cancel order. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Order Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/orders');
            }
          },
        ),
      ),
      body: _buildBody(
        context: context,
        cardColor: cardColor,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),
    );

    
  }

  Widget _buildBody({
    required BuildContext context,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _MessageState(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        message: _error!,
        buttonLabel: 'Retry',
        onPressed: _loadOrder,
      );
    }

    final order = _order;
    if (order == null) {
      return _MessageState(
        icon: Icons.receipt_long_outlined,
        title: 'Order not found',
        message: 'This order may have been removed or you may not have access to it.',
        buttonLabel: 'Back to My Orders',
        onPressed: () => context.go('/orders'),
      );
    }

    final status = order['status']?.toString() ?? 'Order Processing';
    final price = _asDouble(order['price']);
    final productId = order['productId']?.toString() ?? '';
    final giftWrap = order['giftWrap'] == true;
    final greetingCard = order['greetingCard'] == true;
    final isFinalStatus = _isCancelled(status) || _isDelivered(status);

    return RefreshIndicator(
      onRefresh: _loadOrder,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _productSummaryCard(
            order: order,
            status: status,
            price: price,
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const Gap(16),
          _trackingCard(
            status: status,
            progress: _asDouble(order['progress']),
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const Gap(16),
          _customizationCard(
            order: order,
            giftWrap: giftWrap,
            greetingCard: greetingCard,
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const Gap(16),
          _priceCard(
            total: price,
            giftWrap: giftWrap,
            greetingCard: greetingCard,
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const Gap(20),
          _actionButtons(productId: productId, isFinalStatus: isFinalStatus),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _productSummaryCard({
    required Map<String, dynamic> order,
    required String status,
    required double price,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final imageUrl = order['imageUrl']?.toString() ?? '';
    final title = order['name']?.toString() ?? 'Gift item';
    final artisanName = _product?.artisanName ?? 'Cambodian Artisan';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 88,
                height: 88,
                color: AppColors.grey200,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Text(
                  'by $artisanName',
                  style: TextStyle(color: textSecondary, fontSize: 13),
                ),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(10),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _trackingCard({
    required String status,
    required double progress,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final cancelled = _isCancelled(status);
    final delivered = _isDelivered(status);
    final normalized = progress.clamp(0.0, 1.0).toDouble();
    final steps = <_TrackingStep>[
      _TrackingStep('Order Placed', true),
      _TrackingStep('Processing', !cancelled && normalized >= 0.25),
      _TrackingStep('Gift Wrapping', !cancelled && normalized >= 0.50),
      _TrackingStep('Ready / Delivery', !cancelled && normalized >= 0.75),
      _TrackingStep(delivered ? 'Delivered' : cancelled ? 'Cancelled' : 'Delivered', delivered || cancelled),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Tracking',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Gap(12),
          LinearProgressIndicator(
            value: cancelled ? 1.0 : normalized,
            minHeight: 7,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: AppColors.grey200,
            color: cancelled ? AppColors.error : AppColors.primary,
          ),
          const Gap(16),
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(
                    step.done ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 20,
                    color: step.done
                        ? cancelled && step.label == 'Cancelled'
                            ? AppColors.error
                            : AppColors.primary
                        : textSecondary,
                  ),
                  const Gap(10),
                  Text(
                    step.label,
                    style: TextStyle(
                      color: step.done ? textPrimary : textSecondary,
                      fontWeight: step.done ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customizationCard({
    required Map<String, dynamic> order,
    required bool giftWrap,
    required bool greetingCard,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final note = order['note']?.toString().trim() ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gift Details',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Gap(12),
          _detailRow('Recipient', order['recipient']?.toString() ?? '-', textPrimary, textSecondary),
          _detailRow('Delivery Date', order['date']?.toString() ?? '-', textPrimary, textSecondary),
          _detailRow('Gift Wrap', giftWrap ? 'Yes' : 'No', textPrimary, textSecondary),
          _detailRow('Greeting Card', greetingCard ? 'Yes' : 'No', textPrimary, textSecondary),
          if (note.isNotEmpty) ...[
            const Gap(8),
            Text('Message / Request', style: TextStyle(color: textSecondary, fontSize: 13)),
            const Gap(4),
            Text(note, style: TextStyle(color: textPrimary, height: 1.35)),
          ],
        ],
      ),
    );
  }

  Widget _priceCard({
    required double total,
    required bool giftWrap,
    required bool greetingCard,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final addon = (giftWrap ? 5.0 : 0.0) + (greetingCard ? 2.5 : 0.0);
    final productPrice = (total - addon).clamp(0.0, double.infinity).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _priceRow('Product price', productPrice, textPrimary, textSecondary),
          if (giftWrap) _priceRow('Gift wrapping', 5.0, textPrimary, textSecondary),
          if (greetingCard) _priceRow('Greeting card', 2.5, textPrimary, textSecondary),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButtons({required String productId, required bool isFinalStatus}) {
    final product = _product;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: productId.isEmpty ? null : () => context.push('/detail/$productId'),
                icon: const Icon(Icons.remove_red_eye_outlined),
                label: const Text('View Product'),
              ),
            ),
            const Gap(12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product == null || product.artisanId.isEmpty
                    ? null
                    : () => context.push('/chat/${product.artisanId}'),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                label: const Text('Contact Artisan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: isFinalStatus ? null : _cancelOrder,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel Order'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, Color textPrimary, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textSecondary)),
          const Gap(16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, Color textPrimary, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textSecondary)),
          Text('\$${value.toStringAsFixed(2)}', style: TextStyle(color: textPrimary)),
        ],
      ),
    );
  }
}

class _TrackingStep {
  final String label;
  final bool done;

  const _TrackingStep(this.label, this.done);
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: AppColors.primary),
            const Gap(16),
            Text(
              title,
              style: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              message,
              style: TextStyle(color: textSecondary),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
