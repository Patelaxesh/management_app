import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';
import 'wishlist_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  Future<void> _logout() async {
    // Clear user data from providers
    await context.read<AuthProvider>().logout();
    await context.read<CartProvider>().clearUser();
    await context.read<WishlistProvider>().clearUser();

    if (!mounted) return;

    // Go back to Login screen and clear navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          // Wishlist
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
            icon: const Icon(Icons.favorite_border),
          ),

          // Cart
          IconButton(
            tooltip: 'Cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            icon: Badge(
              backgroundColor: Colors.red,
              textColor: Colors.white,
              label: Text(
                cartProvider.cartCount.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),

          // Logout
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              onChanged: productProvider.search,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search, color: primaryGreen),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
              ),
            ),
          ),

          // Product list
          Expanded(child: _buildBody(productProvider)),
        ],
      ),
    );
  }

  Widget _buildBody(ProductProvider provider) {
    if (provider.isLoading) {
      return const LoadingWidget();
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.fetchProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: provider.fetchProducts,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        itemCount: provider.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = provider.filteredProducts[index];
          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(productId: product.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}