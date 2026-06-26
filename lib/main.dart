import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'main_navigation_wrapper.dart';
import 'model/user_model.dart';

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ti Mache Lakay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE94560),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/main') {
          final user = settings.arguments as UserModel;

          return MaterialPageRoute(
            builder: (_) => MainNavigationWrapper(user: user),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      },
    );
  }
}