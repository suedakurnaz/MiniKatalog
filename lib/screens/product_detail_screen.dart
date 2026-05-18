import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _added = false;

  void _handleAdd() {
    widget.onAddToCart(widget.product);
    setState(() => _added = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _added = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // App bar with image
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_rounded,
                          color: Color(0xFF1A1A1A), size: 18),
                    ),
                  ),
                  title: const Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  titleSpacing: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: const Color(0xFFF5F5F7),
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      child: p.image.isNotEmpty
                          ? Image.network(
                              p.image,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_outlined,
                                color: Color(0xFFD1D1D6),
                                size: 80,
                              ),
                            )
                          : const Icon(
                              Icons.image_outlined,
                              color: Color(0xFFD1D1D6),
                              size: 80,
                            ),
                    ),
                  ),
                ),
                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          p.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p.category,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Price + rating row
                        Row(
                          children: [
                            Text(
                              '\$${p.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const Spacer(),
                            if (p.rating > 0)
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Color(0xFFFF9500), size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    p.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Divider
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 24),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p.description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF3C3C43),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Specs row
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 20),
                        const Text(
                          'Specifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _SpecTile(
                                label: 'STOK',
                                value: '${p.stock} adet'),
                            _SpecTile(
                                label: 'KATEGORİ',
                                value: p.category),
                            _SpecTile(
                                label: 'PUAN',
                                value: p.rating > 0
                                    ? '${p.rating.toStringAsFixed(1)}/5'
                                    : 'N/A'),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: _added ? const Color(0xFF34C759) : const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleAdd,
                    borderRadius: BorderRadius.circular(14),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _added
                                ? Icons.check_rounded
                                : Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _added ? 'Sepete Eklendi' : 'Sepete Ekle',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final String label;
  final String value;

  const _SpecTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF8E8E93),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
