import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.grey600;
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.white;

    // --- List items ---
    final listItems = [
      {'label': 'Rate Us', 'icon': Icons.star_outline},
      {'label': 'Share App', 'icon': Icons.share_outlined},
      {'label': 'Terms of Service', 'icon': Icons.description_outlined},
      {'label': 'Privacy Policy', 'icon': Icons.gavel_outlined},
      {'label': 'Licenses', 'icon': Icons.verified_user_outlined},
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'About Anusav',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // --- Content ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Column(
                  children: [
                    const Gap(8),

                    // --- Logo ---
                    Container(
                      width: 160,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.card_giftcard,
                            size: 40,
                            color: AppColors.primary,
                          ),
                          const Gap(4),
                          Text(
                            'Anusav',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(20),

                    // --- App Name ---
                    Text(
                      'Anusav',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const Gap(4),

                    // --- Tagline ---
                    Text(
                      'Authentic Cambodian Handmade Gifts',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const Gap(4),

                    // --- Version ---
                    Text(
                      'Version ${AppConstants.appVersion}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: secondaryColor,
                      ),
                    ),

                    const Gap(20),

                    // --- Our Mission Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const Gap(8),
                              Text(
                                'Our Mission',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Text(
                            'At Anusav, we are dedicated to empowering local Cambodian artisans by providing a global stage for their exceptional craftsmanship. Our mission is to preserve the rich cultural tapestry of Cambodia while ensuring sustainable livelihoods for the families who keep these ancient traditions alive through handmade excellence.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: textColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(16),

                    // --- Our Story Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.menu_book,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const Gap(8),
                              Text(
                                'Our Story',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Text(
                            'Born from a deep passion for the intricate textures of Khmer silk and the rustic beauty of lotus fiber, Anusav began as a small initiative to catalog local treasures. Today, it has evolved into a premium digital marketplace, bridging the gap between traditional villages and modern hearts seeking meaningful gifts.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: textColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(16),

                    // --- List Items Card ---
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < listItems.length; i++) ...[
                            InkWell(
                              onTap: () => AppHelpers.showComingSoon(
                                context,
                                listItems[i]['label'] as String,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        listItems[i]['icon'] as IconData,
                                        size: 18,
                                        color: AppColors.goldDark,
                                      ),
                                    ),
                                    const Gap(16),
                                    Expanded(
                                      child: Text(
                                        listItems[i]['label'] as String,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: secondaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (i != listItems.length - 1)
                              Divider(
                                height: 1,
                                indent: 68,
                                color: isDark
                                    ? AppColors.grey800
                                    : AppColors.grey200,
                              ),
                          ],
                        ],
                      ),
                    ),

                    const Gap(24),

                    // --- Social Section ---
                    Text(
                      'FOLLOW OUR JOURNEY',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: secondaryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const Gap(12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialIcon(
                          icon: Icons.facebook,
                          onTap: () =>
                              AppHelpers.showComingSoon(context, 'Facebook'),
                        ),
                        const Gap(16),
                        _SocialIcon(
                          icon: Icons.camera_alt_outlined,
                          onTap: () =>
                              AppHelpers.showComingSoon(context, 'Instagram'),
                        ),
                        const Gap(16),
                        _SocialIcon(
                          icon: Icons.send_outlined,
                          onTap: () =>
                              AppHelpers.showComingSoon(context, 'Telegram'),
                        ),
                      ],
                    ),

                    const Gap(20),

                    // --- Footer ---
                    Text(
                      'Made with ❤️ in Cambodia',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '© 2026 Anusav. All rights reserved.',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: secondaryColor.withOpacity(0.7),
                      ),
                    ),

                    const Gap(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Social Icon ---
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}