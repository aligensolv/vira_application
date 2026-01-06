import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/home/presentation/widgets/place_card.dart';
import 'package:vira/features/places/application/place_provider.dart';
import 'package:vira/features/places/data/models/place.dart';
import 'package:vira/features/places/presentation/screens/place_details_screen.dart';
import 'package:vira/features/region/data/models/region.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_input.dart';

class RegionPlacesScreen extends ConsumerWidget {
  final Region region;

  const RegionPlacesScreen({super.key, required this.region});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the API Data based on Region ID
    final placesAsync = ref.watch(placesByRegionProvider(region.id));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
          SliverAppBar(
            surfaceTintColor: Colors.white,
            pinned: true,
            title: Text(
              region.name,
            ),
          ),
      
          // 2. Search Header (Full Width)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AppInput(
                hintText: "Search in ${region.name}...",
                prefixIcon: Icons.search,
                onChanged: (val) {
                  // Implement local filtering logic here if needed
                },
              ),
            ),
          ),
      
          // 3. Async List Content
          placesAsync.when(
            // --- LOADING STATE ---
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              ),
            ),
            
            // --- ERROR STATE ---
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.destructive),
                    const SizedBox(height: 16),
                    Text(
                      "Failed to load spots",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => ref.refresh(placesByRegionProvider(region.id)),
                      child: const Text("Retry", style: TextStyle(color: AppColors.primary)),
                    )
                  ],
                ),
              ),
            ),
      
            // --- DATA STATE ---
            data: (places) {
              if (places.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No spots found in this zone.",
                      style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
      
              // Using a SliverList to render the count header + items
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Header: Spots Found Count (Index 0)
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "${places.length} SPOTS FOUND",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                              letterSpacing: 1.0,
                            ),
                          ),
                        );
                      }
      
                      // Items (Index 1 to N)
                      final place = places[index - 1]; // Offset index by 1
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PlaceCard(
                          place: place,
                          onTap: () => _navigateToDetails(context, place),
                        ),
                      );
                    },
                    childCount: places.length + 1, // +1 for the header
                  ),
                ),
              );
            },
          ),
      
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceDetailsScreen(placeId: place.id,),
      ),
    );
  }
}