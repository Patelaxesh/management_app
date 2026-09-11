import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'product_list_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();

    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<CartProvider>().clearCart();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Order Successful'),
          content: const Text('Your order has been placed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close success dialog
                Navigator.pop(dialogContext);

                // Go directly to Product List
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: primaryGreen),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  final name = value?.trim() ?? '';

                  if (name.isEmpty) {
                    return 'Please enter your name';
                  }

                  if (name.length < 2) {
                    return 'Name must be at least 2 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Mobile
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  counterText: '',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  final mobile = value?.trim() ?? '';

                  if (mobile.isEmpty) {
                    return 'Please enter your mobile number';
                  }

                  if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
                    return 'Enter a valid 10 digit mobile number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                textInputAction: TextInputAction.next,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  final address = value?.trim() ?? '';

                  if (address.isEmpty) {
                    return 'Please enter your address';
                  }

                  if (address.length < 5) {
                    return 'Please enter a valid address';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // City
              TextFormField(
                controller: _cityController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  final city = value?.trim() ?? '';

                  if (city.isEmpty) {
                    return 'Please enter your city';
                  }

                  if (city.length < 2) {
                    return 'City must be at least 2 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Pincode
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  prefixIcon: Icon(Icons.pin_drop_outlined),
                  counterText: '',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  final pincode = value?.trim() ?? '';

                  if (pincode.isEmpty) {
                    return 'Please enter your pincode';
                  }

                  if (!RegExp(r'^[0-9]{6}$').hasMatch(pincode)) {
                    return 'Enter a valid 6 digit pincode';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Place Order
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
