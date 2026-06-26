class ProductModel {
  final String id;
  final String name;
  final double price;
  final double oldPrice;
  final String rating;
  final String sold;
  final int discount;
  final String image;
  final String? tag;
  final String category;
  final String description;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final bool inStock;
  final int reviewCount;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.sold,
    required this.discount,
    required this.image,
    this.tag,
    required this.category,
    this.description = '',
    this.images = const [],
    this.sizes = const [],
    this.colors = const [],
    this.inStock = true,
    this.reviewCount = 0,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final id = map['id'] as String? ??
        (map['name'] as String).toLowerCase().replaceAll(' ', '-');
    return ProductModel(
      id: id,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      oldPrice: (map['oldPrice'] as num).toDouble(),
      rating: map['rating'] as String,
      sold: map['sold'] as String,
      discount: map['discount'] as int,
      image: map['image'] as String,
      tag: map['tag'] as String?,
      category: map['category'] as String? ?? 'Jeneral',
      description: map['description'] as String? ?? '',
      images: List<String>.from(map['images'] ?? [map['image']]),
      sizes: List<String>.from(map['sizes'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      inStock: map['inStock'] as bool? ?? true,
      reviewCount: map['reviewCount'] as int? ?? 0,
    );
  }
}