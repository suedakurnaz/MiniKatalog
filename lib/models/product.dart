class Product {
  final int id;
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;
  final double rating;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.rating,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double ratingValue = 0.0;
    if (json['rating'] is Map) {
      ratingValue = (json['rating']['rate'] ?? 0).toDouble();
    } else if (json['rating'] is num) {
      ratingValue = (json['rating'] as num).toDouble();
    }

    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['thumbnail'] ?? json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      rating: ratingValue,
      stock: json['stock'] ?? 99,
    );
  }
}
