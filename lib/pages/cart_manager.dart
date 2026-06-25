import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartManager {
  static final ValueNotifier<List<CartItem>> notifier =
      ValueNotifier<List<CartItem>>([]);

  static List<CartItem> get items => notifier.value;

  static int get count {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  static double get subtotal {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  static double get shipping => items.isEmpty ? 0 : 10;

  static double get total => subtotal + shipping;

  static void _refresh() {
    notifier.value = List<CartItem>.from(items);
  }

  static void addItem({
    required String name,
    required String image,
    required double price,
  }) {
    final index = items.indexWhere((item) => item.name == name);

    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(
        CartItem(
          name: name,
          image: image,
          price: price,
        ),
      );
    }

    _refresh();
  }

  static void increase(int index) {
    items[index].quantity++;
    _refresh();
  }

  static void decrease(int index) {
    if (items[index].quantity > 1) {
      items[index].quantity--;
      _refresh();
    }
  }

  static void remove(int index) {
    items.removeAt(index);
    _refresh();
  }

  static void clear() {
    items.clear();
    _refresh();
  }
}