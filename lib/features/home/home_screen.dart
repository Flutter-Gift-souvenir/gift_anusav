import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ← NEW: for navigation
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/supabase_repository.dart'; // ← Supabase
import '../../models/artisan_model.dart';     // ← Artisan model


class AppColors {
  static const Color primary    = Color(0xFF8B3A1A);
  static const Color gold       = Color(0xFFD4A017);
  static const Color background = Color(0xFFFAF6F1);
  static const Color textDark   = Color(0xFF1A1208);
  static const Color textGrey   = Color(0xFF6B5B45);
  static const Color badge      = Color(0xFFF5C842);
  static const Color border     = Color(0xFFE8D5B7);
  static const Color surface    = Color(0xFFFFFFFF);
}


class HeroItem {
  final String badge;
  final String title;
  final String subtitle;
  final String imageUrl;
  HeroItem({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class CategoryItem {
  final String label;
  final IconData icon;
  CategoryItem({required this.label, required this.icon});
}

class CollectionItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  CollectionItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class ArtisanItem {
  final String id;       // ← NEW: added id for navigation
  final String name;
  final String location;
  final String craft;
  final double rating;
  final String badge;
  final String imageUrl;
  ArtisanItem({
    required this.id,    // ← NEW
    required this.name,
    required this.location,
    required this.craft,
    required this.rating,
    required this.badge,
    required this.imageUrl,
  });
}


final List<HeroItem> heroItems = [
  HeroItem(
    badge: 'Heritage Collection',
    title: 'Crafted in Cambodia',
    subtitle: 'Discover the soul of Khmer artistry through our gifts from local artisans.',
    imageUrl: 'assets/images/craft.jpg',
  ),
  HeroItem(
    badge: 'Silk Collection',
    title: 'Women with Tradition',
    subtitle: 'Authentic Cambodian silk crafted by skilled weavers from Siem Reap.',
    imageUrl: 'assets/images/craft.jpg',
  ),
  HeroItem(
    badge: 'New Arrivals',
    title: 'Silver & Stone',
    subtitle: 'Handcrafted silverware with ancient Khmer motifs passed down through generations.',
    imageUrl: 'assets/images/craft.jpg',
  ),
];

final List<CategoryItem> categories = [
  CategoryItem(label: 'Textile',  icon: Icons.checkroom_outlined),
  CategoryItem(label: 'Silver',   icon: Icons.diamond_outlined),
  CategoryItem(label: 'Wood',     icon: Icons.forest_outlined),
  CategoryItem(label: 'Edible',   icon: Icons.restaurant_outlined),
  CategoryItem(label: 'Jewelry',  icon: Icons.auto_awesome_outlined),
];

final List<CollectionItem> collections = [
  CollectionItem(
    title: 'For Him',
    subtitle: '24 Items',
    imageUrl: 'assets/images/craft.jpg',
  ),
  CollectionItem(
    title: 'Songkran Set',
    subtitle: 'Festive Limited',
    imageUrl: 'assets/images/craft.jpg',
  ),
  CollectionItem(
    title: 'Wedding',
    subtitle: 'Elegant Gifts',
    imageUrl: 'assets/images/craft.jpg',
  ),
  CollectionItem(
    title: 'Tourist',
    subtitle: 'Best Souvenirs',
    imageUrl: 'assets/images/craft.jpg',
  ),
];

// ← NEW: added id to each artisan — must match Rasy's artisanId
final List<ArtisanItem> artisans = [
  ArtisanItem(
    id: 'a001',          // ← make sure Rasy uses same id
    name: 'Srey Mao',
    location: 'Kampong Chhnang',
    craft: 'Clay & Ceramics',
    rating: 4.9,
    badge: 'Master Potter',
    imageUrl: 'assets/images/craft.jpg',
  ),
  ArtisanItem(
    id: 'a002',
    name: 'Sovann Rith',
    location: 'Siem Reap',
    craft: 'Traditional Wood Carving',
    rating: 4.8,
    badge: 'Wood Carver',
    imageUrl: 'assets/images/craft.jpg',
  ),
  ArtisanItem(
    id: 'a003',
    name: 'Bopha Keo',
    location: 'Phnom Penh',
    craft: 'Silk Painting',
    rating: 4.7,
    badge: 'Silk Artist',
    imageUrl: 'assets/images/craft.jpg',
  ),
  ArtisanItem(
    id: 'a004',
    name: 'Dara Chea',
    location: 'Siem Reap',
    craft: 'Silversmithing',
    rating: 4.9,
    badge: 'Silver Master',
    imageUrl: 'assets/images/craft.jpg',
  ),
];


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _heroIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  final TextEditingController _emailController = TextEditingController();

  // Artisans loaded from Supabase (falls back to empty until loaded)
  List<ArtisanItem> _artisans = [];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  Color get _themedTextDark => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFFFF8F0)
      : const Color(0xFF1A1208);

  Color get _themedTextGrey => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFBFAA8E)
      : const Color(0xFF6B5B45);

  Color get _themedSurface => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF2C1F0E)
      : Colors.white;

  Color get _themedBorder => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF423525)
      : const Color(0xFFE8D5B7);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
    _loadArtisans();
  }

  // Load real artisans from Supabase and map them to ArtisanItem
  Future<void> _loadArtisans() async {
    final list = await SupabaseRepository.getArtisans();
    if (!mounted) return;
    setState(() {
      _artisans = list
          .map((a) => ArtisanItem(
                id: a.id,
                name: a.name,
                location: a.location,
                craft: a.specialty,
                rating: a.rating,
                badge: a.masterTitle.isNotEmpty ? a.masterTitle : 'Verified',
                imageUrl: a.photoUrl,
              ))
          .toList();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            _buildBrowseByCraft(),
            _buildCollections(),
            _buildMeetArtisans(),
            _buildKadoCircle(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ─── Section 1: Hero (unchanged) ─────────────────────────────────────────
  Widget _buildHero() {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 480,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, reason) {
              setState(() => _heroIndex = index);
            },
          ),
          items: heroItems.map((item) => _buildHeroSlide(item)).toList(),
        ),
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _heroIndex,
              count: heroItems.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.white,
                dotColor: Colors.white38,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSlide(HeroItem item) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          item.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.primary,
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.white, size: 48),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.80),
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 60,
          bottom: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.badge,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.badge,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Explore Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Section 2: Browse by Craft (unchanged) ───────────────────────────────
  Widget _buildBrowseByCraft() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Browse by Craft',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _themedTextDark,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) =>
                  _buildCategoryItem(categories[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryItem item) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: _themedSurface,
              shape: BoxShape.circle,
              border: Border.all(color: _themedBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _themedTextGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 3: Curated Collections (unchanged) ───────────────────────────
  Widget _buildCollections() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Curated Collections',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _themedTextDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Handpicked for every meaningful moment.',
            style: TextStyle(
              fontSize: 13,
              color: _themedTextGrey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCollectionCard(collections[0], height: 295),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    _buildCollectionCard(collections[1], height: 145),
                    const SizedBox(height: 10),
                    _buildCollectionCard(collections[2], height: 68),
                    const SizedBox(height: 10),
                    _buildCollectionCard(collections[3], height: 68),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(CollectionItem item, {required double height}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white, size: 24),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Section 4: Meet the Artisans ────────────────────────────────────────
  Widget _buildMeetArtisans() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meet the Artisans',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _themedTextDark,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward,
                    color: _themedTextDark,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'The hands behind the heritage.',
            style: TextStyle(
              fontSize: 13,
              color: _themedTextGrey,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: _artisans.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) =>
                  _buildArtisanCard(_artisans[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtisanCard(ArtisanItem artisan) {
    return GestureDetector(
      // ← NEW: navigate to Rasy's artisan screen when tapped
      onTap: () => context.push('/artisan/${artisan.id}'),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: _themedSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _themedBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    artisan.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: AppColors.primary.withValues(alpha: 0.2),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.badge,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      artisan.badge,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artisan.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _themedTextDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 11, color: Colors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          artisan.location,
                          style: TextStyle(
                            fontSize: 10,
                            color: _themedTextGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          artisan.craft,
                          style: TextStyle(
                            fontSize: 10,
                            color: _themedTextGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 12, color: AppColors.gold),
                          const SizedBox(width: 2),
                          Text(
                            '${artisan.rating}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _themedTextDark,
                            ),
                          ),
                        ],
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

  // ─── Section 5: Kado Circle (unchanged) ──────────────────────────────────
  Widget _buildKadoCircle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join the Kado Circle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Get early access to limited seasonal gift\ndrops and artisan stories.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Your email',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey.withValues(alpha: 0.7),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Welcome to the Kado Circle!'),
                        backgroundColor: AppColors.gold,
                      ),
                    );
                    _emailController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.textDark,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Join',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}