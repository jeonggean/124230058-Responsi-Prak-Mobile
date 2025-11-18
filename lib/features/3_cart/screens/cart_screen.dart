import 'package:flutter/material.dart';
import 'package:responsi/core/utils/app_colors.dart'; // Sesuaikan path

import '../../1_product/models/product_model.dart';
import '../../1_product/screens/product_detail_screen.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CartController();
    _controller.addListener(_onStateChanged);
    _loadData();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _controller.loadFavorites();
  }

  void _navigateToDetail(ProductModel Product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(Product: Product),
      ),
    ).then((_) {
      
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorit Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary));
    }

    if (_controller.favorites.isEmpty) {
      return Center(
        child: Text(
          'Belum ada Product favorit.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.kSecondaryTextColor,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _controller.favorites.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final Product = _controller.favorites[index];
        return _buildProductCard(Product);
      },
    );
  }

  Widget _buildProductCard(ProductModel Product) {
    // Card ini saya samakan dengan di Product_list_screen
    return InkWell(
      onTap: () => _navigateToDetail(Product),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'Product-poster-${Product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  Product.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 80,
                    width: 80,
                    color: AppColors.kBackgroundColor,
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: AppColors.kSecondaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.kTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        "Price: ${Product.price.toString()}",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}