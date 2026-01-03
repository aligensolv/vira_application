import 'package:flutter/material.dart';
import 'package:vira/features/places/data/models/place.dart';
import 'package:vira/features/places/presentation/screens/place_details_screen.dart';
import 'package:vira/features/places/presentation/widgets/place_list_tile.dart';
import '../../../../core/config/app_colors.dart';


class PlaceSearchDelegate extends SearchDelegate {
  final List<Place> places;

  PlaceSearchDelegate({required this.places})
      : super(
          searchFieldLabel: "Search ID, Zone, or Street...",
          searchFieldStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );

  // 1. Theme Overrides to match Vira Design
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  // 2. Clear Button
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: AppColors.secondary),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  // 3. Back Button
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
      onPressed: () => close(context, null),
    );
  }

  // 4. Results (When user hits enter, but we will make it live)
  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  // 5. Suggestions (Live typing)
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    // Filter Logic
    final results = places.where((place) {
      final q = query.toLowerCase();
      return place.name.toLowerCase().contains(q) ||
             (place.region?.name ?? 'unknown').toLowerCase().contains(q) ||
             place.id.toString().contains(q);
    }).toList();

    // BACKGROUND COLOR
    return Container(
      color: AppColors.background, // Light Grey Background
      child: query.isEmpty
          ? _buildEmptyState(context) // Show something when empty
          : results.isEmpty
              ? _buildNoResults()
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final place = results[index];
                    return PlaceListTile(
                      name: place.name,
                      region: place.region?.name ?? 'unknown',
                      price: place.pricePerHour.toStringAsFixed(0),
                      minDuration: place.minDurationMinutes.toString(),
                      // Example logic for EV tag
                      onTap: () {
                        // Close search and nav
                        close(context, null); 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailsScreen(placeId: place.id),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  // Initial State (Before typing)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: AppColors.secondary.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            "FIND YOUR SPOT",
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // No Matches
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_crash_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          const Text(
            "NO PARKING FOUND",
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try searching for a different zone ID.",
            style: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}