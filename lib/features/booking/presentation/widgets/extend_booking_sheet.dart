import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/application/booking_provider.dart';
import 'package:vira/features/booking/data/models/booking.dart';
import 'package:vira/shared/providers/payment_provider.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';

class ExtendBookingSheet extends ConsumerStatefulWidget {
  final Booking booking;

  const ExtendBookingSheet({super.key, required this.booking});

  @override
  ConsumerState<ExtendBookingSheet> createState() => _ExtendBookingSheetState();
}

class _ExtendBookingSheetState extends ConsumerState<ExtendBookingSheet> {
  final TextEditingController _hoursCtrl = TextEditingController(text: "0");
  final TextEditingController _minsCtrl = TextEditingController(text: "30"); // Default 30 min extension
  
  bool _isLoading = false;

  int get _additionalMinutes {
    final h = int.tryParse(_hoursCtrl.text) ?? 0;
    final m = int.tryParse(_minsCtrl.text) ?? 0;
    return (h * 60) + m;
  }

  double get _additionalCost {
    // Business Rule: Cost = ceil(hours) * rate
    // We treat the extension as a new block for simplicity in calculation
    final hours = _additionalMinutes / 60;
    return hours * widget.booking.place.pricePerHour;
  }

  Future<void> _submitExtension() async {
  if (_additionalMinutes <= 0) return;

  setState(() => _isLoading = true);
  try {
    // 1. Initialize Stripe
    final stripeService = ref.read(stripePaymentServiceProvider);
    
    // 2. Process Payment
    // final isPaid = await stripeService.makePayment(_additionalCost, 'usd');
    final isPaid = await stripeService.payWithCard(_additionalCost, 'usd');
    if (!isPaid) {
      setState(() => _isLoading = false);
      return;
    }

    // 3. Call Extend API (After Payment)
    final repo = ref.read(bookingRepositoryProvider);
    await repo.extendBooking(widget.booking.id, _additionalMinutes);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Extended Successfully"), backgroundColor: AppColors.success));
      ref.refresh(myBookingsProvider);
    }
  } catch (e) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.destructive));
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    // Calculate new end time preview
    final newEndTime = widget.booking.endTime.add(Duration(minutes: _additionalMinutes));
    final endTimeStr = "${newEndTime.hour}:${newEndTime.minute.toString().padLeft(2, '0')}";

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      height: 550,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "EXTEND SESSION",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  letterSpacing: 1.0,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          
          const SizedBox(height: 32),

          // Duration Inputs
          const Text("ADDITIONAL TIME", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DigitalInput(
                  controller: _hoursCtrl,
                  label: "HOURS",
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              const Text(":", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.border)),
              const SizedBox(width: 16),
              Expanded(
                child: _DigitalInput(
                  controller: _minsCtrl,
                  label: "MINUTES",
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "New End Time: $endTimeStr",
              style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),

          const Spacer(),

          // Cost Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              border: Border.all(color: AppColors.secondary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ADDITIONAL COST",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Pay via Default Card",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  "\$${_additionalCost.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          
          SafeArea(
            child: AppButton(
              text: "CONFIRM EXTENSION",
              type: ButtonType.primary,
              isLoading: _isLoading,
              onPressed: _additionalMinutes > 0 ? _submitExtension : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Reusing the Digital Input style
class _DigitalInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  const _DigitalInput({required this.controller, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
            onChanged: onChanged,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.secondary,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}