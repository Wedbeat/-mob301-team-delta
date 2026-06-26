import 'package:flutter/material.dart';

<<<<<<< HEAD
// ══════════════════════════════════════════════════════════
//  IMPORTE SCREENS YO — chak koleg mete pa yo lè yo fin fet
// ══════════════════════════════════════════════════════════
import 'pages/home_page.dart';           // Ou  — Accueil
import 'pages/profile_page.dart';     // Ou  — Profile
// import 'screens/catalog/catalog_screen.dart';  // Koleg 2 — Catalogue
// import 'screens/cart/cart_screen.dart';        // Koleg 3 — Panier


// ══════════════════════════════════════════════════════════
//  KONSTANT: Enndèks chak onglet (evite magic numbers)
// ══════════════════════════════════════════════════════════
class NavIndex {
  static const int home    = 0;
  static const int catalog = 1;
  static const int cart    = 2;
  static const int profile = 3;
}


// ══════════════════════════════════════════════════════════
//  MAIN NAVIGATION WRAPPER
//  • IndexedStack → chak screen rete nan memwa (pa rechaje)
//  • cartCount    → badge dinamik sou ikòn panier
// ══════════════════════════════════════════════════════════
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});
=======
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
>>>>>>> main

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
<<<<<<< HEAD

  // ── Index kouran ──
  int _currentIndex = NavIndex.home;

  // ── Kantite atik nan panier (chanje sa ak state management ou) ──
  int _cartCount = 3;

  // ── Liste screens — chak koleg ajoute pa yo ──
  late final List<Widget> _screens = [
    const HomeScreen(),      // NavIndex.home    = 0
    _buildComingSoon('Catalogue', Icons.grid_view), // NavIndex.catalog = 1
    _buildComingSoon('Panier', Icons.shopping_cart), // NavIndex.cart    = 2
    const ProfileScreen(),   // NavIndex.profile = 3
  ];

  // ── Placeholder pou screens ki poko fet ──
=======
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

>>>>>>> main
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
<<<<<<< HEAD
                fontSize: 20,
=======
                fontSize: 22,
>>>>>>> main
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
<<<<<<< HEAD
              'En cours de développement...',
              style: TextStyle(color: Colors.grey, fontSize: 13),
=======
              'Paj sa a ap vini byento...',
              style: TextStyle(color: Colors.grey),
>>>>>>> main
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  // ── Chanje onglet ──
  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  // ── Mete jou badge panier (rele sa depi nenpot screen) ──
  void updateCartCount(int count) {
    setState(() => _cartCount = count);
=======
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
>>>>>>> main
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      // ── Corps: chak screen rete vivan, pa rechaje ──
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ── Baz navigasyon ──
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }


  // ════════════════════════════════════════════
  //  BOTTOM NAVIGATION BAR
  // ════════════════════════════════════════════
=======
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

>>>>>>> main
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
<<<<<<< HEAD
            color: Colors.black,
            blurRadius: 16,
            offset: const Offset(0, -4),
=======
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
>>>>>>> main
          ),
        ],
      ),
      child: SafeArea(
<<<<<<< HEAD
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
=======
        child: SizedBox(
          height: 58,
>>>>>>> main
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: NavIndex.home,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
<<<<<<< HEAD
                label: 'Accueil',
              ),
              _buildNavItem(
                index: NavIndex.catalog,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: 'Catalogue',
=======
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
>>>>>>> main
              ),
              _buildNavItem(
                index: NavIndex.cart,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
<<<<<<< HEAD
                label: 'Panier',
                badgeCount: _cartCount,  // ← badge dinamik
=======
                label: 'Panye',
                badgeCount: CartManager.count,
>>>>>>> main
              ),
              _buildNavItem(
                index: NavIndex.profile,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
<<<<<<< HEAD
                label: 'Profil',
=======
                label: 'Mwen',
>>>>>>> main
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD

  // ════════════════════════════════════════════
  //  CHAK ITEM NAVIGATION (avèk animasyon)
  // ════════════════════════════════════════════
=======
>>>>>>> main
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
  }) {
    final bool isActive = _currentIndex == index;
<<<<<<< HEAD
    const Color activeColor   = Color(0xFFE94560);
=======
    const Color activeColor = Color(0xFFE94560);
>>>>>>> main
    const Color inactiveColor = Colors.grey;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
<<<<<<< HEAD
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icône + badge ──
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

                // Badge (afiche sèlman si > 0)
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

            // ── Label ──
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
                fontFamily: 'Poppins',
              ),
              child: Text(label),
            ),
          ],
        ),
=======
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
>>>>>>> main
      ),
    );
  }
}

<<<<<<< HEAD

// ══════════════════════════════════════════════════════════
//  HELPER: Navige vè yon onglet depi nenpot lòt screen
//
//  ITILIZASYON:
//    NavigationHelper.goTo(context, NavIndex.cart);
// ══════════════════════════════════════════════════════════
=======
>>>>>>> main
class NavigationHelper {
  static void goTo(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationWrapperState>();
    state?._onTabTapped(index);
  }
<<<<<<< HEAD

  static void updateCart(BuildContext context, int count) {
    final state = context.findAncestorStateOfType<_MainNavigationWrapperState>();
    state?.updateCartCount(count);
  }
}
=======
}
>>>>>>> main
