import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  double get total {
    return product.price * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'discountPercentage': product.discountPercentage,
        'rating': product.rating,
        'stock': product.stock,
        'brand': product.brand,
        'category': product.category,
        'images': product.images,
      },
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }
}
