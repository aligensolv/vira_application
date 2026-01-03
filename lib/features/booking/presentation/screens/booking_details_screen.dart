import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/utils/error_handler.dart';
import 'package:vira/core/widgets/ui/base_dialog.dart';
import 'package:vira/features/booking/application/booking_control.dart';
import 'package:vira/features/booking/application/booking_provider.dart';
import 'package:vira/features/booking/data/models/booking.dart';
import 'package:vira/features/booking/presentation/widgets/extend_booking_sheet.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';

class BookingDetailsScreen extends ConsumerWidget {
  final int id;

  const BookingDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingByIdProvider(id));

    if (booking == null) return Text("Booking not found");
    
    // 1. Time Formatting
    final String dateStr = "${booking.startTime.year}-${booking.startTime.month.toString().padLeft(2, '0')}-${booking.startTime.day.toString().padLeft(2, '0')}";
    final String startStr = _formatTime(booking.startTime);
    final String endStr = _formatTime(booking.endTime);
    final String timeRange = "$startStr - $endStr"; // Fixed: Variable is now defined
    
    // 2. Duration Calculation
    final int totalMinutes = booking.endTime.difference(booking.startTime).inMinutes;
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    final String durationStr = minutes > 0 ? "${hours}h ${minutes}m" : "$hours Hours";

    // 3. Cancellation Rule (Strict: Only before start time)
    // Also check if status is not already cancelled or completed
    final bool isBeforeStart = DateTime.now().isBefore(booking.startTime);
    final bool isActiveStatus = booking.status == BookingStatus.active || booking.status == BookingStatus.initial;
    final bool canCancel = isBeforeStart && isActiveStatus;

    final bool isActive = booking.status == BookingStatus.active;
    // final bool isNotExpired = DateTime.now().isBefore(booking.endTime);
    final bool canExtend = isActive;

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
                _StatusBadge(booking: booking),
              ],
            ),

            const SizedBox(height: 32),

            // --- SECTION 1: PLACE INFO ---
            const _SectionTitle(title: "LOCATION"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  _DetailRow(label: "PLACE", value: booking.place.name),
                  const Divider(height: 1, color: AppColors.border),
                  _DetailRow(label: "REGION", value: booking.place.region?.name ?? 'UNKNOWN'),
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
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    "\$${booking.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
                type: ButtonType.destructiveOutline, // Or specific error style
                isFullWidth: true,
                onPressed: () {
                  _showCancelConfirmation(context, ref, booking);
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

            if (canExtend) ...[
              const SizedBox(height: 16),
              AppButton(
                text: "EXTEND BOOKING",
                type: ButtonType.outline, // Dark button for primary action
                icon: Icons.access_time_outlined,
                isFullWidth: true,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.zero)),
                    builder: (context) => ExtendBookingSheet(booking: booking),
                  );
                },
              ),
            ],
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, WidgetRef ref, Booking booking) {
    showDialog(
      context: context,
      builder: (ctx) => BaseDialog(
        variant: DialogVariant.secondary,
        borderRadius: 0.0,
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cancel Booking?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Are you sure? This action cannot be undone.",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("No, Keep it", style: TextStyle(
                    color: Colors.black
                  ),),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      Navigator.pop(ctx);
                      await ref.read(bookingControllerProvider(booking.place).notifier).cancelBooking(booking.id);
                      ref.refresh(myBookingsProvider);
                      
                      if(context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                          content: Text("Booking cancelled successfully"),
                          backgroundColor: AppColors.secondary,
                          ),
                        );
                        Navigator.pop(context);
                      }

                      

                    } catch (error){
                      ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(DioErrorUtil.getErrorMessage(error as DioException)),
                        backgroundColor: AppColors.destructive,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.destructive,
                  ),
                  child: const Text(
                  "Yes, Cancel",
                  style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
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
  final Booking booking;

  const _StatusBadge({required this.booking});

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: booking.statusColor.withOpacity(0.1),
        border: Border.all(color: booking.statusColor),
      ),
      child: Text(
        booking.statusLabel,
        style: TextStyle(
          color: booking.statusColor,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}