import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/inventory_provider.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<InventoryProvider>();
    final dateStr = DateFormat('MMM dd, yyyy – HH:mm').format(product.lastUpdated);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Qty: ${product.quantity}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    dateStr,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.red),
              onPressed: product.quantity > 0
                  ? () => provider.decrementQuantity(product.id)
                  : null,
              tooltip: 'Decrement',
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () => provider.incrementQuantity(product.id),
              tooltip: 'Increment',
            ),
          ],
        ),
      ),
    );
  }
}
