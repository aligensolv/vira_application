import '../../../../core/config/app_colors.dart';
import 'package:flutter/material.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

class Booking {
  final int id;
  final String placeName; // Flattened for UI
  final String region;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.placeName,
    required this.region,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  // Helper for UI Colors
  Color get statusColor {
    switch (status) {
      case BookingStatus.confirmed: return AppColors.success;
      case BookingStatus.pending: return AppColors.warning;
      case BookingStatus.cancelled: return AppColors.destructive;
      case BookingStatus.completed: return AppColors.secondary;
    }
  }

  String get statusLabel => status.name.toUpperCase();
}