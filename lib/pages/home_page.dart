import 'package:flutter/material.dart';

import '../model/user_model.dart';

// ══════════════════════════════════════════════════════════════
//  HOME SCREEN
//  ✅ Rechèch fonksyonèl
//  ✅ Pwodui pi piti + plis pwodui (12)
//  ✅ Panye a 0
//  ✅ Imaj placeholder pou ekip la mete pa yo
// ══════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  final bool showBottomNav;
  final UserModel? initialUser;

  const HomeScreen({super.key, this.showBottomNav = true, this.initialUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  bool _isLoggedIn = false;
  UserModel? _currentUser;

  // ── Rechèch ──
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  // ══════════════════════════════════════════════
  //  DONE PWODUI — 12 pwodui
  //  Ekip la: mete imaj nan assets/images/ epi
  //  chanje chemen 'image' anba a
  // ══════════════════════════════════════════════
  static const List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'iPhone 15 Pro',
      'price': 999.0,
      'oldPrice': 1199.0,
      'rating': '4.8',
      'sold': '10k+',
      'discount': 17,
      'image': 'assets/images/images1.jpg',
      'tag': 'Bestseller',
      'category': 'Téléphones',
    },
    {
      'name': 'Nike Air Max 270',
      'price': 120.0,
      'oldPrice': 180.0,
      'rating': '4.6',
      'sold': '5k+',
      'discount': 33,
      'image': 'assets/images/images2.png',
      'tag': 'Flash Sale',
      'category': 'Sport',
    },
    {
      'name': 'MacBook Pro M3',
      'price': 1299.0,
      'oldPrice': 1599.0,
      'rating': '4.9',
      'sold': '3k+',
      'discount': 19,
      'image': 'assets/images/images3.jpg',
      'tag': null,
      'category': 'Laptops',
    },
    {
      'name': 'AirPods Pro 2',
      'price': 249.0,
      'oldPrice': 329.0,
      'rating': '4.7',
      'sold': '8k+',
      'discount': 24,
      'image': 'assets/images/images4.jpg',
      'tag': 'Hot',
      'category': 'Téléphones',
    },
    {
      'name': 'Samsung TV 55"',
      'price': 599.0,
      'oldPrice': 899.0,
      'rating': '4.5',
      'sold': '2k+',
      'discount': 33,
      'image': 'assets/images/images11.jpg',
      'tag': null,
      'category': 'Maison',
    },
    {
      'name': 'Adidas Ultraboost',
      'price': 89.0,
      'oldPrice': 150.0,
      'rating': '4.7',
      'sold': '6k+',
      'discount': 41,
      'image': 'assets/images/images2.png',
      'tag': 'Sale',
      'category': 'Sport',
    },
    {
      'name': 'Samsung Galaxy S24',
      'price': 849.0,
      'oldPrice': 999.0,
      'rating': '4.7',
      'sold': '7k+',
      'discount': 15,
      'image': 'assets/images/images10.jpg',
      'tag': 'New',
      'category': 'Téléphones',
    },
    {
      'name': 'Robe Été Floral',
      'price': 35.0,
      'oldPrice': 65.0,
      'rating': '4.4',
      'sold': '12k+',
      'discount': 46,
      'image': 'assets/images/images5.jpg',
      'tag': 'Flash Sale',
      'category': 'Vêtements',
    },
    {
      'name': 'Canapé Moderne',
      'price': 450.0,
      'oldPrice': 750.0,
      'rating': '4.6',
      'sold': '1k+',
      'discount': 40,
      'image': 'assets/images/images6.jpg',
      'tag': null,
      'category': 'Maison',
    },
    {
      'name': 'T-Shirt Coton Bio',
      'price': 22.0,
      'oldPrice': 40.0,
      'rating': '4.3',
      'sold': '15k+',
      'discount': 45,
      'image': 'assets/images/images8.jpg',
      'tag': 'Sale',
      'category': 'Vêtements',
    },
    {
      'name': 'Ballon Football Pro',
      'price': 30.0,
      'oldPrice': 55.0,
      'rating': '4.5',
      'sold': '4k+',
      'discount': 45,
      'image': 'assets/images/images9.jpg',
      'tag': null,
      'category': 'Sport',
    },
  ];

  // ── Kategoris ──
  static const List<Map<String, dynamic>> _categories = [
    {'icon': Icons.phone_android, 'label': 'Téléphones'},
    {'icon': Icons.checkroom, 'label': 'Vêtements'},
    {'icon': Icons.laptop, 'label': 'Laptops'},
    {'icon': Icons.chair, 'label': 'Maison'},
    {'icon': Icons.sports_soccer, 'label': 'Sport'},
    {'icon': Icons.face_retouching_natural, 'label': 'Beauté'},
  ];

  // ── Pwodui filtre pa rechèch ──
  List<Map<String, dynamic>> get _filteredProducts {
    if (_searchQuery.isEmpty) return _allProducts;
    final q = _searchQuery.toLowerCase();
    return _allProducts.where((p) {
      final name = (p['name'] as String).toLowerCase();
      final category = (p['category'] as String).toLowerCase();
      final tag = ((p['tag'] as String?) ?? '').toLowerCase();
      return name.contains(q) || category.contains(q) || tag.contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUser;
    _isLoggedIn = widget.initialUser != null;
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════
  //  LOGIN MODAL
  // ════════════════════════════════════════════
  void _showLoginModal({String? reason}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LoginBottomSheet(
        reason: reason,
        onLoginSuccess: (user) {
          setState(() {
            _isLoggedIn = true;
            _currentUser = user;
          });
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/main', (route) => false, arguments: user);
        },
      ),
    );
  }

  void _requireLogin(String reason) {
    if (_isLoggedIn) return;
    _showLoginModal(reason: reason);
  }

  // ════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),

            // Si rechèch aktif, montre rezilta sèlman
            if (_isSearching && _searchQuery.isNotEmpty) ...[
              _buildSearchResults(products),
            ] else ...[
              _buildPromoTicker(),
              _buildFlashSaleBanner(),
              _buildCategories(),
              _buildDivider(),
              _buildSectionHeader('Produits Populaires', 'Voir tout'),
              _buildProductGrid(products),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav ? _buildBottomNav() : null,
    );
  }

  // ════════════════════════════════════════════
  //  APP BAR
  // ════════════════════════════════════════════
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFA3C3C),
      elevation: 0,
      title: const Text(
        'Ti Mache Lakay',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        // ✅ Panye a 0 — pa gen pwodui pre-charge
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () => _requireLogin('pou wè panye ou'),
            ),
            // Pa montre badge si 0
          ],
        ),
        if (!_isLoggedIn)
          GestureDetector(
            onTap: () => _showLoginModal(),
            child: Container(
              margin: const EdgeInsets.only(right: 10, left: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Konekte',
                style: TextStyle(
                  color: Color(0xFFFA3C3C),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
        else
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                _currentUser?.avatarInitials ?? 'U',
                style: const TextStyle(
                  color: Color(0xFFFA3C3C),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ════════════════════════════════════════════
  //  ✅ RECHÈCH FONKSYONÈL
  // ════════════════════════════════════════════
  Widget _buildSearchBar() {
    return Container(
      color: const Color(0xFFFA3C3C),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Color(0xFF999999), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onTap: () => setState(() => _isSearching = true),
                onSubmitted: (_) {},
                style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
                decoration: const InputDecoration(
                  hintText: 'Chèche pwodui, mak, kategori...',
                  hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 13),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                  filled: false,
                ),
              ),
            ),
            // Bouton efase / fèmen rechèch
            if (_isSearching || _searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isSearching = false;
                    _searchQuery = '';
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.close, color: Color(0xFF999999), size: 18),
                ),
              )
            else
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B00),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Chèche',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  ✅ REZILTA RECHÈCH
  // ════════════════════════════════════════════
  Widget _buildSearchResults(List<Map<String, dynamic>> products) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.search_off_outlined,
                size: 60,
                color: Color(0xFFCCCCCC),
              ),
              const SizedBox(height: 16),
              Text(
                'Pa jwenn rezilta pou "$_searchQuery"',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Eseye ak lòt mo kle',
                style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Text(
            '${products.length} rezilta pou "$_searchQuery"',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
        ),
        _buildProductGrid(products),
        const SizedBox(height: 16),
      ],
    );
  }

  // ════════════════════════════════════════════
  //  TICKER PROMO
  // ════════════════════════════════════════════
  Widget _buildPromoTicker() {
    return Container(
      color: const Color(0xFFFFF3F3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFA3C3C),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              '🔥 PROMO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Livrezon gratis pou tout kòmand plis pase \$30  •  Kode: LAKAY10',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFCC0000),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: Color(0xFFFA3C3C)),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  FLASH SALE BANNER
  // ════════════════════════════════════════════
  Widget _buildFlashSaleBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Color(0xFFFA3C3C), Color(0xFFFF6B00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.yellow, size: 20),
                    const SizedBox(width: 4),
                    const Text(
                      'FLASH SALE',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildCountdown(),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Jiska 60% Rabè',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Prese — Kantite limite!',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _requireLogin('pou pwofite Flash Sale a'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Achte Kounye a →',
                      style: TextStyle(
                        color: Color(0xFFFA3C3C),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
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

  Widget _buildCountdown() {
    return Row(
      children: ['02', ':', '45', ':', '30'].map((seg) {
        if (seg == ':') {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              ':',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            seg,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ════════════════════════════════════════════
  //  KATEGORIS
  // ════════════════════════════════════════════
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Text(
            'Kategoris',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                // ✅ Klike sou kategori filtre pwodui
                onTap: () {
                  final label = _categories[index]['label'] as String;
                  _searchController.text = label;
                  setState(() {
                    _isSearching = true;
                    _searchQuery = label;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 64,
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEEEEEE),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          _categories[index]['icon'] as IconData,
                          color: const Color(0xFFFA3C3C),
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _categories[index]['label'] as String,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 6,
      color: const Color(0xFFEAEAEA),
      margin: const EdgeInsets.only(top: 8),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFFA3C3C),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Voir tout >',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFFA3C3C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  ✅ GRIY PWODUI — pi piti, pi pwòp
  // ════════════════════════════════════════════
  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        // ✅ Rapò pi gwo = kat pi piti
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _buildProductCard(products[index]),
    );
  }

  // ════════════════════════════════════════════
  //  ✅ KAT PWODUI — pi konpak
  // ════════════════════════════════════════════
  Widget _buildProductCard(Map<String, dynamic> p) {
    final int discount = p['discount'] as int;
    final double price = p['price'] as double;
    final double oldPrice = p['oldPrice'] as double;
    final String? tag = p['tag'] as String?;

    return GestureDetector(
      // ✅ Ekip la: Navige vè DetailScreen isit
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imaj + Badges ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: AspectRatio(
                    // ✅ Imaj pi piti: 1.2 olye 1.0
                    aspectRatio: 1.2,
                    child: Image.asset(
                      p['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        color: const Color(0xFFF5F5F5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                size: 28,
                                color: Color(0xFFCCCCCC),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p['name'] as String,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFFAAAAAA),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Badge rabè
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA3C3C),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '-$discount%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                // Badge tag
                if (tag != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Bouton favori
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _requireLogin('pou sove pwodui nan favori ou'),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 13,
                        color: Color(0xFFFA3C3C),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Enfòmasyon ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p['name'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFA3C3C),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 1),
                              child: Text(
                                '\$${oldPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF999999),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 10,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              p['rating'] as String,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${p['sold']} vann',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Bouton ajoute ──
            GestureDetector(
              // ✅ Ekip la: Logik panye isit
              onTap: () => _requireLogin('pou ajoute nan panye ou'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFA3C3C),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Ajoute nan panye',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  BOTTOM NAV
  // ════════════════════════════════════════════
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (i) {
        if ((i == 3 || i == 4) && !_isLoggedIn) {
          _requireLogin(i == 3 ? 'pou wè panye ou' : 'pou wè pwofil ou');
          return;
        }
        setState(() => _currentNavIndex = i);
      },
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFFA3C3C),
      unselectedItemColor: const Color(0xFF999999),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      elevation: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Akèy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: 'Dekouvri',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          activeIcon: Icon(Icons.local_offer),
          label: 'Promo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Panye',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Pwofil',
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  LOGIN BOTTOM SHEET
// ══════════════════════════════════════════════════════════════
class _LoginBottomSheet extends StatefulWidget {
  final String? reason;
  final void Function(UserModel user) onLoginSuccess;

  const _LoginBottomSheet({required this.onLoginSuccess, this.reason});

  @override
  State<_LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<_LoginBottomSheet> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  void _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Tanpri ranpli tout champ yo.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    final userData = mockUsers[email];
    if (userData == null || userData['password'] != password) {
      setState(() {
        _loading = false;
        _error = 'Imèl oswa modpas la pa kòrèk.';
      });
      return;
    }

    setState(() => _loading = false);
    if (!mounted) return;

    Navigator.of(context).pop();
    widget.onLoginSuccess(userData['user'] as UserModel);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomPad),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFA3C3C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konekte',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      'Ti Mache Lakay',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.reason != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3F3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFA3C3C).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: Color(0xFFFA3C3C),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ou bezwen konekte ${widget.reason}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFCC0000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            _buildField(
              controller: _emailCtrl,
              hint: 'Imèl ou',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _passwordCtrl,
              hint: 'Modpas ou',
              icon: Icons.lock_outline,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 18,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFFFA3C3C),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Ou bliye modpas ou?',
                  style: TextStyle(color: Color(0xFFFA3C3C), fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA3C3C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Konekte',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 13,
                        color: Color(0xFFFF6B00),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Kont Demo — Klike pou ranpli',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _demoRow('jean.dupont@gmail.com', 'jean1234'),
                  _demoRow('marie.paul@gmail.com', 'marie5678'),
                  _demoRow('pierre.louis@gmail.com', 'pierre999'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ou pa gen kont?',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 4),
                  ),
                  child: const Text(
                    'Kreye kont gratis →',
                    style: TextStyle(
                      color: Color(0xFFFA3C3C),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      onSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFFA3C3C), size: 19),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFA3C3C), width: 1.5),
        ),
      ),
    );
  }

  Widget _demoRow(String email, String pwd) {
    return GestureDetector(
      onTap: () {
        _emailCtrl.text = email;
        _passwordCtrl.text = pwd;
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            const Icon(
              Icons.touch_app_outlined,
              size: 12,
              color: Color(0xFFFF6B00),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$email  /  $pwd',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white60,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
