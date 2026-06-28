import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../models/product_model.dart';
import '../../data/supabase_repository.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final products = await SupabaseRepository.getProducts();
    setState(() {
      _allProducts = products;
      _productsLoaded = true;
    });
  }

  // --- State ---
  int _currentStep = 0;
  String? _selectedRecipient;
  String? _selectedVibe;
  String? _selectedBudget;
  String? _selectedOccasion;
  String? _selectedPreference;
  List<Product> _allProducts = [];
  bool _productsLoaded = false;

  // --- Quiz Data ---
  final List<Map<String, String>> _recipients = [
    {
      'label': 'Family',
      'description': 'Parents, siblings, and elders',
      'image': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400',
    },
    {
      'label': 'Friends',
      'description': 'Besties and close companions',
      'image': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400',
    },
    {
      'label': 'Colleague',
      'description': 'Business partners and mentors',
      'image': 'https://images.unsplash.com/photo-1521737711867-e3b97375f902?w=400',
    },
    {
      'label': 'Partner',
      'description': 'Spouse or significant other',
      'image': 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=400',
    },
  ];

  final List<Map<String, dynamic>> _vibes = [
    {'label': 'Love', 'icon': Icons.favorite},
    {'label': 'Party', 'icon': Icons.celebration},
    {'label': 'Craft', 'icon': Icons.handyman},
    {'label': 'Home', 'icon': Icons.home},
  ];
  final List<Map<String, String>> _budgets = [
  {
    'label': 'Under \$20',
    'description': 'Small but meaningful',
    'image': 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400',
  },
  {
    'label': '\$20 - \$50',
    'description': 'Popular range',
    'image': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400',
  },
  {
    'label': '\$50 - \$100',
    'description': 'Premium gifts',
    'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=400',
  },
  {
    'label': 'Over \$100',
    'description': 'Luxury experience',
    'image': 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400',
  },
];

final List<Map<String, String>> _occasions = [
  {
    'label': 'Birthday',
    'description': 'Celebrate their special day',
    'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
  },
  {
    'label': 'Wedding',
    'description': 'Honor the happy couple',
    'image': 'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
  },
  {
    'label': 'Festival',
    'description': 'Khmer New Year and more',
    'image': 'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?w=400',
  },
  {
    'label': 'Just Because',
    'description': 'No reason needed',
    'image': 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400',
  },
];

final List<Map<String, String>> _preferences = [
  {
    'label': 'Handcrafted',
    'description': 'Silverware and ceramics',
    'image': 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400',
  },
  {
    'label': 'Wearables',
    'description': 'Silk and traditional Krama',
    'image': 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=400',
  },
  {
    'label': 'Food & Spices',
    'description': 'Authentic Cambodian flavors',
    'image': 'https://images.unsplash.com/photo-1599909533815-cc6e3a03d3f5?w=400',
  },
  {
    'label': 'Home Decor',
    'description': 'Artisan-made interior accents',
    'image': 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400',
  },
];

  // Total steps
  static const int _totalSteps = 5;

@override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- Progress Bar ---
            _buildProgressBar(),

            // --- Content ---
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    _buildHeader(isDark),
                    const Gap(16),

                    // --- Step content ---
                    if (_currentStep == 0) _buildStep1(isDark),
                    if (_currentStep == 1) _buildStep2(isDark),
                    if (_currentStep == 2) _buildStep3(isDark),
                    if (_currentStep == 3) _buildStep4(isDark),
                    if (_currentStep == 4) _buildResults(isDark),

                    const Gap(32),
                  ],
                ),
              ),
            ),

            // --- Bottom Buttons ---
            if (_currentStep < 4) _buildBottomButtons(isDark),
          ],
        ),
      ),
    );
  }

  // --- Step 1 ---
  Widget _buildStep1(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepLabel(1),
        const Gap(12),
        Text(
          'Who are you buying for?',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(8),
        Text(
          'Select the lucky recipient to personalize your Anusav experience.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.grey600
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(24),
        _buildOptionsGrid(_recipients, _selectedRecipient, (val) {
          setState(() => _selectedRecipient = val);
        }),
        const Gap(24),
        _buildVibeSection(isDark),
      ],
    );
  }

  // --- Step 2 ---
  Widget _buildStep2(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepLabel(2),
        const Gap(12),
        Text(
          'What is your budget?',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(8),
        Text(
          'Choose a budget range to find the perfect gift.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.grey600
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(24),
        _buildOptionsGrid(_budgets, _selectedBudget, (val) {
          setState(() => _selectedBudget = val);
        }),
      ],
    );
  }

  // --- Step 3 ---
  Widget _buildStep3(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepLabel(3),
        const Gap(12),
        Text(
          'What is the occasion?',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(8),
        Text(
          'Pick the occasion to find the most meaningful gift.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.grey600
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(24),
        _buildOptionsGrid(_occasions, _selectedOccasion, (val) {
          setState(() => _selectedOccasion = val);
        }),
      ],
    );
  }
  Widget _buildStep4(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepLabel(4),
        const Gap(12),
        Text(
          'Any gift preferences?',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(8),
        Text(
          'Select a category that resonates with their style.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.grey600
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(24),
        _buildOptionsGrid(_preferences, _selectedPreference, (val) {
          setState(() => _selectedPreference = val);
        }),
      ],
    );
  }

  Widget _buildResults(bool isDark) {
    if (!_productsLoaded) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final matched = _getMatchedProducts();
    final topMatch = matched.isNotEmpty ? matched.first : null;
    final others = matched.length > 1 ? matched.sublist(1, matched.length > 4 ? 4 : matched.length) : [];

    const khrRate = 4000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),

        // --- Title ---
        Text(
          'Handpicked for You',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(8),
        Text(
          'Based on your love for $_selectedPreference and ${_selectedOccasion?.toLowerCase()} gifts.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.grey600
          ),
          textAlign: TextAlign.center,
        ),

        const Gap(20),

        // --- Top Match Card ---
        if (topMatch != null) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                child: CachedNetworkImage(
                  imageUrl: topMatch.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 220,
                    color: isDark ? AppColors.grey800 : AppColors.grey200,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 220,
                    color: isDark ? AppColors.grey800 : AppColors.grey200,
                    child: const Icon(Icons.image, color: AppColors.grey400),
                  ),
                ),
              ),
              // Top Match badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.white),
                      const Gap(4),
                      Text(
                        'TOP MATCH',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Gap(12),

          // Name + price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topMatch.name,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: AppColors.gold),
                        const Gap(4),
                        Text(
                          topMatch.rating.toString(),
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '(${topMatch.reviewCount} reviews)',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${topMatch.price.toStringAsFixed(2)}',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${(topMatch.price * khrRate).toInt()} KHR',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Gap(12),

          // Why it's a match box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                left: BorderSide(color: AppColors.gold, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHY IT\'S A MATCH',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const Gap(6),
                Text(
                  '"Perfect for your $_selectedBudget budget and expressed interest in $_selectedPreference for $_selectedOccasion."',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const Gap(24),
        ],

        // --- Other Recommendations ---
        if (others.isNotEmpty) ...[
          Text(
            'OTHER RECOMMENDATIONS',
            style: AppTextStyles.labelMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.grey600,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Gap(12),
          ...others.map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RecommendationCard(
                  product: product,
                  khrRate: khrRate,
                ),
              )),
        ],

        const Gap(16),

        // --- Retake Quiz ---
        Center(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _currentStep = 0;
                _selectedRecipient = null;
                _selectedBudget = null;
                _selectedOccasion = null;
                _selectedPreference = null;
                _selectedVibe = null;
              });
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            icon: const Icon(Icons.refresh, size: 18, color: AppColors.gold),
            label: Text(
              'Retake Quiz',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.goldDark,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        const Gap(8),

        // --- Browse All Collections ---
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.go('/gifts'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Browse All Collections',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                const Icon(Icons.arrow_forward, size: 18, color: AppColors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

// --- Step Label ---
Widget _buildStepLabel(int step) {
  return Text(
    'STEP 0$step OF 0$_totalSteps',
    style: AppTextStyles.labelMedium.copyWith(
      color: AppColors.gold,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    ),
  );
}

// --- Map quiz preference to product categories ---
List<String> _preferenceCategories(String? preference) {
  switch (preference) {
    case 'Handcrafted':
      return ['Silverware', 'Ceramics'];
    case 'Wearables':
      return ['Textiles'];
    case 'Food & Spices':
      return ['Food & Spices'];
    case 'Home Decor':
      return ['Wood Carvings', 'Ceramics', 'Paintings'];
    default:
      return [];
  }
}

// --- Get matched products based on preference ---
List<Product> _getMatchedProducts() {
  final categories = _preferenceCategories(_selectedPreference);
  final matched = _allProducts
      .where((p) => categories.contains(p.category))
      .toList();
  if (matched.isEmpty) {
    final sorted = List<Product>.from(_allProducts)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }
  matched.sort((a, b) => b.rating.compareTo(a.rating));
  return matched;
}

  // --- Progress Bar ---
  Widget _buildProgressBar() {
    final progress = (_currentStep + 1) / _totalSteps;
    return Container(
      height: 4,
      color: AppColors.grey200,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          color: AppColors.gold,
        ),
      ),
    );
  }

  // --- Header (X + Title) ---
  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Close button
        GestureDetector(
          onTap: () => context.go('/gifts'),
          child: Icon(
            Icons.close,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            size: 24,
          ),
        ),

        // Title
        Text(
          'Anusav Gift Finder',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),

        // Empty space for alignment
        const SizedBox(width: 24),
      ],
    );
  }

  // --- Options Grid ---
  Widget _buildOptionsGrid(
  List<Map<String, String>> options,
  String? selectedValue,
  Function(String) onSelect,
) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
    ),
    itemCount: options.length,
    itemBuilder: (context, index) {
      final option = options[index];
      final isSelected = selectedValue == option['label'];
      return _OptionCard(
        label: option['label']!,
        description: option['description']!,
        imageUrl: option['image']!,
        isSelected: isSelected,
        onTap: () => onSelect(option['label']!),
      );
    },
  );
}

  // --- Vibe Section ---
  Widget _buildVibeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Vibe',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),

        const Gap(16),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _vibes.map((vibe) {
            final isSelected = _selectedVibe == vibe['label'];
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedVibe = vibe['label']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.surfaceDark : AppColors.white),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.gold
                          : (isDark ? AppColors.grey800 : AppColors.grey200),
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    vibe['icon'] as IconData,
                    color: isSelected
                        ? AppColors.white
                        : (isDark ? AppColors.textSecondaryDark : AppColors.grey600),
                    size: 24,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  bool _isCurrentStepValid() {
  if (_currentStep == 0) return _selectedRecipient != null;
  if (_currentStep == 1) return _selectedBudget != null;
  if (_currentStep == 2) return _selectedOccasion != null;
  if (_currentStep == 3) return _selectedPreference != null;
  if (_currentStep == 4) return true;
  return true;
}

  // --- Bottom Buttons ---
  Widget _buildBottomButtons(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              } else {
                context.go('/gifts');
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                const Gap(6),
                Text(
                  'Back',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Next Step button
          ElevatedButton(
            onPressed: _isCurrentStepValid()
                ? ()  {
                    if (_currentStep < _totalSteps - 1) {
                      setState(() => _currentStep++);
                    } else {
                      // TODO: show results
                      context.go('/gifts');
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                    _currentStep == 3 ? 'See Results' : 'Next Step',
  style: AppTextStyles.labelLarge.copyWith(
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  ),
                ),
                const Gap(8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Option Card ---
class _OptionCard extends StatelessWidget {
  final String label;
  final String description;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.description,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.grey200,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
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
                imageUrl: imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 120,
                  color: AppColors.grey200,
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  color: AppColors.grey200,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.grey400,
                    size: 40,
                  ),
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

// --- Recommendation Card ---
class _RecommendationCard extends StatelessWidget {
  final Product product;
  final int khrRate;

  const _RecommendationCard({
    required this.product,
    required this.khrRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 70,
                height: 70,
                color: AppColors.grey200,
              ),
              errorWidget: (context, url, error) => Container(
                width: 70,
                height: 70,
                color: AppColors.grey200,
                child: const Icon(Icons.image, color: AppColors.grey400),
              ),
            ),
          ),

          const Gap(12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.gold),
                    Text(
                      ' ${product.rating}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${(product.price * khrRate).toInt()} KHR',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),

          // Cart icon (visual only)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}