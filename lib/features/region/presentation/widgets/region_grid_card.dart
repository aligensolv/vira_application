import 'package:flutter/material.dart';
import 'package:vira/features/region/data/models/region.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_card.dart';

class RegionGridCard extends StatelessWidget {
  final Region region;
  final VoidCallback onTap;

  const RegionGridCard({
    super.key,
    required this.region,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Stack(
        children: [
          // Background Icon (Watermark)
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.location_city,
              size: 80,
              color: AppColors.secondary.withOpacity(0.05),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top: Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.map_outlined, size: 20, color: AppColors.secondary),
                ),

                // Bottom: Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      region.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${region.placesCount} Available Spots",
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}