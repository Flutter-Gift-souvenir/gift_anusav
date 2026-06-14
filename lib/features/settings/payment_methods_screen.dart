import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool _enableCOD = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.grey600;
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.white;

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
                  Expanded(
                    child: Text(
                      'Payment Methods',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(Icons.lock_outline, color: AppColors.primary),
                  const Gap(8),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Saved Cards ---
                    _buildSectionLabel('SAVED CARDS', secondaryColor),
                    const Gap(8),

                    _CardItem(
                      icon: Icons.credit_card,
                      iconBg: AppColors.grey800,
                      lastFour: '4242',
                      expiry: 'Exp 12/25',
                      isDefault: true,
                      isDark: isDark,
                      textColor: textColor,
                      secondaryColor: secondaryColor,
                      cardColor: cardColor,
                    ),
                    const Gap(10),
                    _CardItem(
                      icon: Icons.credit_card,
                      iconBg: AppColors.gold,
                      lastFour: '8899',
                      expiry: 'Exp 08/24',
                      isDefault: false,
                      isDark: isDark,
                      textColor: textColor,
                      secondaryColor: secondaryColor,
                      cardColor: cardColor,
                    ),

                    const Gap(20),

                    // --- Mobile Payments ---
                    _buildSectionLabel('MOBILE PAYMENTS', secondaryColor),
                    const Gap(8),

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
                          _MobilePaymentTile(
                            label: 'ABA Pay',
                            badgeText: 'ABA',
                            badgeColor: const Color(0xFF1E3A8A),
                            isConnected: true,
                            textColor: textColor,
                          ),
                          Divider(
                            height: 1,
                            indent: 56,
                            color: isDark ? AppColors.grey800 : AppColors.grey200,
                          ),
                          _MobilePaymentTile(
                            label: 'Wing Money',
                            badgeText: 'WING',
                            badgeColor: const Color(0xFF8DC63F),
                            isConnected: false,
                            textColor: textColor,
                          ),
                          Divider(
                            height: 1,
                            indent: 56,
                            color: isDark ? AppColors.grey800 : AppColors.grey200,
                          ),
                          _MobilePaymentTile(
                            label: 'Bakong',
                            badgeText: 'BK',
                            badgeColor: AppColors.error,
                            isConnected: true,
                            textColor: textColor,
                          ),
                        ],
                      ),
                    ),

                    const Gap(20),

                    // --- Cash on Delivery ---
                    _buildSectionLabel('CASH ON DELIVERY', secondaryColor),
                    const Gap(8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.grey800
                                  : AppColors.grey100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.payments_outlined,
                              size: 20,
                              color: textColor,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Text(
                              'Enable COD',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch(
                            value: _enableCOD,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() => _enableCOD = value);
                            },
                          ),
                        ],
                      ),
                    ),

                    const Gap(20),

                    // --- Add New Card Button ---
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            AppHelpers.showComingSoon(context, 'Add New Card'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.goldDark,
                          side: const BorderSide(
                            color: AppColors.gold,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_card_outlined, size: 20),
                            const Gap(8),
                            Text(
                              '+ Add New Card',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.goldDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildSectionLabel(String label, Color color) {
    return Text(
      label,
      style: AppTextStyles.labelMedium.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    );
  }
}

// --- Saved Card Item ---
class _CardItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String lastFour;
  final String expiry;
  final bool isDefault;
  final bool isDark;
  final Color textColor;
  final Color secondaryColor;
  final Color cardColor;

  const _CardItem({
    required this.icon,
    required this.iconBg,
    required this.lastFour,
    required this.expiry,
    required this.isDefault,
    required this.isDark,
    required this.textColor,
    required this.secondaryColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Card icon
          Container(
            width: 48,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: AppColors.white, size: 20),
          ),

          const Gap(12),

          // Card info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '•••• $lastFour',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isDefault) ...[
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  expiry,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Edit / Delete
          IconButton(
            icon: Icon(Icons.edit_outlined, size: 18, color: secondaryColor),
            onPressed: () => AppHelpers.showComingSoon(context, 'Edit card'),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 18, color: secondaryColor),
            onPressed: () => AppHelpers.showComingSoon(context, 'Delete card'),
          ),
        ],
      ),
    );
  }
}

// --- Mobile Payment Tile ---
class _MobilePaymentTile extends StatelessWidget {
  final String label;
  final String badgeText;
  final Color badgeColor;
  final bool isConnected;
  final Color textColor;

  const _MobilePaymentTile({
    required this.label,
    required this.badgeText,
    required this.badgeColor,
    required this.isConnected,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Badge icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                badgeText,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ),
          ),

          const Gap(12),

          // Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isConnected)
                  Text(
                    'Connected',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.goldDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),

          // Status
          if (isConnected)
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.goldDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 16, color: AppColors.white),
            )
          else
            OutlinedButton(
              onPressed: () =>
                  AppHelpers.showComingSoon(context, '$label connect'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Connect',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}