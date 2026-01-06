import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../network/api_client.dart';

class StripePaymentService {
  final ApiClient _apiClient;

  StripePaymentService(this._apiClient);

  // --- 1. CARD FLOW (Stripe Payment Sheet) ---
  Future<bool> payWithCard(double amount, String currency) async {
    try {
      final paymentData = await _createPaymentIntent(amount, currency);
      final clientSecret = paymentData['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Vira Parking',
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: Color(0xFFEE6C4D)),
            shapes: PaymentSheetShape(borderRadius: 0, borderWidth: 1),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(background: Color(0xFF353535), text: Colors.white),
              ),
              shapes: PaymentSheetPrimaryButtonShape(),
            ),
          ),
          // Disable Google/Apple Pay here to force Card entry
          googlePay: null,
          applePay: null,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return false;
      throw Exception(e.error.localizedMessage);
    } catch (e) {
      debugPrint('Card Payment Error: $e');
      rethrow;
    }
  }

  // --- 2. GOOGLE PAY FLOW (Native) ---
  Future<bool> payWithGooglePay(double amount, String currency) async {
    try {
      final paymentData = await _createPaymentIntent(amount, currency);
      final clientSecret = paymentData['clientSecret'];

      // 1. Initialize Google Pay
      await Stripe.instance.confirmPlatformPaySetupIntent(
        clientSecret: clientSecret,
        confirmParams: PlatformPayConfirmParams.googlePay(
          googlePay: GooglePayParams(
            merchantCountryCode: 'US', 
            currencyCode: currency
          )
        )
      );

      // 2. Present Google Pay Sheet
      // await Stripe.instance.presentGooglePay(
      //   PresentGooglePayParams(clientSecret: clientSecret),
      // );
      
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return false;
      // Handle "Google Pay not available" specifically
      throw Exception(e.error.localizedMessage);
    } catch (e) {
      debugPrint('Google Pay Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(double amount, String currency) async {
    try {
      final response = await _apiClient.post(
        '/payment/create-payment-intent',
        data: {'amount': amount, 'currency': currency},
      );
      return response.data;
    } catch (e) {
      throw Exception("Failed to initialize payment with server.");
    }
  }
}