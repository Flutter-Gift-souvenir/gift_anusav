import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.grey600;

    // --- Mock Addresses ---
    final addresses = [
      {
        'label': 'Home',
        'icon': Icons.home_outlined,
        'address':
            '#123 St 456, Sangkat Boeung Keng Kang I, Khan Chamkarmon, Phnom Penh, 12302, Cambodia',
        'isDefault': true,
      },
      {
        'label': 'Work',
        'icon': Icons.work_outline,
        'address':
            'Vattanac Capital, Level 18, 66 Monivong Blvd, Phnom Penh, Cambodia',
        'isDefault': false,
      },
      {
        'label': "Parent's House",
        'icon': Icons.account_tree_outlined,
        'address': 'Road 6, Near Old Market Area, Siem Reap, Cambodia',
        'isDefault': false,
      },
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Saved Addresses',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Section Label ---
                    Text(
                      'YOUR DELIVERY LOCATIONS',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: secondaryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),

                    const Gap(12),

                    // --- Address Cards ---
                    ...addresses.map(
                      (addr) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AddressCard(
                          icon: addr['icon'] as IconData,
                          label: addr['label'] as String,
                          address: addr['address'] as String,
                          isDefault: addr['isDefault'] as bool,
                          isDark: isDark,
                          textColor: textColor,
                          secondaryColor: secondaryColor,
                        ),
                      ),
                    ),

                    // --- Dashed Box ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 32,
                            color: secondaryColor,
                          ),
                          const Gap(8),
                          Text(
                            'Sending a gift to someone else?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: secondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(4),
                          GestureDetector(
                            onTap: () => AppHelpers.showComingSoon(
                              context,
                              'New contact address',
                            ),
                            child: Text(
                              'Save a new contact address',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(16),

                    // --- Add New Address Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/add-address'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, size: 20),
                            const Gap(8),
                            Text(
                              'Add New Address',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
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
}

// --- Address Card ---
class _AddressCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String address;
  final bool isDefault;
  final bool isDark;
  final Color textColor;
  final Color secondaryColor;

  const _AddressCard({
    required this.icon,
    required this.label,
    required this.address,
    required this.isDefault,
    required this.isDark,
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Icon(icon, size: 20, color: textColor),
              const Gap(8),
              Text(
                label,
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Default',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const Gap(8),

          // Address text
          Text(
            address,
            style: AppTextStyles.bodyMedium.copyWith(color: secondaryColor),
          ),

          const Gap(12),

          Divider(
            height: 1,
            color: isDark ? AppColors.grey800 : AppColors.grey200,
          ),

          const Gap(8),

          // Edit / Delete actions
          Row(
            children: [
              GestureDetector(
                onTap: () => AppHelpers.showComingSoon(context, 'Edit address'),
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined,
                        size: 16, color: AppColors.primary),
                    const Gap(4),
                    Text(
                      'Edit',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(20),

              GestureDetector(
                onTap: () =>
                    AppHelpers.showComingSoon(context, 'Delete address'),
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: secondaryColor),
                    const Gap(4),
                    Text(
                      'Delete',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}