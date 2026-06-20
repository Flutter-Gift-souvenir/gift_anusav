import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../router/app_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex; // 0=Home, 1=Gifts, 2=Map, 3=Orders, 4=Account

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.home);
        break;
      case 1:
        context.go(AppRouter.gifts);
        break;
      case 2:
        context.go(AppRouter.map);
        break;
      case 3:
        context.go(AppRouter.booking);
        break;
      case 4:
        context.go(AppRouter.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final navBgColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final shadowColor = isDark ? AppColors.black.withValues(alpha: 0.25) : AppColors.black.withValues(alpha: 0.06);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // --- Header ---
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: headerTextColor,
          ),
          onPressed: () {
            // TODO: open drawer
          },
        ),
        title: Text(
          'Anusav',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: headerTextColor,
            ),
            onPressed: () {
              // TODO: open cart
            },
          ),
        ],
      ),

      // --- Body ---
      body: body,

      // --- Footer ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBgColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => _onTabTapped(context, 0),
                ),
                _NavItem(
                  icon: Icons.card_giftcard_outlined,
                  activeIcon: Icons.card_giftcard,
                  label: 'Gifts',
                  isSelected: currentIndex == 1,
                  onTap: () => _onTabTapped(context, 1),
                ),
                _NavItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: 'Map',
                  isSelected: currentIndex == 2,
                  onTap: () => _onTabTapped(context, 2),
                ),
                _NavItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag,
                  label: 'Orders',
                  isSelected: currentIndex == 3,
                  onTap: () => _onTabTapped(context, 3),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Account',
                  isSelected: currentIndex == 4,
                  onTap: () => _onTabTapped(context, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Single nav item ---
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark ? AppColors.textSecondaryDark : AppColors.grey600;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? AppColors.white : unselectedColor,
            ),
            if (isSelected) ...[
              const Gap(6),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}