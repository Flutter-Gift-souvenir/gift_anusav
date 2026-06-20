import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.grey600;

    // --- Quick Actions Data ---
    final quickActions = [
      {'label': 'Track My Order', 'icon': Icons.local_shipping_outlined},
      {'label': 'Returns & Refunds', 'icon': Icons.assignment_return_outlined},
      {'label': 'Payment Issues', 'icon': Icons.account_balance_wallet_outlined},
      {'label': 'Contact Artisan', 'icon': Icons.groups_outlined},
    ];

    // --- FAQ Data ---
    final faqs = [
      {
        'question': 'How long does delivery take?',
        'answer':
            'Standard delivery within Phnom Penh takes 1-2 business days. Provincial deliveries typically take 3-5 business days.',
      },
      {
        'question': 'Can I customize gift wrapping?',
        'answer':
            'Yes! During checkout, you can choose from several wrapping styles including Krama Wrap, Banana Leaf, and Gold Foil for an additional \$2.50.',
      },
      {
        'question': 'Do you offer international shipping?',
        'answer':
            'Currently we only ship within Cambodia. International shipping is coming soon — stay tuned!',
      },
      {
        'question': 'How do I apply a coupon code?',
        'answer':
            'Enter your coupon code at checkout in the "Promo Code" field, then tap Apply to see the discount applied to your total.',
      },
      {
        'question': 'Can I cancel my order?',
        'answer':
            'Orders can be cancelled within 1 hour of placing them. Go to My Orders and select Cancel Order.',
      },
      {
        'question': 'How are artisans selected?',
        'answer':
            'All artisans go through a verification process to ensure authentic craftsmanship and fair trade practices before joining Anusav.',
      },
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Help & Support',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // --- Content ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Search Bar ---
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        readOnly: true,
                        onTap: () =>
                            AppHelpers.showComingSoon(context, 'Search'),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for help...',
                          hintStyle: AppTextStyles.bodyLarge.copyWith(
                            color: secondaryColor,
                          ),
                          prefixIcon: Icon(Icons.search, color: secondaryColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const Gap(16),

                    // --- Quick Actions Grid ---
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: quickActions.length,
                      itemBuilder: (context, index) {
                        final item = quickActions[index];
                        return _QuickActionCard(
                          icon: item['icon'] as IconData,
                          label: item['label'] as String,
                          isDark: isDark,
                          textColor: textColor,
                        );
                      },
                    ),

                    const Gap(24),

                    // --- FAQ Section ---
                    Text(
                      'Frequently Asked Questions',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Gap(12),

                    ...faqs.map(
                      (faq) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _FaqTile(
                          question: faq['question']!,
                          answer: faq['answer']!,
                          isDark: isDark,
                          textColor: textColor,
                          secondaryColor: secondaryColor,
                        ),
                      ),
                    ),

                    const Gap(8),

                    // --- Contact Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Still need help?',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            'Our support team is ready to assist you with any questions.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const Gap(20),

                          // Live Chat
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => AppHelpers.showComingSoon(
                                context,
                                'Live Chat',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.textPrimaryLight,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.chat_bubble_outline, size: 18),
                                  const Gap(8),
                                  Text(
                                    'Live Chat',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Gap(10),

                          // Email Support
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => AppHelpers.showComingSoon(
                                context,
                                'Email Support',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.white,
                                side: const BorderSide(
                                  color: AppColors.white,
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.email_outlined, size: 18),
                                  const Gap(8),
                                  Text(
                                    'Email Support',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(16),

                    // --- Support Hours ---
                    Center(
                      child: Text(
                        'Available Mon-Fri, 8AM - 6PM (ICT)',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                    ),

                    const Gap(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Quick Action Card ---
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color textColor;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppHelpers.showComingSoon(context, label),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const Gap(8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// --- FAQ Expandable Tile ---
class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final bool isDark;
  final Color textColor;
  final Color secondaryColor;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isDark,
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          title: Text(
            widget.question,
            style: AppTextStyles.bodyLarge.copyWith(
              color: widget.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: widget.secondaryColor,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.topLeft,
          children: [
            Text(
              widget.answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: widget.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}