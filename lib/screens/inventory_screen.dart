import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          const _InventorySummaryCard(),
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
          _InventoryItemCard(
            name: 'Nước ngọt',
            quantity: '18 thùng',
            cost: '120.000 đ',
            price: '150.000 đ',
            isLowStock: false,
          ),
          _InventoryItemCard(
            name: 'Bánh mì',
            quantity: '3 thùng',
            cost: '90.000 đ',
            price: '120.000 đ',
            isLowStock: true,
          ),
          _InventoryItemCard(
            name: 'Sữa tươi',
            quantity: '6 thùng',
            cost: '180.000 đ',
            price: '210.000 đ',
            isLowStock: false,
          ),
        ],
      ),
    );
  }
}

class _InventorySummaryCard extends StatelessWidget {
  const _InventorySummaryCard();

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
          Text('48,5 triệu', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Có 2 mặt hàng gần hết', style: Theme.of(context).textTheme.bodySmall),
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
