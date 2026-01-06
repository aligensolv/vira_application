import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/shared/providers/api_client.dart';

import '../../core/services/stripe_payment_service.dart';

// ... existing providers

final stripePaymentServiceProvider = Provider<StripePaymentService>((ref) {
  final client = ref.watch(apiClientProvider);
  return StripePaymentService(client);
});