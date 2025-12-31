import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_card.dart';

class PlaceListTile extends StatelessWidget {
  final String name;
  final String region;
  final String price;
  final String minDuration;
  final VoidCallback onTap;

  const PlaceListTile({
    super.key,
    required this.name,
    required this.region,
    required this.price,
    required this.minDuration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Left Status Strip
            Container(
              width: 6,
              color: AppColors.secondary, // Dark strip indicates "Vira Spot"
            ),

            // 2. Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Region + Tags
                    Row(
                      children: [
                        Text(
                          region.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 6),
                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Min Duration
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          "Min $minDuration mins",
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. Vertical Divider
            const VerticalDivider(width: 1, color: AppColors.border),

            // 4. Price & Action
            Container(
              width: 100,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\$$price",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            fontFamily: 'Lato',
                          ),
                        ),
                        const TextSpan(
                          text: "/hr",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      // Squared button small
                    ),
                    child: const Text(
                      "BOOK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}