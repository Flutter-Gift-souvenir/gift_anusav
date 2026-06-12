import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_repository.dart';
import '../../models/shop_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_card.dart';
import '../../utils/helpers.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  List<Shop> _allShops = [];
  List<Shop> _filteredShops = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _filterTopRated = false;
  bool _filterOpenNow = false;
  String _selectedDistance = 'All';

  final List<String> _distanceOptions = ['All', '< 1 km', '< 2 km', '< 5 km'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadShops() async {
    final shops = await MockRepository.getShops();
    setState(() {
      _allShops = shops;
      _filteredShops = shops;
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Shop> result = List.from(_allShops);
    if (_selectedDistance != 'All') {
      double maxDistance = 0;
      if (_selectedDistance == '< 1 km') maxDistance = 1.0;
      if (_selectedDistance == '< 2 km') maxDistance = 2.0;
      if (_selectedDistance == '< 5 km') maxDistance = 5.0;
      result = result.where((s) => s.distance < maxDistance).toList();
    }
    if (_filterTopRated) {
      result = result.where((s) => s.rating >= 4.7).toList();
    }
    if (_filterOpenNow) {
      result = result.where((s) => s.status == 'Open Now').toList();
    }
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      result = result
          .where((s) => s.name.toLowerCase().contains(query))
          .toList();
    }
    setState(() => _filteredShops = result);
  }

  void _resetFilters() {
    setState(() {
      _selectedDistance = 'All';
      _filterTopRated = false;
      _filterOpenNow = false;
      _searchController.clear();
      _filteredShops = List.from(_allShops);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            _buildFilters(isDark),
            Expanded(
              child: _isLoading
                  ? const ShimmerList(itemCount: 3, itemHeight: 280)
                  : _filteredShops.isEmpty
                      ? EmptyState(
                          icon: Icons.store_mall_directory_outlined,
                          title: 'No Shops Found',
                          message: 'Try adjusting your filters.',
                          buttonLabel: 'Reset Filters',
                          onButtonPressed: _resetFilters,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(
                            AppConstants.defaultPadding,
                          ),
                          itemCount: _filteredShops.length,
                          separatorBuilder: (_, __) => const Gap(16),
                          itemBuilder: (context, index) {
                            return _NearbyShopCard(
                              shop: _filteredShops[index],
                              isDark: isDark,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          // Back Button
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: textColor,
            ),
            onPressed: () => context.go('/map'),
          ),

          // Title or Search Field
          Expanded(
            child: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: AppTextStyles.bodyMedium.copyWith(color: textColor),
                    onChanged: (_) => _applyFilters(),
                    decoration: InputDecoration(
                      hintText: 'Search shops...',
                      border: InputBorder.none,
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.grey600 : AppColors.grey400,
                      ),
                    ),
                  )
                : Text(
                    'Nearby Shops',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),

          // Search / Close Button
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: textColor,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _applyFilters();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _DistanceChip(
            value: _selectedDistance,
            options: _distanceOptions,
            isDark: isDark,
            onChanged: (value) {
              setState(() => _selectedDistance = value);
              _applyFilters();
            },
          ),
          const Gap(8),
          _FilterChip(
            label: 'Top Rated',
            icon: Icons.star,
            isSelected: _filterTopRated,
            isDark: isDark,
            onTap: () {
              setState(() => _filterTopRated = !_filterTopRated);
              _applyFilters();
            },
          ),
          const Gap(8),
          _FilterChip(
            label: 'Open Now',
            icon: Icons.circle,
            isSelected: _filterOpenNow,
            iconColor: AppColors.success,
            isDark: isDark,
            onTap: () {
              setState(() => _filterOpenNow = !_filterOpenNow);
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }
}

// --- Big Shop Card ---
class _NearbyShopCard extends StatelessWidget {
  final Shop shop;
  final bool isDark;

  const _NearbyShopCard({required this.shop, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isOpen = shop.status == 'Open Now';
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.grey600;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image with rating badge ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.cardBorderRadius),
                ),
                child: CachedNetworkImage(
                  imageUrl: shop.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: AppColors.grey200,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: AppColors.grey200,
                    child: const Icon(
                      Icons.store,
                      color: AppColors.grey400,
                    ),
                  ),
                ),
              ),
              // Rating badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.gold,
                      ),
                      const Gap(4),
                      Text(
                        shop.rating.toString(),
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- Info section ---
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        shop.name,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      '${shop.distance} km away',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),

                const Gap(8),

                // Status + tags
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: isOpen ? AppColors.success : AppColors.warning,
                    ),
                    const Gap(4),
                    Text(
                      shop.status,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isOpen ? AppColors.success : AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    ...shop.tags.map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.grey800
                                : AppColors.grey100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.grey800,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(12),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            AppHelpers.showComingSoon(context, 'Directions'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Directions',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            AppHelpers.showComingSoon(context, 'View Store'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'View Store',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Distance Dropdown Chip ---
class _DistanceChip extends StatelessWidget {
  final String value;
  final List<String> options;
  final bool isDark;
  final Function(String) onChanged;

  const _DistanceChip({
    required this.value,
    required this.options,
    required this.isDark,
    required this.onChanged,
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distance',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            const Gap(12),
            ...options.map(
              (option) => ListTile(
                title: Text(option, style: AppTextStyles.bodyLarge),
                trailing: value == option
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  onChanged(option);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isActive = value != 'All';
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : (isDark ? AppColors.grey600 : AppColors.grey400),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value == 'All' ? 'Distance' : value,
              style: AppTextStyles.labelMedium.copyWith(
                color: isActive ? AppColors.white : textColor,
              ),
            ),
            const Gap(4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isActive ? AppColors.white : textColor,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Toggle Filter Chip ---
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final Color? iconColor;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.grey600 : AppColors.grey400),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppColors.white : (iconColor ?? textColor),
            ),
            const Gap(6),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.white : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}