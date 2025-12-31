import 'package:vira/features/region/data/models/region.dart';

class Place {
  final int id;
  final String name;
  final Region? region;
  final double pricePerHour;
  final int minDurationMinutes;
  final bool isActive;
  final String? description; // Optional for details
  final List<String> amenities;

  Place({
    required this.id,
    required this.name,
    this.region,
    required this.pricePerHour,
    required this.minDurationMinutes,
    this.isActive = true,
    this.description,
    this.amenities = const ["Free Wifi", "Coffee", "Power Outlet", "Whiteboard"],
  });

  // Factory for API (Placeholder)
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      pricePerHour: double.parse(json['price_per_hour'].toString()),
      minDurationMinutes: json['min_duration_min'],
      isActive: json['is_active'] ?? true,
    );
  }
}