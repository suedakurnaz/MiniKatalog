import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cart;
  final Function(int) onRemove;
  final VoidCallback onClear;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onRemove,
    required this.onClear,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final total = widget.cart.fold(0.0, (s, p) => s + p.price);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios_rounded,
                            size: 18, color: Color(0xFF0071E3)),
                        Text(
                          'Cart',
                          style: TextStyle(
                            color: Color(0xFF0071E3),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List
            Expanded(
              child: widget.cart.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              size: 72, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Add items to start shopping',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: widget.cart.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1, color: Color(0xFFF0F0F0)),
                      itemBuilder: (context, index) {
                        final item = widget.cart[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              // Image
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: item.image.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          item.image,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.image_outlined,
                                                  color: Color(0xFFD1D1D6)),
                                        ),
                                      )
                                    : const Icon(Icons.image_outlined,
                                        color: Color(0xFFD1D1D6)),
                              ),
                              const SizedBox(width: 14),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.category,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF8E8E93),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$${item.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Remove button
                              GestureDetector(
                                onTap: () {
                                  setState(() => widget.onRemove(index));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.remove_rounded,
                                      size: 16, color: Color(0xFF8E8E93)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Bottom info + checkout
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Column(
                children: [
                  // Info bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 16, color: Color(0xFF8E8E93)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.cart.isEmpty
                                ? 'Sepetiniz boş'
                                : '${widget.cart.length} ürün · Toplam: \$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Checkout button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: widget.cart.isEmpty
                          ? null
                          : () {
                              setState(() => widget.onClear());
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Siparişiniz alındı! 🎉'),
                                  backgroundColor: const Color(0xFF34C759),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFD1D1D6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
