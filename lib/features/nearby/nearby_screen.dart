import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gift_anusav/data/mock_repository.dart';
import 'package:gift_anusav/features/home/home_screen.dart' hide AppColors;
import 'package:gift_anusav/models/shop_model.dart';
import 'package:gift_anusav/theme/app_text_styles.dart';
import 'package:gift_anusav/utils/constants.dart';
import 'package:gift_anusav/widgets/app_scaffold.dart';
import 'package:gift_anusav/widgets/empty_state.dart';
import 'package:gift_anusav/widgets/shimmer_card.dart';
import 'package:gift_anusav/widgets/shop_card.dart';
import 'package:gift_anusav/theme/app_colors.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  List<Shop> _allShops = [];
  List<Shop> _filteredShops = [];
  bool _isLoading = true;

  String _selectedDistance = 'All';
  String _selectedRating = 'All';
  bool _availableOnly = false;

  final List<String> _distanceOptions = ['All', '< 1 km', '< 2 km', '< 5 km'];
  final List<String> _ratingOptions = ['All', '4.5+', '4.0+', '3.5+'];

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  // Loading shops from mock repository
  Future<void> _loadShops() async {
    final shops = await MockRepository.getShops();
    setState(() {
      _allShops = shops;
      _filteredShops = shops;
      _isLoading = false;
    });
  }

  // Applying filters to the shop list
  void _applyFilters() {
    List<Shop> result = List.from(_allShops);
    // Filter Distance
    if (_selectedDistance != 'All') {
      double maxDistance = 0;
      if (_selectedDistance == '< 1 km') maxDistance = 1;
      if (_selectedDistance == '< 2 km') maxDistance = 2;
      if (_selectedDistance == '< 5 km') maxDistance = 5;
      result = result.where((s) => s.distance <= maxDistance).toList();
    }
    // Filter Rating
    if (_selectedRating != 'All') {
      double minRating = 0;
      if (_selectedRating == '4.5+') minRating = 4.5;
      if (_selectedRating == '4.0+') minRating = 4.0;
      if (_selectedRating == '3.5+') minRating = 3.5;
      result = result.where((s) => s.rating >= minRating).toList();
    }
    setState(() {
      _filteredShops = result;
    });
  }

  // Reset filters to default
  void resetFilters() {
    setState(() {
      _selectedDistance = 'All';
      _selectedRating = 'All';
      _availableOnly = false;
      _filteredShops = List.from(_allShops);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildFilters(),

          const Divider(height: 1),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: 10,
              ),
              child: Text(
                '${_filteredShops.length} shops found',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ),

          Expanded(
            child: _isLoading
                ? const ShimmerList(itemCount: 4, itemHeight: 110)
                : _filteredShops.isEmpty
                ? EmptyState(
                    icon: Icons.store_mall_directory_outlined,
                    title: 'No shops found',
                    message: 'Try adjusting your filters.',
                    buttonLabel: 'Reset Filters',
                    onButtonPressed: resetFilters,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      return ShopCard(shop: _filteredShops[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  ),
          ),
        ],
      ),
    ));
  }

  // Header section with title and subtitle
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.defaultPadding,
        AppConstants.defaultPadding,
        AppConstants.defaultPadding,
        8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nearby Shops',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Souvenir shops around you',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
          if (_selectedDistance != 'All' ||
              _selectedRating != 'All' ||
              _availableOnly)
            GestureDetector(
              onTap: resetFilters,
              child: Text(
                'Reset',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          // Distance Filter
          _FilterDropDown(
            label: 'Distance',
            icon: Icons.near_me_outlined,
            value: _selectedDistance,
            options: _distanceOptions,
            onChanged: (value) {
              setState(() => _selectedDistance = value);
              _applyFilters();
            },
          ),
          const Gap(8),
          // Rating Filter
          _FilterDropDown(
            label: 'Rating',
            icon: Icons.star_outlined,
            value: _selectedRating,
            options: _ratingOptions,
            onChanged: (value) {
              setState(() => _selectedRating = value);
              _applyFilters();
            },
          ),
          const Gap(8),
          // Availability Toggle
          _AvailabilityChip(
            isSelected: _availableOnly,
            onTap: () {
              setState(() => _availableOnly = !_availableOnly);
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }
}

// Filter section with dropdowns and toggle
class _FilterDropDown extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> options;
  final Function(String) onChanged;

  const _FilterDropDown({
    required this.label,
    required this.icon,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const Gap(12),
              ...options.map(
                (option) => ListTile(
                  title: Text(option, style: AppTextStyles.bodyLarge),
                  trailing: value == option
                      ? Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    onChanged(option);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isActive = value != 'All';
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.grey400,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? AppColors.white : AppColors.grey600,
            ),
            const Gap(4),
            Text(
              value == 'All' ? label : value,
              style: AppTextStyles.labelMedium.copyWith(
                color: isActive ? AppColors.white : AppColors.grey600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: isActive ? AppColors.white : AppColors.grey600,
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _AvailabilityChip({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey400,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 14,
              color: isSelected ? AppColors.white : AppColors.grey600,
            ),
            const Gap(4),
            Text(
              'Available Now',
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
