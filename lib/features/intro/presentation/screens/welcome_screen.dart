import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image with Gradient
          Positioned.fill(
            child: Container(
              color: AppColors.secondary,
              // In real app, use NetworkImage or AssetImage here
              // For now, a placeholder with a nice color
              // child: const Icon(
              //   Icons.apartment_rounded, 
              //   size: 400, 
              //   color: Colors.white10,
              // ),
            ),
          ),
          
          // Overlay Gradient to ensure text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.secondary.withOpacity(0.3),
                    AppColors.secondary.withOpacity(0.9),
                    AppColors.secondary,
                  ],
                ),
              ),
            ),
          ),

          // 2. Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Logo (Small)
                  Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        color: AppColors.primary,
                        alignment: Alignment.center,
                        child: const Text(
                          "V",
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "VIRA",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Big Headline
                  const Text(
                    "Find your\nperfect space.",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Book meeting rooms, desk spaces, and private offices instantly.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Actions
                  AppButton(
                    text: "Get Started".toUpperCase(),
                    type: ButtonType.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: "Sign In".toUpperCase(),
                    type: ButtonType.accent, // White outline style needs adjustment in AppButton
                    // Or we create a specific style for this dark background
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
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