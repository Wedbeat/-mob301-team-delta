import 'package:flutter/material.dart';

import '../model/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 6),
            _buildOrderTracker(),
            const SizedBox(height: 6),
            _buildStatsRow(),
            const SizedBox(height: 6),
            _buildPromoCard(),
            const SizedBox(height: 6),
            _buildMenuSection(context),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFA3C3C), Color(0xFFFF6B00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mon Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Text(
                          user.avatarInitials,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFA3C3C),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFA3C3C), width: 1.5),
                          ),
                          child: const Icon(Icons.camera_alt, size: 13, color: Color(0xFFFA3C3C)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.phone,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: user.isVerified
                                ? Colors.white.withValues(alpha: 0.25)
                                : Colors.orange.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: user.isVerified ? Colors.white54 : Colors.orange,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                user.isVerified ? Icons.verified : Icons.warning_amber_rounded,
                                color: user.isVerified ? Colors.white : Colors.orange,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.isVerified ? 'Kont Verifye' : 'Pa verifye',
                                style: TextStyle(
                                  color: user.isVerified ? Colors.white : Colors.orange,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTracker() {
    final steps = [
      {'icon': Icons.shopping_bag_outlined, 'label': 'Kòmande'},
      {'icon': Icons.inventory_2_outlined, 'label': 'Prepare'},
      {'icon': Icons.local_shipping_outlined, 'label': 'Livrezon'},
      {'icon': Icons.rate_review_outlined, 'label': 'Evalye'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Swiv Kòmand Mwen',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: steps.asMap().entries.map((entry) {
              final i = entry.key;
              final step = entry.value;
              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (i > 0)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: i <= 1 ? const Color(0xFFFA3C3C) : const Color(0xFFEEEEEE),
                            ),
                          ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: i <= 1 ? const Color(0xFFFA3C3C) : const Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: i <= 1 ? const Color(0xFFFA3C3C) : const Color(0xFFDDDDDD),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            size: 17,
                            color: i <= 1 ? Colors.white : const Color(0xFFAAAAAA),
                          ),
                        ),
                        if (i < steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: i == 0 ? const Color(0xFFFA3C3C) : const Color(0xFFEEEEEE),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: i <= 1 ? const Color(0xFFFA3C3C) : const Color(0xFFAAAAAA),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {
        'value': '${user.orders}',
        'label': 'Kòmand',
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'value': '${user.pending}',
        'label': 'An Kou',
        'icon': Icons.pending_outlined,
      },
      {
        'value': '${user.reviews}',
        'label': 'Evalyasyon',
        'icon': Icons.star_outline,
      },
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final i = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: i < stats.length - 1
                    ? const Border(
                        right: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                      )
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    stat['icon'] as IconData,
                    color: const Color(0xFFFA3C3C),
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['value'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    stat['label'] as String,
                    style: const TextStyle(color: Color(0xFF999999), fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFA3C3C), Color(0xFFFF6B00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.yellow, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kode: LAKAY10',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '10% rabè sou pwochen kòmand ou',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Kopye',
              style: TextStyle(
                color: Color(0xFFFA3C3C),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final groups = [
      {
        'title': 'Kòmand & Livrezon',
        'items': [
          {
            'icon': Icons.shopping_bag_outlined,
            'label': 'Mes Commandes',
            'subtitle': "Voir l'historique",
            'badge': null,
          },
          {
            'icon': Icons.favorite_outline,
            'label': 'Favoris',
            'subtitle': '5 articles sauvegardés',
            'badge': '5',
          },
          {
            'icon': Icons.location_on_outlined,
            'label': 'Adresses',
            'subtitle': 'Gérer mes adresses',
            'badge': null,
          },
        ],
      },
      {
        'title': 'Kont & Peman',
        'items': [
          {
            'icon': Icons.payment_outlined,
            'label': 'Paiement',
            'subtitle': 'Cartes et méthodes',
            'badge': null,
          },
          {
            'icon': Icons.notifications_outlined,
            'label': 'Notifications',
            'subtitle': 'Gérer les alertes',
            'badge': '3',
          },
        ],
      },
      {
        'title': 'Sipò',
        'items': [
          {
            'icon': Icons.help_outline,
            'label': 'Aide & Support',
            'subtitle': 'FAQ et contact',
            'badge': null,
          },
          {
            'icon': Icons.policy_outlined,
            'label': 'Règlement & Confidentialité',
            'subtitle': 'Kondisyon itilizasyon',
            'badge': null,
          },
        ],
      },
    ];

    return Column(
      children: groups.map((group) {
        final items = group['items'] as List<Map<String, dynamic>>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
              child: Text(
                group['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF999999),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  final badge = item['badge'] as String?;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: const Color(0xFFFA3C3C),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        subtitle: Text(
                          item['subtitle'] as String,
                          style: const TextStyle(color: Color(0xFF999999), fontSize: 11),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (badge != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFA3C3C),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  badge,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (badge != null) const SizedBox(width: 6),
                            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 18),
                          ],
                        ),
                        onTap: () {},
                      ),
                      if (i < items.length - 1)
                        const Divider(
                          height: 1,
                          indent: 60,
                          endIndent: 14,
                          color: Color(0xFFF5F5F5),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: onLogout,
        child: Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Color(0xFFFA3C3C), size: 18),
              SizedBox(width: 8),
              Text(
                'Dekonekte',
                style: TextStyle(
                  color: Color(0xFFFA3C3C),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}