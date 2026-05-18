import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../components/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _cart = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('https://dummyjson.com/products?limit=30'))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List data = body['products'];
        final products = data.map((e) => Product.fromJson(e)).toList();
        setState(() {
          _allProducts = products;
          _filteredProducts = products;
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}
    setState(() {
      _allProducts = _fallback();
      _filteredProducts = _allProducts;
      _isLoading = false;
    });
  }

  List<Product> _fallback() => [
        Product(id: 1, title: 'iPhone 15 Pro', description: 'Titanium. So strong. So light. So Pro.', image: '', price: 999, category: 'Smartphones', rating: 4.9, stock: 10),
        Product(id: 2, title: 'MacBook Pro 14"', description: 'Pro to the max.', image: '', price: 1599, category: 'Laptops', rating: 4.8, stock: 5),
        Product(id: 3, title: 'AirPods Pro', description: 'Adaptive Audio. Now it\'s personal.', image: '', price: 249, category: 'Audio', rating: 4.7, stock: 20),
        Product(id: 4, title: 'iPad Air', description: 'Light. Bright. Full of might.', image: '', price: 599, category: 'Tablets', rating: 4.6, stock: 15),
        Product(id: 5, title: 'Apple Watch', description: 'The future of health is on your wrist.', image: '', price: 399, category: 'Wearables', rating: 4.5, stock: 8),
        Product(id: 6, title: 'HomePod Mini', description: 'Color-pop.', image: '', price: 99, category: 'Audio', rating: 4.4, stock: 30),
      ];

  void _onSearch(String q) {
    setState(() {
      _filteredProducts = _allProducts
          .where((p) => p.title.toLowerCase().contains(q.toLowerCase()) ||
              p.category.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  void _addToCart(Product p) {
    setState(() => _cart.add(p));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.title} sepete eklendi'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(
          cart: _cart,
          onRemove: (i) => setState(() => _cart.removeAt(i)),
          onClear: () => setState(() => _cart.clear()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discover',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        'Find your perfect product.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _openCart,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined,
                              size: 22, color: Color(0xFF1A1A1A)),
                        ),
                        if (_cart.isNotEmpty)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0071E3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${_cart.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    hintStyle: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 15),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFFAEAEB2), size: 20),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Grid
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0071E3),
                        strokeWidth: 2,
                      ),
                    )
                  : _filteredProducts.isEmpty
                      ? const Center(
                          child: Text('Ürün bulunamadı',
                              style: TextStyle(color: Color(0xFF8E8E93))),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.78,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final p = _filteredProducts[index];
                            return ProductCard(
                              product: p,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                    product: p,
                                    onAddToCart: _addToCart,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
