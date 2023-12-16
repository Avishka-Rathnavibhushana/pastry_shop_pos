class SupplierItem {
  String name;
  String date;
  int sold;
  double salePrice;
  double purchasePrice;
  int qty;
  int? balance;
  double? salePriceTotal;
  double? purchasePriceTotal;
  double? cheap;

  SupplierItem({
    required this.name,
    required this.date,
    required this.sold,
    required this.salePrice,
    required this.purchasePrice,
    required this.qty,
    this.balance,
    this.salePriceTotal,
    this.purchasePriceTotal,
    this.cheap,
  });

  // Factory constructor to create a SupplierItem object from a map (e.g., from Firestore)
  factory SupplierItem.fromMap(Map<String, dynamic> map) {
    return SupplierItem(
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      sold: map['sold'] ?? 0,
      qty: map['qty'] ?? 0,
      salePrice: (map['salePrice'] ?? 0.0).toDouble(),
      purchasePrice: (map['purchasePrice'] ?? 0.0).toDouble(),
      balance: map['balance'],
      salePriceTotal: (map['salePriceTotal'] ?? 0.0).toDouble(),
      purchasePriceTotal: (map['purchasePriceTotal'] ?? 0.0).toDouble(),
      cheap: (map['cheap'] ?? 0.0).toDouble(),
    );
  }

  // Method to convert the SupplierItem object to a map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'sold': sold,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      'qty': qty,
      'balance': balance,
      'salePriceTotal': salePriceTotal,
      'purchasePriceTotal': purchasePriceTotal,
      'cheap': cheap,
    };
  }

  // Method to convert a subset of SupplierItem fields to a map
  Map<String, dynamic> toMapSubset() {
    return {
      'name': name,
      'date': date,
      'sold': sold,
      'qty': qty,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
    };
  }

  // Factory constructor to create a SupplierItem object from a map with a subset of fields
  factory SupplierItem.fromMapSubset(Map<String, dynamic> map) {
    return SupplierItem(
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      sold: map['sold'] ?? 0,
      qty: map['qty'] ?? 0,
      salePrice: (map['salePrice'] ?? 0.0).toDouble(),
      purchasePrice: (map['purchasePrice'] ?? 0.0).toDouble(),
    );
  }
}
