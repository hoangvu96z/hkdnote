import 'package:flutter/material.dart';

import '../models/inventory_item.dart';
import '../services/calculations.dart';
import '../services/formatters.dart';
import '../state/app_state.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final items = appState.inventory;
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
              _InventoryActionsRow(onAdd: () => _openInventoryDialog(context)),
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
      },
    );
  }

  Future<void> _openInventoryDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final costCtrl = TextEditingController(text: '0');
    final priceCtrl = TextEditingController(text: '0');
    final minCtrl = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();
    final item = await showDialog<InventoryItem>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm hàng tồn'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Tên hàng'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Nhập tên' : null,
                  ),
                  TextFormField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Số lượng'),
                    validator: (v) => (double.tryParse(v ?? '') ?? 0) > 0 ? null : 'SL > 0',
                  ),
                  TextFormField(
                    controller: costCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Giá vốn'),
                  ),
                  TextFormField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Giá bán'),
                  ),
                  TextFormField(
                    controller: minCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tồn tối thiểu'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(
                  context,
                  InventoryItem(
                    id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text,
                    quantity: double.tryParse(qtyCtrl.text) ?? 0,
                    unitCost: double.tryParse(costCtrl.text) ?? 0,
                    unitPrice: double.tryParse(priceCtrl.text) ?? 0,
                    minStock: double.tryParse(minCtrl.text) ?? 0,
                  ),
                );
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
    if (item != null) {
      appState.upsertInventory(item);
    }
    nameCtrl.dispose();
    qtyCtrl.dispose();
    costCtrl.dispose();
    priceCtrl.dispose();
    minCtrl.dispose();
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
  const _InventoryActionsRow({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onAdd,
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
