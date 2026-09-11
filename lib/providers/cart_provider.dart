import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../storage/local_storage.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> cartItems = [];

  Future<void> loadCart() async {
    final savedCart = await LocalStorage.getCart();

    if (savedCart == null) {
      return;
    }

    try {
      final List data = jsonDecode(savedCart);

      cartItems = data.map((item) => CartItemModel.fromJson(item)).toList();

      notifyListeners();
    } catch (e) {
      cartItems = [];
    }
  }

  Future<void> addToCart(ProductModel product) async {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      if (cartItems[index].quantity >= product.stock) {
        return;
      }

      cartItems[index].quantity++;
    } else {
      if (product.stock <= 0) {
        return;
      }

      cartItems.add(CartItemModel(product: product, quantity: 1));
    }

    await _saveCart();

    notifyListeners();
  }

  Future<void> increaseQuantity(int index) async {
    final item = cartItems[index];

    if (item.quantity >= item.product.stock) {
      return;
    }

    item.quantity++;

    await _saveCart();

    notifyListeners();
  }

  Future<void> decreaseQuantity(int index) async {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }

    await _saveCart();

    notifyListeners();
  }

  Future<void> removeFromCart(int index) async {
    cartItems.removeAt(index);

    await _saveCart();

    notifyListeners();
  }

  double get totalAmount {
    return cartItems.fold(0, (total, item) => total + item.total);
  }

  int get cartCount {
    return cartItems.fold(0, (total, item) => total + item.quantity);
  }

  Future<void> clearCart() async {
    cartItems.clear();

    await _saveCart();

    notifyListeners();
  }

  Future<void> _saveCart() async {
    final data = cartItems.map((item) => item.toJson()).toList();

    await LocalStorage.saveCart(jsonEncode(data));
  }
}
