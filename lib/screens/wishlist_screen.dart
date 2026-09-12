import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: wishlist.isEmpty
          ? const Center(
        child: Text(
          'Your wishlist is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final product = wishlist[index];
          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailScreen(productId: product.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}