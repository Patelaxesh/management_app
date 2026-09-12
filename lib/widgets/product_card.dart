
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
final ProductModel product;
final VoidCallback onTap;

const ProductCard({
super.key,
required this.product,
required this.onTap,
});

@override
Widget build(BuildContext context) {
final wishlistProvider = context.watch<WishlistProvider>();
final cartProvider = context.watch<CartProvider>();

final isWishlisted =
wishlistProvider.isInWishlist(product.id);

final isInCart = cartProvider.cartItems.any(
(item) => item.product.id == product.id,
);

final isOutOfStock = product.stock <= 0;

return Card(
margin: const EdgeInsets.only(bottom: 12),
elevation: 1,
shadowColor: Colors.black12,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
clipBehavior: Clip.antiAlias,
child: InkWell(
onTap: onTap,
child: Padding(
padding: const EdgeInsets.all(12),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// =========================
// Product Image
// =========================
Container(
width: 95,
height: 110,
decoration: BoxDecoration(
color: Colors.grey.shade100,
borderRadius: BorderRadius.circular(10),
),
clipBehavior: Clip.antiAlias,
child: Image.network(
product.images.isNotEmpty
? product.images.first
    : '',
fit: BoxFit.cover,
loadingBuilder: (
context,
child,
loadingProgress,
) {
if (loadingProgress == null) {
return child;
}

return const Center(
child: SizedBox(
width: 22,
height: 22,
child: CircularProgressIndicator(
strokeWidth: 2,
),
),
);
},
errorBuilder: (_, __, ___) {
return Icon(
Icons.image_outlined,
size: 34,
color: Colors.grey.shade400,
);
},
),
),

const SizedBox(width: 12),

// =========================
// Product Information
// =========================
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Product Title + Wishlist
Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Expanded(
child: Text(
product.title,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 15.5,
fontWeight: FontWeight.w700,
height: 1.25,
),
),
),

const SizedBox(width: 4),

// Wishlist Button
Material(
color: isWishlisted
? Colors.red.withValues(alpha: 0.08)
    : Colors.grey.withValues(alpha: 0.08),
shape: const CircleBorder(),
child: InkWell(
customBorder: const CircleBorder(),
onTap: () async {
await context
    .read<WishlistProvider>()
    .toggleWishlist(product);
},
child: Padding(
padding: const EdgeInsets.all(7),
child: Icon(
isWishlisted
? Icons.favorite
    : Icons.favorite_border,
size: 19,
color: isWishlisted
? Colors.red
    : Colors.grey.shade600,
),
),
),
),
],
),

const SizedBox(height: 6),

// Price
Text(
'₹${product.price.toStringAsFixed(2)}',
style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
color: Color(0xFF2E7D32),
),
),

const SizedBox(height: 5),

// Rating + Category
Row(
children: [
const Icon(
Icons.star,
size: 16,
color: Colors.amber,
),
const SizedBox(width: 3),
Text(
'${product.rating}',
style: const TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
),
),
const SizedBox(width: 10),
Flexible(
child: Text(
product.category,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: 12.5,
color: Colors.grey.shade600,
),
),
),
],
),

const SizedBox(height: 8),

// =========================
// Cart Status / Button
// =========================
if (isInCart)
Container(
height: 38,
width: double.infinity,
alignment: Alignment.center,
decoration: BoxDecoration(
color: const Color(0xFFE8F5E9),
borderRadius: BorderRadius.circular(9),
),
child: const Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.check_circle_outline,
size: 18,
color: Color(0xFF2E7D32),
),
SizedBox(width: 7),
Text(
'Added to Cart',
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
color: Color(0xFF2E7D32),
),
),
],
),
)
else if (isOutOfStock)
Container(
height: 38,
width: double.infinity,
alignment: Alignment.center,
decoration: BoxDecoration(
color: Colors.grey.shade100,
borderRadius: BorderRadius.circular(9),
),
child: Text(
'Out of Stock',
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
color: Colors.grey.shade600,
),
),
)
else
SizedBox(
height: 38,
width: double.infinity,
child: ElevatedButton(
onPressed: () async {
await context
    .read<CartProvider>()
    .addToCart(product);

if (!context.mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(
const SnackBar(
content: Text(
'Product added to cart',
),
behavior:
SnackBarBehavior.floating,
),
);
},
style: ElevatedButton.styleFrom(
backgroundColor:
const Color(0xFF2E7D32),
foregroundColor: Colors.white,
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(9),
),
),
child: const Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Icon(
Icons.shopping_cart_outlined,
size: 18,
),
SizedBox(width: 7),
Text(
'Add to Cart',
style: TextStyle(
fontSize: 13.5,
fontWeight: FontWeight.w600,
),
),
],
),
),
),
],
),
),
],
),
),
),
);
}
}
