class UserMetrics {
  final int totalBookings;
  final int totalDurationMinutes;

  UserMetrics({
    required this.totalBookings,
    required this.totalDurationMinutes,
  });

  factory UserMetrics.fromJson(Map<String, dynamic> json) {
    return UserMetrics(
      totalBookings: json['totalBookings'] ?? 0,
      totalDurationMinutes: json['totalDuration'] ?? 0,
    );
  }
}