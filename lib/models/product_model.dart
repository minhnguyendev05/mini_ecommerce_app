class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      price: (json['price'] ?? 0).toDouble(),
      description: (json['description'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      rating: json['rating'] == null
          ? null
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating?.toJson(),
    };
  }
}

class Rating {
  const Rating({required this.rate, required this.count});

  final double rate;
  final int count;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] ?? 0).toDouble(),
      count: (json['count'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
