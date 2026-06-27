import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:gap/gap.dart';
import '../../data/supabase_repository.dart';
import '../../models/shop_model.dart';
import '../../models/promotion_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/shop_card.dart';
import '../../utils/helpers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // --- State ---
  List<Shop> _shops = [];
  List<Promotion> _promotions = [];
  bool _isLoading = true;
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  // --- Load data from mock repository ---
  Future<void> _loadData() async {
    final shops = await SupabaseRepository.getShops();
    final promotions = await SupabaseRepository.getActivePromotions();
    setState(() {
      _shops = shops;
      _promotions = promotions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // --- Map ---
                _buildMap(),

                // --- Top Right Buttons ---
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
_MapButton(
  icon: Icons.layers_outlined,
  onTap: () => AppHelpers.showComingSoon(context, 'Map layers'),
),
                    ],
                  ),
                ),

                // --- Draggable Bottom Sheet ---
                _buildBottomSheet(),
              ],
            ),
    );
  }

  // --- Map Widget ---
  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(
          AppConstants.defaultLatitude,
          AppConstants.defaultLongitude,
        ),
        initialZoom: AppConstants.defaultZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        // --- Map Tiles ---
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.anusav.app',
        ),

        // --- Markers ---
        MarkerLayer(markers: _shops.map((shop) => _buildMarker(shop)).toList()),
      ],
    );
  }

  // --- Single Marker ---
  Marker _buildMarker(Shop shop) {
    return Marker(
      point: LatLng(shop.latitude, shop.longitude),
      width: 120,
      height: 80,
      child: Column(
        children: [
          // --- Gold circle with icon ---
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getMarkerIcon(shop.icon),
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          const Gap(4),

          // --- Label ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              shop.name,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- Get icon for marker ---
  IconData _getMarkerIcon(String icon) {
    switch (icon) {
      case 'temple':
        return Icons.temple_buddhist;
      case 'question':
        return Icons.help_outline;
      case 'flower':
        return Icons.local_florist;
      case 'diamond':
        return Icons.diamond_outlined;
      case 'store':
        return Icons.store;
      default:
        return Icons.location_on;
    }
  }

  // --- Draggable Bottom Sheet ---
  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.35,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

return Container(
  decoration: BoxDecoration(
    color: isDark ? AppColors.surfaceDark : AppColors.white,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // --- Drag Handle ---
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
decoration: BoxDecoration(
  color: isDark ? AppColors.grey600 : AppColors.grey400,
  borderRadius: BorderRadius.circular(2),
),
                ),
              ),

              // --- Special Offers ---
              if (_promotions.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Special Offers',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/promotions'),
                        child: Text(
                          '         All',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(8),

                // --- Promotion Cards ---
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    itemCount: _promotions.length,
                    separatorBuilder: (_, __) => const Gap(12),
                    itemBuilder: (context, index) {
                      return _PromotionCard(
                        promotion: _promotions[index],
                        index: index,
                      );
                    },
                  ),
                ),

                const Gap(24),
              ],

              // --- Nearby Artisans Header ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Artisans',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/nearby'),
                      child: Text(
                        '${_shops.length} Shops found',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(12),

              // --- Shop List ---
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                itemCount: _shops.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  return ShopCard(shop: _shops[index]);
                },
              ),

              const Gap(24),
            ],
          ),
        );
      },
    );
  }
}

// --- Map Button Widget ---
class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimaryLight),
      ),
    );
  }
}

// --- Promotion Card Widget ---
class _PromotionCard extends StatelessWidget {
  final Promotion promotion;
  final int index;

  const _PromotionCard({required this.promotion, required this.index});

  @override
  Widget build(BuildContext context) {
    final isEven = index % 2 == 0;
    final bgColor = isEven ? AppColors.primary : AppColors.gold;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            promotion.occasion.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
              letterSpacing: 1.5,
            ),
          ),
          const Gap(4),
          Text(
            '${promotion.discountPercent.toInt()}% off for all crafts',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    promotion.couponCode,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: promotion.couponCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coupon code copied!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Copy Code',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: bgColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}