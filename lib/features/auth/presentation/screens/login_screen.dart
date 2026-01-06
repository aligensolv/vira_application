import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/extensions/context_extenstions.dart';
import 'package:vira/features/auth/application/auth_providers.dart';
import 'package:vira/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:vira/features/auth/presentation/screens/register_screen.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../../core/widgets/ui/app_input.dart';
import '../../../layout/presentation/main_layout_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _handleLogin() async {
    await ref.read(authControllerProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

    final authState = ref.read(authControllerProvider);

    if (authState.hasValue && authState.value != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
      );
    } else if (authState.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed: ${authState.error}"),
          backgroundColor: AppColors.destructive,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BRAND MARK
              // Container(
              //   height: 48,
              //   width: 48,
              //   decoration: BoxDecoration(
              //     color: AppColors.secondary,
              //     // No radius = Squared
              //   ),
              //   alignment: Alignment.center,
              //   child: const Text(
              //     "V",
              //     style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.w900,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              
              // const SizedBox(height: 40),

              // 2. TYPOGRAPHY HEADER
              const Text(
                "Welcome\nBack.",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  height: 1.0, // Tight line height
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(width: 24, height: 2, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Text(
                    "Sign in to access your bookings.",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // 3. INPUTS
              AppInput(
                hintText: "Email Address",
                prefixIcon: Icons.alternate_email,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              AppInput(
                hintText: "Password",
                prefixIcon: Icons.lock_outline_rounded,
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),

              // Forgot Password
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => context.push(const ForgotPasswordScreen()),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 4. ACTIONS
              AppButton(
                text: "SIGN IN",
                type: ButtonType.primary,
                isLoading: isLoading,
                onPressed: _handleLogin,
              ),

              const SizedBox(height: 40),

              // 5. FOOTER (Sign Up)
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
                        ),
                        child: const Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}