import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/auth/application/auth_controller.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_input.dart';

class HomeScreenConceptV5 extends ConsumerStatefulWidget {
  const HomeScreenConceptV5({super.key});

  @override
  ConsumerState<HomeScreenConceptV5> createState() => _HomeScreenConceptV5State();
}

class _HomeScreenConceptV5State extends ConsumerState<HomeScreenConceptV5> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _zones = ["Downtown", "Maadi", "Zamalek", "Nasr City", "Zayed"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _zones.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    final userName = user?.name.split(' ').first.toUpperCase() ?? "GUEST";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // 1. Sticky Header
            SliverAppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.white,
              floating: true,
              pinned: true,
              elevation: 0,
              expandedHeight: 180, // Height for the Action Grid
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Column(
                    children: [
                      // Quick Action Grid (3-Column)
                      Row(
                        children: [
                          _QuickAction(icon: Icons.map_outlined, label: "MAP VIEW"),
                          const SizedBox(width: 12),
                          _QuickAction(icon: Icons.qr_code_scanner, label: "SCAN QR", isPrimary: true),
                          const SizedBox(width: 12),
                          _QuickAction(icon: Icons.history, label: "HISTORY"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // The Title Row (Stays Pinned)
              // titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "VIRA PARKING",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "HELLO, $userName",
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  // Search Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.search, color: AppColors.secondary),
                  ),
                ],
              ),
            ),

            // 2. Zone Tab Bar (Sticky)
            SliverPersistentHeader(
              delegate: _SliverTabDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabs: _zones.map((z) => Tab(text: z.toUpperCase())).toList(),
                ),
              ),
              pinned: true,
            ),
          ],

          // 3. The Feed (Tab Bar View)
          body: TabBarView(
            controller: _tabController,
            children: _zones.map((zone) {
              return _ZoneListView(zoneName: zone);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// --- SUB-WIDGETS ---

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _QuickAction({
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.secondary : Colors.white,
          border: Border.all(color: isPrimary ? AppColors.secondary : AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: isPrimary ? Colors.white : AppColors.secondary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneListView extends StatelessWidget {
  final String zoneName;

  const _ZoneListView({required this.zoneName});

  @override
  Widget build(BuildContext context) {
    // Generate some diverse dummy data
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _LedgerPlaceCard(index: index, zoneName: zoneName),
        );
      },
    );
  }
}

class _LedgerPlaceCard extends StatelessWidget {
  final int index;
  final String zoneName;

  const _LedgerPlaceCard({required this.index, required this.zoneName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // 1. Status Indicator Strip
          Container(
            width: 6,
            color: index == 0 ? AppColors.destructive : AppColors.success,
          ),

          // 2. ID & Icon
          Container(
            width: 80,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_parking, size: 28, color: AppColors.textSecondary.withOpacity(0.5)),
                const SizedBox(height: 8),
                Text(
                  "P-${100 + index}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // 3. Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$zoneName Garage",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      // Availability Tag
                      Text(
                        index == 0 ? "FULL" : "OPEN",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: index == 0 ? AppColors.destructive : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Attributes
                  Row(
                    children: [
                      const Icon(Icons.bolt, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        "EV Charging",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.roofing, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        "Covered",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Price Button
          InkWell(
            onTap: () {
              // Navigate
            },
            child: Container(
              width: 90,
              color: AppColors.secondary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${10 + index}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    "BOOK",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for Sticky Headers
class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background, // Match background
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          tabBar,
          const Divider(height: 1, color: AppColors.border),
        ],
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  double get minExtent => tabBar.preferredSize.height + 1;

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) {
    return false;
  }
}