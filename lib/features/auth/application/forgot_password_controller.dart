import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart'; // To access the repo provider
import '../data/repositories/auth_repository.dart';

// --- STATE ---
class ForgotPasswordState {
  final bool isLoading;
  final String? email; // Store email to pass between screens
  final String? otp;   // Store OTP after verification to use in reset

  ForgotPasswordState({
    this.isLoading = false,
    this.email,
    this.otp,
  });

  ForgotPasswordState copyWith({bool? isLoading, String? email, String? otp}) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }
}

// --- CONTROLLER ---
class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final AuthRepository _repo;

  ForgotPasswordController(this._repo) : super(ForgotPasswordState());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  // Step 1: Request OTP
  Future<void> sendOtp(String email) async {
    state = state.copyWith(isLoading: true, email: email);
    try {
      await _repo.forgotPassword(email);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Step 2: Verify OTP
  Future<void> verifyCode(String otp) async {
    if (state.email == null) throw Exception("Email not found");
    state = state.copyWith(isLoading: true);
    try {
      await _repo.verifyOtp(state.email!, otp);
      state = state.copyWith(otp: otp); // Save OTP for next step
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Step 3: Reset Password
  Future<void> resetPassword(String newPassword) async {
    if (state.email == null || state.otp == null) throw Exception("Session invalid");
    state = state.copyWith(isLoading: true);
    try {
      await _repo.resetPassword(state.email!, state.otp!, newPassword);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Resend OTP if not received
  Future<void> resendOtp() async {
    if (state.email == null) throw Exception("Email not found");
    state = state.copyWith(isLoading: true);
    try {
      await _repo.resendOtp(state.email!);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// --- PROVIDER ---
final forgotPasswordControllerProvider = 
    StateNotifierProvider.autoDispose<ForgotPasswordController, ForgotPasswordState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ForgotPasswordController(repo);
});