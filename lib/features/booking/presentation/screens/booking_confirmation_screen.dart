import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/services/stripe_payment_service.dart';
import 'package:vira/features/booking/application/booking_control.dart';
import 'package:vira/features/places/data/models/place.dart';
import 'package:vira/shared/providers/payment_provider.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../layout/presentation/main_layout_screen.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final Place place;
  final BookingDraftState bookingState;

  const BookingConfirmationScreen({super.key, required this.place, required this.bookingState});

  @override
  ConsumerState<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends ConsumerState<BookingConfirmationScreen> {
  int _selectedMethod = 0; // 0 = Card, 1 = Google Pay
  bool _isLoading = false;

  Future<void> _handlePayPress() async {
    setState(() => _isLoading = true);

    try {
      final stripeService = ref.read(stripePaymentServiceProvider);
      final bookingController = ref.read(bookingControllerProvider(widget.place).notifier);
      final double amount = widget.bookingState.estimatedPrice;

      bool isPaid = false;

      // --- BRANCH LOGIC BASED ON SELECTION ---
      if (_selectedMethod == 0) {
        // CARD FLOW
        isPaid = await stripeService.payWithCard(amount, 'usd');
      } else {
        // GOOGLE PAY FLOW
        isPaid = await stripeService.payWithGooglePay(amount, 'usd');
      }

      if (!isPaid) {
        // User cancelled
        setState(() => _isLoading = false);
        return;
      }

      // --- SUBMIT BOOKING AFTER PAYMENT ---
      String methodStr = _selectedMethod == 0 ? "credit_card" : "google_pay";
      
      await bookingController.submitBooking(
        widget.place.id,
        // methodStr,
        // "Stripe ${methodStr.toUpperCase()} Verified",
      );

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Error: ${e.toString()}"), backgroundColor: AppColors.destructive),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
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
              decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: AppColors.success, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              "Booking Confirmed!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.secondary),
            ),
            const SizedBox(height: 8),
            const Text("Your spot is reserved.", textAlign: TextAlign.center),
            const SizedBox(height: 32),
            AppButton(
              text: "GO TO HOME",
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
                  (route) => false,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.bookingState;
    final regionName = (widget.place.region?.name ?? 'Unknown').toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("CHECKOUT"),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TICKET SUMMARY (Keep existing code) ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                ]
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(regionName, style: const TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                const SizedBox(height: 4),
                                Text(widget.place.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.white.withOpacity(0.1),
                              child: const Icon(Icons.local_parking, color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _TicketField("START", "${state.startTime.hour}:${state.startTime.minute.toString().padLeft(2, '0')}"),
                            const Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
                            _TicketField("DURATION", "${state.durationMinutes}m"),
                            const Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
                            _TicketField("RATE", "\$${state.pricePerHour.toStringAsFixed(0)}/hr"),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("TOTAL DUE", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(
                              "\$${state.estimatedPrice.toStringAsFixed(2)}", 
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.primary, height: 1.0)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- PAYMENT METHOD SELECTOR ---
            const Text("PAYMENT METHOD", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.0)),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _MethodCard(
                    icon: Icons.credit_card,
                    label: "Credit Card",
                    isSelected: _selectedMethod == 0,
                    onTap: () => setState(() => _selectedMethod = 0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MethodCard(
                    icon: Icons.android, // Or generic wallet icon
                    label: "Google Pay",
                    isSelected: _selectedMethod == 1,
                    onTap: () => setState(() => _selectedMethod = 1),
                    disabled: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MethodCard(
                    icon: Icons.apple_outlined, // Or generic wallet icon
                    label: "Apply Pay",
                    isSelected: _selectedMethod == 2,
                    onTap: () => setState(() => _selectedMethod = 2),
                    disabled: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent,
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, size: 16, color: AppColors.secondary),
                  SizedBox(width: 8),
                  Expanded(child: Text("Secure payment processed by Stripe", style: TextStyle(fontSize: 12, color: AppColors.secondary))),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- PAY BUTTON ---
            AppButton(
              text: "PAY \$${state.estimatedPrice.toStringAsFixed(2)}",
              isLoading: _isLoading,
              onPressed: _handlePayPress,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ... _MethodCard and _TicketField Helpers remain the same ...
class _TicketField extends StatelessWidget {
  final String label;
  final String value;
  const _TicketField(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool disabled;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 80,
          decoration: BoxDecoration(
            color: disabled ? AppColors.background : (isSelected ? Colors.white : AppColors.background),
            border: Border.all(
              color: disabled ? AppColors.border : (isSelected ? AppColors.secondary : AppColors.border),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: disabled ? AppColors.textSecondary.withOpacity(0.5) : (isSelected ? AppColors.secondary : AppColors.textSecondary),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: disabled ? AppColors.textSecondary.withOpacity(0.5) : (isSelected ? AppColors.secondary : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}