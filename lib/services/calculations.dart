import '../models/inventory_item.dart';
import '../models/payroll_record.dart';
import '../models/transaction.dart';

class Calculations {
  static double totalIncome(List<Transaction> transactions) {
    return transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  static double totalExpense(List<Transaction> transactions) {
    return transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  static double profit(List<Transaction> transactions) {
    return totalIncome(transactions) - totalExpense(transactions);
  }

  static double estimatedTax(List<Transaction> transactions) {
    final outputTaxBase = transactions
        .where((transaction) => transaction.taxType == TaxType.output)
        .fold(0.0, (sum, item) => sum + item.amount);
    final inputTaxBase = transactions
        .where((transaction) => transaction.taxType == TaxType.input)
        .fold(0.0, (sum, item) => sum + item.amount);
    return (outputTaxBase * 0.015) - (inputTaxBase * 0.01);
  }

  static int missingDocumentCount(List<Transaction> transactions) {
    return transactions.where((transaction) => transaction.isMissingDocument).length;
  }

  static double inventoryValue(List<InventoryItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.stockValue);
  }

  static int lowStockCount(List<InventoryItem> items) {
    return items.where((item) => item.isLowStock).length;
  }

  static double totalPayroll(List<PayrollRecord> records) {
    return records.fold(0.0, (sum, record) => sum + record.payout);
  }

  static int unpaidCount(List<PayrollRecord> records) {
    return records.where((record) => !record.isPaid).length;
  }
}
