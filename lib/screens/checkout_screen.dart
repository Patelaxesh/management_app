import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/checkout_service.dart';
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

  final CheckoutService _checkoutService = CheckoutService();

  static const Color primaryGreen = Color(0xFF2E7D32);

  bool _isLoading = false;

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

    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();

    final userId = authProvider.currentUserId;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User session not found. Please login again.'),
        ),
      );
      return;
    }

    if (cartProvider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Process checkout for logged-in user
      await _checkoutService.checkout(
        userId: userId,
        cartItems: cartProvider.cartItems,
      );

      // Clear cart only after successful checkout
      await cartProvider.clearCart();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Order Successful'),
            content: const Text(
              'Your order has been placed successfully.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductListScreen(),
                    ),
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
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
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
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
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

              TextFormField(
                controller: _addressController,
                textInputAction: TextInputAction.next,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
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

              TextFormField(
                controller: _cityController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(),
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

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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