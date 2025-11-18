import 'package:flutter/material.dart';
import '../../1_product/models/product_model.dart';
import '../../1_product/service/product_service.dart'; 

//buat nampilinnya mau yang top atau yang search
enum ProductListMode { top, search }

class ProductController with ChangeNotifier {
  final ProductService _ProductService = ProductService();

  List<ProductModel> _topProducts = [];
  List<ProductModel> _searchedProducts = [];

  ProductListMode _currentMode = ProductListMode.top;
  ProductListMode get currentMode => _currentMode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<ProductModel> get ProductsToShow {
    return _currentMode == ProductListMode.top ? _topProducts : _searchedProducts;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _notifyListenersIfNotDisposed();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setLoading(false);
  }

  void _notifyListenersIfNotDisposed() {
    if (!hasListeners) return;
    try {
      notifyListeners();
    } catch (e) {
      // Controller is disposed, ignore
    }
  }

  Future<void> fetchTopProduct() async {
    _setLoading(true);
    _currentMode = ProductListMode.top;
    try {
      _topProducts = await _ProductService.fetchTopProduct();
      _errorMessage = '';
    } catch (e) {
      _setError(e.toString());
      _topProducts = [];
    }
    _setLoading(false);
  }

  Future<void> searchProduct(String keyword) async {
    if (keyword.isEmpty) {
      fetchTopProduct();
      return;
    }
    _setLoading(true);
    _currentMode = ProductListMode.search;
    try {
      _searchedProducts = await _ProductService.searchProduct(keyword);
      _errorMessage = '';
    } catch (e) {
      _setError(e.toString());
      _searchedProducts = [];
    }
    _setLoading(false);
  }
}