
import 'package:flutter/material.dart';
import 'package:vira/core/config/app_colors.dart';
import 'package:vira/features/places/data/models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  VoidCallback? onTap;
  
  PlaceCard({
    super.key, 
    required this.place,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140, // Fixed height for consistency
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        // No shadows, purely flat
      ),
      child: Row(
        children: [
          // Left: Visual / ID
          Container(
            width: 100,
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_parking, 
                  size: 32, 
                  color: AppColors.textSecondary.withOpacity(0.3)
                ),
                const SizedBox(height: 8),
                Text(
                  "P-${100+place.id}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),
                // const SizedBox(height: 4),
                // Text(
                //   (place.region?.name ?? 'unknown').toUpperCase(),
                //   style: TextStyle(
                //     fontSize: 10,
                //     fontWeight: FontWeight.bold,
                //     color: AppColors.primary,
                //   ),
                // ),
              ],
            ),
          ),

          // Right: Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            place.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            //   color: AppColors.success,
                            //   child: const Text(
                            //     "CLOSEST",
                            //     style: TextStyle(
                            //       fontSize: 8,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${(place.region?.name ?? 'unkown')} • min/${place.minDurationMinutes} mins",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Divider
                  Divider(height: 1, color: AppColors.border.withOpacity(0.5)),

                  // Footer: Price & Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "RATE",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                "\$${place.pricePerHour}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Text(
                                "/hr",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Book Button
                      InkWell(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            // Sharp corners
                          ),
                          child: const Text(
                            "BOOK",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}