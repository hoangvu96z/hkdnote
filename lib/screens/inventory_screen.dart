import 'package:flutter/material.dart';

import '../models/inventory_item.dart';
import '../services/calculations.dart';
import '../services/formatters.dart';
import '../services/sample_data.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = SampleData.inventoryItems();
    final totalValue = Calculations.inventoryValue(items);
    final lowStock = Calculations.lowStockCount(items);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text('Kho', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InventorySummaryCard(
            totalValue: formatCurrency(totalValue),
            lowStockCount: lowStock,
          ),
          const SizedBox(height: 12),
          const _InventoryActionsRow(),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm hàng hóa',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(_InventoryItemCard.fromItem),
        ],
      ),
    );
  }
}

class _InventorySummaryCard extends StatelessWidget {
  const _InventorySummaryCard({
    required this.totalValue,
    required this.lowStockCount,
  });

  final String totalValue;
  final int lowStockCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tổng giá trị tồn kho', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(totalValue, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Có $lowStockCount mặt hàng gần hết',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _InventoryActionsRow extends StatelessWidget {
  const _InventoryActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_shopping_cart_outlined),
            label: const Text('Nhập hàng'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.remove_shopping_cart_outlined),
            label: const Text('Xuất hàng'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('Kiểm kê'),
          ),
        ),
      ],
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  const _InventoryItemCard({
    required this.name,
    required this.quantity,
    required this.cost,
    required this.price,
    required this.isLowStock,
  });

  final String name;
  final String quantity;
  final String cost;
  final String price;
  final bool isLowStock;

  factory _InventoryItemCard.fromItem(InventoryItem item) {
    return _InventoryItemCard(
      name: item.name,
      quantity: '${item.quantity.toInt()} thùng',
      cost: formatCurrency(item.unitCost),
      price: formatCurrency(item.unitPrice),
      isLowStock: item.isLowStock,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(name),
        subtitle: Text('Tồn: $quantity • Giá vốn: $cost'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(price, style: Theme.of(context).textTheme.labelLarge),
            if (isLowStock)
              Text(
                'Sắp hết',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
