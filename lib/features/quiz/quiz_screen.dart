import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // --- State ---
  int _currentStep = 0;
  String? _selectedRecipient;
  String? _selectedVibe;
  String? _selectedBudget;
  String? _selectedOccasion;
  String? _selectedPreference;

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
  return Scaffold(
    backgroundColor: AppColors.backgroundLight,
    body: SafeArea(
      child: Column(
        children: [
          // --- Progress Bar ---
          _buildProgressBar(),

          // --- Content ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  _buildHeader(),
                  const Gap(16),

                  // --- Step content ---
                  if (_currentStep == 0) _buildStep1(),
                  if (_currentStep == 1) _buildStep2(),
                  if (_currentStep == 2) _buildStep3(),
                  if (_currentStep == 3) _buildStep4(),
                  if (_currentStep == 4) _buildResults(),

                  const Gap(32),
                ],
              ),
            ),
          ),

          // --- Bottom Buttons ---
          if (_currentStep < 4) _buildBottomButtons(),
        ],
      ),
    ),
  );
}

  // --- Step 1 ---
Widget _buildStep1() {
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
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
        textAlign: TextAlign.center,
      ),
      const Gap(24),
      _buildOptionsGrid(_recipients, _selectedRecipient, (val) {
        setState(() => _selectedRecipient = val);
      }),
      const Gap(24),
      _buildVibeSection(),
    ],
  );
}

// --- Step 2 ---
Widget _buildStep2() {
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
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
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
Widget _buildStep3() {
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
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
        textAlign: TextAlign.center,
      ),
      const Gap(24),
      _buildOptionsGrid(_occasions, _selectedOccasion, (val) {
        setState(() => _selectedOccasion = val);
      }),
    ],
  );
}
Widget _buildStep4() {
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
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
        textAlign: TextAlign.center,
      ),
      const Gap(24),
      _buildOptionsGrid(_preferences, _selectedPreference, (val) {
        setState(() => _selectedPreference = val);
      }),
    ],
  );
}

Widget _buildResults() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Gap(24),
      Center(
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.card_giftcard,
            size: 48,
            color: AppColors.primary,
          ),
        ),
      ),
      const Gap(24),
      Center(
        child: Text(
          'Your Perfect Gift!',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const Gap(8),
      Center(
        child: Text(
          'Based on your answers, we recommend $_selectedPreference gifts for $_selectedRecipient on a $_selectedBudget budget for $_selectedOccasion.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
          textAlign: TextAlign.center,
        ),
      ),
      const Gap(32),
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
          child: Text(
            'View Recommended Gifts',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      const Gap(16),
      Center(
        child: TextButton(
          onPressed: () {
            setState(() {
              _currentStep = 0;
              _selectedRecipient = null;
              _selectedBudget = null;
              _selectedOccasion = null;
              _selectedPreference = null;
              _selectedVibe = null;
            });
          },
          child: Text(
            'Retake Quiz',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.grey600,
            ),
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
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Close button
        GestureDetector(
          onTap: () => context.go('/gifts'),
          child: const Icon(
            Icons.close,
            color: AppColors.textPrimaryLight,
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
  Widget _buildVibeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Vibe',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
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
                        : AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.gold
                          : AppColors.grey200,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    vibe['icon'] as IconData,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.grey600,
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
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
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
                const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: AppColors.textPrimaryLight,
                ),
                const Gap(6),
                Text(
                  'Back',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimaryLight,
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
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
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
              color: AppColors.black.withOpacity(0.05),
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