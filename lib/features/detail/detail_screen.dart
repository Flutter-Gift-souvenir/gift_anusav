import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import '../../theme/app_colors.dart';

class DetailScreen extends StatefulWidget {
  final String productId;

  const DetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentImageIndex = 0;
  bool _isStoryExpanded = true;
  bool _isMaterialsExpanded = false;
  bool _isDimensionsExpanded = false;

  // 📦 Pure Frontend Mock Data List
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Handwoven Golden Silk Lotus Scarf',
      category: 'Textiles',
      isAvailable: true,
      description: 'Inspired by the lotus flowers of the Tonle Sap lake, this scarf is hand-woven by women from the Siem Reap province. Each piece takes approximately 12 days to complete, utilizing natural dyes extracted from the bark of indigenous trees.',
      price: 120.00,
      imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=600',
      rating: 4.8,
      reviewCount: 24,
      artisanName: 'Sopheak Vuthy',
      artisanId: 'artisan_01',
      origin: 'Siem Reap Province',
      tags: ['Silk', 'Scarves', 'Traditional'],
      images: [
        'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=600',
      ],
    ),
    Product(
      id: '2',
      name: 'Cambodian Silver Plated Bracelet',
      category: 'Jewelry',
      isAvailable: true,
      description: 'Crafted carefully in the historical silver-smithing village of Kampong Luong. Features traditional Angkorian floral carvings engraved intricately by hand over pure silver alloys.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600',
      rating: 4.9,
      reviewCount: 18,
      artisanName: 'Chantha Piseth',
      artisanId: 'artisan_02',
      origin: 'Kandal Province',
      tags: ['Silver', 'Jewelry', 'Handcarved'],
      images: [
        'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600',
      ],
    ),
    Product(
      id: '3',
      name: 'Premium Cotton Krama Scarf',
      category: 'Textiles',
      isAvailable: true,
      description: 'The iconic traditional Cambodian gingham scarf woven with love. Soft, breathable, and highly durable multi-purpose textile representing Khmer utility and identity.',
      price: 15.00,
      imageUrl: 'https://images.unsplash.com/photo-1520635360276-79f3dbd809f6?q=80&w=600',
      rating: 4.7,
      reviewCount: 32,
      artisanName: 'Srey Mom',
      artisanId: 'artisan_03',
      origin: 'Takeo Province',
      tags: ['Cotton', 'Krama', 'Everyday'],
      images: [
        'https://images.unsplash.com/photo-1520635360276-79f3dbd809f6?q=80&w=600',
      ],
    ),
    Product(
      id: '4',
      name: 'Handmade Kampot Ceramic Teaset',
      category: 'Ceramics',
      isAvailable: true,
      description: 'An elegant clay teaset sculpted carefully using the iconic rich, iron-dense clay found in the foothills of Kampot. Finished with an organic salt-glaze technique inside wood-fired kilns.',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600',
      rating: 4.9,
      reviewCount: 12,
      artisanName: 'Kosal Sopheap',
      artisanId: 'artisan_04',
      origin: 'Kampot Province',
      tags: ['Clay', 'Ceramics', 'Kitchen'],
      images: [
        'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    // 🎯 Smart Lookup: Checks exact ID, partial strings, or falls back to standard index positions
    final product = _mockProducts.firstWhere(
      (p) => p.id == widget.productId || 
             widget.productId.toLowerCase().contains(p.id.toLowerCase()) ||
             p.name.toLowerCase().contains(widget.productId.toLowerCase()),
      orElse: () {
        int index = int.tryParse(widget.productId) ?? 1;
        if (index > 0 && index <= _mockProducts.length) {
          return _mockProducts[index - 1];
        }
        return _mockProducts.first;
      },
    );

    final int khrPrice = (product.price * 4000).round();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Anusav',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image Carousel Layout Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 380,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: PageView.builder(
                            itemCount: product.images.isNotEmpty ? product.images.length : 1,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final currentImg = product.images.isNotEmpty 
                                  ? product.images[index] 
                                  : product.imageUrl;
                              return Image.network(
                                currentImg,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.grey200,
                                  child: const Icon(Icons.image_not_supported, size: 48),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.images.isNotEmpty ? product.images.length : 1,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: _currentImageIndex == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index 
                                  ? AppColors.primary 
                                  : AppColors.grey400.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Titles & Pricing Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '~ ${khrPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} KHR',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Star Rating Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < product.rating.floor() ? Icons.star : Icons.star_border,
                            color: AppColors.gold,
                            size: 18,
                          ),
                        ),
                      ),
                      const Gap(6),
                      Text(
                        '${product.rating}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        '(${product.reviewCount} Reviews)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // 4. Artisan Profile Section Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.grey900 : AppColors.grey100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.goldLight,
                          child: Text(
                            product.artisanName.isNotEmpty ? product.artisanName.substring(0, 1) : 'A',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.goldDark),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ARTISAN',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: textSecondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                product.artisanName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                          onPressed: () {
                            context.push('/chat/${product.artisanId}');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),

                // 5. Expandable Information Accordion Panels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildCustomExpansionTile(
                        title: 'The Story Behind the Item',
                        icon: Icons.auto_stories_outlined,
                        isExpanded: _isStoryExpanded,
                        onToggle: () => setState(() => _isStoryExpanded = !_isStoryExpanded),
                        child: Text(
                          product.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textPrimary.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                        context: context,
                      ),
                      const Gap(10),
                      _buildCustomExpansionTile(
                        title: 'Materials & Origin',
                        icon: Icons.layers_outlined,
                        isExpanded: _isMaterialsExpanded,
                        onToggle: () => setState(() => _isMaterialsExpanded = !_isMaterialsExpanded),
                        child: Text(
                          'Handcrafted authentically in ${product.origin}. Utilizing sustainable regional resources and signature techniques unique to local artisan guilds.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: textPrimary.withOpacity(0.8), height: 1.4),
                        ),
                        context: context,
                      ),
                      const Gap(10),
                      _buildCustomExpansionTile(
                        title: 'Tags & Classifications',
                        icon: Icons.straighten_outlined,
                        isExpanded: _isDimensionsExpanded,
                        onToggle: () => setState(() => _isDimensionsExpanded = !_isDimensionsExpanded),
                        child: Wrap(
                          spacing: 8,
                          children: product.tags.map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                          )).toList(),
                        ),
                        context: context,
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // 6. Impact / Purpose Highlight Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withOpacity(isDark ? 0.4 : 0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: AppColors.goldLight, size: 20),
                            const Gap(8),
                            Text(
                              'A Gift with Purpose',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        Text(
                          '20% of the proceeds from this purchase go directly to support our local artisan networks across Cambodia.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 7. Sticky Bottom Control Panel Dock
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.5 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.grey800 : AppColors.grey200),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                        onPressed: () {},
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/booking/${product.id}');
                        },
                        icon: const Icon(Icons.card_giftcard, color: Colors.white),
                        label: const Text(
                          'Add to Kado (Gift)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomExpansionTile({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.grey800 : AppColors.grey200),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: AppColors.primary),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.grey600,
            ),
            onTap: onToggle,
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Align(alignment: Alignment.centerLeft, child: child),
            ),
        ],
      ),
    );
  }
}