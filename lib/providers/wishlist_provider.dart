import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final Map<String, List<ProductModel>> _userWishlists = {};
  String _currentUsername = '';

  List<ProductModel> get wishlist {
    return _userWishlists[_currentUsername] ?? [];
  }

  Future<void> setUser(String username) async {
    _currentUsername = username;
    _userWishlists.putIfAbsent(username, () => []);
    notifyListeners();
  }

  bool isInWishlist(int productId) {
    return wishlist.any((product) => product.id == productId);
  }

  Future<void> toggleWishlist(ProductModel product) async {
    if (_currentUsername.isEmpty) return;

    final userWishlist = _userWishlists[_currentUsername]!;

    final index = userWishlist.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      userWishlist.removeAt(index);
    } else {
      userWishlist.add(product);
    }

    notifyListeners();
  }

  Future<void> removeFromWishlist(int productId) async {
    if (_currentUsername.isEmpty) return;

    _userWishlists[_currentUsername]?.removeWhere(
          (product) => product.id == productId,
    );
    notifyListeners();
  }

  Future<void> clearWishlist() async {
    if (_currentUsername.isEmpty) return;
    _userWishlists[_currentUsername]?.clear();
    notifyListeners();
  }

  Future<void> clearUser() async {
    _currentUsername = '';
    notifyListeners();
  }
}