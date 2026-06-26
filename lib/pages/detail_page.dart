import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../data/mock_products.dart';
import 'cart_manager.dart';
import 'cart_page.dart';

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

  late final PageController _imageController;

  ProductModel get product => widget.product;

  List<String> get images {
    return product.images.isNotEmpty ? product.images : [product.image];
  }

  @override
  void initState() {
    super.initState();
    _imageController = PageController();

    if (product.sizes.isNotEmpty) {
      _selectedSize = product.sizes.first;
    }

    if (product.colors.isNotEmpty) {
      _selectedColor = product.colors.first;
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    for (int i = 0; i < _quantity; i++) {
      CartManager.addItem(
        name: product.name,
        image: product.image,
        price: product.price,
      );
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ajoute nan panye! (x$_quantity)'),
        backgroundColor: const Color(0xFF2ECC71),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {});
  }

  void _buyNow() {
    _addToCart();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final similarProducts = getSimilarProducts(product);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildImageGallery()),
                SliverToBoxAdapter(child: _buildPriceSection()),
                SliverToBoxAdapter(child: _buildPromoBanner()),

                if (product.sizes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildOptionSection(
                      'Chwazi Tay',
                      product.sizes,
                      _selectedSize,
                      (value) {
                        setState(() {
                          _selectedSize = value;
                        });
                      },
                    ),
                  ),

                if (product.colors.isNotEmpty)
                  SliverToBoxAdapter(child: _buildColorSection()),

                SliverToBoxAdapter(child: _buildShippingInfo()),
                SliverToBoxAdapter(child: _buildDescription()),
                SliverToBoxAdapter(child: _buildReviewSnapshot()),

                if (similarProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildSimilarProducts(similarProducts),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          _buildBottomActionBar(),
        ],
      ),
    );
  }
  Widget _buildImageGallery() {
    return Stack(
      children: [
        SizedBox(
          height: 360,
          child: PageView.builder(
            controller: _imageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF5F5F5),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: _buildCircleButton(
            Icons.arrow_back,
            () => Navigator.pop(context),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: Row(
            children: [
              _buildCircleButton(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
                iconColor: _isFavorite ? const Color(0xFFFA3C3C) : null,
              ),
              const SizedBox(width: 8),
              _buildCircleButton(Icons.share_outlined, () {}),
              const SizedBox(width: 8),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildCircleButton(
                    Icons.shopping_cart_outlined,
                    _openCart,
                  ),
                  if (CartManager.count > 0)
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
                          '${CartManager.count}',
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
              ),
            ),
          ),
        ),

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

        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Column(
            children: [
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
              if (images.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (index) {
                      final isActive = _currentImageIndex == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFFA3C3C)
                              : Colors.white60,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton(
    IconData icon,
    VoidCallback onTap, {
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              Text(
                '\$${product.oldPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF999999),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  final rating = double.tryParse(product.rating) ?? 0;

                  return Icon(
                    index < rating.floor()
                        ? Icons.star
                        : index < rating
                            ? Icons.star_half
                            : Icons.star_border,
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
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${product.reviewCount})',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
              const Spacer(),
              if (product.inStock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'An Stòk',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: const Row(
        children: [
          Text(
            '🎉 PROMO',
            style: TextStyle(
              color: Color(0xFFFA3C3C),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Livrezon GRATIS pou kòmand +\$30 • Kode: LAKAY10',
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
          Text(
            selected == null ? title : '$title : $selected',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selected == option;

              return GestureDetector(
                onTap: () => onSelect(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                    option,
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

  Widget _buildColorSection() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedColor == null ? 'Koulè' : 'Koulè : $_selectedColor',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.colors.map((colorName) {
              final isSelected = _selectedColor == colorName;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = colorName;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
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
                          color: _getColorFromName(colorName),
                          border: Border.all(
                            color: const Color(0xFFDDDDDD),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        colorName,
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
    final value = name.toLowerCase();

    if (value.contains('noir')) return Colors.black87;
    if (value.contains('blanc')) return Colors.white;
    if (value.contains('rouge')) return Colors.red;
    if (value.contains('bleu')) return Colors.blue;
    if (value.contains('vert')) return Colors.green;
    if (value.contains('jaune')) return Colors.amber;
    if (value.contains('rose')) return Colors.pink.shade200;
    if (value.contains('gri')) return Colors.grey;
    if (value.contains('violet')) return Colors.purple;
    if (value.contains('or')) return Colors.amber.shade700;
    if (value.contains('beige')) return const Color(0xFFF5F5DC);
    if (value.contains('argent')) return Colors.grey.shade300;
    if (value.contains('olive')) return const Color(0xFF808000);
    if (value.contains('navy') || value.contains('marin')) {
      return const Color(0xFF000080);
    }

    return Colors.grey.shade400;
  }

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
          const Divider(height: 18, color: Color(0xFFF5F5F5)),
          _buildInfoRow(
            Icons.verified_user_outlined,
            'Garanti 30 Jou',
            'Retounen oswa ranbousman san pwoblèm',
            const Color(0xFF2196F3),
          ),
          const Divider(height: 18, color: Color(0xFFF5F5F5)),
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
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    final description = product.description.isNotEmpty
        ? product.description
        : 'Pa gen deskripsyon disponib pou pwodui sa a.';

    final isLong = description.length > 120;

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
          Text(
            description,
            maxLines: _showFullDescription ? null : 3,
            overflow:
                _showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
          if (isLong)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showFullDescription = !_showFullDescription;
                  });
                },
                child: Text(
                  _showFullDescription ? 'Wè mwens' : 'Wè plis',
                  style: const TextStyle(
                    color: Color(0xFFFA3C3C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewSnapshot() {
    final rating = double.tryParse(product.rating) ?? 0;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Text(
            product.rating,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating.floor()
                        ? Icons.star
                        : index < rating
                            ? Icons.star_half
                            : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '${product.reviewCount} evalyasyon',
                style: const TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
              itemBuilder: (context, index) {
                return _buildSimilarCard(products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard(ProductModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: item),
          ),
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
            Expanded(
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_outlined);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '\$${item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFFFA3C3C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartManager.notifier,
      builder: (context, items, child) {
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
                _buildBottomIcon(Icons.chat_bubble_outline, 'Chat', () {}),
                const SizedBox(width: 4),
                _buildBottomIcon(
                  Icons.shopping_cart_outlined,
                  'Panye',
                  _openCart,
                  badge: CartManager.count,
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      _buildQtyBtn(Icons.remove, () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
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
                        setState(() {
                          _quantity++;
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
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
                        'Achte • \$${(product.price * _quantity).toStringAsFixed(0)}',
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
      },
    );
  }

  Widget _buildBottomIcon(
    IconData icon,
    String label,
    VoidCallback onTap, {
    int badge = 0,
  }) {
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
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF999999),
              ),
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
        child: Icon(
          icon,
          size: 14,
          color: const Color(0xFF666666),
        ),
      ),
    );
  }
}