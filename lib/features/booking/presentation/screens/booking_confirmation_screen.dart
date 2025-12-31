import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/application/booking_control.dart';
import 'package:vira/features/places/data/models/place.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../../core/widgets/ui/app_input.dart';
import '../../../layout/presentation/main_layout_screen.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final Place place;
  final BookingDraftState bookingState;

  const BookingConfirmationScreen({super.key, required this.place, required this.bookingState});

  @override
  ConsumerState<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends ConsumerState<BookingConfirmationScreen> {
  int _selectedMethod = 0; // 0: Card, 1: Apple Pay, 2: Google Pay

  void _handlePayPress() {
    // Open the Credit Card Input Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _PaymentDetailsSheet(
          amount: widget.bookingState.estimatedPrice,
          onPaymentSuccess: _onPaymentSuccess,
        ),
      ),
    );
  }

  void _onPaymentSuccess() {
    Navigator.pop(context); // Close Sheet
    
    // Show Success Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Squared
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
              "Booking Confirmed!",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w900, 
                color: AppColors.secondary,
                letterSpacing: -0.5
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your spot has been reserved. You can find your QR code in the Bookings tab.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
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
        // backgroundColor: Colors.white,
        // centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. The "Black Ticket" Summary
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.secondary,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Header
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
                        
                        // Time Details
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
                        
                        // Dashed Line
                        Row(
                          children: List.generate(30, (index) => Expanded(
                            child: Container(
                              height: 1, 
                              color: index % 2 == 0 ? Colors.white24 : Colors.transparent
                            ),
                          )),
                        ),
                        
                        const SizedBox(height: 24),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("TOTAL DUE", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(
                              "\$${state.estimatedPrice.toStringAsFixed(2)}", 
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.primary, height: 1.0)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Decorative Circles (Ticket Holes)
                  Positioned(
                    bottom: 80,
                    left: -10,
                    child: Container(height: 20, width: 20, decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle)),
                  ),
                  Positioned(
                    bottom: 80,
                    right: -10,
                    child: Container(height: 20, width: 20, decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. Payment Method Selector
            const Text("PAYMENT METHOD", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.0)),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _MethodCard(
                    icon: Icons.credit_card,
                    label: "Card",
                    isSelected: _selectedMethod == 0,
                    onTap: () => setState(() => _selectedMethod = 0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MethodCard(
                    icon: Icons.apple,
                    label: "Pay",
                    isSelected: _selectedMethod == 1,
                    onTap: () => setState(() => _selectedMethod = 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MethodCard(
                    icon: Icons.android,
                    label: "Pay",
                    isSelected: _selectedMethod == 2,
                    onTap: () => setState(() => _selectedMethod = 2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            
            // Info Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // border: Border.all(color: AppColors.border),
                color: AppColors.accent
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, size: 16, color: AppColors.textPrimary),
                  SizedBox(width: 8),
                  Expanded(child: Text("Transactions are secure and encrypted.", style: TextStyle(fontSize: 12, color: AppColors.textPrimary))),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 3. Pay Button
            AppButton(
              text: "PAY \$${state.estimatedPrice.toStringAsFixed(2)}",
              onPressed: _handlePayPress,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- PAYMENT SHEET (SIMULATION) ---

class _PaymentDetailsSheet extends StatefulWidget {
  final double amount;
  final VoidCallback onPaymentSuccess;

  const _PaymentDetailsSheet({required this.amount, required this.onPaymentSuccess});

  @override
  State<_PaymentDetailsSheet> createState() => _PaymentDetailsSheetState();
}

class _PaymentDetailsSheetState extends State<_PaymentDetailsSheet> {
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() => _isProcessing = true);
    // Simulate Network Delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      widget.onPaymentSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ENTER CARD DETAILS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.0)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))
            ],
          ),
          const SizedBox(height: 20),
          const AppInput(hintText: "Card Number", prefixIcon: Icons.credit_card),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: AppInput(hintText: "MM/YY", prefixIcon: Icons.calendar_today)),
              const SizedBox(width: 16),
              Expanded(child: AppInput(hintText: "CVV", prefixIcon: Icons.lock_outline)),
            ],
          ),
          const SizedBox(height: 16),
          const AppInput(hintText: "Cardholder Name", prefixIcon: Icons.person_outline),
          
          const SizedBox(height: 32),
          
          AppButton(
            text: "CONFIRM PAYMENT",
            isLoading: _isProcessing,
            onPressed: _processPayment,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// --- HELPER WIDGETS ---

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
  final VoidCallback onTap;

  const _MethodCard({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.background,
          border: Border.all(color: isSelected ? AppColors.secondary : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.secondary : AppColors.textSecondary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.secondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}