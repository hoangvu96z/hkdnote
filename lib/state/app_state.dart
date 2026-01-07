import 'package:flutter/widgets.dart';

import '../models/inventory_item.dart';
import '../models/payroll_record.dart';
import '../models/transaction.dart';

/// Simple shared state holder for demo without external dependencies.
class AppState extends ChangeNotifier {
  AppState({
    List<Transaction>? initialTransactions,
    List<InventoryItem>? initialInventory,
    List<PayrollRecord>? initialPayroll,
  })  : _transactions = initialTransactions ?? [],
        _inventory = initialInventory ?? [],
        _payroll = initialPayroll ?? [];

  final List<Transaction> _transactions;
  final List<InventoryItem> _inventory;
  final List<PayrollRecord> _payroll;

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<InventoryItem> get inventory => List.unmodifiable(_inventory);
  List<PayrollRecord> get payroll => List.unmodifiable(_payroll);

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void upsertInventory(InventoryItem item) {
    final index = _inventory.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      _inventory.add(item);
    } else {
      _inventory[index] = item;
    }
    notifyListeners();
  }

  void upsertPayroll(PayrollRecord record) {
    final index = _payroll.indexWhere((e) => e.id == record.id);
    if (index == -1) {
      _payroll.add(record);
    } else {
      _payroll[index] = record;
    }
    notifyListeners();
  }

  void markPayrollPaid(String id, bool isPaid) {
    final index = _payroll.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final current = _payroll[index];
    _payroll[index] = PayrollRecord(
      id: current.id,
      employeeName: current.employeeName,
      baseSalary: current.baseSalary,
      workingDays: current.workingDays,
      totalWorkingDays: current.totalWorkingDays,
      allowance: current.allowance,
      deduction: current.deduction,
      isPaid: isPaid,
    );
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
