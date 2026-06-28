import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/supabase_repository.dart';
import '../../models/promotion_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/shimmer_card.dart';
import '../../utils/helpers.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  List<Promotion> _promotions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    final promotions = await SupabaseRepository.getPromotions();
    setState(() {
      _promotions = promotions;
      _isLoading = false;
    });
  }

  List<Promotion> get _activePromotions =>
      _promotions.where((p) => p.isActive).toList();

  List<Promotion> get _expiringSoon => _activePromotions.where((p) {
    final daysLeft = p.endDate.difference(DateTime.now()).inDays;
    return daysLeft <= 30;
  }).toList();

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code "$code" copied!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(AppConstants.defaultPadding),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            _buildHeader(context, isDark),

            // --- Content ---
            Expanded(
              child: _isLoading
                  ? const ShimmerList(itemCount: 3, itemHeight: 200)
                  : ListView(
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      children: [
                        // --- Active Coupons Banner ---
                        _buildActiveCouponsBanner(isDark),

                        const Gap(20),

                        // --- Featured Promotion ---
                        if (_activePromotions.isNotEmpty)
                          _buildFeaturedPromotion(
                            context,
                            _activePromotions.first,
                          ),

                        const Gap(24),

                        // --- Upcoming Occasions ---
                        Text(
                          'Upcoming Occasions',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const Gap(16),

                        // --- Promotion List ---
                        ..._promotions
                            .skip(1)
                            .map(
                              (promo) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildPromotionCard(
                                  context,
                                  promo,
                                  isDark,
                                ),
                              ),
                            ),

                        const Gap(16),

                        // --- Terms ---
                        Text(
                          'Terms and conditions apply to all offers. Anusav reserves the right to modify promotions without prior notice.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.grey600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const Gap(24),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/gifts');
              }
            },
          ),
          Expanded(
            child: Text(
              'Special Offers',
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          const Gap(8),
        ],
      ),
    );
  }

  // --- Active Coupons Banner ---
  Widget _buildActiveCouponsBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.grey800 : AppColors.grey200,
        ),
      ),
      child: Row(
        children: [
          // Ticket icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.confirmation_number,
              color: AppColors.gold,
              size: 22,
            ),
          ),

          const Gap(12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_activePromotions.length} Active Coupons',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                if (_expiringSoon.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.warning,
                      ),
                      const Gap(4),
                      Text(
                        '${_expiringSoon.length} expiring soon',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // View all
          TextButton(
            onPressed: () => AppHelpers.showComingSoon(context, 'Coupon list'),
            child: Text(
              'View all',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Featured Promotion ---
  Widget _buildFeaturedPromotion(BuildContext context, Promotion promo) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        image: DecorationImage(
          image: NetworkImage(promo.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primary.withValues(alpha: 0.7),
            BlendMode.srcOver,
          ),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'LIMITED CELEBRATION',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),

          const Gap(8),

          // Title
          Text(
            promo.title,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),

          const Gap(4),

          // Description
          Text(
            promo.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.85),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // Copy Code button
          GestureDetector(
            onTap: () => _copyCode(context, promo.couponCode),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.white.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Copy Code: ${promo.couponCode}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(8),
                  const Icon(Icons.copy, size: 16, color: AppColors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Promotion Card ---
  Widget _buildPromotionCard(
    BuildContext context,
    Promotion promo,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image ---
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.cardBorderRadius),
            ),
            child: CachedNetworkImage(
              imageUrl: promo.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(height: 150, color: AppColors.grey200),
              errorWidget: (context, url, error) => Container(
                height: 150,
                color: AppColors.grey200,
                child: const Icon(Icons.image, color: AppColors.grey400),
              ),
            ),
          ),

          // --- Info ---
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        promo.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    Text(
                      '${promo.discountPercent.toInt()}% OFF',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const Gap(6),

                // Description
                Text(
                  promo.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.grey600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Gap(8),

                // Expiry date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.grey600,
                    ),
                    const Gap(4),
                    Text(
                      'Exp: ${_formatDate(promo.endDate)}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.grey600,
                      ),
                    ),
                  ],
                ),

                const Gap(12),

                // Apply Now button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _copyCode(context, promo.couponCode),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Apply Now',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}