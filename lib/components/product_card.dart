import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF0F0F5),
                  child: product.image.isNotEmpty
                      ? Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_outlined,
                            color: Color(0xFFD1D1D6),
                            size: 36,
                          ),
                        )
                      : const Icon(
                          Icons.image_outlined,
                          color: Color(0xFFD1D1D6),
                          size: 36,
                        ),
                ),
              ),
            ),
            // Info area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0071E3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
