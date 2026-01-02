import 'package:flutter/material.dart';

import '../models/payroll_record.dart';
import '../services/calculations.dart';
import '../services/formatters.dart';
import '../services/sample_data.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = SampleData.payrollRecords();
    final totalPayroll = Calculations.totalPayroll(records);
    final unpaidCount = Calculations.unpaidCount(records);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text('Lương', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today_outlined),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PayrollSummaryCard(
            totalPayroll: formatCurrency(totalPayroll),
            unpaidCount: unpaidCount,
            totalEmployees: records.length,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.calculate_outlined),
            label: const Text('Tính lương tháng này'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('Tạo phiếu chi lương'),
          ),
          const SizedBox(height: 16),
          Text('Danh sách nhân viên', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...records.map(_EmployeeRow.fromRecord),
        ],
      ),
    );
  }
}

class _PayrollSummaryCard extends StatelessWidget {
  const _PayrollSummaryCard({
    required this.totalPayroll,
    required this.unpaidCount,
    required this.totalEmployees,
  });

  final String totalPayroll;
  final int unpaidCount;
  final int totalEmployees;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tháng 12/2024', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(
            'Quỹ lương: $totalPayroll',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '$totalEmployees nhân viên • $unpaidCount chưa trả',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EmployeeRow extends StatelessWidget {
  const _EmployeeRow({
    required this.name,
    required this.baseSalary,
    required this.workdays,
    required this.payout,
    required this.isPaid,
  });

  final String name;
  final String baseSalary;
  final String workdays;
  final String payout;
  final bool isPaid;

  factory _EmployeeRow.fromRecord(PayrollRecord record) {
    return _EmployeeRow(
      name: record.employeeName,
      baseSalary: formatCurrency(record.baseSalary),
      workdays: '${record.workingDays}/${record.totalWorkingDays} công',
      payout: formatCurrency(record.payout),
      isPaid: record.isPaid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(name),
        subtitle: Text('Lương cơ bản: $baseSalary • $workdays'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(payout, style: Theme.of(context).textTheme.labelLarge),
            Text(
              isPaid ? 'Đã trả' : 'Chưa trả',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isPaid ? Colors.green : Colors.orange,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
