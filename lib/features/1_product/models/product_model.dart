class ProductModel {
  final int id;
  final String title;
  final String price;
  final String description;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? json['id'] ?? 0,
      title: json['title'] ?? "-",
      description: json['description'] ?? "-",
      imageUrl: json['images']?['jpg']?['image_url'] ?? json['image_url'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
    };
  }
}
