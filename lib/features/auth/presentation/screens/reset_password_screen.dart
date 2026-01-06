import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../../core/widgets/ui/app_input.dart';
import '../../application/forgot_password_controller.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  void _handleReset() async {
    // Validation
    if (_passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password cannot be empty")));
      return;
    }
    if (_passController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match"), backgroundColor: AppColors.destructive)
      );
      return;
    }

    try {
      await ref.read(forgotPasswordControllerProvider.notifier).resetPassword(_passController.text);
      
      if (mounted) {
        // Success Dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: AppColors.success, size: 40),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Password Reset!",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.w900, 
                    color: AppColors.secondary,
                    letterSpacing: -0.5
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your password has been updated successfully. Please login with your new credentials.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: "LOGIN NOW",
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Close dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Reset Failed: ${e.toString()}"),
          backgroundColor: AppColors.destructive,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // User shouldn't go back to OTP
        title: const Text("RESET PASSWORD", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // Cancel flow
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "NEW CREDENTIALS",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.5),
              ),
              const SizedBox(height: 8),
              const Text(
                "Create New Password",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.secondary, letterSpacing: -1.0, height: 1.1),
              ),
              const SizedBox(height: 12),
              const Text(
                "Your new password must be different from previously used passwords.",
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),

              const SizedBox(height: 40),

              const Text(
                "PASSWORD",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              AppInput(
                hintText: "Enter new password",
                prefixIcon: Icons.lock_outline,
                controller: _passController,
              ),
              const SizedBox(height: 16),
              const Text(
                "CONFIRM PASSWORD",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              AppInput(
                hintText: "Re-enter new password",
                prefixIcon: Icons.lock_outline_rounded,
                controller: _confirmController,
              ),
              
              const Spacer(),
              
              AppButton(
                text: "RESET PASSWORD",
                isLoading: state.isLoading,
                onPressed: _handleReset,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}