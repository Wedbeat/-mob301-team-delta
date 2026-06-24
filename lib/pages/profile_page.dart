import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Mon Profil',
            style: TextStyle(
                color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Profil ──
            _buildProfileHeader(),

            const SizedBox(height: 16),

            // ── Stats ──
            _buildStatsRow(),

            const SizedBox(height: 16),

            // ── Menu Options ──
            _buildMenuSection(context),

            const SizedBox(height: 24),

            // ── Bouton Déconnexion ──
            _buildLogoutButton(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF1A1A2E),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE94560),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jean Dupont',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E))),
              SizedBox(height: 4),
              Text('jean.dupont@email.com',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.verified, color: Color(0xFFE94560), size: 16),
                  SizedBox(width: 4),
                  Text('Compte Vérifié',
                      style: TextStyle(
                          color: Color(0xFFE94560),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'value': '12', 'label': 'Commandes'},
      {'value': '3', 'label': 'En cours'},
      {'value': '8', 'label': 'Avis'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) {
          return Column(
            children: [
              Text(stat['value']!,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E))),
              Text(stat['label']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.shopping_bag_outlined,
        'label': 'Mes Commandes',
        'subtitle': 'Voir l\'historique'
      },
      {
        'icon': Icons.favorite_outline,
        'label': 'Favoris',
        'subtitle': '5 articles sauvegardés'
      },
      {
        'icon': Icons.location_on_outlined,
        'label': 'Adresses',
        'subtitle': 'Gérer mes adresses'
      },
      {
        'icon': Icons.payment_outlined,
        'label': 'Paiement',
        'subtitle': 'Cartes et méthodes'
      },
      {
        'icon': Icons.notifications_outlined,
        'label': 'Notifications',
        'subtitle': 'Gérer les alertes'
      },
      {
        'icon': Icons.help_outline,
        'label': 'Aide & Support',
        'subtitle': 'FAQ et contact'
      },
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94560),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item['icon'] as IconData,
                      color: const Color(0xFFE94560), size: 22),
                ),
                title: Text(item['label'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E))),
                subtitle: Text(item['subtitle'] as String,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
              if (entry.key < menuItems.length - 1)
                const Divider(height: 1, indent: 60),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: Color(0xFFE94560)),
        label: const Text('Déconnexion',
            style: TextStyle(color: Color(0xFFE94560))),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: Color(0xFFE94560)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}