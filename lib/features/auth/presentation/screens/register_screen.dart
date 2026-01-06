import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/extensions/context_extenstions.dart';
import 'package:vira/core/extensions/sizedbox.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  void _handleRegister() async {
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match"), backgroundColor: AppColors.destructive),
      );
      return;
    }

    await ref.read(authControllerProvider.notifier).register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    final authState = ref.read(authControllerProvider);

    if (authState.hasValue && authState.value != null && mounted) {
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

  // Getter for convenience in validation check
  TextEditingController get _confirmController => _confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: AppColors.secondary,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.h,
              // 1. HEADER
              const Text(
                "New\nAccount.",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  height: 1.0,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(width: 24, height: 2, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Text(
                    "Join Vira for seamless booking.",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 2. INPUTS
              AppInput(
                hintText: "Full Name",
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              AppInput(
                hintText: "Email Address",
                prefixIcon: Icons.alternate_email,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              AppInput(
                hintText: "Password",
                prefixIcon: Icons.lock_outline,
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
              const SizedBox(height: 16),
              AppInput(
                hintText: "Confirm Password",
                prefixIcon: Icons.lock_reset,
                controller: _confirmPasswordController,
                obscureText: !_isConfirmVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isConfirmVisible = !_isConfirmVisible),
                ),
              ),

              const SizedBox(height: 40),

              // 3. ACTIONS
              AppButton(
                text: "GET STARTED",
                type: ButtonType.primary,
                isLoading: isLoading,
                onPressed: _handleRegister,
              ),

              const SizedBox(height: 32),

  

              Center(
                child: Column(
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
                        ),
                        child: const Text(
                          "SIGN IN",
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}