class User {
  String username;
  String role; // ADMIN, CASHIER, ACCCOUNTANT
  String password;
  String address;
  String tel;
  String? shop;

  User({
    required this.username,
    required this.role,
    required this.password,
    required this.address,
    required this.tel,
    this.shop,
  });

  // Factory constructor to create a User object from a map (e.g., from Firestore)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      role: map['role'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      tel: map['tel'] ?? '',
      shop: map['shop'] ?? '',
    );
  }

  // Method to convert the User object to a map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
      'password': password,
      'address': address,
      'tel': tel,
      'shop': shop,
    };
  }
}
