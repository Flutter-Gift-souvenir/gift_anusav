import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../../state/theme_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/app_scaffold.dart';
import '../../utils/helpers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return AppScaffold(
      currentIndex: 4,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(8),

            // --- Profile Section ---
            Center(
              child: Column(
                children: [
                  // Avatar with camera badge
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: AppColors.grey200,
                              child: const Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.grey400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.backgroundLight,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(12),

                  // Name
// Name
Text(
  'Sopheak Vuthy',
  style: AppTextStyles.titleLarge.copyWith(
    fontWeight: FontWeight.w700,
    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
  ),
),

                  // Email
                  Text(
                    'sopheak.v@anusav.com',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),

                  const Gap(8),

                  // Edit Profile
                  GestureDetector(
                    onTap: () => AppHelpers.showComingSoon(context, 'Edit Profile'),
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(24),

            // --- Preferences Section ---
            _buildSectionLabel('PREFERENCES'),
            const Gap(8),
            _buildGroupedCard([
              // Dark Mode
              _SettingsTile(
                icon: themeProvider.isDarkMode
                    ? Icons.dark_mode
                    : Icons.dark_mode_outlined,
                label: 'Dark Mode',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  activeColor: AppColors.primary,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
              // Language
              _SettingsTile(
                icon: Icons.translate,
                label: 'Language',
                subtitle: 'English/Khmer',
                onTap: () => AppHelpers.showComingSoon(context, 'Language settings'),
              ),
              // Notifications
              _SettingsTile(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                trailing: Switch(
                  value: true,
                  activeColor: AppColors.primary,
                  onChanged: (_) => AppHelpers.showComingSoon(context, 'Notifications'),
                ),
              ),
            ]),

            const Gap(20),

            // --- Account Section ---
            _buildSectionLabel('ACCOUNT'),
            const Gap(8),
            _buildGroupedCard([
              _SettingsTile(
                icon: Icons.shopping_bag_outlined,
                label: 'My Orders',
                onTap: () => AppHelpers.showComingSoon(context, 'My Orders'),
              ),
              _SettingsTile(
                icon: Icons.location_on_outlined,
                label: 'Saved Addresses',
                onTap: () => AppHelpers.showComingSoon(context, 'Saved Addresses'),
              ),
              _SettingsTile(
                icon: Icons.payment_outlined,
                label: 'Payment Methods',
                onTap: () => AppHelpers.showComingSoon(context, 'Payment Methods'),
              ),
            ]),

            const Gap(20),

            // --- Support Section ---
            _buildSectionLabel('SUPPORT'),
            const Gap(8),
            _buildGroupedCard([
              _SettingsTile(
                icon: Icons.help_outline,
                label: 'Help & Support',
                onTap: () => AppHelpers.showComingSoon(context, 'Help & Support'),
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                label: 'About Anusav',
                onTap: () => AppHelpers.showComingSoon(context, 'About Anusav'),
              ),
            ]),

            const Gap(24),

            // --- Logout Button ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => AppHelpers.showComingSoon(context, 'Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, size: 18, color: AppColors.error),
                    const Gap(8),
                    Text(
                      'Logout',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Gap(16),

            // --- Version ---
            Center(
              child: Text(
                'Version 1.0.0 (Anusav)',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ),

            const Gap(24),
          ],
        ),
      ),
    );
  }

  // --- Section Label ---
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    );
  }

  // --- Grouped Card (white container with divided tiles) ---
  Widget _buildGroupedCard(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
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
          for (int i = 0; i < tiles.length; i++) ...[
            tiles[i],
            if (i != tiles.length - 1)
              const Divider(height: 1, indent: 52),
          ],
        ],
      ),
    );
  }
}

// --- Settings Tile ---
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.textPrimaryLight),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(
                        Icons.chevron_right,
                        color: AppColors.grey400,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}