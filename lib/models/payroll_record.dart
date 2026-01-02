import 'package:flutter/foundation.dart';

@immutable
class PayrollRecord {
  const PayrollRecord({
    required this.id,
    required this.employeeName,
    required this.baseSalary,
    required this.workingDays,
    required this.totalWorkingDays,
    required this.allowance,
    required this.deduction,
    required this.isPaid,
  });

  final String id;
  final String employeeName;
  final double baseSalary;
  final int workingDays;
  final int totalWorkingDays;
  final double allowance;
  final double deduction;
  final bool isPaid;

  double get salaryPerDay => baseSalary / totalWorkingDays;

  double get payout => (salaryPerDay * workingDays) + allowance - deduction;
}
