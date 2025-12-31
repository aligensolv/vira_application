import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/auth/application/auth_controller.dart';
import '../../../../core/config/app_colors.dart';

class HomeScreenConceptV4 extends ConsumerStatefulWidget {
  const HomeScreenConceptV4({super.key});

  @override
  ConsumerState<HomeScreenConceptV4> createState() => _HomeScreenConceptV4State();
}

class _HomeScreenConceptV4State extends ConsumerState<HomeScreenConceptV4> {
  int _selectedZoneIndex = 0;
  final _zones = ["All Zones", "Downtown", "Maadi", "Zamalek", "Nasr City", "Zayed"];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    final userName = user?.name.split(' ').first.toUpperCase() ?? "GUEST";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // 1. Minimal App Bar
            SliverAppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              pinned: false,
              snap: true,
              floating: true,
              elevation: 0,
              centerTitle: false,
              titleSpacing: 20,
              title: Row(
                children: [
                  Container(
                    width: 8, height: 8, color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "HELLO, $userName",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.search, color: AppColors.secondary, size: 28),
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.qr_code_scanner, color: AppColors.secondary, size: 28),
                ),
                const SizedBox(width: 12),
              ],
            ),

            // 2. Large Page Title
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Find Parking",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                    height: 1.0,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),

            // 3. Zone Selector (Sticky-ish feel via placement)
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _zones.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedZoneIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedZoneIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.secondary : Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.secondary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          _zones[index].toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          // 4. The Feed (Body)
          body: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: 8,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return _ProPlaceCard(index: index);
            },
          ),
        ),
      ),
      
      // Floating Map Button (High Utility)
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.map_outlined, color: Colors.white),
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class _ProPlaceCard extends StatelessWidget {
  final int index;
  const _ProPlaceCard({required this.index});

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
                  "P-${100+index}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ZONE A",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                ),
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
                          const Text(
                            "CENTRAL GARAGE",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          if (index == 0) // Only show on first for demo
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              color: AppColors.success,
                              child: const Text(
                                "CLOSEST",
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Downtown • 3 mins away",
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
                                "\$${10 + index}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Text(
                                "/hr",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Book Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          // Sharp corners
                        ),
                        child: const Text(
                          "Book",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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