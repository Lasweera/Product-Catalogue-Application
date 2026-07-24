
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'category': category,
      'price': price,
      'description': description,
      'image': imageUrl,
    };
  }
}