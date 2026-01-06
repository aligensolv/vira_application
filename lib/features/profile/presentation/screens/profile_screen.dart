import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vira/features/profile/application/profile_provider.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_card.dart';
import '../../../../core/widgets/ui/app_tile.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get User Data
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    
    // 2. Get Metrics Data
    final metricsAsync = ref.watch(userMetricsProvider);
    
    final name = user?.name ?? "Guest User";
    final email = user?.email ?? "guest@vira.com";
    final words = name.isNotEmpty ? name.split(' ') : <String>[];
    final initials = words.map((word) => word.isNotEmpty ? word.substring(0, 1).toUpperCase() : '').join('');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("MY PROFILE"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 2. Identity Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Stack(
                  children: [
                    // Decorative Pattern
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.fingerprint, 
                        size: 150, 
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Avatar
                              Container(
                                height: 72,
                                width: 72,
                                color: Colors.white,
                                alignment: Alignment.center,
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      color: AppColors.primary,
                                      child: const Text(
                                        "ACTIVE",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Stats Strip (Real API Data)
              metricsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: AppColors.secondary),
                  ),
                ),
                error: (err, stack) => const Text("Failed to load stats"),
                data: (metrics) {
                  // Convert minutes to hours (e.g. 1235 min -> 20.5h)
                  // final hoursTemp = (metrics.totalDurationMinutes / 60).toStringAsFixed(1);
                  final totalHours = metrics.totalDurationMinutes / 60;
                  final days = (totalHours / 24).toInt();
                  final remainingHours = (totalHours % 24).toStringAsFixed(1);
                  final hours = days > 0 ? "$days D ${remainingHours}H" : "${totalHours.toStringAsFixed(1)}H";
                  
                  return Row(
                    children: [
                      Expanded(
                        child: AppCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${metrics.totalBookings}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "TOTAL BOOKINGS",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hours,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "HOURS PARKED",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              // 4. Personal Info Section
              AppTileGroup(
                title: "Personal Information",
                children: [
                  AppTile(
                    icon: Icons.email_outlined,
                    label: "Email Address",
                    subLabel: email,
                    showChevron: false,
                    onTap: () {},
                  ),
                  AppTile(
                    icon: Icons.phone_outlined,
                    label: "Phone Number",
                    subLabel: "ـــــــــــــــــــــــــــ",
                    showChevron: false,
                    onTap: () {},
                  ),
                  AppTile(
                    icon: Icons.person_outline_outlined,
                    label: "Joined At",
                    subLabel: user?.joinedAt != null ? DateFormat('dd MMM yyyy').format(user!.joinedAt.toLocal()) : "N/A",
                    showChevron: false,
                    onTap: () {},
                  )
                ],
              ),

              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    color: AppColors.destructive,
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "LOGOUT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdentityField extends StatelessWidget {
  final String label;
  final String value;

  const _IdentityField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}