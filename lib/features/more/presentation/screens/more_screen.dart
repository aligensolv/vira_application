import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/extensions/context_extenstions.dart';
import 'package:vira/core/widgets/ui/app_tile.dart';
import 'package:vira/features/booking/presentation/screens/bookings_screen.dart';
import '../../../../core/config/app_colors.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get User Data
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final name = user?.name ?? "Guest User";
    final email = user?.email ?? "Sign in to access profile";
    final initials = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "G";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Settings & Preferences".toUpperCase()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Title
              // const Text(
              //   "Menu",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: AppColors.textSecondary,
              //     letterSpacing: 1.0,
              //     // uppercase: true,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // const Text(
              //   "Settings & Preferences",
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.w900,
              //     color: AppColors.secondary,
              //     height: 1.1,
              //     letterSpacing: -1.0,
              //   ),
              // ),

              // const SizedBox(height: 32),

              // 2. Profile Badge (Architectural Card)
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: AppColors.secondary,
              //     border: Border.all(color: AppColors.secondary),
              //     // Sharp corners
              //   ),
              //   child: Row(
              //     children: [
              //       // Avatar Box
              //       Container(
              //         height: 64,
              //         width: 64,
              //         decoration: const BoxDecoration(
              //           color: AppColors.primary,
              //           // No radius
              //         ),
              //         alignment: Alignment.center,
              //         child: Text(
              //           initials,
              //           style: const TextStyle(
              //             fontSize: 28,
              //             fontWeight: FontWeight.w900,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 20),
              //       // Info
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               name,
              //               style: const TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //                 letterSpacing: -0.5,
              //               ),
              //             ),
              //             const SizedBox(height: 6),
              //             Text(
              //               email,
              //               style: const TextStyle(
              //                 fontSize: 13,
              //                 color: Colors.white70,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             const SizedBox(height: 12),
              //             // Edit Label
              //             InkWell(
              //               onTap: () {},
              //               child: const Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Text(
              //                     "EDIT PROFILE",
              //                     style: TextStyle(
              //                       color: AppColors.primary,
              //                       fontSize: 10,
              //                       fontWeight: FontWeight.bold,
              //                       letterSpacing: 1.0,
              //                     ),
              //                   ),
              //                   SizedBox(width: 4),
              //                   Icon(Icons.arrow_forward, size: 12, color: AppColors.primary)
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 40),

              // 3. Settings Sections
              AppTileGroup(
                title: "Workspace",
                children: [
                  AppTile(
                    icon: Icons.history_edu_rounded,
                    label: "Booking History",
                    subLabel: "View past and upcoming reservations",
                    onTap: () {
                      context.push(
                        BookingsScreen()
                      );
                    },
                  ),
                  AppTile(
                    icon: Icons.credit_card_outlined,
                    label: "Payment Methods",
                    onTap: () {},
                  ),
                  // Using the Factory constructor for Switch
                  AppTile.switchTile(
                    icon: Icons.notifications_none_rounded,
                    label: "Notifications",
                    // value: _notificationsEnabled,
                    value: true,
                    onChanged: (val) {
                      // setState(() => _notificationsEnabled = val);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              AppTileGroup(
                title: "Support",
                children: [
                  AppTile(
                    icon: Icons.help_outline_rounded,
                    label: "Help Center",
                    onTap: () {},
                  ),
                  AppTile(
                    icon: Icons.privacy_tip_outlined,
                    label: "Privacy & Terms",
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 4. Logout Action
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
                        "LOG OUT",
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

              const SizedBox(height: 24),

              // 5. Version Info
              const Center(
                child: Text(
                  "Version 1.0.0 • Build 142",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.border),
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              
              return Container(
                decoration: BoxDecoration(
                  border: isLast ? null : const Border(
                    bottom: BorderSide(color: AppColors.border, width: 0.5),
                  ),
                ),
                child: item,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasSwitch;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.secondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (hasSwitch)
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: AppColors.primary,
                ),
              )
            else
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}