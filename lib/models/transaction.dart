import 'package:flutter/foundation.dart';

enum TransactionType { income, expense, transfer }

enum TaxType { none, input, output }

@immutable
class Transaction {
  const Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.category,
    required this.account,
    required this.note,
    this.documentNumber,
    this.taxType = TaxType.none,
  });

  final String id;
  final DateTime date;
  final double amount;
  final TransactionType type;
  final String category;
  final String account;
  final String note;
  final String? documentNumber;
  final TaxType taxType;

  bool get isMissingDocument => documentNumber == null || documentNumber!.isEmpty;
}
