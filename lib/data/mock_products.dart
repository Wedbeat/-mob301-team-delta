import '../model/product_model.dart';

final List<ProductModel> mockProducts =
    _rawProducts.map((map) => ProductModel.fromMap(map)).toList();

List<ProductModel> getProductsByCategory(String category) {
  return mockProducts.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
}

List<ProductModel> getPromoProducts() {
  return mockProducts.where((p) => p.discount >= 30).toList();
}

List<ProductModel> getFlashSaleProducts() {
  return mockProducts.where((p) => p.tag?.toLowerCase() == 'flash sale').toList();
}

List<ProductModel> searchProducts(String query) {
  final q = query.toLowerCase();
  return mockProducts.where((p) {
    return p.name.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q) ||
        (p.tag ?? '').toLowerCase().contains(q);
  }).toList();
}

List<ProductModel> getSimilarProducts(ProductModel product) {
  return mockProducts
      .where((p) => p.category == product.category && p.id != product.id)
      .take(6)
      .toList();
}

const List<Map<String, dynamic>> _rawProducts = [
  {
    'id': 'iphone-15-pro',
    'name': 'iPhone 15 Pro',
    'price': 999.0,
    'oldPrice': 1199.0,
    'rating': '4.8',
    'sold': '10k+',
    'discount': 17,
    'image': 'assets/images/images1.jpg',
    'tag': 'Bestseller',
    'category': 'Téléphones',
    'description':
        'Dènye modèl iPhone la ak puce A17 Pro, kamera 48MP trè pwisan, ak design titàn elégan. Ekran Super Retina XDR 6.1 pouces, batri ki dire tout jounen, ak USB-C pou premye fwa.',
    'images': ['assets/images/images1.jpg', 'assets/images/images2.png', 'assets/images/images3.jpg'],
    'sizes': ['128GB', '256GB', '512GB', '1TB'],
    'colors': ['Noir Titane', 'Blanc Titane', 'Bleu Titane', 'Naturel'],
    'reviewCount': 2847,
  },
  {
    'id': 'nike-air-max-270',
    'name': 'Nike Air Max 270',
    'price': 120.0,
    'oldPrice': 180.0,
    'rating': '4.6',
    'sold': '5k+',
    'discount': 33,
    'image': 'assets/images/images2.png',
    'tag': 'Flash Sale',
    'category': 'Sport',
    'description':
        'Soulye espò konfo ak teknoloji Air Max 270 pou tout jounen. Semèl ki absòbe chòk, materyèl mesh ki respire, ak design modèn.',
    'images': ['assets/images/images2.png', 'assets/images/images1.jpg'],
    'sizes': ['38', '39', '40', '41', '42', '43', '44'],
    'colors': ['Noir', 'Blanc', 'Rouge', 'Bleu'],
    'reviewCount': 1523,
  },
  {
    'id': 'macbook-pro-m3',
    'name': 'MacBook Pro M3',
    'price': 1299.0,
    'oldPrice': 1599.0,
    'rating': '4.9',
    'sold': '3k+',
    'discount': 19,
    'image': 'assets/images/images3.jpg',
    'tag': null,
    'category': 'Laptops',
    'description':
        'MacBook Pro ak puce M3 pou pèfòmans maksimòm. Ekran Liquid Retina XDR, batri 22 è, ak performance inegalab pou travay kreyatif.',
    'images': ['assets/images/images3.jpg', 'assets/images/images4.jpg'],
    'sizes': ['14 pouces', '16 pouces'],
    'colors': ['Gri Sideral', 'Argent'],
    'reviewCount': 956,
  },
  {
    'id': 'airpods-pro-2',
    'name': 'AirPods Pro 2',
    'price': 249.0,
    'oldPrice': 329.0,
    'rating': '4.7',
    'sold': '8k+',
    'discount': 24,
    'image': 'assets/images/images4.jpg',
    'tag': 'Hot',
    'category': 'Téléphones',
    'description':
        'Ekoutè san fil ak anilasyon bri aktif 2x pi bon, son espasyal pèsonalize, ak rezistans pousyè ak dlo IP54.',
    'images': ['assets/images/images4.jpg', 'assets/images/images1.jpg'],
    'colors': ['Blanc'],
    'reviewCount': 4231,
  },
  {
    'id': 'samsung-tv-55',
    'name': 'Samsung TV 55"',
    'price': 599.0,
    'oldPrice': 899.0,
    'rating': '4.5',
    'sold': '2k+',
    'discount': 33,
    'image': 'assets/images/images11.jpg',
    'tag': null,
    'category': 'Maison',
    'description':
        'Televizyon 4K UHD Crystal ak Smart TV Tizen entegre. Pwosesè Crystal 4K, HDR, ak son Dolby Digital Plus.',
    'images': ['assets/images/images1.jpg'],
    'sizes': ['55 pouces', '65 pouces', '75 pouces'],
    'colors': ['Noir'],
    'reviewCount': 678,
  },
  {
    'id': 'adidas-ultraboost',
    'name': 'Adidas Ultraboost',
    'price': 89.0,
    'oldPrice': 150.0,
    'rating': '4.7',
    'sold': '6k+',
    'discount': 41,
    'image': 'assets/images/images12.png',
    'tag': 'Sale',
    'category': 'Sport',
    'description':
        'Soulye kous Ultraboost ak Boost pou retou enèji maksimòm. Primeknit ki adapte ak pye ou, semèl Continental™ Rubber.',
    'images': ['assets/images/images2.png', 'assets/images/images3.jpg'],
    'sizes': ['38', '39', '40', '41', '42', '43'],
    'colors': ['Noir', 'Blanc', 'Gri'],
    'reviewCount': 2156,
  },
  {
    'id': 'samsung-galaxy-s24',
    'name': 'Samsung Galaxy S24',
    'price': 849.0,
    'oldPrice': 999.0,
    'rating': '4.7',
    'sold': '7k+',
    'discount': 15,
    'image': 'assets/images/images10.jpg',
    'tag': 'New',
    'category': 'Téléphones',
    'description':
        'Dènye Samsung ak Galaxy AI entegre. Kamera 200MP, ekran Dynamic AMOLED 2X, ak batri 4000mAh.',
    'images': ['assets/images/images3.jpg', 'assets/images/images4.jpg'],
    'sizes': ['128GB', '256GB', '512GB'],
    'colors': ['Noir', 'Violet', 'Jaune', 'Gri'],
    'reviewCount': 1834,
  },
  {
    'id': 'robe-ete-floral',
    'name': 'Robe Été Floral',
    'price': 35.0,
    'oldPrice': 65.0,
    'rating': '4.4',
    'sold': '12k+',
    'discount': 46,
    'image': 'assets/images/images5.jpg',
    'tag': 'Flash Sale',
    'category': 'Vêtements',
    'description':
        'Wòb lete ak motif floral, leje ak konfo. Tisi ki respire, ideyal pou plaj ak soti.',
    'images': ['assets/images/images4.jpg', 'assets/images/images1.jpg'],
    'sizes': ['S', 'M', 'L', 'XL'],
    'colors': ['Rose', 'Bleu', 'Vert', 'Jaune'],
    'reviewCount': 3567,
  },
  {
    'id': 'canape-moderne',
    'name': 'Canapé Moderne',
    'price': 450.0,
    'oldPrice': 750.0,
    'rating': '4.6',
    'sold': '1k+',
    'discount': 40,
    'image': 'assets/images/images6.jpg',
    'tag': null,
    'category': 'Maison',
    'description':
        'Kanape modèn 3 plas pou salon ou. Remouraj moeleux, estrikti bwa solid, ak ousi detachab.',
    'images': ['assets/images/images1.jpg', 'assets/images/images2.png'],
    'colors': ['Gri', 'Beige', 'Bleu Marin'],
    'reviewCount': 423,
  },
  {
    'id': 'parfum-elegance',
    'name': 'Parfum Élégance',
    'price': 65.0,
    'oldPrice': 95.0,
    'rating': '4.8',
    'sold': '9k+',
    'discount': 32,
    'image': 'assets/images/images15.png',
    'tag': 'Hot',
    'category': 'Beauté',
    'description':
        'Pafen liks pou fanm elegans. Nòt tèt: bergamote ak jasmen. Nòt kè: roz ak iris. Nòt baz: misk ak bwa sandal.',
    'images': ['assets/images/images2.png'],
    'sizes': ['30ml', '50ml', '100ml'],
    'colors': ['Or', 'Rose'],
    'reviewCount': 1876,
  },
  {
    'id': 'tshirt-coton-bio',
    'name': 'T-Shirt Coton Bio',
    'price': 22.0,
    'oldPrice': 40.0,
    'rating': '4.3',
    'sold': '15k+',
    'discount': 45,
    'image': 'assets/images/images8.jpg',
    'tag': 'Sale',
    'category': 'Vêtements',
    'description':
        'T-shirt koton biyolojik 100%, dous sou po ou. Kouti doubleman ranfòse, pa retresi nan lavaj.',
    'images': ['assets/images/images3.jpg', 'assets/images/images4.jpg'],
    'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
    'colors': ['Blanc', 'Noir', 'Gri', 'Bleu Navy', 'Vert Olive'],
    'reviewCount': 5234,
  },
  {
    'id': 'ballon-football-pro',
    'name': 'Ballon Football Pro',
    'price': 30.0,
    'oldPrice': 55.0,
    'rating': '4.5',
    'sold': '4k+',
    'discount': 45,
    'image': 'assets/images/images9.jpg',
    'tag': null,
    'category': 'Sport',
    'description':
        'Balon foutbòl pwofesyonèl FIFA Quality Pro. Panèl termosoude, vejiga latex, ak grip siperyè.',
    'images': ['assets/images/images4.jpg'],
    'sizes': ['Taille 4', 'Taille 5'],
    'colors': ['Blanc/Noir', 'Jaune/Bleu'],
    'reviewCount': 892,
  },
];