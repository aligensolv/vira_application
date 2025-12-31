import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/intro/presentation/screens/welcome_screen.dart';
import '../../../../core/config/app_colors.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../layout/presentation/main_layout_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    // 1. Keep the splash visible for at least 2 seconds for branding
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    // 2. Check Auth State
    // We read the provider. The controller checks SharedPreferences in its constructor.
    final authState = ref.read(authControllerProvider);

    // 3. Navigate based on state
    if (authState.value != null) {
      // User is logged in -> Go Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
      );
    } else {
      // User is NOT logged in -> Go to Welcome Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary, // Dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutBack,
              builder: (context, double scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    height: 100,
                    width: 100,
                    color: AppColors.primary, // Orange Logo
                    alignment: Alignment.center,
                    child: const Text(
                      "V",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Brand Name
            const Text(
              "VIRA PARKING",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}