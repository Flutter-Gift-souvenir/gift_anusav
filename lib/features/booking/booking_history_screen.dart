import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../data/supabase_repository.dart';
import '../../theme/app_colors.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  bool _showPast = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final orders = await SupabaseRepository.getMyBookings();
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load your orders. Please try again.';
        _isLoading = false;
      });
    }
  }

  bool _isPastOrder(Map<String, dynamic> order) {
    final status = (order['status'] ?? '').toString().toLowerCase();
    return status.contains('delivered') || status.contains('cancel');
  }

  List<Map<String, dynamic>> get _visibleOrders =>
      _orders.where((order) => _isPastOrder(order) == _showPast).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Orders',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const Gap(16),
              _buildToggle(isDark: isDark),
              const Gap(24),
              _buildContent(
                context: context,
                isDark: isDark,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey900 : AppColors.grey200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _toggleItem(label: 'Active', selected: !_showPast, onTap: () => setState(() => _showPast = false)),
          _toggleItem(label: 'Past Orders', selected: _showPast, onTap: () => setState(() => _showPast = true)),
        ],
      ),
    );
  }

  Widget _toggleItem({required String label, required bool selected, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? (isDark ? AppColors.grey800 : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? AppColors.primary : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color cardColor,
  }) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return _emptyState(
        icon: Icons.error_outline,
        title: 'Unable to load orders',
        message: _error!,
        buttonLabel: 'Retry',
        onPressed: _loadOrders,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      );
    }

    final orders = _visibleOrders;
    if (orders.isEmpty) {
      return _emptyState(
        icon: _showPast ? Icons.history_outlined : Icons.shopping_bag_outlined,
        title: _showPast ? 'No past orders yet' : 'No active orders yet',
        message: _showPast
            ? 'Delivered and cancelled orders will appear here.'
            : 'Start from a product detail page and confirm a gift order.',
        buttonLabel: 'Browse Gifts',
        onPressed: () => context.go('/gifts'),
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(
          context: context,
          isDark: isDark,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          cardColor: cardColor,
          order: order,
        );
      },
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonLabel,
    required VoidCallback onPressed,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 72, color: AppColors.primary.withValues(alpha: 0.75)),
            const Gap(16),
            Text(
              title,
              style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildOrderCard({
    required BuildContext context,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color cardColor,
    required Map<String, dynamic> order,
  }) {
    final id = order['id'].toString();
    final imageUrl = order['imageUrl']?.toString() ?? '';
    final title = order['name']?.toString() ?? 'Gift item';
    final status = order['status']?.toString() ?? 'Order Processing';
    final date = order['date']?.toString() ?? '';
    final price = (order['price'] as num?)?.toDouble() ?? 0.0;
    final progress = (order['progress'] as num?)?.toDouble() ?? 0.25;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/orders/$id'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 64,
                        height: 64,
                        color: AppColors.grey200,
                        child: const Icon(Icons.image_not_supported_outlined, size: 22),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status,
                          style: TextStyle(
                            color: _statusColor(status),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(2),
                        Text(
                          date.isEmpty ? 'Delivery date not set' : 'Arriving: $date',
                          style: TextStyle(color: textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: textSecondary),
                ],
              ),
              const Gap(16),
              Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.primary),
                  const Gap(8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary, fontSize: 14),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push('/orders/$id'),
                    child: const Text('Track Order'),
                  ),
                ],
              ),
              const Gap(8),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0).toDouble(),
                backgroundColor: isDark ? AppColors.grey800 : AppColors.grey200,
                color: _statusColor(status),
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    final value = status.toLowerCase();
    if (value.contains('cancel')) return AppColors.error;
    if (value.contains('delivered')) return AppColors.success;
    if (value.contains('wrap')) return AppColors.goldDark;
    return AppColors.primary;
  }
}
