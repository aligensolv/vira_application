import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/utils/error_handler.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../application/forgot_password_controller.dart';
import 'reset_password_screen.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    if (_codeController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter full 6-digit code")),
      );
      return;
    }

    try {
      await ref.read(forgotPasswordControllerProvider.notifier).verifyCode(_codeController.text.trim());
      
      if (mounted) {
        // Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Code Verified Successfully"),
            backgroundColor: AppColors.success,
          ),
        );
        // Navigate
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(DioErrorUtil.getErrorMessage(e as DioException)),
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
        title: Text("Verification OTP".toUpperCase())
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                "SECURITY CHECK",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.5),
              ),
              const SizedBox(height: 8),
              const Text(
                "Verify It's You",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.secondary, letterSpacing: -1.0),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
                  children: [
                    const TextSpan(text: "Enter the 6-digit code sent to\n"),
                    TextSpan(
                      text: state.email ?? "your email",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- CUSTOM PIN INPUT ---
              GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(_focusNode),
                child: Container(
                  color: Colors.transparent, // Hitbox
                  child: Stack(
                    children: [
                      // 1. Hidden Real Input
                      Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: _codeController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                          onChanged: (val) => setState(() {}), // Rebuild to update boxes
                        ),
                      ),
                      // 2. Visible Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          final char = _codeController.text.length > index ? _codeController.text[index] : "";
                          final isActive = _codeController.text.length == index;
                          return _PinBox(char: char, isActive: isActive);
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Action
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: AppButton(
                                    text: "VERIFY CODE",
                                    type: ButtonType.primary,
                                    isLoading: state.isLoading,
                                    onPressed: _handleVerify,
                                  ),
                  ),
              
              
              // Resend Logic (Visual only for now)
              Expanded(
                child: AppButton(
                  text: "Resend Code",
                  type: ButtonType.accent,
                  onPressed: () {
                    ref.read(forgotPasswordControllerProvider.notifier).resendOtp();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Code resent!")));
                    setState(() {
                      _codeController.text = "";
                      _focusNode.requestFocus();
                    });
                  },
                ),
              )
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinBox extends StatelessWidget {
  final String char;
  final bool isActive;

  const _PinBox({required this.char, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final hasValue = char.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasValue ? AppColors.secondary : Colors.white,
        border: Border.all(
          color: isActive ? AppColors.primary : (hasValue ? AppColors.secondary : AppColors.border),
          width: isActive ? 2 : 1,
        ),
        // Squared
      ),
      child: Text(
        char,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: hasValue ? Colors.white : AppColors.secondary,
        ),
      ),
    );
  }
}