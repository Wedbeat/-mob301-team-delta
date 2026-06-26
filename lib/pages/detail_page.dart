import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../model/cart_model.dart';
import '../data/mock_products.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;
  bool _isFavorite = false;
  bool _showFullDescription = false;

  // Kontrolè pou imaj PageView
  late final PageController _imageController;

  ProductModel get product => widget.product;
  List<String> get images =>
      product.images.isNotEmpty ? product.images : [product.image];

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
    if (product.sizes.isNotEmpty) _selectedSize = product.sizes[0];
    if (product.colors.isNotEmpty) _selectedColor = product.colors[0];
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    CartManager.instance.addItem(
      product,
      size: _selectedSize,
      color: _selectedColor,
      qty: _quantity,
    );

    // Animasyon snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${product.name} ajoute nan panye! (x$_quantity)',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2ECC71),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
    setState(() {});
  }

  void _buyNow() {
    _addToCart();
    // TODO: Navige vè checkout
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Checkout ap vini byento...'),
        backgroundColor: const Color(0xFFFA3C3C),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final similarProducts = getSimilarProducts(product);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // ═══ KÒ PRENSIPAL ═══
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── GALRI IMAJ ──
                SliverToBoxAdapter(child: _buildImageGallery()),

                // ── PRI + NON ──
                SliverToBoxAdapter(child: _buildPriceSection()),

                // ── PROMO BANNER ──
                SliverToBoxAdapter(child: _buildPromoBanner()),

                // ── SELEKSYON TAY ──
                if (product.sizes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildOptionSection(
                      'Chwazi Tay',
                      product.sizes,
                      _selectedSize,
                      (val) => setState(() => _selectedSize = val),
                    ),
                  ),

                // ── SELEKSYON KOULÈ ──
                if (product.colors.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildColorSection(),
                  ),

                // ── LIVREZON + GARANTI ──
                SliverToBoxAdapter(child: _buildShippingInfo()),

                // ── DESKRIPSYON ──
                SliverToBoxAdapter(child: _buildDescription()),

                // ── REVIEW SNAPSHOT ──
                SliverToBoxAdapter(child: _buildReviewSnapshot()),

                // ── PWODUI SIMILÈ ──
                if (similarProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildSimilarProducts(similarProducts),
                  ),

                // Espas pou ba aksyon
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // ═══ BA AKSYON ANBA ═══
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  GALRI IMAJ — Style Temu
  // ════════════════════════════════════════════
  Widget _buildImageGallery() {
    return Stack(
      children: [
        // Imaj prensipal
        SizedBox(
          height: 360,
          child: PageView.builder(
            controller: _imageController,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemBuilder: (_, i) => Image.asset(
              images[i],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFF5F5F5),
                child: const Center(
                  child: Icon(Icons.image_outlined,
                      size: 60, color: Color(0xFFCCCCCC)),
                ),
              ),
            ),
          ),
        ),

        // Bouton retounen
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: _buildCircleButton(
            Icons.arrow_back,
            () => Navigator.pop(context),
          ),
        ),

        // Bouton aksyon dwat
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: Row(
            children: [
              _buildCircleButton(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                () => setState(() => _isFavorite = !_isFavorite),
                iconColor: _isFavorite ? const Color(0xFFFA3C3C) : null,
              ),
              const SizedBox(width: 8),
              _buildCircleButton(Icons.share_outlined, () {}),
              const SizedBox(width: 8),
              // Badge panye
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildCircleButton(
                    Icons.shopping_cart_outlined,
                    () => Navigator.pop(context),
                  ),
                  if (CartManager.instance.itemCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFA3C3C),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${CartManager.instance.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Badge rabè
        Positioned(
          bottom: 56,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFA3C3C),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '-${product.discount}% RABÈ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),

        // Tag pwodui
        if (product.tag != null)
          Positioned(
            bottom: 56,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.tag!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Endikè imaj + konte
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Nimewo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Pwen endikè
              if (images.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentImageIndex == i ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == i
                            ? const Color(0xFFFA3C3C)
                            : Colors.white60,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Ti imaj thumbnail anba
        if (images.length > 1)
          Positioned(
            bottom: 44,
            right: 12,
            child: Row(
              children: List.generate(
                images.length > 4 ? 4 : images.length,
                (i) => GestureDetector(
                  onTap: () {
                    _imageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 4),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _currentImageIndex == i
                            ? const Color(0xFFFA3C3C)
                            : Colors.white54,
                        width: _currentImageIndex == i ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.asset(
                        images[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap,
      {Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 18),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  PRI + NON + RATING
  // ════════════════════════════════════════════
  Widget _buildPriceSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Liy pri
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFA3C3C),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '\$${product.oldPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Ekonomize \$${(product.oldPrice - product.price).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFFA3C3C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Non pwodui
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Rating + Sold + Review
          Row(
            children: [
              // Etwal
              Row(
                children: List.generate(5, (i) {
                  final rating = double.tryParse(product.rating) ?? 0;
                  return Icon(
                    i < rating.floor()
                        ? Icons.star
                        : (i < rating ? Icons.star_half : Icons.star_border),
                    size: 14,
                    color: Colors.amber,
                  );
                }),
              ),
              const SizedBox(width: 6),
              Text(
                product.rating,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${product.reviewCount})',
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 14,
                color: const Color(0xFFEEEEEE),
              ),
              const SizedBox(width: 12),
              Text(
                '${product.sold} vann',
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              const Spacer(),
              if (product.inStock)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 12, color: Color(0xFF4CAF50)),
                      SizedBox(width: 4),
                      Text(
                        'An Stòk',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  PROMO BANNER
  // ════════════════════════════════════════════
  Widget _buildPromoBanner() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFA3C3C),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              '🎉 PROMO',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Livrezon GRATIS pou kòmand +\$30  •  Kode: LAKAY10 pou 10% rabè',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFFCC0000),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  SELEKSYON OPSYON (TAY)
  // ════════════════════════════════════════════
  Widget _buildOptionSection(
    String title,
    List<String> options,
    String? selected,
    void Function(String) onSelect,
  ) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (selected != null) ...[
                const SizedBox(width: 8),
                Text(
                  ': $selected',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFA3C3C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              final isSelected = selected == opt;
              return GestureDetector(
                onTap: () => onSelect(opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFF0F0)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFA3C3C)
                          : const Color(0xFFEEEEEE),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFFFA3C3C)
                          : const Color(0xFF333333),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  SELEKSYON KOULÈ — ak ti sèk koulè
  // ════════════════════════════════════════════
  Widget _buildColorSection() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Koulè',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (_selectedColor != null) ...[
                const SizedBox(width: 8),
                Text(
                  ': $_selectedColor',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFA3C3C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.colors.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFF0F0)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFA3C3C)
                          : const Color(0xFFEEEEEE),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getColorFromName(color),
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        color,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFFFA3C3C)
                              : const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getColorFromName(String name) {
    final n = name.toLowerCase();
    if (n.contains('noir')) return Colors.black87;
    if (n.contains('blanc')) return Colors.white;
    if (n.contains('rouge')) return Colors.red;
    if (n.contains('bleu')) return Colors.blue;
    if (n.contains('vert')) return Colors.green;
    if (n.contains('jaune')) return Colors.amber;
    if (n.contains('rose')) return Colors.pink.shade200;
    if (n.contains('gri')) return Colors.grey;
    if (n.contains('violet')) return Colors.purple;
    if (n.contains('or')) return Colors.amber.shade700;
    if (n.contains('beige')) return const Color(0xFFF5F5DC);
    if (n.contains('argent')) return Colors.grey.shade300;
    if (n.contains('titane') || n.contains('naturel')) return const Color(0xFFB8B8B8);
    if (n.contains('olive')) return const Color(0xFF808000);
    if (n.contains('navy') || n.contains('marin')) return const Color(0xFF000080);
    return Colors.grey.shade400;
  }

  // ════════════════════════════════════════════
  //  LIVREZON + GARANTI
  // ════════════════════════════════════════════
  Widget _buildShippingInfo() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.local_shipping_outlined,
            'Livrezon Gratis',
            'Pou kòmand plis pase \$30 • 3-7 jou',
            const Color(0xFF4CAF50),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: Color(0xFFF5F5F5)),
          ),
          _buildInfoRow(
            Icons.verified_user_outlined,
            'Garanti 30 Jou',
            'Retounen oswa ranbousman san pwoblèm',
            const Color(0xFF2196F3),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: Color(0xFFF5F5F5)),
          ),
          _buildInfoRow(
            Icons.security_outlined,
            'Peman Sekirize',
            'Done ou pwoteje ak ankriptaj SSL',
            const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A))),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF999999))),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFFCCCCCC)),
      ],
    );
  }

  // ════════════════════════════════════════════
  //  DESKRIPSYON
  // ════════════════════════════════════════════
  Widget _buildDescription() {
    final desc = product.description.isNotEmpty
        ? product.description
        : 'Pa gen deskripsyon disponib pou pwodui sa a.';
    final isLong = desc.length > 120;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsyon Pwodui',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: Text(
              desc,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                height: 1.6,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              desc,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                height: 1.6,
              ),
            ),
            crossFadeState: _showFullDescription
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          if (isLong) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () =>
                  setState(() => _showFullDescription = !_showFullDescription),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _showFullDescription ? 'Wè mwens' : 'Wè plis',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFA3C3C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    _showFullDescription
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: const Color(0xFFFA3C3C),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  REVIEW SNAPSHOT
  // ════════════════════════════════════════════
  Widget _buildReviewSnapshot() {
    final rating = double.tryParse(product.rating) ?? 0;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Evalyasyon Kliyan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Wè tout >',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFFA3C3C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Gwo nòt
              Column(
                children: [
                  Text(
                    product.rating,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < rating.floor()
                            ? Icons.star
                            : (i < rating
                                ? Icons.star_half
                                : Icons.star_border),
                        size: 14,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.reviewCount} evalyasyon',
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF999999)),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Ba pousantaj
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    // Simulate distribution
                    final pct = star == 5
                        ? 0.65
                        : star == 4
                            ? 0.20
                            : star == 3
                                ? 0.10
                                : star == 2
                                    ? 0.03
                                    : 0.02;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          Text('$star',
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF999999))),
                          const SizedBox(width: 4),
                          const Icon(Icons.star,
                              size: 10, color: Colors.amber),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor: const Color(0xFFEEEEEE),
                                valueColor:
                                    const AlwaysStoppedAnimation(Colors.amber),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${(pct * 100).toInt()}%',
                              style: const TextStyle(
                                  fontSize: 9, color: Color(0xFF999999)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  PWODUI SIMILÈ
  // ════════════════════════════════════════════
  Widget _buildSimilarProducts(List<ProductModel> products) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'Pwodui Similè',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: products.length,
              itemBuilder: (_, i) => _buildSimilarCard(products[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard(ProductModel p) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
        );
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Image.asset(
                      p.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFF5F5F5),
                        child: const Icon(Icons.image_outlined,
                            color: Color(0xFFCCCCCC)),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFA3C3C),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '-${p.discount}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${p.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFA3C3C),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$${p.oldPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  BA AKSYON ANBA — Style Temu
  // ════════════════════════════════════════════
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Bouton Chat
            _buildBottomIcon(Icons.chat_bubble_outline, 'Chat', () {}),
            const SizedBox(width: 4),

            // Bouton Panye
            _buildBottomIcon(
              Icons.shopping_cart_outlined,
              'Panye',
              () => Navigator.pop(context),
              badge: CartManager.instance.itemCount,
            ),

            const SizedBox(width: 12),

            // Selektè kantite
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEEEEEE)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  _buildQtyBtn(Icons.remove, () {
                    if (_quantity > 1) setState(() => _quantity--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildQtyBtn(Icons.add, () {
                    setState(() => _quantity++);
                  }),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Bouton Ajoute
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: _addToCart,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFA3C3C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Ajoute',
                    style: TextStyle(
                      color: Color(0xFFFA3C3C),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            // Bouton Achte
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: _buyNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA3C3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Achte  •  \$${(product.price * _quantity).toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
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

  Widget _buildBottomIcon(IconData icon, String label, VoidCallback onTap,
      {int badge = 0}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 20, color: const Color(0xFF666666)),
                if (badge > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFA3C3C),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 14, color: const Color(0xFF666666)),
      ),
    );
  }
}