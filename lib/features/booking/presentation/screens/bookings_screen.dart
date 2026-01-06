import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/features/booking/application/booking_provider.dart';
import 'package:vira/features/booking/application/booking_realtime_provider.dart';
import 'package:vira/features/booking/data/models/booking.dart';
import 'package:vira/features/booking/presentation/screens/booking_details_screen.dart';
import 'package:vira/features/layout/application/layout_provider.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../widgets/booking_card.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  // 0 = Current, 1 = Completed, 2 = Cancelled
  int _tabIndex = 0; 

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(myBookingsProvider);
    ref.watch(bookingRealtimeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("MY BOOKINGS"),
      ),
      body: Column(
        children: [
          // 1. Custom Tabs (3 Tabs)
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: "Current", 
                    isSelected: _tabIndex == 0, 
                    onTap: () => setState(() => _tabIndex = 0),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: "Completed", 
                    isSelected: _tabIndex == 1, 
                    onTap: () => setState(() => _tabIndex = 1),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: "Cancelled", 
                    isSelected: _tabIndex == 2, 
                    onTap: () => setState(() => _tabIndex = 2),
                  ),
                ),
              ],
            ),
          ),

          // 2. Data List
          Expanded(
            child: bookingsAsync.when(
              // LOADING
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              ),
              
              // ERROR
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.destructive),
                    const SizedBox(height: 16),
                    // Text(err.toString()), // Debug only
                    const Text(
                      "Failed to load bookings",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => ref.refresh(myBookingsProvider),
                      child: const Text("Retry", style: TextStyle(color: AppColors.primary)),
                    )
                  ],
                ),
              ),

              // SUCCESS
              data: (allBookings) {
                // Filter Logic based on Tab Index
                List<Booking> currentList;

                if (_tabIndex == 0) {
                  // Current: Initial + Active
                  currentList = allBookings.where((b) => 
                    b.status == BookingStatus.active || 
                    b.status == BookingStatus.initial
                  ).toList();
                } else if (_tabIndex == 1) {
                  // Completed
                  currentList = allBookings.where((b) => 
                    b.status == BookingStatus.completed
                  ).toList();
                } else {
                  // Cancelled
                  currentList = allBookings.where((b) => 
                    b.status == BookingStatus.cancelled
                  ).toList();
                }

                // Empty State
                if (currentList.isEmpty) {
                  return _buildEmptyState();
                }

                // List View
                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(myBookingsProvider),
                  color: AppColors.secondary,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    itemCount: currentList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return BookingCard(
                        booking: currentList[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingDetailsScreen(id: currentList[index].id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    switch (_tabIndex) {
      case 0: message = "You have no active bookings."; break;
      case 1: message = "You haven't completed any bookings yet."; break;
      case 2: message = "No cancelled bookings found."; break;
      default: message = "No bookings found.";
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(Icons.confirmation_number_outlined, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Bookings Found",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          
          // Show "Find Parking" only for Current/Active tab
          ...[
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  SizedBox(
                    width: 140,
                    child: AppButton(
                      text: "Find Parking",
                      type: ButtonType.outline,
                      onPressed: () {
                        ref.watch(bottomNavIndexProvider.notifier).state = 0;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: AppButton(
                      text: "Refresh",
                      icon: Icons.refresh,
                      type: ButtonType.secondary,
                      onPressed: () => ref.refresh(myBookingsProvider),
                    ),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12, // Slightly smaller font to fit 3 items
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}