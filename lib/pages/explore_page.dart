import 'package:flutter/material.dart';

import '../data/mock_products.dart';
import '../model/product_model.dart';
import 'detail_page.dart';

// ══════════════════════════════════════════════════════════════
//  PAJ DEKOUVRI / CATALOGUE
//  Montre tout pwodui pa kategori ak filtre
//  Style Temu — tab kategori, rechèch, griy pwodui
// ══════════════════════════════════════════════════════════════
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _selectedCategory = 'Tout';
  String _selectedSort = 'Popilè';
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = true;

  static const List<Map<String, dynamic>> _categories = [
    {'icon': Icons.grid_view_rounded, 'label': 'Tout'},
    {'icon': Icons.phone_android, 'label': 'Téléphones'},
    {'icon': Icons.checkroom, 'label': 'Vêtements'},
    {'icon': Icons.laptop, 'label': 'Laptops'},
    {'icon': Icons.chair, 'label': 'Maison'},
    {'icon': Icons.sports_soccer, 'label': 'Sport'},
    {'icon': Icons.face_retouching_natural, 'label': 'Beauté'},
  ];

  static const List<String> _sortOptions = [
    'Popilè',
    'Pri: Ba → Wo',
    'Pri: Wo → Ba',
    'Rabè',
    'Nòt',
  ];

  List<ProductModel> get _filteredProducts {
    List<ProductModel> results = List.from(mockProducts);

    // Filtre pa kategori
    if (_selectedCategory != 'Tout') {
      results = results
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    // Filtre pa rechèch
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      results = results
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q) ||
              (p.tag ?? '').toLowerCase().contains(q))
          .toList();
    }

    // Tri
    switch (_selectedSort) {
      case 'Pri: Ba → Wo':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Pri: Wo → Ba':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rabè':
        results.sort((a, b) => b.discount.compareTo(a.discount));
        break;
      case 'Nòt':
        results.sort((a, b) {
          final rA = double.tryParse(a.rating) ?? 0;
          final rB = double.tryParse(b.rating) ?? 0;
          return rB.compareTo(rA);
        });
        break;
      default:
        break;
    }

    return results;
  }

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.trim());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════
  //  BUILD PRENSIPAL
  // ════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryTabs(),
          _buildToolbar(products.length),
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : _isGridView
                    ? _buildGridView(products)
                    : _buildListView(products),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  ANTÈT — Rechèch
  // ════════════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFFA3C3C),
      padding: EdgeInsets.fromLTRB(
        14,
        MediaQuery.of(context).padding.top + 12,
        14,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tit
          const Text(
            'Dekouvri',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Jwenn tout sa ou bezwen isit',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Barre rechèch
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search,
                    color: Color(0xFF999999), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF1A1A1A)),
                    decoration: const InputDecoration(
                      hintText: 'Chèche nan katalòg la...',
                      hintStyle: TextStyle(
                          color: Color(0xFF999999), fontSize: 13),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10),
                      isDense: true,
                      filled: false,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.close,
                          color: Color(0xFF999999), size: 18),
                    ),
                  )
                else
                  Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B00),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.search,
                          color: Colors.white, size: 20),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  TAB KATEGORIS — scroll orizontal
  // ════════════════════════════════════════════
  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final label = cat['label'] as String;
                final isActive = _selectedCategory == label;

                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = label),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFFA3C3C)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                      border: isActive
                          ? null
                          : Border.all(
                              color: const Color(0xFFEEEEEE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 14,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF666666),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Liy separasyon
          Container(height: 1, color: const Color(0xFFF0F0F0)),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  TOOLBAR — Konte, Tri, View Toggle
  // ════════════════════════════════════════════
  Widget _buildToolbar(int count) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Konte rezilta
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12),
              children: [
                TextSpan(
                  text: '$count ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFA3C3C),
                  ),
                ),
                const TextSpan(
                  text: 'pwodui',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bouton Tri
          GestureDetector(
            onTap: () => _showSortSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFFEEEEEE)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swap_vert,
                      size: 14, color: Color(0xFF666666)),
                  const SizedBox(width: 4),
                  Text(
                    _selectedSort,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Toggle Grid / List
          GestureDetector(
            onTap: () =>
                setState(() => _isGridView = !_isGridView),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFFEEEEEE)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _isGridView
                    ? Icons.view_list_outlined
                    : Icons.grid_view_rounded,
                size: 16,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  MODAL TRI
  // ════════════════════════════════════════════
  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Triye Pa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const Divider(height: 1),
            ..._sortOptions.map((option) {
              final isActive = _selectedSort == option;
              return ListTile(
                onTap: () {
                  setState(() => _selectedSort = option);
                  Navigator.pop(context);
                },
                leading: Icon(
                  _getSortIcon(option),
                  color: isActive
                      ? const Color(0xFFFA3C3C)
                      : const Color(0xFF999999),
                  size: 20,
                ),
                title: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isActive
                        ? const Color(0xFFFA3C3C)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                trailing: isActive
                    ? const Icon(Icons.check_circle,
                        color: Color(0xFFFA3C3C), size: 20)
                    : null,
              );
            }),
            SizedBox(
                height: MediaQuery.of(context).padding.bottom + 12),
          ],
        ),
      ),
    );
  }

  IconData _getSortIcon(String option) {
    switch (option) {
      case 'Popilè':
        return Icons.local_fire_department_outlined;
      case 'Pri: Ba → Wo':
        return Icons.arrow_upward;
      case 'Pri: Wo → Ba':
        return Icons.arrow_downward;
      case 'Rabè':
        return Icons.discount_outlined;
      case 'Nòt':
        return Icons.star_outline;
      default:
        return Icons.sort;
    }
  }

  // ════════════════════════════════════════════
  //  ETA VID
  // ════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFA3C3C)
                    .withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: const Icon(Icons.search_off_outlined,
                size: 38, color: Color(0xFFFA3C3C)),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Pa jwenn rezilta pou "$_searchQuery"'
                : 'Pa gen pwodui nan "$_selectedCategory"',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Eseye ak lòt kategori oswa mo kle',
            style:
                TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _searchCtrl.clear();
              setState(() {
                _selectedCategory = 'Tout';
                _searchQuery = '';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFA3C3C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Wè tout pwodui',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  VIEW GRIY (2 kolonn)
  // ════════════════════════════════════════════
  Widget _buildGridView(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.68,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) =>
          _buildGridCard(products[i]),
    );
  }

  // ════════════════════════════════════════════
  //  KAT GRIY — style Temu
  // ════════════════════════════════════════════
  Widget _buildGridCard(ProductModel product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductDetailPage(product: product),
        ),
      ),
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
                      top: Radius.circular(8)),
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF5F5F5),
                        child: const Center(
                          child: Icon(Icons.image_outlined,
                              size: 30,
                              color: Color(0xFFCCCCCC)),
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
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA3C3C),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '-${product.discount}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                // Badge tag
                if (product.tag != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        product.tag!,
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
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 14,
                      color: Color(0xFFFA3C3C),
                    ),
                  ),
                ),
              ],
            ),

            // ── Enfòmasyon ──
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(8, 6, 8, 4),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFA3C3C),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding:
                                  const EdgeInsets.only(
                                      bottom: 1),
                              child: Text(
                                '\$${product.oldPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF999999),
                                  decoration: TextDecoration
                                      .lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 10,
                                color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              product.rating,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color:
                                      Color(0xFF666666)),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.sold} vann',
                              style: const TextStyle(
                                  fontSize: 9,
                                  color:
                                      Color(0xFF999999)),
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
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFFA3C3C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'Wè Detay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
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
  //  VIEW LIS (1 kolonn)
  // ════════════════════════════════════════════
  Widget _buildListView(List<ProductModel> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (_, i) => _buildListCard(products[i]),
    );
  }

  // ════════════════════════════════════════════
  //  KAT LIS — orizontal
  // ════════════════════════════════════════════
  Widget _buildListCard(ProductModel product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductDetailPage(product: product),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Imaj
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: Image.asset(
                    product.image,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120,
                      height: 120,
                      color: const Color(0xFFF5F5F5),
                      child: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),
                // Badge rabè
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA3C3C),
                      borderRadius:
                          BorderRadius.circular(3),
                    ),
                    child: Text(
                      '-${product.discount}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Enfòmasyon
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Non
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Kategori + Tag
                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFF5F5F5),
                            borderRadius:
                                BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (product.tag != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFFF6B00),
                              borderRadius:
                                  BorderRadius.circular(
                                      4),
                            ),
                            child: Text(
                              product.tag!,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pri
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFA3C3C),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding:
                              const EdgeInsets.only(
                                  bottom: 2),
                          child: Text(
                            '\$${product.oldPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              decoration: TextDecoration
                                  .lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFFF0F0),
                            borderRadius:
                                BorderRadius.circular(3),
                          ),
                          child: Text(
                            'Ekonomize \$${(product.oldPrice - product.price).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 8,
                              color: Color(0xFFFA3C3C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Rating + Sold
                    Row(
                      children: [
                        Row(
                          children: List.generate(5,
                              (i) {
                            final r = double.tryParse(
                                    product.rating) ??
                                0;
                            return Icon(
                              i < r.floor()
                                  ? Icons.star
                                  : (i < r
                                      ? Icons.star_half
                                      : Icons
                                          .star_border),
                              size: 12,
                              color: Colors.amber,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${product.sold} vann',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Chevron
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right,
                  color: Color(0xFFCCCCCC), size: 20),
            ),
          ],
        ),
      ),
    );
  }
}