import 'package:flutter/material.dart';
<<<<<<< HEAD

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> cartItems = [
    CartItem(
      name: 'iPhone 15 Pro',
      image: 'assets/images/images1.jpg',
      price: 999,
      quantity: 1,
    ),
    CartItem(
      name: 'Nike Air Max',
      image: 'assets/images/images2.png',
      price: 120,
      quantity: 2,
    ),
    CartItem(
      name: 'AirPods Pro',
      image: 'assets/images/images4.jpg',
      price: 249,
      quantity: 1,
    ),
  ];

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get delivery => cartItems.isEmpty ? 0 : 10;
  double get total => subtotal + delivery;

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mon Panier',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: cartItems.isEmpty ? null : _buildBottomTotal(),
    );
  }

  Widget _buildCartContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.image,
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 85,
                      height: 85,
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFFE94560),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _quantityButton(
                          icon: Icons.remove,
                          onTap: () => decreaseQuantity(index),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _quantityButton(
                          icon: Icons.add,
                          onTap: () => increaseQuantity(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => removeItem(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFE94560),
                ),
              ),
            ],
          ),
=======
import 'cart_manager.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color accentColor = Color(0xFFE94560);
  static const Color bgColor = Color(0xFFF5F5F5);

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
            iconTheme: const IconThemeData(color: primaryColor),
            title: const Text(
              'PANYE',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (items.isNotEmpty)
                IconButton(
                  tooltip: 'Vider le panier',
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => _confirmClearCart(context),
                ),
            ],
          ),
          body: items.isEmpty ? _emptyCart() : _cartBody(items),
          bottomNavigationBar: items.isEmpty ? null : _checkoutBox(context),
>>>>>>> main
        );
      },
    );
  }

<<<<<<< HEAD
  Widget _quantityButton({
=======
  Widget _cartBody(List<CartItem> items) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _summaryHeader(),
        const SizedBox(height: 14),
        ...List.generate(items.length, (index) {
          return _cartItemCard(items[index], index);
        }),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _summaryHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, accentColor],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.shopping_cart, color: accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Résumé du panier',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${CartManager.count} article(s) dans votre panier',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItemCard(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              item.image,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 92,
                  height: 92,
                  color: const Color(0xFFF0F0F0),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _qtyButton(
                        icon: Icons.remove,
                        onTap: () => CartManager.decrease(index),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _qtyButton(
                        icon: Icons.add,
                        onTap: () => CartManager.increase(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => CartManager.remove(index),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 17,
                      color: accentColor,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
>>>>>>> main
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
<<<<<<< HEAD
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFE94560),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
=======
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
>>>>>>> main
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildBottomTotal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
=======
  Widget _checkoutBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
>>>>>>> main
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
<<<<<<< HEAD
            _priceRow('Sous-total', subtotal),
            const SizedBox(height: 8),
            _priceRow('Livraison', delivery),
            const Divider(height: 24),
            _priceRow('Total', total, isTotal: true),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Commande validée avec succès')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94560),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Passer la commande',
=======
            _priceRow('Sous-total', CartManager.subtotal),
            const SizedBox(height: 8),
            _priceRow('Livraison', CartManager.shipping),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 8),
            _priceRow('Total', CartManager.total, isTotal: true),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () => _checkout(context),
              icon: const Icon(Icons.lock_outline, color: Colors.white),
              label: const Text(
                'Commander maintenant',
>>>>>>> main
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
<<<<<<< HEAD
=======
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
>>>>>>> main
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
<<<<<<< HEAD
            color: isTotal ? const Color(0xFF1A1A2E) : Colors.grey,
=======
            color: isTotal ? primaryColor : Colors.grey,
>>>>>>> main
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(0)}',
          style: TextStyle(
<<<<<<< HEAD
            color: isTotal ? const Color(0xFFE94560) : const Color(0xFF1A1A2E),
            fontSize: isTotal ? 20 : 14,
=======
            color: isTotal ? accentColor : primaryColor,
            fontSize: isTotal ? 22 : 15,
>>>>>>> main
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Votre panier est vide',
            style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
=======
  Widget _emptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE8EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 70,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Panier ou vid',
              style: TextStyle(
                color: primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ajoute pwodwi nan paj akèy la pou yo parèt isit la.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _checkout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande passée avec succès ✅'),
        backgroundColor: accentColor,
      ),
    );
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vider le panier ?'),
          content: const Text('Voulez-vous vraiment supprimer tous les articles ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                CartManager.clear();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              child: const Text(
                'Vider',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
>>>>>>> main
