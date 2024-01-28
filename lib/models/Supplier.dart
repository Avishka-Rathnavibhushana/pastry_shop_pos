class Supplier {
  String name;
  String address;
  String tel;
  List<String> shops;
  List<String> items;

  Supplier({
    required this.name,
    required this.address,
    required this.tel,
    required this.shops,
    required this.items,
  });

  // Factory constructor to create a Supplier object from a map (e.g., from Firestore)
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      tel: map['tel'] ?? '',
      shops: List<String>.from(map['shops'] ?? []),
      items: List<String>.from(map['items'] ?? []),
    );
  }

  // Method to convert the Supplier object to a map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'tel': tel,
      'shops': shops,
      'items': items,
    };
  }
}
