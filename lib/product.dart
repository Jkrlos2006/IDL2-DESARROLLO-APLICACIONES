class Product {
  final String id;
  final String slug;
  final String name;
  final String description;
  final double price;
  final int stock;

  Product(
      {required this.id,
      required this.slug,
      required this.name,
      required this.description,
      required this.price,
      required this.stock});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }
}
