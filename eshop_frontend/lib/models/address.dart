class Address {
  final String? id;
  final String userId;
  final String name;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String phone;
  final bool isDefault;

  Address({
    this.id,
    required this.userId,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.phone,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipCode: json['zipCode'],
      phone: json['phone'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'phone': phone,
      'isDefault': isDefault,
    };
  }
}
