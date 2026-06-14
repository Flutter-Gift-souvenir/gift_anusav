import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_scaffold.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../data/mock_repository.dart';

class ReviewsScreen extends StatefulWidget {
  final String productId;
  const ReviewsScreen({super.key, required this.productId});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = const [
    'All',
    '5 Stars',
    'With Photos',
    'Recent',
  ];

  bool get _isArtisanReviewMode => widget.productId.startsWith('a');

  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  final List<Color> _avatarColorPalette = const [
    Color(0xFF475B6B),
    Color(0xFFF2C94C),
    Color(0xFF8B4513),
    Color(0xFF6A7B4F),
    Color(0xFF7C4DFF),
  ];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final loaded = _isArtisanReviewMode
          ? await MockRepository.getRawReviewsByArtisan(widget.productId)
          : await MockRepository.getRawReviewsByProduct(widget.productId);

      if (!mounted) return;

      setState(() {
        _reviews = loaded.map((r) {
          final name = r['name'] ?? '';
          final initials = r['initials'] ?? _computeInitials(name);
          return {
            'name': name,
            'initials': initials,
            'rating': r['rating'] ?? 0,
            'date': r['date'] ?? '',
            'product': r['product'] ?? '',
            'comment': r['comment'] ?? '',
            'hasPhoto': r['hasPhoto'] ?? false,
            'helpful': r['helpful'] ?? 0,
            'avatarColor': _avatarColorFor(name),
          };
        }).toList();

        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _computeInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Color _avatarColorFor(String seed) {
    final sum = seed.runes.fold<int>(0, (p, c) => p + c);
    return _avatarColorPalette[sum % _avatarColorPalette.length];
  }

  List<Map<String, dynamic>> get _filteredReviews {
    if (_selectedFilterIndex == 1) {
      return _reviews.where((review) => review['rating'] == 5).toList();
    }

    if (_selectedFilterIndex == 2) {
      return _reviews.where((review) => review['hasPhoto'] == true).toList();
    }

    return _reviews;
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0;

    final total = _reviews.fold<int>(
      0,
      (sum, review) => sum + (review['rating'] as int),
    );

    return total / _reviews.length;
  }

  int _countRating(int rating) {
    return _reviews.where((review) => review['rating'] == rating).length;
  }

  void _showWriteReviewSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.grey800 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Gap(20),
              Text(
                'Write a Review',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const Gap(8),
              Text(
                'This is frontend demo mode. Your review form UI is ready, backend can be added later.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const Gap(18),
              Row(
                children: List.generate(
                  5,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.star_rounded, color: Color(0xFFF2C94C), size: 32),
                  ),
                ),
              ),
              const Gap(16),
              TextField(
                maxLines: 4,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.grey800 : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Gap(18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else if (_isArtisanReviewMode) {
                context.go('/artisan/${widget.productId}');
              } else {
                context.go('/');
              }
            },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final reviews = _filteredReviews;

    return AppScaffold(
      currentIndex: 0,
      body: Container(
        color: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(context),
                      const Gap(20),
                      _buildRatingSummary(context),
                      const Gap(22),
                      _buildFilterChips(context),
                      const Gap(18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customer Reviews',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${reviews.length} shown',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                    ],
                  ),
                ),
              ),

              if (reviews.isEmpty)
                SliverToBoxAdapter(
                  child: _buildEmptyState(context),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.separated(
                    itemCount: reviews.length,
                    separatorBuilder: (_, __) => const Gap(12),
                    itemBuilder: (context, index) {
                      return _buildReviewCard(context, reviews[index]);
                    },
                  ),
                ),

              const SliverToBoxAdapter(child: Gap(90)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.grey800 : const Color(0xFFE8DFD5),
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isArtisanReviewMode ? 'Artisan Reviews' : 'Reviews',
                style: AppTextStyles.titleLarge.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(2),
              Text(
                _isArtisanReviewMode
                    ? 'Artisan ID: ${widget.productId}'
                    : 'Product ID: ${widget.productId}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _showWriteReviewSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.edit_outlined, color: AppColors.white, size: 17),
                Gap(6),
                Text(
                  'Write',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSummary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFE8DFD5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(isDark ? 0.16 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star_rounded,
                      color: index < _averageRating.round()
                          ? const Color(0xFFF2C94C)
                          : (isDark ? AppColors.grey800 : Colors.grey.shade300),
                      size: 15,
                    ),
                  ),
                ),
                const Gap(4),
                Text(
                  '${_reviews.length} reviews',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Gap(18),
          Expanded(
            child: Column(
              children: [
                _buildRatingProgress(context, 5),
                const Gap(8),
                _buildRatingProgress(context, 4),
                const Gap(8),
                _buildRatingProgress(context, 3),
                const Gap(8),
                _buildRatingProgress(context, 2),
                const Gap(8),
                _buildRatingProgress(context, 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingProgress(BuildContext context, int rating) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final count = _countRating(rating);
    final percent = _reviews.isEmpty ? 0.0 : count / _reviews.length;

    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '$rating',
            style: AppTextStyles.labelMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Icon(Icons.star_rounded, color: Color(0xFFF2C94C), size: 14),
        const Gap(8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: percent,
              backgroundColor: isDark ? AppColors.grey800 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        const Gap(8),
        SizedBox(
          width: 18,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: AppTextStyles.labelSmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (context, index) {
          final selected = _selectedFilterIndex == index;

          return ChoiceChip(
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            label: Text(_filters[index]),
            selectedColor: AppColors.primary,
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
            labelStyle: AppTextStyles.labelMedium.copyWith(
              color: selected
                  ? AppColors.white
                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              fontWeight: FontWeight.bold,
            ),
            side: BorderSide(
              color: selected
                  ? AppColors.primary
                  : (isDark ? AppColors.grey800 : const Color(0xFFE0D8D0)),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rating = review['rating'] as int;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFE8DFD5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(isDark ? 0.14 : 0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: review['avatarColor'],
                child: Text(
                  review['initials'],
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: AppTextStyles.titleSmall.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      review['date'],
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2C94C).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      '$rating',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Gap(3),
                    const Icon(Icons.star_rounded, color: Color(0xFFF2C94C), size: 14),
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                color: index < rating
                    ? const Color(0xFFF2C94C)
                    : (isDark ? AppColors.grey800 : Colors.grey.shade300),
                size: 18,
              ),
            ),
          ),
          const Gap(10),
          Text(
            review['comment'],
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const Gap(12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSmallTag(context, review['product']),
              if (review['hasPhoto'] == true)
                _buildSmallTag(context, 'Photo review'),
            ],
          ),
          const Gap(14),
          Row(
            children: [
              Icon(
                Icons.thumb_up_alt_outlined,
                size: 17,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade500,
              ),
              const Gap(6),
              Text(
                '${review['helpful']} found this helpful',
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTag(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : const Color(0xFFF7F5F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          const Gap(16),
          Text(
            'No reviews found',
            style: AppTextStyles.titleMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Try another filter or write the first review for this product.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
