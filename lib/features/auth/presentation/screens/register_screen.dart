import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/auth/application/auth_providers.dart';
import 'package:vira/features/layout/presentation/main_layout_screen.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../../core/widgets/ui/app_input.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  void _handleRegister() async {
    // ... Basic Validation (Empty check, password match) same as before ...

    // Call Provider
    await ref.read(authControllerProvider.notifier).register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    final authState = ref.read(authControllerProvider);

    if (authState.hasValue && authState.value != null && mounted) {
      // Success - Go to Home directly or Login (Choice is yours, usually Home)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
        (route) => false,
      );
    } else if (authState.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration Failed: ${authState.error}"),
          backgroundColor: AppColors.destructive,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Logo / Brand
                Center(
                  child: Container(
                    height: 60,
                    width: 60,
                    color: AppColors.secondary,
                    alignment: Alignment.center,
                    child: const Text(
                      "V",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 2. Header
                const Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Join Vira and start booking spaces",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 40),

                // 3. Form Fields
                AppInput(
                  hintText: "Full Name",
                  prefixIcon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                
                AppInput(
                  hintText: "Email Address",
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                
                AppInput(
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline,
                  controller: _passwordController,
                  // Toggle Visibility Logic
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                const SizedBox(height: 16),
                
                AppInput(
                  hintText: "Confirm Password",
                  prefixIcon: Icons.lock_outline,
                  controller: _confirmPasswordController,
                   // Toggle Visibility Logic
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isConfirmVisible = !_isConfirmVisible),
                  ),
                ),

                const SizedBox(height: 32),

                // 4. Action Button
                AppButton(
                  text: "Sign Up",
                  type: ButtonType.primary,
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 24),

                // 5. Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Bottom Padding
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}