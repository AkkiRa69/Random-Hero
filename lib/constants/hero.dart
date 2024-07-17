// constants/hero.dart
class HeroData {
  final String key;
  final String name;
  final String heroid;

  HeroData({required this.key, required this.name, required this.heroid});

  factory HeroData.fromJson(Map<String, dynamic> json) {
    return HeroData(
      key: json['key'] ?? '', // Handle null case
      name: json['name'] ?? 'Unknown', // Handle null case
      heroid: json['heroid'] ?? '', // Handle null case
    );
  }
}
