class Category {
  final String id;
  final String name;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.description,
  });

  // Factory constructor to create a Category from a Map (e.g., from Firestore)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // Convert Category to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  //from json
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
