import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Importe tes screens ici (ajuste les chemins
//  selon ta structure de dossiers)
// ─────────────────────────────────────────────
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

// ── Les 2 autres screens (tes coéquipiers) ──
// import 'screens/catalog/catalog_screen.dart';
// import 'screens/cart/cart_screen.dart';

void main() {
  runApp(const ShopApp());
}

// ─────────────────────────────────────────────
//  Root Widget
// ─────────────────────────────────────────────
class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopApp',
      debugShowCheckedModeBanner: false,

      // ── Thème Global ──
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1A1A2E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE94560),
          primary: const Color(0xFF1A1A2E),
          secondary: const Color(0xFFE94560),
          surface: Colors.white,
        //  background: const Color(0xFFF5F5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),

        // ── Typographie ──
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF555555),
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),

        // ── AppBar ──
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A1A2E),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
          iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
        ),

        // ── ElevatedButton ──
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE94560),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),

        // ── OutlinedButton ──
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE94560),
            side: const BorderSide(color: Color(0xFFE94560)),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),

        // ── InputDecoration (TextFields) ──
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFE94560), width: 1.5),
          ),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),

        // ── BottomNavigationBar ──
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFE94560),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
          ),
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      // ── Écran de démarrage ──
      home: const MainNavigationWrapper(),
    );
  }
}

// ─────────────────────────────────────────────
//  Navigation principale (BottomNavigationBar)
//  Connecte les 4 screens de l'équipe
// ─────────────────────────────────────────────
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  // ── Liste des screens (1 par coéquipier) ──
  final List<Widget> _screens = const [
    HomeScreen(),       // Toi — Accueil
    // CatalogScreen(), // Coéquipier 2 — Décommente quand prêt
    Placeholder(color: Color(0xFFF5F5F5)),  // placeholder Catalogue
    // CartScreen(),    // Coéquipier 3 — Décommente quand prêt
    Placeholder(color: Color(0xFFF5F5F5)),  // placeholder Panier
    ProfileScreen(),    // Toi — Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Catalogue',
          ),
          // Badge panier
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE94560),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            activeIcon: const Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
  
}
