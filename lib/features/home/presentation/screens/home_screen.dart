import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/auth/application/auth_controller.dart';
import 'package:vira/features/home/presentation/widgets/place_search_delegate.dart';
import 'package:vira/features/places/application/place_provider.dart';
import 'package:vira/features/places/application/places_realtime_provider.dart';
import 'package:vira/features/places/presentation/screens/place_details_screen.dart';
import 'package:vira/features/region/application/region_provider.dart';
import '../../../../core/config/app_colors.dart';
import '../widgets/place_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get User
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final userName = user?.name.split(' ').first ?? "Driver"; 

    final regionsAsync = ref.watch(regionsProvider);
    final placesAsync = ref.watch(placesProvider);

    ref.watch(placesRealtimeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "VIRA PARKING", 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications_none, color: Colors.white),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(placesProvider);
            ref.refresh(regionsProvider);
          },
          child: CustomScrollView(
            slivers: [
              // --- HEADER SECTION ---
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning, $userName",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Where are you parking today?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondary,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
          
                  InkWell(
                    onTap: () {
                      final placesState = ref.read(placesProvider);
                
                      placesState.whenData((places) {
                        showSearch(
                          context: context,
                          delegate: PlaceSearchDelegate(places: places),
                        );
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      color: AppColors.secondary,
                      child: Icon(
                        Icons.manage_search_outlined, color: Colors.white,
                      ),
                    ),
                  )
                    ],
                  ),
                ),
              ),
          
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
          
              // --- SELECT REGION HEADER ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "AVAILABLE REGIONS",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (_) => const RegionsListScreen()),
                      //     );
                      //   },
                      //   child: Text(
                      //     'SEE ALL REGIONS',
                      //     style: const TextStyle(
                      //       color: AppColors.primary,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 12,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
          
              // --- HORIZONTAL REGIONS LIST ---
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 72,
                  child: regionsAsync.when(
                    loading: () => ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) => _buildShimmerZone(),
                    ),
                    error: (err, stack) => const Center(
                      child: Text("Error loading zones", style: TextStyle(color: AppColors.destructive)),
                    ),
                    data: (regions) {
                      if (regions.isEmpty) {
                        return const Center(child: Text("No zones available"));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: regions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final region = regions[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => RegionPlacesScreen(region: region),
                              //   ),
                              // );
                            },
                            child: _ZoneTile(
                              name: region.name,
                              count: "${region.placesCount} Spots",
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
          
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
          
              // --- NEARBY PARKING HEADER ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NEARBY PARKING",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (_) => const ExplorePlacesScreen()),
                      //     );                        
                      //   },
                      //   child: const Row(
                      //     children: [
                      //       Text(
                      //         "SEE ALL SPOTS",
                      //         style: TextStyle(
                      //           color: AppColors.primary,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 12,
                      //         ),
                      //       ),
                      //       SizedBox(width: 4),
                      //       Icon(Icons.map_outlined, size: 16, color: AppColors.primary),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
          
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
          
              // --- VERTICAL PARKING LIST ---
              // Replaced SizedBox horizontal list with AsyncValue handling slivers
              placesAsync.when(
                loading: () => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildShimmerPlaceCard(fullWidth: true),
                        const SizedBox(height: 16),
                        _buildShimmerPlaceCard(fullWidth: true),
                      ],
                    ),
                  ),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Center(
                    child: Text("Failed to load spots: $err", style: const TextStyle(color: AppColors.destructive)),
                  ),
                ),
                data: (places) {
                  if (places.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text("No spots available nearby.")),
                    );
                  }
                  
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.separated(
                      itemCount: places.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final place = places[index];
                        return PlaceCard(
                          place: place,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlaceDetailsScreen(placeId: place.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
          
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerZone() {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: SizedBox(
          height: 20, width: 20, 
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary)
        )
      ),
    );
  }

  Widget _buildShimmerPlaceCard({bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : 200,
      height: 180, // Approximate height of the new card
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: SizedBox(
          height: 30, width: 30, 
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary),
        ),
      ),
    );
  }
}

class _ZoneTile extends StatelessWidget {
  final String name;
  final String count;

  const _ZoneTile({required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Icon(
          //   Icons.location_city_outlined,
          //   color: AppColors.textSecondary,
          //   size: 24,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}