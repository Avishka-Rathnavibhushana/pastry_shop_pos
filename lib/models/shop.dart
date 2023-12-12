class Shop {
  String name;
  String address;
  String tel;
  List<String> suppliers;

  Shop({
    required this.name,
    required this.address,
    required this.tel,
    required this.suppliers,
  });

  // Factory constructor to create a Shop object from a map (e.g., from Firestore)
  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      tel: map['tel'] ?? '',
      suppliers: List<String>.from(map['suppliers'] ?? []),
    );
  }

  // Method to convert the Shop object to a map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'tel': tel,
      'suppliers': suppliers,
    };
  }
}
