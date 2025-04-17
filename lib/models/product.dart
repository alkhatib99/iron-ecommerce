class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String material;
  final String grade;
  final String imageUrl;
  final Map<String, dynamic> dimensions;
  final bool inStock;
  final String createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.material,
    required this.grade,
    required this.imageUrl,
    required this.dimensions,
    required this.inStock,
    required this.createdAt,
  });

  // Factory constructor to create a Product from a Map (e.g., from Firestore)
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      unit: map['unit'] ?? 'piece',
      category: map['category'] ?? '',
      material: map['material'] ?? '',
      grade: map['grade'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      dimensions: map['dimensions'] ?? {},
      inStock: map['inStock'] ?? true,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is DateTime
              ? map['createdAt']
              : DateTime.fromMillisecondsSinceEpoch(
                  map['createdAt'].millisecondsSinceEpoch))
          : DateTime.now(),
    );
  }

  // Convert Product to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'material': material,
      'grade': grade,
      'imageUrl': imageUrl,
      'dimensions': dimensions,
      'inStock': inStock,
      'createdAt': createdAt,
    };
  }

  // Convert fronJson to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0.0,
      unit: json['unit'] ?? '',
      category: json['category'] ?? '',
      material: json['material'] ?? '',
      grade: json['grade'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      dimensions: json['dimensions'] ?? {},
      inStock: json['inStock'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? '').toString(),
    );
  }
}
