import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover Khmer Heritage',
      'description': 'Explore unique, premium handicrafts sculpted and woven authentically across Cambodia\'s historic provinces.',
      'image': 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=600', 
    },
    {
      'title': 'Support Local Artisans',
      'description': 'Connect directly with traditional craftsmen. Every purchase directly empowers regional artisan guilds and communities.',
      'image': 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600',
    },
    {
      'title': 'The Art of Kado',
      'description': 'Customize beautiful gifts with traditional premium wrapping and personalized notes sent straight to your loved ones.',
      'image': 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed: Wrapped Align with a proper Padding widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),// Skip straight to login page
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Sliding Content Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Beautiful structural image window
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.network(
                              _onboardingData[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Gap(40),
                        
                        // Text Elements
                        Text(
                          _onboardingData[index]['title']!,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                          textAlign: TextAlign.center, // Fixed: Changed from Center to TextAlign.center
                        ),
                        const Gap(16),
                        Text(
                          _onboardingData[index]['description']!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Indicators & Dynamic Button Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Fixed: Changed to MainAxisAlignment.spaceBetween
                children: [
                  // Smooth Dot Indicators Array
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : AppColors.grey400.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Floating Navigation Controller Button
                  FloatingActionButton.extended(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        context.go('/login'); // Onboarding finishes, route to login
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    backgroundColor: AppColors.primary,
                    label: Text(
                      _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    icon: Icon(
                      _currentPage == _onboardingData.length - 1 ? Icons.done : Icons.arrow_forward,
                      color: Colors.white,
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
}