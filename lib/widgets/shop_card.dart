import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import '../models/shop_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback? onViewStore;

  const ShopCard({super.key, required this.shop, this.onViewStore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: shop.imageUrl ?? '',
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
                style: AppTextStyles.titleMedium,
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
                    style: AppTextStyles.bodySmall,
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
                        shop.rating.toString() ?? '0.0',
                        style: AppTextStyles.labelMedium,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onViewStore,
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
