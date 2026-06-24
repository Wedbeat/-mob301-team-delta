import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ── Done imaj lokal yo ak non fichye reyèl yo ──
  static const List<Map<String, String>> _products = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'ShopApp',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF1A1A2E),
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE94560),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
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
  }

  // ════════════════════════════════════════════
  //  BANNER
  // ════════════════════════════════════════════
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFFE94560)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Soldes d\'Été 🔥',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Jusqu\'à 50% de réduction',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  TITRE SEKSYON
  // ════════════════════════════════════════════
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Voir tout',
              style: TextStyle(color: Color(0xFFE94560)),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  KATEGORIS
  // ════════════════════════════════════════════
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
            width: 70,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    color: const Color(0xFFE94560),
                    size: 24,
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

  // ════════════════════════════════════════════
  //  GRIY PWODUI
  // ════════════════════════════════════════════
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) => _buildProductCard(index),
    );
  }

  // ════════════════════════════════════════════
  //  KAT PWODUI avèk imaj lokal
  // ════════════════════════════════════════════
  Widget _buildProductCard(int index) {
    final product = _products[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Imaj pwodui ──
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                product['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
                // Si imaj pa jwenn, afiche ikòn pito
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF0F0F0),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Info pwodui ──
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['price']!,
                      style: const TextStyle(
                        color: Color(0xFFE94560),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          product['rating']!,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
