import 'package:auto_size_text/auto_size_text.dart'; // Ensure this is in pubspec.yaml
import 'package:flutter/material.dart';
import 'package:vira/core/widgets/ui/app_card.dart';
import 'package:vira/features/booking/presentation/widgets/booking_bottom_sheet.dart';
import 'package:vira/features/places/data/models/place.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    // Formatting helpers
    final regionName = (place.region?.name ?? 'Unknown').toUpperCase();
    final priceStr = "\$${place.pricePerHour.toStringAsFixed(2)}";
    final minDurationStr = "${place.minDurationMinutes} Mins";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("SPOT DETAILS"),
        elevation: 0,
        leading: InkWell(
          child: const Icon(Icons.close, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // 1. THE "PERMIT" CARD
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Stack(
                    children: [
                      // Watermark Background
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          Icons.local_parking,
                          size: 180,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Region
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "ZONE / DISTRICT",
                                  style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: AppColors.primary,
                                  child: Text(
                                    (place.region?.name ?? 'unknown').toUpperCase(),
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Spot ID (Updated: AutoSizeText + Smaller)
                            const Text(
                              "SPOT NAME",
                              style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                            const SizedBox(height: 4),
                            AutoSizeText(
                              place.name, 
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24, // Reduced from 40
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. KEY STATS GRID
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: "HOURLY RATE",
                        value: priceStr,
                        // icon: Icons.attach_money,
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatBox(
                        label: "MIN DURATION",
                        value: minDurationStr,
                        // icon: Icons.timer_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 3. LOCATION PREVIEW
                const Text(
                  "LOCATION",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(child: CustomPaint(painter: _GridPainter())),
                      const Icon(Icons.location_on, size: 40, color: AppColors.primary),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          color: Colors.white,
                          child: const Icon(Icons.directions, size: 20, color: AppColors.secondary),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 4. FEATURES GRID (Refactored)
                const Text(
                  "FEATURES",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),
                
                GridView.count(
                  crossAxisCount: 3, // 2 Columns
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2, // Wide tiles
                  children: const [
                    _FeatureTile(icon: Icons.videocam_outlined, label: "CCTV 24/7"),
                    _FeatureTile(icon: Icons.electric_car_outlined, label: "EV Support"),
                    _FeatureTile(icon: Icons.lightbulb_outlined, label: "Good Lighting"),
                    _FeatureTile(icon: Icons.accessible_outlined, label: "Accessible"),
                    _FeatureTile(icon: Icons.wc_outlined, label: "Toilet"),
                    _FeatureTile(icon: Icons.wifi_outlined, label: "Free Wi-Fi"),
                  ],
                ),

                const SizedBox(height: 32),

                // 5. DESCRIPTION (Wrapped in Card)
                const Text(
                  "PARKING DETAILS",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),
                AppCard(
                  // width: double.infinity,
                  child: Text(
                    place.description ?? 
                    "This spot is located in a secured zone. Use the QR code generated after booking to enter the gate. Please ensure you park exactly within the lines of ${place.name}.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. STICKY BOTTOM BAR (Full Width Button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -3)),
                ],
              ),
              child: SafeArea(
                child: AppButton(
                  text: "RESERVE SPOT",
                  type: ButtonType.primary,
                  isFullWidth: true, // Takes full width
                  onPressed: () => _showBookingModal(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        return BookingBottomSheet(place: place);
      },
    );
  }
}

// --- HELPER WIDGETS ---

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  // final IconData icon;
  final bool isPrimary;

  const _StatBox({
    required this.label,
    required this.value,
    // required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon(icon, size: 20, color: isPrimary ? AppColors.primary : AppColors.textSecondary),
          // const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isPrimary ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: AppColors.secondary),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}