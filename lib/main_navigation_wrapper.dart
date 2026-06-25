import 'package:flutter/material.dart';

import 'model/user_model.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

// ══════════════════════════════════════════════════════════════
//  KONSTANT ENDÈKS
// ══════════════════════════════════════════════════════════════
class NavIndex {
  static const int home = 0;
  static const int explore = 1;
  static const int promo = 2;
  static const int cart = 3;
  static const int profile = 4;
}

// ══════════════════════════════════════════════════════════════
//  MAIN NAVIGATION WRAPPER
// ══════════════════════════════════════════════════════════════
class MainNavigationWrapper extends StatefulWidget {
  final UserModel user;

  const MainNavigationWrapper({super.key, required this.user});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = NavIndex.home;
  int _cartCount = 3;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        showBottomNav: false,
        initialUser: widget.user,
      ),
      _buildComingSoon('Dekouvri', Icons.explore_outlined),
      _buildComingSoon('Promo', Icons.local_offer_outlined),
      _buildComingSoon('Panye', Icons.shopping_cart_outlined),
      ProfileScreen(
        user: widget.user,
        onLogout: _handleLogout,
      ),
    ];
  }

  void _handleLogout() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  Widget _buildComingSoon(String label, IconData icon) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFFA3C3C),
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 20),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFA3C3C).withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 42,
                      color: const Color(0xFFFA3C3C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Paj sa a ap vini byento...',
                    style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA3C3C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Avize mwen →',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void updateCartCount(int count) {
    setState(() => _cartCount = count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      _NavItem(
        index: NavIndex.home,
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Akèy',
      ),
      _NavItem(
        index: NavIndex.explore,
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore,
        label: 'Dekouvri',
      ),
      _NavItem(
        index: NavIndex.promo,
        icon: Icons.local_offer_outlined,
        activeIcon: Icons.local_offer,
        label: 'Promo',
      ),
      _NavItem(
        index: NavIndex.cart,
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        label: 'Panye',
        badge: _cartCount,
      ),
      _NavItem(
        index: NavIndex.profile,
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Mwen',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
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
          height: 56,
          child: Row(
            children: items.map((item) {
              return Expanded(
                child: _buildNavItem(item),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item) {
    final bool isActive = _currentIndex == item.index;

    return GestureDetector(
      onTap: () => _onTabTapped(item.index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  key: ValueKey(isActive),
                  color: isActive ? const Color(0xFFFA3C3C) : const Color(0xFF999999),
                  size: 24,
                ),
              ),
              if (item.badge > 0)
                Positioned(
                  right: -10,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA3C3C),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      item.badge > 99 ? '99+' : '${item.badge}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
              color: isActive ? const Color(0xFFFA3C3C) : const Color(0xFF999999),
              fontFamily: 'Poppins',
            ),
            child: Text(item.label),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(top: 3),
            height: 2,
            width: isActive ? 20 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFFFA3C3C),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badge;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge = 0,
  });
}

class NavigationHelper {
  static void goTo(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationWrapperState>();
    state?._onTabTapped(index);
  }

  static void updateCart(BuildContext context, int count) {
    final state = context.findAncestorStateOfType<_MainNavigationWrapperState>();
    state?.updateCartCount(count);
  }
}
