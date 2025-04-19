import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../services/address_service.dart';
import '../models/address.dart';
import 'addresses_screen.dart';
import '../models/payment_method.dart';
import '../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  bool _isLoading = true;
  Address? _selectedAddress;
  List<Address> _addresses = [];
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  bool _showCardForm = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final addressService = AddressService(authToken: authProvider.token);
      final addresses =
          await addressService.getUserAddresses(authProvider.userId!);
      setState(() {
        _addresses = addresses;
        // Find default address or use the first one if available
        _selectedAddress =
            addresses.where((addr) => addr.isDefault).firstOrNull ??
                (addresses.isNotEmpty ? addresses.first : null);
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading addresses: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Widget _buildAddressSection() {
    if (_addresses.isEmpty) {
      return ListTile(
        title: const Text('No addresses found'),
        trailing: TextButton(
          onPressed: _addNewAddress,
          child: const Text('Add Address'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _addNewAddress,
                child: const Text('Add New'),
              ),
            ],
          ),
        ),
        ...List.generate(_addresses.length, (index) {
          final address = _addresses[index];
          return RadioListTile<Address>(
            value: address,
            groupValue: _selectedAddress,
            title: Text(address.name),
            subtitle: Text(
              '${address.street}, ${address.city}, ${address.state} ${address.zipCode}',
            ),
            onChanged: (Address? value) {
              setState(() => _selectedAddress = value);
            },
          );
        }),
      ],
    );
  }

  Future<void> _addNewAddress() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddressesScreen()),
    );

    if (result == true) {
      _loadAddresses();
    }
  }

  Future<void> _submitOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final orderService = OrderService(authToken: authProvider.token);

        await orderService.createOrder(
          authProvider.userId!,
          _selectedAddress!.id!,
          _selectedPaymentMethod.toString().split('.').last,
        );

        // Clear cart after successful order
        Provider.of<CartProvider>(context, listen: false).clear();

        if (mounted) {
          // Show success message and navigate back to home
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...PaymentMethod.values.map((method) => RadioListTile<PaymentMethod>(
              value: method,
              groupValue: _selectedPaymentMethod,
              title: Row(
                children: [
                  Icon(
                    PaymentMethodHelper.getIcon(method),
                    color: method == _selectedPaymentMethod
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Text(PaymentMethodHelper.getName(method)),
                ],
              ),
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                  _showCardForm = value == PaymentMethod.card;
                });
              },
            )),
        if (_showCardForm) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
            validator: (v) => _showCardForm && (v?.isEmpty ?? true)
                ? 'Please enter card number'
                : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      _showCardForm && (v?.isEmpty ?? true) ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      _showCardForm && (v?.isEmpty ?? true) ? 'Required' : null,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildAddressSection(),
                  const Divider(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPaymentSection(),
                        const SizedBox(height: 20),
                        Text(
                          'Total Amount: \$${cart.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitOrder,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Pay with ${PaymentMethodHelper.getName(_selectedPaymentMethod)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
