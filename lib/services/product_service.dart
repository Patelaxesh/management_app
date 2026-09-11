import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  Future<List<ProductModel>> getProducts() async {
    final response = await _apiService.get('/products');

    final List products = response['products'];

    return products.map((product) => ProductModel.fromJson(product)).toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await _apiService.get('/products/$id');

    return ProductModel.fromJson(response);
  }
}
