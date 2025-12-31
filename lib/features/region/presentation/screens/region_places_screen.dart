import 'package:flutter/material.dart';
import 'package:vira/features/home/presentation/widgets/place_card.dart';
import 'package:vira/features/places/data/models/place.dart';
import 'package:vira/features/places/presentation/screens/place_details_screen.dart';
import 'package:vira/features/region/data/models/region.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_input.dart';


class RegionPlacesScreen extends StatelessWidget {
  final Region region;

  const RegionPlacesScreen({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    // Mock Data based on the passed Region
    final places = List.generate(8, (index) => {
      "name": "${region.name} Spot ${String.fromCharCode(65+index)}-${index + 10}",
      "price": (12 + index * 1.5).toStringAsFixed(0),
      "min": "60",
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. App Bar
            SliverAppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "ZONE: ${region.name.toUpperCase()}",
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 1.0,
                ),
              ),
              centerTitle: true,
            ),

            // 2. Search / Filter Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppInput(
                            hintText: "Search in ${region.name}...",
                            prefixIcon: Icons.search,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 52,
                          width: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                          ),
                          child: const Icon(Icons.tune, color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${places.length} SPOTS FOUND",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.sort, size: 16, color: AppColors.textSecondary),
                            SizedBox(width: 4),
                            Text(
                              "Price: Low to High",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. Vertical Places List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.separated(
                itemCount: places.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  // final placeData = places[index];
                  // return PlaceCard(
                  //   // Pass null width to make it expand to screen width
                  //   // width: null, 
                  //   region: "z",
                  //   name: placeData['name'] ?? '',
                  //   price: placeData['price'] ?? '',
                  //   minDuration: placeData['min'] ?? '',
                  //   onTap: () => _navigateToDetails(context, placeData),
                  // );

                  return Container();
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Map<String, String> placeData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceDetailsScreen(
          place: Place(
            id: DateTime.now().millisecondsSinceEpoch,
            name: placeData['name'] ?? '',
            region: region,
            pricePerHour: double.parse(placeData['price'] ?? ''),
            minDurationMinutes: int.parse(placeData['min'] ?? ''),
          ),
        ),
      ),
    );
  }
}