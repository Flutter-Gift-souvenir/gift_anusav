import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import 'booking_cache.dart'; // 📦 Reads from your static list local cache

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Orders', 
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, 
                color: textPrimary
              )
            ),
            const Gap(16),
            
            // 🎛️ Tab Toggle Bar (Active / Past Orders)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey900 : AppColors.grey200, 
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.grey800 : Colors.white, 
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Center(
                        child: Text(
                          'Active', 
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)
                        )
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Past Orders', 
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
                      )
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // 🎯 Dynamic Active Bookings Monitor List
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: bookedItemsNotifier,
              builder: (context, activeOrders, child) {
                // FALLBACK SAMPLE CARD: Shows up if the cache list is empty
                if (activeOrders.isEmpty) {
                  return Column(
                    children: [
                      _buildOrderCard(
                        context: context,
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        cardColor: cardColor,
                        id: '1', 
                        imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=600',
                        title: 'Handwoven Golden Silk Lotus Scarf',
                        status: 'Order Processing',
                        date: '2026-06-16',
                        price: 120.00,
                        progress: 0.35,
                        isSample: true,
                      ),
                      const Gap(24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'PREVIOUS ORDERS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Gap(12),
                      _buildPastOrderRow(
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        cardColor: cardColor,
                        imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600',
                        title: 'Silver Plated Bracelet',
                        date: 'May 12, 2026',
                        price: '\$45.00',
                        subPrice: '185,000 KHR',
                        actionLabel: 'Reorder',
                      ),
                    ],
                  );
                }

                // DYNAMIC: Renders your custom items when added to the cache
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeOrders.length,
                  itemBuilder: (context, index) {
                    final order = activeOrders[index];
                    return _buildOrderCard(
                      context: context,
                      isDark: isDark,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      cardColor: cardColor,
                      id: order['id'].toString(),
                      imageUrl: order['imageUrl'],
                      title: order['name'],
                      status: order['status'],
                      date: order['date'],
                      price: order['price'],
                      progress: order['progress'],
                      isSample: false,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Card Layout Builder with InkWell Click Callback
  Widget _buildOrderCard({
    required BuildContext context,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color cardColor,
    required String id,
    required String imageUrl,
    required String title,
    required String status,
    required String date,
    required double price,
    required double progress,
    required bool isSample,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04), 
            blurRadius: 14,
            offset: const Offset(0, 6)
          )
        ],
      ),
      // 🎯 CLICKABLE WRAPPER: Takes the user back to the /booking/:id details path
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          context.push('/booking/$id');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(imageUrl, width: 64, height: 64, fit: BoxFit.cover),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'In Progress', 
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)
                        ),
                        const Gap(2),
                        Text(
                          title, 
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: textPrimary), 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis
                        ),
                        const Gap(2),
                        Text(
                          'Arriving: $date ${isSample ? "" : "(Customized)"}', 
                          style: TextStyle(color: textSecondary, fontSize: 13)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),
              
              // Tracking Status Information
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                  const Gap(8),
                  Text(
                    status, 
                    style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary, fontSize: 14)
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Icon(Icons.more_horiz, color: textPrimary, size: 18),
                  ),
                ],
              ),
              const Gap(12),
              
              // 🎯 FIXED: Removed syntax breaking label here
              LinearProgressIndicator(
                value: progress, 
                backgroundColor: isDark ? AppColors.grey800 : AppColors.grey200, 
                color: AppColors.primary, 
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              ),
              const Gap(12),
              
              // Bottom Artisan Verification Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_outlined, size: 14, color: AppColors.primary),
                    const Gap(6),
                    Text(
                      'Sourced directly from Artisans',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Past Orders Row Item Component
  Widget _buildPastOrderRow({
    required Color textPrimary,
    required Color textSecondary,
    required Color cardColor,
    required String imageUrl,
    required String title,
    required String date,
    required String price,
    required String subPrice,
    required String actionLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, width: 48, height: 48, fit: BoxFit.cover),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(date, style: TextStyle(color: textSecondary, fontSize: 11)),
                Row(
                  children: [
                    Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                    const Gap(6),
                    Text(subPrice, style: TextStyle(color: textSecondary, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDF6F0),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              actionLabel, 
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }
}