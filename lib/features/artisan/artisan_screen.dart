import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../data/supabase_repository.dart';

class ArtisanScreen extends StatelessWidget {
  final String artisanId;

  const ArtisanScreen({super.key, required this.artisanId});

  Future<Map<String, dynamic>> _loadScreenData() async {
    // Load the artisan from Supabase (instead of assets/mock/artisans.json)
    final Map<String, dynamic>? fetchedArtisan =
        await SupabaseRepository.getArtisanRawById(artisanId);

    if (fetchedArtisan == null) {
      throw Exception('Artisan "$artisanId" not found in Supabase.');
    }

    final Map<String, dynamic> artisanData =
        Map<String, dynamic>.from(fetchedArtisan);

    final List<String> productIds = _asStringList(artisanData['productIds']);
    final List<String> collectionIds =
        _asStringList(artisanData['collectionIds']);

    // Products + collections now come from Supabase (not mock JSON).
    final List<Map<String, dynamic>> artisanProducts =
        await SupabaseRepository.getProductsByIds(productIds);

    final List<Map<String, dynamic>> artisanCollections =
        await SupabaseRepository.getCollectionsByIds(collectionIds);

    // Artisan review preview now comes from Supabase
    final List<Map<String, dynamic>> artisanReviews =
        await SupabaseRepository.getReviewsByArtisanId(artisanId);

    return {
      'artisan': artisanData,
      'products': artisanProducts,
      'collections': artisanCollections,
      'reviews': artisanReviews,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadScreenData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState(context);
          }

          if (snapshot.hasError) {
            return _buildErrorState(context, snapshot.error.toString());
          }

          final Map<String, dynamic> artisan =
              Map<String, dynamic>.from(snapshot.data?['artisan'] ?? {});
          final List<Map<String, dynamic>> products =
              (snapshot.data?['products'] as List<Map<String, dynamic>>?) ?? [];
          final List<Map<String, dynamic>> collections =
              (snapshot.data?['collections'] as List<Map<String, dynamic>>?) ?? [];
          final List<Map<String, dynamic>> reviews =
              (snapshot.data?['reviews'] as List<Map<String, dynamic>>?) ?? [];

          final String artisanName = _firstNotEmpty([
            artisan['name'],
            artisan['fullName'],
            'Cambodian Artisan',
          ]);

          final String masterTitle = _firstNotEmpty([
            artisan['masterTitle'],
            artisan['specialty'],
            'Verified Maker',
          ]);

          final String location = _firstNotEmpty([
            artisan['location'],
            artisan['province'],
            artisan['city'],
            'Cambodia',
          ]);

          final String story = _firstNotEmpty([
            artisan['story'],
            artisan['description'],
            'This Cambodian artisan creates handmade cultural gifts using traditional skills and local materials.',
          ]);

          final String totalGifts = _firstNotEmpty([
            artisan['totalSales'],
            artisan['totalGifts'],
            products.isNotEmpty ? '${products.length}+' : null,
          ]);

          final String years = _firstNotEmpty([
            artisan['yearsOfExperience'],
            artisan['years'],
            '5+',
          ]);

          final String rating = _firstNotEmpty([
            artisan['rating'],
            '4.8',
          ]);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeroHeader(
                context: context,
                artisan: artisan,
                artisanName: artisanName,
                masterTitle: masterTitle,
                location: location,
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsPanel(
                      context: context,
                      totalGifts: totalGifts,
                      years: years,
                      rating: rating,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(context, 'Meet the Maker'),
                          const Gap(16),
                          Text(
                            story,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.65,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF555555),
                            ),
                          ),
                          const Gap(20),
                          _buildSpecialtyChips(context, artisan, masterTitle, location),
                          const Gap(36),
                          _buildSectionHeaderWithAction(
                            context: context,
                            title: 'Signature Collection',
                            actionLabel: 'View All',
                            onTap: () {
                              if (collections.isNotEmpty) {
                                context.push("/collection/${collections.first['id']}");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No collection found for this artisan'),
                                  ),
                                );
                              }
                            },
                          ),
                          const Gap(12),
                        ],
                      ),
                    ),
                    _buildProductSection(context, products),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeaderWithAction(
                            context: context,
                            title: 'Inside the Atelier',
                            actionLabel: 'View All',
                            onTap: () {
                              context.push('/gallery/$artisanId');
                            },
                          ),
                          const Gap(6),
                          Text(
                            'See photos and videos from the artisan making process.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : Colors.grey.shade600,
                            ),
                          ),
                          const Gap(16),
                          _buildGalleryGrid(context, artisan),
                          const Gap(40),
                          _buildSectionHeaderWithAction(
                            context: context,
                            title: 'Artisan Stories',
                            actionLabel:
                                reviews.isEmpty ? '$rating ★' : '${reviews.length} Reviews',
                            onTap: () {
                              context.push('/reviews/$artisanId');
                            },
                          ),
                          const Gap(16),
                          if (reviews.isEmpty)
                            _buildEmptyState(
                              context: context,
                              icon: Icons.rate_review_outlined,
                              title: 'No reviews yet',
                              subtitle: 'Reviews for this artisan will appear here.',
                            )
                          else
                            ...reviews.take(2).toList().asMap().entries.map((entry) {
                              final review = entry.value;
                              return _buildReviewCard(
                                context,
                                initials: _firstNotEmpty([
                                  review['initials'],
                                  'CU',
                                ]),
                                name: _firstNotEmpty([
                                  review['name'],
                                  'Customer',
                                ]),
                                purchasedItem: _firstNotEmpty([
                                  review['product'],
                                  products.isNotEmpty ? products.first['name'] : null,
                                  'Handmade Gift',
                                ]),
                                reviewText: _firstNotEmpty([
                                  review['comment'],
                                  'Beautiful handmade quality and meaningful cultural gift.',
                                ]),
                                avatarColor: entry.key.isEven
                                    ? const Color(0xFF475B6B)
                                    : const Color(0xFFF2C94C),
                              );
                            }),
                          const Gap(40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildHeroHeader({
    required BuildContext context,
    required Map<String, dynamic> artisan,
    required String artisanName,
    required String masterTitle,
    required String location,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String heroImage = _firstNotEmpty([
      artisan['coverImageUrl'],
      artisan['coverImage'],
      artisan['bannerUrl'],
      artisan['photoUrl'],
    ]);
    final String avatarImage = _firstNotEmpty([
      artisan['avatarUrl'],
      artisan['profileUrl'],
      artisan['photoUrl'],
      heroImage,
    ]);

    return SliverAppBar(
      expandedHeight: 420.0,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFF4A3B32),
      iconTheme: const IconThemeData(color: Colors.white),

      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 16,
            ),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share feature is coming soon')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cart feature is coming soon')),
            );
          },
        ),
        const Gap(8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildNetworkImage(
              context: context,
              imageUrl: heroImage,
              fit: BoxFit.cover,
              height: 420,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVerifiedPill(masterTitle),
                  const Gap(14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAvatar(context, avatarImage),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              artisanName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            const Gap(6),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    color: Colors.white70, size: 16),
                                const Gap(4),
                                Expanded(
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
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
                  const Gap(18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Following artisan')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4513),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.person_add_alt_1, size: 18),
                          label: const Text(
                            'Follow',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.push('/chat/$artisanId');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.55)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white.withValues(alpha: 0.12),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text(
                            'Chat',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF8B4513)),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
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
                'Unable to load artisan profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF4A3B32),
                ),
              ),
              const Gap(8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedPill(String masterTitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2C94C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, size: 14, color: Color(0xFF8B4513)),
          const Gap(4),
          Text(
            masterTitle.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String imageUrl) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildNetworkImage(
          context: context,
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          height: 72,
          width: 72,
        ),
      ),
    );
  }

  Widget _buildStatsPanel({
    required BuildContext context,
    required String totalGifts,
    required String years,
    required String rating,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn('GIFTS', totalGifts),
          _buildDivider(context),
          _buildStatColumn('YEARS', years),
          _buildDivider(context),
          _buildRatingColumn('RATING', rating),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(width: 24, height: 2, color: const Color(0xFF8B4513)),
        const Gap(8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF4A3B32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeaderWithAction({
    required BuildContext context,
    required String title,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF4A3B32),
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionLabel,
            style: const TextStyle(
              color: Color(0xFF8B4513),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyChips(
    BuildContext context,
    Map<String, dynamic> artisan,
    String masterTitle,
    String location,
  ) {
    final List<String> chips = [
      masterTitle,
      location,
      ..._asStringList(artisan['tags']),
    ].where((item) => item.trim().isNotEmpty).take(4).toList();

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips.map((chip) => _buildInfoChip(context, chip)).toList(),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFF7F0E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFE9D8C4),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6B4A32),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductSection(BuildContext context, List<Map<String, dynamic>> products) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildEmptyState(
          context: context,
          icon: Icons.inventory_2_outlined,
          title: 'No signature products yet',
          subtitle: 'Products made by this artisan will appear here.',
        ),
      );
    }

    return SizedBox(
      height: 270,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final String title = _firstNotEmpty([product['name'], 'Handmade Gift']);
          final double price = _asDouble(product['price']);
          final String imageUrl = _firstNotEmpty([
            product['imageUrl'],
            product['photoUrl'],
            product['image'],
          ]);

          return _buildNewProductCard(
            context,
            title,
            '\$${price.toStringAsFixed(2)}',
            '${(price * 4100).toInt()} KHR',
            imageUrl,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.grey800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF8B4513), size: 34),
          const Gap(10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF4A3B32),
            ),
          ),
          const Gap(6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B4513),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const Gap(4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B4513),
              ),
            ),
            const Gap(2),
            const Icon(Icons.star, size: 16, color: Color(0xFFF2C94C)),
          ],
        )
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 30,
      width: 1,
      color: isDark ? AppColors.grey800 : Colors.grey.shade300,
    );
  }

  Widget _buildNewProductCard(
    BuildContext context,
    String title,
    String usdPrice,
    String khrPrice,
    String imageUrl,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 165,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.black.withValues(alpha: 0.2)
                : AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title selected')),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: _buildNetworkImage(
                      context: context,
                      imageUrl: imageUrl,
                      height: 145,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: isDark ? AppColors.grey800 : Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: isDark ? AppColors.grey400 : Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usdPrice,
                                style: const TextStyle(
                                  color: Color(0xFF8B4513),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                khrPrice,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B4513),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 14,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(BuildContext context, Map<String, dynamic> artisan) {
    final List<Map<String, dynamic>> atelierGallery =
        _asMapList(artisan['atelierGallery']);

    final List<String> galleryImages = atelierGallery
        .map((item) => _firstNotEmpty([
              item['imageUrl'],
              item['image'],
              item['photoUrl'],
              item['url'],
            ]))
        .where((imageUrl) => imageUrl.trim().isNotEmpty)
        .toList();

    final List<String> galleryCaptions = atelierGallery
        .map((item) => _firstNotEmpty([
              item['caption'],
              item['title'],
              item['name'],
              'Making Process',
            ]))
        .toList();

    final String firstImage = galleryImages.isNotEmpty
        ? galleryImages[0]
        : _firstNotEmpty([
            artisan['photoUrl'],
            'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=600',
          ]);

    final String secondImage = galleryImages.length > 1
        ? galleryImages[1]
        : firstImage;

    final String thirdImage = galleryImages.length > 2
        ? galleryImages[2]
        : secondImage;

    final String firstCaption = galleryCaptions.isNotEmpty
        ? galleryCaptions[0]
        : 'Making Process';

    final String secondCaption = galleryCaptions.length > 1
        ? galleryCaptions[1]
        : 'Atelier Detail';

    final String thirdCaption = galleryCaptions.length > 2
        ? galleryCaptions[2]
        : 'Craft Detail';

    return Column(
      children: [
        _buildGalleryImage(
          context,
          firstImage,
          firstCaption,
          200,
          double.infinity,
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: _buildGalleryImage(
                context,
                secondImage,
                secondCaption,
                140,
                double.infinity,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildGalleryImage(
                context,
                thirdImage,
                thirdCaption,
                140,
                double.infinity,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildGalleryImage(
    BuildContext context,
    String url,
    String overlayText,
    double height,
    double width,
  ) {
    return GestureDetector(
      onTap: () {
        context.push('/gallery/$artisanId');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            _buildNetworkImage(
              context: context,
              imageUrl: url,
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: overlayText.isNotEmpty ? 0.72 : 0.25),
                    ],
                    stops: const [0.55, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            if (overlayText.isNotEmpty)
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Row(
                  children: [
                    const Icon(
                      Icons.photo_camera_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const Gap(6),
                    Expanded(
                      child: Text(
                        overlayText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage({
    required BuildContext context,
    required String imageUrl,
    required BoxFit fit,
    required double height,
    required double width,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (imageUrl.trim().isEmpty) {
      return _buildImageFallback(context, height, width);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      height: height,
      width: width,
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        color: isDark ? AppColors.grey800 : Colors.grey.shade200,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8B4513),
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => _buildImageFallback(context, height, width),
    );
  }

  Widget _buildImageFallback(BuildContext context, double height, double width) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      width: width,
      color: isDark ? AppColors.grey800 : const Color(0xFFEFE7DA),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF8B4513), size: 34),
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context, {
    required String initials,
    required String name,
    required String purchasedItem,
    required String reviewText,
    required Color avatarColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFF7F5F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.grey800 : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 20,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : const Color(0xFF333333),
                      ),
                    ),
                    Text(
                      'Purchased: $purchasedItem',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFF2C94C),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            '"$reviewText"',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF555555),
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  static String _cleanString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static String _firstNotEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = _cleanString(value);
      if (text.isNotEmpty && text.toLowerCase() != 'null') {
        return text;
      }
    }
    return '';
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => _cleanString(item))
          .where((item) => item.isNotEmpty)
          .toList();
    }

    final singleValue = _cleanString(value);
    if (singleValue.isEmpty) return [];
    return [singleValue];
  }

  static List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return [];
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(_cleanString(value)) ?? 0.0;
  }
}