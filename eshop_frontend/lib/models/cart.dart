class CartData {
  final String? id;
  final String userId;
  final List<CartItemData> items;
  final double total;

  CartData({
    this.id,
    required this.userId,
    required this.items,
    required this.total,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => CartItemData.fromJson(item))
          .toList(),
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}

class CartItemData {
  final String productId;
  final int quantity;
  final double price;

  CartItemData({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
