import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
                                      child: Text(
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

              // 3. Stats Strip (Gamification)
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "12",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
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
                          const Text(
                            "45h",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "HOURS PARKED",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                    showChevron: false, // Read only feel
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
                    subLabel: user?.joinedAt != null ? DateFormat('dd MMM yyyy, hh:mm a').format(user!.joinedAt.toLocal()) : null,
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