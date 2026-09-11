import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> products = [];

  ProductModel? selectedProduct;

  bool isLoading = false;
  bool isDetailLoading = false;

  String? errorMessage;
  String? detailErrorMessage;

  String searchQuery = '';

  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      products = await _productService.getProducts();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductDetails(int id) async {
    isDetailLoading = true;
    detailErrorMessage = null;
    selectedProduct = null;

    notifyListeners();

    try {
      selectedProduct = await _productService.getProductById(id);
    } catch (e) {
      detailErrorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    searchQuery = query;

    notifyListeners();
  }

  List<ProductModel> get filteredProducts {
    if (searchQuery.trim().isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
}
