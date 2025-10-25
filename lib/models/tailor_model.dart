class Tailor {
  final String id;
  final String name;
  final String area;
  final String category;
  final String initials;
  final String? imageUrl;

  Tailor({
    required this.id,
    required this.name,
    required this.area,
    required this.category,
    this.imageUrl,
  }) : initials = _computeInitials(name);

  static String _computeInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Factory constructor for creating Tailor from Firestore document
  factory Tailor.fromFirestore(Map<String, dynamic> data, String id) {
    return Tailor(
      id: id,
      name: data['name'] ?? '',
      area: data['area'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  // Convert Tailor to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'area': area,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}

