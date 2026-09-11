import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/loading_widget.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () =>
          context.read<ProductProvider>().fetchProductDetails(widget.productId),
    );
  }

  Future<void> _addToCart() async {
    final product = context.read<ProductProvider>().selectedProduct;

    if (product == null) {
      return;
    }

    if (product.stock <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product is out of stock')));
      return;
    }

    await context.read<CartProvider>().addToCart(product);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to cart'),
        backgroundColor: primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    // Loading
    if (provider.isDetailLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    // Error
    if (provider.detailErrorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              provider.detailErrorMessage!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final product = provider.selectedProduct;

    // Product not found
    if (product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: product.images.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    : PageView.builder(
                        itemCount: product.images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            product.images[index],
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) {
                              return const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Product Name
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Price
            Text(
              '₹${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              product.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 20),

            // Product Information
            _buildInfoRow(
              'Discount',
              '${product.discountPercentage.toStringAsFixed(1)}%',
            ),

            _buildInfoRow('Rating', '⭐ ${product.rating}'),

            _buildInfoRow('Stock', product.stock.toString()),

            _buildInfoRow('Brand', product.brand),

            _buildInfoRow('Category', product.category),

            const SizedBox(height: 20),

            // Add To Cart
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: product.stock > 0 ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
