import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart'; 

class ProductService {
  final String _baseUrl = "https://fakestoreapi.com/products";

  Future<List<ProductModel>> fetchTopProduct() async {
    String url = "$_baseUrl/top/products";
    print("Memanggil API");

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['data'] == null) return [];

        final List ProductJsonList = data['data'];
        List<ProductModel> Products = [];
        for (var ProductJson in ProductJsonList) {
          Products.add(ProductModel.fromJson(ProductJson));
        }
        return Products;
      } else {
        throw Exception("Gagal memuat data Product: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi error saat memanggil API: $e");
    }
  }

  Future<List<ProductModel>> searchProduct(String keyword) async {
    String url = "$_baseUrl/Product?q=${Uri.encodeComponent(keyword)}";
    print("Memanggil API");

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['data'] == null) return [];

        final List ProductJsonList = data['data'];
        List<ProductModel> Products = [];
        for (var ProductJson in ProductJsonList) {
          Products.add(ProductModel.fromJson(ProductJson));
        }
        return Products;
      } else {
        throw Exception("Gagal mencari data Product: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi error saat memanggil API: $e");
    }
  }
}