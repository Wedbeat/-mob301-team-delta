import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'model/user_model.dart';

// ══════════════════════════════════════════════════════════════
//  KONSTANT: Endèks chak onglet (evite magic numbers)
// ══════════════════════════════════════════════════════════════
class NavIndex {
  static const int home = 0;
  static const int catalog = 1;
  static const int cart = 2;
  static const int profile = 3;
}

// ══════════════════════════════════════════════════════════════
//  MAIN NAVIGATION WRAPPER
//  • Resevwa UserModel apre login
//  • IndexedStack → chak screen rete nan memwa (pa rechaje)
//  • cartCount    → badge dinamik sou ikòn panier
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
      const HomeScreen(), // NavIndex.home    = 0
      _buildComingSoon('Catalogue', Icons.grid_view), // NavIndex.catalog = 1
      _buildComingSoon('Panier', Icons.shopping_cart), // NavIndex.cart    = 2
      ProfileScreen(user: widget.user), // NavIndex.profile = 3
    ];
  }

  // ── Placeholder pou screens ki poko fet ──
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'En cours de développement...',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
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

  // ════════════════════════════════════════════
  //  BOTTOM NAVIGATION BAR
  // ════════════════════════════════════════════
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: NavIndex.home,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Accueil',
              ),
              _buildNavItem(
                index: NavIndex.catalog,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: 'Catalogue',
              ),
              _buildNavItem(
                index: NavIndex.cart,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'Panier',
                badgeCount: _cartCount,
              ),
              _buildNavItem(
                index: NavIndex.profile,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  CHAK ITEM NAVIGATION (avèk animasyon)
  // ════════════════════════════════════════════
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
  }) {
    final bool isActive = _currentIndex == index;
    const Color activeColor = Color(0xFFE94560);
    const Color inactiveColor = Color.fromARGB(255, 194, 184, 184);

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? activeIcon : icon,
                    key: ValueKey(isActive),
                    color: isActive ? activeColor : inactiveColor,
                    size: 24,
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
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
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
                fontFamily: 'Poppins',
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  HELPER: Navige vè yon onglet depi nenpot lòt screen
//
//  ITILIZASYON:
//    NavigationHelper.goTo(context, NavIndex.cart);
// ══════════════════════════════════════════════════════════════
class NavigationHelper {
  static void goTo(BuildContext context, int index) {
    final state = context
        .findAncestorStateOfType<_MainNavigationWrapperState>();
    state?._onTabTapped(index);
  }

  static void updateCart(BuildContext context, int count) {
    final state = context
        .findAncestorStateOfType<_MainNavigationWrapperState>();
    state?.updateCartCount(count);
  }
}
