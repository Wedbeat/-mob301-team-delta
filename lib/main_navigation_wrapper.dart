import 'package:flutter/material.dart';

import 'model/user_model.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/cart_page.dart';
import 'pages/cart_manager.dart';
import 'pages/explore_page.dart';

class NavIndex {
  static const int home = 0;
  static const int explore = 1;
  static const int promo = 2;
  static const int cart = 3;
  static const int profile = 4;
}

class MainNavigationWrapper extends StatefulWidget {
  final UserModel user;

  const MainNavigationWrapper({super.key, required this.user});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = NavIndex.home;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      const ExplorePage(),
      _buildComingSoon('Promo', Icons.local_offer_outlined),
      const CartPage(),
      ProfileScreen(
  user: widget.user,
  onLogout: () {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  },
),
    ];
  }

  Widget _buildComingSoon(String label, IconData icon) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(0xFFE94560)),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Paj sa a ap vini byento...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CartManager.notifier,
      builder: (context, items, child) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: NavIndex.home,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Akèy',
              ),
              _buildNavItem(
                index: NavIndex.explore,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Dekouvri',
              ),
              _buildNavItem(
                index: NavIndex.promo,
                icon: Icons.local_offer_outlined,
                activeIcon: Icons.local_offer,
                label: 'Promo',
              ),
              _buildNavItem(
                index: NavIndex.cart,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'Panye',
                badgeCount: CartManager.count,
              ),
              _buildNavItem(
                index: NavIndex.profile,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Mwen',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
  }) {
    final bool isActive = _currentIndex == index;
    const Color activeColor = Color(0xFFE94560);
    const Color inactiveColor = Colors.grey;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -10,
                  top: -7,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 17,
                      minHeight: 17,
                    ),
                    decoration: const BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      textAlign: TextAlign.center,
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
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? activeColor : inactiveColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationHelper {
  static void goTo(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationWrapperState>();
    state?._onTabTapped(index);
  }
}