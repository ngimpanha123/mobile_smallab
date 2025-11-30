import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  final String image;
  final String name;
  final String category;
  final int stock;
  final String id;
  final double price;
  final VoidCallback? onTap;

  const ProductCardWidget({
    super.key,
    required this.image,
    required this.name,
    required this.category,
    required this.stock,
    required this.id,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  image,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    /// Category
                    Text(
                      category,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Stock
                    Text(
                      "Stock: $stock",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Price
              Text(
                "\$${price.toStringAsFixed(2)}",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}