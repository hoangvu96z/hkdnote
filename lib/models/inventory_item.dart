import 'package:flutter/foundation.dart';

@immutable
class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitCost,
    required this.unitPrice,
    required this.minStock,
  });

  final String id;
  final String name;
  final double quantity;
  final double unitCost;
  final double unitPrice;
  final double minStock;

  bool get isLowStock => quantity < minStock;
  double get stockValue => quantity * unitCost;
}
