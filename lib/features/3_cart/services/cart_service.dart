import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../1_product/models/product_model.dart';
import '../../2_auth/services/auth_service.dart';

class CartsService {
  final AuthService _authService = AuthService();

  Future<String> _getCurrentUser() async {
    final user = await _authService.getCurrentUser();
    if (user == null) {
      throw Exception("User tidak login");
    }
    return user;
  }

  String _getCartsKey(String username) {
    return 'Carts_$username';
  }

  Future<List<String>> _getUserCartsList() async {
    final username = await _getCurrentUser();
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_getCartsKey(username)) ?? [];
  }

  Future<List<ProductModel>> getCarts() async {
    final List<String> jsonStringList = await _getUserCartsList();
    return jsonStringList.map((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ProductModel.fromJson(jsonMap);
    }).toList();
  }

  Future<void> addCart(ProductModel Product) async {
    final username = await _getCurrentUser();
    final prefs = await SharedPreferences.getInstance();
    final String key = _getCartsKey(username);

    final List<String> CartsList = prefs.getStringList(key) ?? [];

    final String ProductString = jsonEncode(Product.toJson());

    if (!CartsList.any(
      (item) => jsonDecode(item)['id'] == Product.id,
    )) {
      CartsList.add(ProductString);
      await prefs.setStringList(key, CartsList);
    }
  }

  Future<void> removeCart(ProductModel Product) async {
    final username = await _getCurrentUser();
    final prefs = await SharedPreferences.getInstance();
    final String key = _getCartsKey(username);

    List<String> CartsList = prefs.getStringList(key) ?? [];

    CartsList.removeWhere((jsonString) {
      final Map<String, dynamic> ProductMap = jsonDecode(jsonString);
      return ProductMap['id'] == Product.id;
    });
    await prefs.setStringList(key, CartsList);
  }

  Future<bool> isCart(ProductModel Product) async {
    final List<String> CartsList = await _getUserCartsList();

    return CartsList.any((jsonString) {
      final Map<String, dynamic> ProductMap = jsonDecode(jsonString);
      return ProductMap['id'] == Product.id;
    });
  }
}
