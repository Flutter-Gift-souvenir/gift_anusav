import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppColors {
  static const Color primary    = Color(0xFF8B3A1A);
  static const Color gold       = Color(0xFFD4A017);
  static const Color background = Color(0xFFFAF6F1);
  static const Color textDark   = Color(0xFF1A1208);
  static const Color textGrey   = Color(0xFF6B5B45);
  static const Color badge      = Color(0xFFF5C842);
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

final List<HeroItem> heroItems = [
  HeroItem(
    badge: 'Heritage Collection',
    title: 'Crafted in Cambodia',
    subtitle: 'Discover the soul of khmer artistry through our gifts from local artisans.',
    imageUrl:  'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
  ),
  HeroItem(
    badge: 'Silk Collection',
    title: 'Women with Tradition',
    subtitle: 'Authentic Cambodian silk crafted by skilled weavers from Siem Reap.',
    imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&q=80',
  ),
  HeroItem(
    badge: 'New Arrivals',
    title: 'Silver & Stone',
    subtitle: 'Handcrafted silverware with ancient khmer motifs passed down through generations.',
    imageUrl: 'https://images.unsplash.com/photo-1611085583191-a3b181a88401?w=800&q=80',
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
        child: Column(
          children: [
            //  Removed _buildAppBar() here to prevent double headers!
            _buildHero(),
            
            // Add your upcoming grid items, products, or categories here!
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
              setState(() {
                _heroIndex = index;
              });
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
        CachedNetworkImage(
          imageUrl: item.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.primary.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.primary,
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.white,
              size: 48,
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
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                      ),
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
}