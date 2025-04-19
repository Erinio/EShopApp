import 'package:flutter/material.dart';

enum PaymentMethod {
  card,
  paypal,
  applePay,
}

class PaymentMethodHelper {
  static String getName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }

  static IconData getIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.paypal:
        return Icons.payment;
      case PaymentMethod.applePay:
        return Icons.apple;
    }
  }
}
