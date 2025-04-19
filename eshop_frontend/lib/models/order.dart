import 'address.dart';

class Order {
  final String? id; // Make id nullable
  final String? userId; // Make userId nullable
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final Address shippingAddress;
  final String paymentMethod;
  final String? trackingNumber;
  final String? courier;
  final String? deliveryStatus;
  final DateTime? estimatedDeliveryDate;
  final DateTime? deliveredAt;
  final List<TrackingUpdate>? trackingHistory;

  Order({
    this.id, // Update constructor
    this.userId, // Update constructor
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
    this.trackingNumber,
    this.courier,
    this.deliveryStatus,
    this.estimatedDeliveryDate,
    this.deliveredAt,
    this.trackingHistory,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        id: json['id']?.toString(),
        userId: json['userId']?.toString(),
        items: ((json['items'] as List?) ?? [])
            .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        total: (json['total'] as num?)?.toDouble() ?? 0.0,
        status: json['status']?.toString() ?? 'PENDING',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        shippingAddress: json['shippingAddress'] != null
            ? Address.fromJson(json['shippingAddress'] as Map<String, dynamic>)
            : Address(
                userId: '',
                name: 'N/A',
                street: '',
                city: '',
                state: '',
                country: '',
                zipCode: '',
                phone: '',
              ),
        paymentMethod: json['paymentMethod']?.toString() ?? 'Unknown',
        trackingNumber: json['trackingNumber']?.toString(),
        courier: json['courier']?.toString(),
        deliveryStatus: json['deliveryStatus']?.toString(),
        estimatedDeliveryDate: json['estimatedDeliveryDate'] != null
            ? DateTime.parse(json['estimatedDeliveryDate'])
            : null,
        deliveredAt: json['deliveredAt'] != null
            ? DateTime.parse(json['deliveredAt'])
            : null,
        trackingHistory: (json['trackingHistory'] as List?)
            ?.map((update) =>
                TrackingUpdate.fromJson(update as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('Error parsing order: $e');
      print('Order JSON: $json');
      rethrow;
    }
  }
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;
  final String productName;
  final String productImage; // Add imageUrl field

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.productImage, // Add to constructor
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      productName: json['productName']?.toString() ?? 'Unknown Product',
      productImage: json['productImage']?.toString() ?? '', // Parse from JSON
    );
  }
}

class TrackingUpdate {
  final DateTime timestamp;
  final String status;
  final String? location;
  final String? description;

  TrackingUpdate({
    required this.timestamp,
    required this.status,
    this.location,
    this.description,
  });

  factory TrackingUpdate.fromJson(Map<String, dynamic> json) {
    return TrackingUpdate(
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
      location: json['location'],
      description: json['description'],
    );
  }
}
