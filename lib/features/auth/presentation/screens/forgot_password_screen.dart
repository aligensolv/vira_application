import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../../core/widgets/ui/app_input.dart';
import '../../application/forgot_password_controller.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  void _handleSubmit() async {
    if (_emailController.text.isEmpty) return;

    // Call Controller
    try {
      await ref.read(forgotPasswordControllerProvider.notifier).sendOtp(_emailController.text.trim());
      
      if (mounted) {
        // Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Sent! Check your inbox."),
            backgroundColor: AppColors.success,
          ),
        );
        // Navigate
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OtpVerificationScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${e.toString()}"),
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
        title: Text("Forgot Password".toUpperCase())
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // 2. Headings
              const Text(
                "RECOVERY",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  height: 1.1,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Enter your registered email address below. We will send you a 6-digit code to reset your password.",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // 3. Form
              const Text(
                "EMAIL ADDRESS",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              AppInput(
                hintText: "name@example.com",
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
              ),

              const Spacer(),

              // 4. Action
              AppButton(
                text: "SEND RESET CODE",
                type: ButtonType.primary,
                isLoading: state.isLoading,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}