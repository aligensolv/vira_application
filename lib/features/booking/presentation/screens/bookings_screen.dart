import 'package:flutter/material.dart';
import 'package:vira/features/booking/data/models/booking.dart';
import 'package:vira/features/booking/presentation/screens/booking_details_screen.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_button.dart';
import '../widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _tabIndex = 0; // 0 = Upcoming, 1 = History

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final upcomingList = [
      Booking(
        id: 101,
        placeName: "Central Garage - A12",
        region: "Downtown",
        startTime: DateTime.now().add(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 3)),
        totalPrice: 20.00,
        status: BookingStatus.confirmed,
      ),
      Booking(
        id: 102,
        placeName: "Plaza Parking #4",
        region: "Maadi",
        startTime: DateTime.now().add(const Duration(days: 2)),
        endTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
        totalPrice: 40.00,
        status: BookingStatus.pending,
      ),
    ];

    final historyList = [
      Booking(
        id: 88,
        placeName: "Zamalek Tower",
        region: "Zamalek",
        startTime: DateTime.now().subtract(const Duration(days: 5)),
        endTime: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
        totalPrice: 50.00,
        status: BookingStatus.completed,
      ),
      Booking(
        id: 85,
        placeName: "Nasr City Hub",
        region: "Nasr City",
        startTime: DateTime.now().subtract(const Duration(days: 10)),
        endTime: DateTime.now().subtract(const Duration(days: 10, hours: 1)),
        totalPrice: 15.00,
        status: BookingStatus.cancelled,
      ),
    ];

    final currentList = _tabIndex == 0 ? upcomingList : historyList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "MY BOOKINGS",
        ),
      ),
      body: Column(
        children: [
          // 1. Custom Tabs
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(child: _TabButton(label: "Upcoming", isSelected: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0))),
                Expanded(child: _TabButton(label: "History", isSelected: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1))),
              ],
            ),
          ),

          // 2. List
          Expanded(
            child: currentList.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
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
                              builder: (_) => BookingDetailsScreen(booking: currentList[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: Icon(Icons.confirmation_number_outlined, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Bookings Found",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary),
          ),
          const SizedBox(height: 8),
          const Text(
            "You haven't made any reservations yet.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
          if (_tabIndex == 0) ...[
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: AppButton(
                text: "Find Parking",
                type: ButtonType.outline,
                onPressed: () {
                  // Navigation logic
                },
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
            fontSize: 13,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}