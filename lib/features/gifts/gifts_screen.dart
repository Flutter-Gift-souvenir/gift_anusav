import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../data/mock_repository.dart';
import '../../models/product_model.dart';
import '../../models/collection_model.dart';
import '../../utils/helpers.dart';

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({super.key});

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  List<Product> _products = [];
  List<Collection> _collections = [];
  bool _isLoading = true;

  // Recipient categories
  final List<Map<String, String>> _recipients = [
    {'label': 'For Her', 'image': 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=200'},
    {'label': 'For Him', 'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200'},
    {'label': 'For Elders', 'image': 'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=200'},
    {'label': 'For Kids', 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200'},
    {'label': 'For Friends', 'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200'},
  ];

  // KHR exchange rate
  static const double _khrRate = 4000;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final products = await MockRepository.getProducts();
    final collections = await MockRepository.getCollections();
    setState(() {
      _products = products;
      _collections = collections;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                // --- Quiz Banner ---
                _buildQuizBanner(isDark),

                const Gap(24),

                // --- Explore by Recipient ---
                _buildSectionHeader('Explore by Recipient', isDark),
                const Gap(12),
                _buildRecipientRow(isDark),

                const Gap(24),

                // --- Themed Gift Sets ---
                _buildSectionHeader('Themed Gift Sets', isDark),
                const Gap(12),
                _buildGiftSetsGrid(),

                const Gap(24),

                // --- Cultural Occasions ---
                _buildSectionHeader('Cultural Occasions', isDark),
                const Gap(12),
                _buildCulturalOccasions(),

                const Gap(24),
              ],
            ),
          );
  }

  // --- Section Header ---
  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          TextButton(
            onPressed: () => AppHelpers.showComingSoon(context, '$title - View All'),
            child: Text(
              'View All',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Quiz Banner ---
  Widget _buildQuizBanner(bool isDark) {
  return Container(
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    height: 180,
    decoration: BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.grey100,
      borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
    ),
    child: Row(
      children: [
        // Text side
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Find the\nPerfect Gift',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const Gap(4),
                Text(
                  'Take our quick quiz to find a gift they\'ll love.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
                  ),
                  maxLines: 2,
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () => context.push('/quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Start Quiz',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Image side
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(AppConstants.cardBorderRadius),
          ),
          child: CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300',
            width: 130,
            height: 180,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: isDark ? AppColors.grey800 : AppColors.grey200,
            ),
            errorWidget: (context, url, error) => Container(
              color: isDark ? AppColors.grey800 : AppColors.grey200,
              child: const Icon(
                Icons.card_giftcard,
                color: AppColors.grey400,
                size: 48,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // --- Recipient Row ---
  Widget _buildRecipientRow(bool isDark) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        itemCount: _recipients.length,
        separatorBuilder: (_, __) => const Gap(16),
        itemBuilder: (context, index) {
          final recipient = _recipients[index];
          return Column(
            children: [
              // Circle avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: recipient['image']!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                      child: const Icon(Icons.person,
                          color: AppColors.grey400),
                    ),
                  ),
                ),
              ),
              const Gap(6),
              Text(
                recipient['label']!,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Gift Sets Grid ---
  Widget _buildGiftSetsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: _products.length > 4 ? 4 : _products.length,
        itemBuilder: (context, index) {
          return _GiftSetCard(
            product: _products[index],
            khrRate: _khrRate,
          );
        },
      ),
    );
  }

  // --- Cultural Occasions ---
  Widget _buildCulturalOccasions() {
    final featured = _collections.take(4).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: featured.length,
        itemBuilder: (context, index) {
          return _OccasionCard(collection: featured[index]);
        },
      ),
    );
  }
}

// --- Gift Set Card ---
class _GiftSetCard extends StatelessWidget {
  final Product product;
  final double khrRate;

  const _GiftSetCard({
    required this.product,
    required this.khrRate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final khrPrice = (product.price * khrRate).toInt();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.black.withOpacity(0.2) : AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 130,
                color: isDark ? AppColors.grey800 : AppColors.grey200,
              ),
              errorWidget: (context, url, error) => Container(
                height: 130,
                color: isDark ? AppColors.grey800 : AppColors.grey200,
                child: const Icon(Icons.image, color: AppColors.grey400),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  product.name,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Gap(4),

                // USD Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // KHR Price
                Text(
                  '$khrPrice KHR',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
                  ),
                ),

                const Gap(6),

                // Quick Add button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => AppHelpers.showComingSoon(context, 'Add to cart'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '+ Quick Add',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Occasion Card ---
class _OccasionCard extends StatelessWidget {
  final Collection collection;

  const _OccasionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          CachedNetworkImage(
            imageUrl: collection.coverImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.grey200,
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.grey800,
            ),
          ),

          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),

          // Text overlay
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.occasion,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  collection.title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white.withOpacity(0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}