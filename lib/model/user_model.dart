class UserModel {
  final String fullName;
  final String email;
  final String phone;
  final String avatarInitials;
  final bool isVerified;
  final int orders;
  final int pending;
  final int reviews;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatarInitials,
    required this.isVerified,
    required this.orders,
    required this.pending,
    required this.reviews,
  });
}

const Map<String, Map<String, dynamic>> mockUsers = {
  'jean.dupont@gmail.com': {
    'password': 'jean1234',
    'user': UserModel(
      fullName: 'Jean Dupont',
      email: 'jean.dupont@gmail.com',
      phone: '+509 3700-0001',
      avatarInitials: 'JD',
      isVerified: true,
      orders: 0,
      pending: 0,
      reviews: 0,
    ),
  },
  'marie.paul@gmail.com': {
    'password': 'marie5678',
    'user': UserModel(
      fullName: 'Marie Paul',
      email: 'marie.paul@gmail.com',
      phone: '+509 3700-0002',
      avatarInitials: 'MP',
      isVerified: true,
      orders: 0,
      pending: 0,
      reviews: 0,
    ),
  },
  'pierre.louis@gmail.com': {
    'password': 'pierre999',
    'user': UserModel(
      fullName: 'Pierre Louis',
      email: 'pierre.louis@gmail.com',
      phone: '+509 3700-0003',
      avatarInitials: 'PL',
      isVerified: false,
      orders: 0,
      pending: 0,
      reviews: 0,
    ),
  },
};