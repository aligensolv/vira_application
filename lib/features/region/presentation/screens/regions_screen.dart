import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_input.dart';
import '../widgets/region_grid_card.dart';
import 'region_places_screen.dart';
// Import Provider
import '../../application/region_provider.dart';

class RegionsListScreen extends ConsumerWidget {
  const RegionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(regionsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('All Regions'.toUpperCase()),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // 2. Search (Visual only for now)
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: AppInput(
                  hintText: "Find a zone...",
                  prefixIcon: Icons.search,
                ),
              ),
            ),

            // 3. Real Grid Data
            regionsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.secondary)),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text("Failed to load zones")),
              ),
              data: (regions) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final region = regions[index];
                      return RegionGridCard(
                        region: region,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegionPlacesScreen(region: region),
                            ),
                          );
                        },
                      );
                    },
                    childCount: regions.length,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}