class Supplier {
  String name;
  String address;
  String tel;
  String shop;
  List<String> items;

  Supplier({
    required this.name,
    required this.address,
    required this.tel,
    required this.shop,
    required this.items,
  });

  // Factory constructor to create a Supplier object from a map (e.g., from Firestore)
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      tel: map['tel'] ?? '',
      shop: map['shop'] ?? '',
      items: List<String>.from(map['items'] ?? []),
    );
  }

  // Method to convert the Supplier object to a map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'tel': tel,
      'shop': shop,
      'items': items,
    };
  }
}
