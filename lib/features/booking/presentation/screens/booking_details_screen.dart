import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/data/models/booking.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
// Assuming you have a provider for booking logic, usually in:
// import '../../application/booking_controller.dart'; 

class BookingDetailsScreen extends ConsumerWidget {
  final Booking booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Logic & Helpers ---
    
    // 1. Time Formatting
    final String dateStr = "${booking.startTime.year}-${booking.startTime.month.toString().padLeft(2, '0')}-${booking.startTime.day.toString().padLeft(2, '0')}";
    final String startStr = _formatTime(booking.startTime);
    final String endStr = _formatTime(booking.endTime);
    final String timeRange = "$startStr - $endStr"; // Fixed: Variable is now defined
    
    // 2. Duration Calculation
    final int totalMinutes = booking.endTime.difference(booking.startTime).inMinutes;
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    final String durationStr = minutes > 0 ? "${hours}h ${minutes}m" : "${hours} Hours";

    // 3. Cancellation Rule (Strict: Only before start time)
    // Also check if status is not already cancelled or completed
    final bool isBeforeStart = DateTime.now().isBefore(booking.startTime);
    final bool isActiveStatus = booking.status == BookingStatus.confirmed || booking.status == BookingStatus.pending;
    final bool canCancel = isBeforeStart && isActiveStatus;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("BOOKING DETAILS"),
        // centerTitle: true,
        // backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: ID & STATUS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "BOOKING ID",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "#${booking.id}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                _StatusBadge(status: booking.status),
              ],
            ),

            const SizedBox(height: 32),

            // --- SECTION 1: PLACE INFO ---
            const _SectionTitle(title: "LOCATION"),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary), // Strong border
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        booking.region.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.placeName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- SECTION 2: TIMING ---
            const _SectionTitle(title: "SCHEDULE"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  _DetailRow(label: "DATE", value: dateStr),
                  const Divider(height: 1, color: AppColors.border),
                  _DetailRow(label: "TIME", value: timeRange),
                  const Divider(height: 1, color: AppColors.border),
                  _DetailRow(label: "DURATION", value: durationStr),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- SECTION 3: PAYMENT ---
            const _SectionTitle(title: "PAYMENT"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary, // Dark Background
                // No radius (Squared)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TOTAL PAID",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    "\$${booking.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- ACTION BUTTON ---
            if (canCancel) ...[
              AppButton(
                text: "CANCEL BOOKING",
                type: ButtonType.outline, // Or specific error style
                isFullWidth: true,
                onPressed: () {
                  _showCancelConfirmation(context, ref, booking.id);
                },
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "Cancellation is only available before the start time.",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ),
            ] else if (booking.status == BookingStatus.cancelled) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.destructive.withOpacity(0.1),
                    border: Border.all(color: AppColors.destructive.withOpacity(0.3)),
                  ),
                  child: const Text(
                    "Booking Cancelled",
                    style: TextStyle(color: AppColors.destructive, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, WidgetRef ref, int bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text("Cancel Booking?", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
        content: const Text("Are you sure? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("No, Keep it", style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // --- TODO: TRIGGER CONTROLLER HERE ---
              // ref.read(bookingControllerProvider.notifier).cancelBooking(bookingId);
              
              // For now, simulate feedback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Booking cancelled successfully"),
                  backgroundColor: AppColors.secondary,
                ),
              );
              Navigator.pop(context); // Go back to list
            },
            child: const Text("Yes, Cancel", style: TextStyle(color: AppColors.destructive, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute $amPm";
  }
}

// --- HELPER WIDGETS ---

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case BookingStatus.confirmed:
        color = AppColors.success;
        text = "CONFIRMED";
        break;
      case BookingStatus.pending:
        color = AppColors.warning;
        text = "PENDING";
        break;
      case BookingStatus.cancelled:
        color = AppColors.destructive;
        text = "CANCELLED";
        break;
      case BookingStatus.completed:
        color = AppColors.textSecondary;
        text = "COMPLETED";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}