import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import '../models/shop_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback? onViewStore;

  const ShopCard({super.key, required this.shop, this.onViewStore});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: isDark ? const Color.fromARGB(255, 255, 255, 255) : AppColors.grey100),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: shop.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.grey200,
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.grey200,
              child: const Icon(Icons.store, color: AppColors.grey400),
            ),
          ),
        ),
        const Gap(12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shop.name,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const Gap(4),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined ,
                    size: 14,
                    color: AppColors.grey600,
                  ),
                  const Gap(2),
                  Text(
                    '${shop.area} - ${shop.distance} km',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              const Gap(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const Gap(2),
                      Text(
                        shop.rating.toString(),
                        style: AppTextStyles.labelMedium,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onViewStore ?? () => AppHelpers.showComingSoon(context, 'View Store'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'View Store',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                    )
                  )
                )
                ],
              )
            ]
          ))
      ],)
    );
  }
}