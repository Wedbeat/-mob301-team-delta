import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'cart_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color accentColor = Color(0xFFE94560);
  static const Color bgColor = Color(0xFFF5F5F5);

  final List<Map<String, String>> _products = const [
    {
      'name': 'iPhone 15 Pro',
      'price': '\$999',
      'rating': '4.8',
      'image': 'assets/images/images1.jpg',
    },
    {
      'name': 'Nike Air Max',
      'price': '\$120',
      'rating': '4.6',
      'image': 'assets/images/images2.png',
    },
    {
      'name': 'MacBook Pro',
      'price': '\$1299',
      'rating': '4.9',
      'image': 'assets/images/images3.jpg',
    },
    {
      'name': 'AirPods Pro',
      'price': '\$249',
      'rating': '4.7',
      'image': 'assets/images/images4.jpg',
    },
  ];

  Future<void> _openCart() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );
  }

  void _addToCart(Map<String, String> product) {
    final price = double.tryParse(
          product['price']!.replaceAll('\$', '').trim(),
        ) ??
        0;

    CartManager.addItem(
      name: product['name']!,
      image: product['image']!,
      price: price,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} ajouté au panier'),
        backgroundColor: accentColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartManager.notifier,
      builder: (context, items, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Ti Mache Lakay',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: primaryColor),
                onPressed: () {},
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: primaryColor,
                    ),
                    onPressed: _openCart,
                  ),
                  if (CartManager.count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          CartManager.count > 99
                              ? '99+'
                              : '${CartManager.count}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(),
                _buildSectionTitle('Catégories'),
                _buildCategories(),
                _buildSectionTitle('Produits Populaires'),
                _buildProductGrid(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [primaryColor, accentColor],
        ),
      ),
      child: const Center(
        child: Text(
          'Soldes d\'Été 🔥\nJusqu\'à 50% de réduction',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.phone_android, 'label': 'Téléphones'},
      {'icon': Icons.checkroom, 'label': 'Vêtements'},
      {'icon': Icons.laptop, 'label': 'Laptops'},
      {'icon': Icons.chair, 'label': 'Maison'},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 74,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  categories[index]['label'] as String,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) => _buildProductCard(index),
    );
  }

  Widget _buildProductCard(int index) {
    final product = _products[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              product['image']!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported_outlined);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  product['name']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product['price']!,
                  style: const TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => _addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                    child: const Text(
                      'Ajouter',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}