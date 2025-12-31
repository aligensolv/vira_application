class Region {
  final int id;
  final String name;
  final int placesCount;

  Region({
    required this.id,
    required this.name,
    this.placesCount = 0,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      placesCount: json['places_count'] ?? 0,
    );
  }
}