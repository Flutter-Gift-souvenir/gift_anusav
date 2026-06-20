import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.grey600;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // --- Header ---
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 32,
              bottom: 32,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Anusav',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(8),
                Container(
                  width: 40,
                  height: 3,
                  color: AppColors.gold,
                ),
              ],
            ),
          ),

          // --- Content ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  const Gap(36),

                  // --- Success Icon ---
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 48,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.goldDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(28),

                  Text(
                    'Password Reset\nSuccessful',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Gap(12),

                  Text(
                    'Your account is now secure. You can log in with your new password.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: secondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Gap(32),

                  // --- Back to Login Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Back to Login',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),

                  const Gap(40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 1,
                        color: isDark ? AppColors.grey800 : AppColors.grey200,
                      ),
                      const Gap(10),
                      Icon(Icons.settings_outlined,
                          size: 16, color: secondaryColor),
                      const Gap(10),
                      Container(
                        width: 40,
                        height: 1,
                        color: isDark ? AppColors.grey800 : AppColors.grey200,
                      ),
                    ],
                  ),

                  const Gap(16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Need help? ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => AppHelpers.showComingSoon(
                            context, 'Contact Support'),
                        child: Text(
                          'Contact Support',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}