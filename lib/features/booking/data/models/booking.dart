import 'package:flutter/material.dart';
import 'package:vira/features/places/data/models/place.dart';
import 'package:vira/features/region/data/models/region.dart';
import '../../../../core/config/app_colors.dart';
enum BookingStatus { initial, active, cancelled, completed }

class Booking {
  final int id;
  final int userId;
  final int placeId;

  final DateTime startTime;
  final DateTime endTime;

  final int requestedDurationMinutes;
  final int actualDurationMinutes;

  final double pricePerHour;
  final double totalPrice;

  final BookingStatus status;

  final Payment? payment;
  final List<BookingExtension> extensions;

  final Place place;

  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.startTime,
    required this.endTime,
    required this.requestedDurationMinutes,
    required this.actualDurationMinutes,
    required this.pricePerHour,
    required this.totalPrice,
    required this.status,
    this.payment,
    this.extensions = const [],
    required this.place,
    required this.createdAt,
    required this.updatedAt,
  });

  Color get statusColor {
    switch (status) {
      case BookingStatus.active:
        return AppColors.success;
      case BookingStatus.initial:
        return AppColors.secondary;
      case BookingStatus.cancelled:
        return AppColors.destructive;
      case BookingStatus.completed:
        return AppColors.success;
    }
  }

  String get statusLabel {
    switch (status) {
      case BookingStatus.active:
        return "ACTIVE";
      case BookingStatus.initial:
        return "NOT ACTIVE";
      case BookingStatus.cancelled:
        return "CANCELLED";
      case BookingStatus.completed:
        return "COMPLETED";
    }
  }

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as int,
        userId: json['user_id'] as int,
        placeId: json['place_id'] as int,
        startTime: DateTime.parse(json['start_time'] as String).toLocal(),
        endTime: DateTime.parse(json['end_time'] as String).toLocal(),
        requestedDurationMinutes: json['requested_duration_minutes'] as int,
        actualDurationMinutes: json['actual_duration_minutes'] as int,
        pricePerHour: double.parse(json['price_per_hour']),
        totalPrice: double.parse(json['total_price']),
        status: BookingStatus.values.byName((json['status'] as String).toLowerCase()),
        payment: json['payment'] != null
            ? Payment.fromJson(json['payment'])
            : null,
        extensions: json['extensions'] != null
            ? (json['extensions'] as List)
                .map((e) => BookingExtension.fromJson(e))
                .toList()
            : [],
        place: Place.fromJson(json['place']),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}



class Payment {
  final int id;
  final int bookingId;
  final int userId;
  final double amount;
  final DateTime paidAt;
  final String status; // PENDING, PAID, REFUNDED
  final String? method;

  Payment({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.paidAt,
    required this.status,
    this.method,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'] as int,
        bookingId: json['booking_id'] as int,
        userId: json['user_id'] as int,
        amount: double.parse(json['amount']),
        paidAt: DateTime.parse(json['paid_at'] as String),
        status: json['status'] as String,
        method: json['method'] as String?,
      );
}


class BookingExtension {
  final int id;
  final int bookingId;
  final int fromMinutes;
  final int toMinutes;
  final DateTime oldEndTime;
  final DateTime newEndTime;
  final double priceBefore;
  final double priceAfter;

  BookingExtension({
    required this.id,
    required this.bookingId,
    required this.fromMinutes,
    required this.toMinutes,
    required this.oldEndTime,
    required this.newEndTime,
    required this.priceBefore,
    required this.priceAfter,
  });

  factory BookingExtension.fromJson(Map<String, dynamic> json) =>
      BookingExtension(
        id: json['id'] as int,
        bookingId: json['booking_id'] as int,
        fromMinutes: json['from_minutes'] as int,
        toMinutes: json['to_minutes'] as int,
        oldEndTime: DateTime.parse(json['old_end_time'] as String),
        newEndTime: DateTime.parse(json['new_end_time'] as String),
        priceBefore: double.parse(json['price_before']),
        priceAfter: double.parse(json['price_after']),
      );
}
