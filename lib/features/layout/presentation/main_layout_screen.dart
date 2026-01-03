import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/presentation/screens/bookings_screen.dart';
import 'package:vira/features/layout/presentation/custom_bottom_nav.dart';
import 'package:vira/features/more/presentation/screens/more_screen.dart';
import 'package:vira/features/profile/presentation/screens/profile_screen.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../application/layout_provider.dart';

class MainLayoutScreen extends ConsumerWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = [
      const HomeScreen(),
      const BookingsScreen(),
      const ProfileScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}