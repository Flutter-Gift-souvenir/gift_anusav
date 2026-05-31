import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


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


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _heroIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

 
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
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.80),
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
                  color: Colors.white.withOpacity(0.85),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
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


  Widget _buildBrowseByCraft() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Browse by Craft',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
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
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCollections() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Curated Collections',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Handpicked for every meaningful moment.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 16),

        
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Expanded(
                child: _buildCollectionCard(
                  collections[0],
                  height: 295,
                ),
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
              color: Colors.black.withOpacity(0.12),
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
                  color: AppColors.primary.withOpacity(0.3),
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
                      Colors.black.withOpacity(0.7),
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
                        color: Colors.white.withOpacity(0.8),
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
}