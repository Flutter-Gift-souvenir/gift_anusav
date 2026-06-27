import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../data/supabase_repository.dart';

class CollectionScreen extends StatelessWidget {
  final String collectionId;

  const CollectionScreen({super.key, required this.collectionId});

  Future<Map<String, dynamic>> _loadScreenData() async {
    // Collection + its products now come from Supabase (not mock JSON).
    final Map<String, dynamic>? collectionData =
        await SupabaseRepository.getCollectionById(collectionId);

    if (collectionData == null) {
      throw Exception('Collection "$collectionId" not found in Supabase.');
    }

    final List<String> productIds =
        List<String>.from(collectionData['productIds'] ?? const []);

    final List<Map<String, dynamic>> collectionProducts =
        await SupabaseRepository.getProductsByIds(productIds);

    return {
      'collection': collectionData,
      'products': collectionProducts,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadScreenData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState(isDark);
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildErrorState(context, snapshot.error.toString());
          }

          final collection =
              snapshot.data!['collection'] as Map<String, dynamic>;
          final products =
              snapshot.data!['products'] as List<Map<String, dynamic>>;

          final title = _safeText(collection, ['title', 'name'], 'Collection');
          final occasion =
              _safeText(collection, ['occasion', 'category'], 'Gift Collection');
          final description = _safeText(
            collection,
            ['description', 'story', 'subtitle'],
            'A curated collection of Cambodian handmade gifts and cultural souvenirs.',
          );
          final coverImage = _safeImage(collection, [
            'coverImageUrl',
            'coverImage',
            'bannerUrl',
            'imageUrl',
            'photoUrl',
          ]);

          return Container(
            color: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  expandedHeight: 330,
                  pinned: true,
                  stretch: true,
                  backgroundColor:
                      isDark ? AppColors.surfaceDark : const Color(0xFF4A3B32),
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share collection coming soon')),
                        );
                      },
                    ),
                    const Gap(8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding:
                        const EdgeInsetsDirectional.only(start: 48, end: 48, bottom: 14),
                    title: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildNetworkImage(
                          coverImage,
                          height: double.infinity,
                          width: double.infinity,
                          borderRadius: BorderRadius.zero,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.08),
                                Colors.black.withValues(alpha: 0.82),
                              ],
                              stops: const [0.25, 1],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          right: 24,
                          bottom: 64,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildOccasionChip(occasion),
                              const Gap(14),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const Gap(10),
                              Text(
                                '${products.length} curated items',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCollectionIntroCard(
                          context,
                          occasion: occasion,
                          description: description,
                          productsCount: products.length,
                        ),
                        const Gap(28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Featured Items',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : const Color(0xFF4A3B32),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${products.length} items',
                                style: const TextStyle(
                                  color: Color(0xFF8B4513),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(6),
                        Text(
                          'Browse handmade gifts selected for this collection.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (products.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: _buildEmptyProductsState(context),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return _buildGridProductCard(context, product);
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: Gap(40)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF8B4513)),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFF8B4513), size: 42),
              const Gap(12),
              Text(
                'Collection could not load',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF4A3B32),
                ),
              ),
              const Gap(6),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      isDark ? AppColors.textSecondaryDark : const Color(0xFF777777),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccasionChip(String occasion) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2C94C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        occasion.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF8B4513),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCollectionIntroCard(
    BuildContext context, {
    required String occasion,
    required String description,
    required int productsCount,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFEDE5DA),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 24, height: 2, color: const Color(0xFF8B4513)),
              const Gap(8),
              Text(
                'About This Collection',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color:
                      isDark ? AppColors.textPrimaryDark : const Color(0xFF4A3B32),
                ),
              ),
            ],
          ),
          const Gap(14),
          Text(
            description,
            style: TextStyle(
              color:
                  isDark ? AppColors.textSecondaryDark : const Color(0xFF555555),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const Gap(16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoPill(context, Icons.card_giftcard, 'Gift ready'),
              _buildInfoPill(context, Icons.handshake_outlined, 'Handmade'),
              _buildInfoPill(context, Icons.inventory_2_outlined, '$productsCount items'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(BuildContext context, IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.grey800.withValues(alpha: 0.6)
            : const Color(0xFFF7F2EA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF8B4513)),
          const Gap(5),
          Text(
            label,
            style: TextStyle(
              color:
                  isDark ? AppColors.textSecondaryDark : const Color(0xFF5F5047),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProductsState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFEDE5DA),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 42,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF8B4513),
          ),
          const Gap(12),
          Text(
            'No items in this collection yet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  isDark ? AppColors.textPrimaryDark : const Color(0xFF4A3B32),
            ),
          ),
          const Gap(6),
          Text(
            'Your team can add product IDs in collections.json later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  isDark ? AppColors.textSecondaryDark : const Color(0xFF777777),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridProductCard(BuildContext context, Map<String, dynamic> product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = _safeText(product, ['name', 'title'], 'Handmade Gift');
    final imageUrl = _safeImage(product, ['imageUrl', 'photoUrl', 'image']);
    final price = _safePrice(product['price']);
    final category = _safeText(product, ['category', 'type'], 'Souvenir');
    final productId = product['id']?.toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.18 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: productId.isEmpty ? null : () => context.push('/detail/$productId'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildNetworkImage(
                        imageUrl,
                        height: double.infinity,
                        width: double.infinity,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor:
                              isDark ? AppColors.grey800 : Colors.white,
                          radius: 15,
                          child: Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: isDark ? AppColors.grey400 : Colors.grey,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF8B4513),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B4513),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(
    String imageUrl, {
    required double height,
    required double width,
    required BorderRadius borderRadius,
  }) {
    if (imageUrl.isEmpty) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFE9DFD2),
          borderRadius: borderRadius,
        ),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Color(0xFF8B4513), size: 34),
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: const Color(0xFFE9DFD2),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF8B4513),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFFE9DFD2),
          child: const Center(
            child: Icon(Icons.broken_image_outlined, color: Color(0xFF8B4513)),
          ),
        ),
      ),
    );
  }

  String _safeText(
    Map<String, dynamic> data,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  String _safeImage(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  double _safePrice(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}