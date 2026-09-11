import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),

      body: cart.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Cart Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.images.isNotEmpty
                                      ? item.product.images.first
                                      : '',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return const SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Product details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      '₹${item.product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: primaryGreen,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    // Quantity
                                    Row(
                                      children: [
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () {
                                            cart.decreaseQuantity(index);
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),

                                        Text(
                                          item.quantity.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () {
                                            cart.increaseQuantity(index);
                                          },
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Remove
                              IconButton(
                                tooltip: 'Remove',
                                onPressed: () {
                                  cart.removeFromCart(index);
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total + Checkout
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            '₹${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Checkout',
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
              ],
            ),
    );
  }
}
