import 'package:flutter/material.dart';
import 'package:vira/features/places/data/models/place.dart';
import 'package:vira/features/region/data/models/region.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/widgets/ui/app_input.dart';
import '../widgets/place_list_tile.dart'; // Import New Tile
import 'place_details_screen.dart';

class ExplorePlacesScreen extends StatefulWidget {
  const ExplorePlacesScreen({super.key});

  @override
  State<ExplorePlacesScreen> createState() => _ExplorePlacesScreenState();
}

class _ExplorePlacesScreenState extends State<ExplorePlacesScreen> {
  String _selectedRegion = "All"; // Filter state

  @override
  Widget build(BuildContext context) {
    // Mock Data: Flat list of all places
    final allPlaces = [];

    // Filter Logic
    final displayPlaces = _selectedRegion == "All" 
        ? allPlaces 
        : allPlaces.where((p) => p == _selectedRegion).toList();

    return Scaffold(
      backgroundColor: AppColors.background, // Light grey background makes white cards pop
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("FIND PARKING", style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header & Search (Fixed at top)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          hintText: "Search spot ID...",
                          prefixIcon: Icons.search,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Region Filter Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ["All", "Downtown", "Maadi", "Zamalek", "Nasr City", "Zayed"]
                          .map((region) => _FilterTab(
                                label: region,
                                isSelected: _selectedRegion == region,
                                onTap: () => setState(() => _selectedRegion = region),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16), // Bottom padding of header
                ],
              ),
            ),

            // 2. Results List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: displayPlaces.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final place = displayPlaces[index];
                  return PlaceListTile(
                    name: place.name,
                    region: place.region?.name ?? 'unknown',
                    price: place.pricePerHour.toStringAsFixed(0),
                    minDuration: place.minDurationMinutes.toString(),
                    // Hacky way to pass EV flag via mock
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaceDetailsScreen(place: place),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Place _mockPlace(int id, Region region, double price, {bool isEv = false}) {
    return Place(
      id: id,
      name: "$region Garage ${100+id}",
      region: region,
      pricePerHour: price,
      minDurationMinutes: 60,
    );
  }
}

// --- FILTER TAB WIDGET ---
class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.border
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}