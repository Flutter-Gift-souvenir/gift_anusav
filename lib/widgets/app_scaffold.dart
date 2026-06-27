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

      // --- Side Drawer (nav menu) ---
      drawer: _AppDrawer(currentIndex: currentIndex),

      // --- Header ---
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (innerContext) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: headerTextColor,
              ),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();
              },
            );
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

// --- Side Drawer (mirrors the footer: Home, Gifts, Map, Orders, Account) ---
class _AppDrawer extends StatelessWidget {
  final int currentIndex;

  const _AppDrawer({required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    Navigator.pop(context); // close the drawer first
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
    final bgColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.black.withValues(alpha: 0.08);

    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                'Anusav',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Divider(height: 1, color: dividerColor),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _DrawerNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => _onItemTapped(context, 0),
                  ),
                  _DrawerNavItem(
                    icon: Icons.card_giftcard_outlined,
                    activeIcon: Icons.card_giftcard,
                    label: 'Gifts',
                    isSelected: currentIndex == 1,
                    onTap: () => _onItemTapped(context, 1),
                  ),
                  _DrawerNavItem(
                    icon: Icons.map_outlined,
                    activeIcon: Icons.map,
                    label: 'Map',
                    isSelected: currentIndex == 2,
                    onTap: () => _onItemTapped(context, 2),
                  ),
                  _DrawerNavItem(
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag,
                    label: 'Orders',
                    isSelected: currentIndex == 3,
                    onTap: () => _onItemTapped(context, 3),
                  ),
                  _DrawerNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Account',
                    isSelected: currentIndex == 4,
                    onTap: () => _onItemTapped(context, 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Drawer row version of the same nav item used in the footer ---
class _DrawerNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerNavItem({
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
    final unselectedTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected ? AppColors.white : unselectedColor,
                ),
                const Gap(14),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.white : unselectedTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}