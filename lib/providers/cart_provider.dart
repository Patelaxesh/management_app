import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../storage/local_storage.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> cartItems = [];
  String _currentUsername = '';

  // Call this after successful login / when restoring session
  Future<void> setUser(String username) async {
    _currentUsername = username;
    await loadCart();
  }

  Future<void> loadCart() async {
    if (_currentUsername.isEmpty) {
      cartItems = [];
      notifyListeners();
      return;
    }

    final savedCart = await LocalStorage.getCart(_currentUsername);

    if (savedCart == null) {
      cartItems = [];
      notifyListeners();
      return;
    }

    try {
      final List data = jsonDecode(savedCart);
      cartItems = data.map((item) => CartItemModel.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      cartItems = [];
      notifyListeners();
    }
  }

  Future<void> addToCart(ProductModel product) async {
    if (_currentUsername.isEmpty) return;

    final index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      if (cartItems[index].quantity >= product.stock) return;
      cartItems[index].quantity++;
    } else {
      if (product.stock <= 0) return;
      cartItems.add(CartItemModel(product: product, quantity: 1));
    }

    await _saveCart();
    notifyListeners();
  }

  Future<void> increaseQuantity(int index) async {
    if (_currentUsername.isEmpty) return;

    final item = cartItems[index];
    if (item.quantity >= item.product.stock) return;

    item.quantity++;
    await _saveCart();
    notifyListeners();
  }

  Future<void> decreaseQuantity(int index) async {
    if (_currentUsername.isEmpty) return;

    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }

    await _saveCart();
    notifyListeners();
  }

  Future<void> removeFromCart(int index) async {
    if (_currentUsername.isEmpty) return;

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
    if (_currentUsername.isEmpty) return;

    final data = cartItems.map((item) => item.toJson()).toList();
    await LocalStorage.saveCart(_currentUsername, jsonEncode(data));
  }

  // Optional – call on logout
  Future<void> clearUser() async {
    _currentUsername = '';
    cartItems = [];
    notifyListeners();
  }
}