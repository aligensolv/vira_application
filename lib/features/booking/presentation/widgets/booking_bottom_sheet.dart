import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/application/booking_control.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../../../../features/places/data/models/place.dart';
import '../screens/booking_confirmation_screen.dart';

class BookingBottomSheet extends ConsumerStatefulWidget {
  final Place place;

  const BookingBottomSheet({super.key, required this.place});

  @override
  ConsumerState<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends ConsumerState<BookingBottomSheet> {
  late TextEditingController _hoursCtrl;
  late TextEditingController _minsCtrl;

  @override
  void initState() {
    super.initState();
    final minMins = widget.place.minDurationMinutes;
    // Default to min duration if no state exists, or existing state
    _hoursCtrl = TextEditingController(text: (minMins ~/ 60).toString());
    _minsCtrl = TextEditingController(text: (minMins % 60).toString());
  }

  @override
  void dispose() {
    _hoursCtrl.dispose();
    _minsCtrl.dispose();
    super.dispose();
  }

  void _onDurationChanged() {
    final h = int.tryParse(_hoursCtrl.text) ?? 0;
    final m = int.tryParse(_minsCtrl.text) ?? 0;
    int totalMinutes = (h * 60) + m;
    
    // Update logic
    ref.read(bookingControllerProvider(widget.place).notifier).setDuration(totalMinutes);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingControllerProvider(widget.place));
    final controller = ref.read(bookingControllerProvider(widget.place).notifier);

    // Helpers
    final startTimeStr = "${state.startTime.hour}:${state.startTime.minute.toString().padLeft(2, '0')}";
    final endTimeStr = "${state.endTime.hour}:${state.endTime.minute.toString().padLeft(2, '0')}";
    final isValidDuration = state.durationMinutes >= widget.place.minDurationMinutes;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      height: 620, 
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero, 
          topRight: Radius.zero
        ), // Squared
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "BOOKING DETAILS",
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
          
          const SizedBox(height: 20),

          // 2. Start Time Section
          const Text("START TIME", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SelectionTile(
                  label: "NOW",
                  value: "Start Immediately",
                  isSelected: _isNow(state.startTime),
                  onTap: () => controller.setStartTime(DateTime.now()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SelectionTile(
                  label: "LATER",
                  value: startTimeStr,
                  isSelected: !_isNow(state.startTime),
                  icon: Icons.edit_calendar,
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      confirmText: "SET TIME",
                      cancelText: "CANCEL",
                      initialEntryMode: TimePickerEntryMode.input,
                      helpText: "SELECT BOOKING TIME",


                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.secondary,
                              onPrimary: AppColors.primary,
                              onSurface: AppColors.secondary,
                              tertiary: AppColors.secondary,
                              onTertiary: Colors.white,
                            ),                            
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      final now = DateTime.now();
                      final selected = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                      controller.setStartTime(selected);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 3. Duration Input (Digital Counter Style)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("DURATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary)),
              if (!isValidDuration)
                Text(
                  "Min ${widget.place.minDurationMinutes}m required",
                  style: const TextStyle(fontSize: 11, color: AppColors.destructive, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DigitalInput(
                  controller: _hoursCtrl,
                  label: "HOURS",
                  onChanged: (_) => _onDurationChanged(),
                ),
              ),
              const SizedBox(width: 16),
              const Text(":", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.secondary)),
              const SizedBox(width: 16),
              Expanded(
                child: _DigitalInput(
                  controller: _minsCtrl,
                  label: "MINUTES",
                  onChanged: (_) => _onDurationChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Parking ends at $endTimeStr",
              style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),

          const Spacer(),

          // 4. Ticket Total Card
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.secondary, // Dark
                  // Squared
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashed Line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(20, (index) => Container(
                        width: 3, height: 1, color: Colors.white54,
                      )),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ESTIMATED TOTAL",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${state.durationMinutes}m × \$${widget.place.pricePerHour.toStringAsFixed(0)}/hr",
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          "\$${state.estimatedPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Decorative Cutouts to mimic ticket holes
              Positioned(
                left: -10,
                top: 24, // Align with dashed line
                child: Container(
                  height: 20, width: 20,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
              Positioned(
                right: -10,
                top: 24,
                child: Container(
                  height: 20, width: 20,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ],
          ),

          SafeArea(
            child: AppButton(
              text: "PROCEED TO CHECKOUT",
              type: ButtonType.primary,
              onPressed: isValidDuration ? () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingConfirmationScreen(place: widget.place, bookingState: state),
                  ),
                );
              } : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool _isNow(DateTime time) => DateTime.now().difference(time).inMinutes.abs() < 2;
}

// --- DIGITAL INPUT WIDGET ---
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
            color: AppColors.background, // Light Grey
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
              fontWeight: FontWeight.w900, // Thick font for digital look
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

// --- SELECTION TILE WIDGET ---
class _SelectionTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const _SelectionTile({required this.label, required this.value, required this.isSelected, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.white,
          border: Border.all(color: isSelected ? AppColors.secondary : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10, 
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white54 : AppColors.textSecondary
                  ),
                ),
                if (icon != null) Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 13, 
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary
              ),
            ),
          ],
        ),
      ),
    );
  }
}