import 'package:flutter/material.dart';

import '../models/payroll_record.dart';
import '../services/calculations.dart';
import '../services/formatters.dart';
import '../state/app_state.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final records = appState.payroll;
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
                onPressed: () => _openAddDialog(context),
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
              ...records.map(
                (r) => _EmployeeRow.fromRecord(
                  r,
                  onTogglePaid: (paid) => appState.markPayrollPaid(r.id, paid),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAddDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final baseCtrl = TextEditingController(text: '6000000');
    final workCtrl = TextEditingController(text: '22');
    final totalCtrl = TextEditingController(text: '26');
    final allowanceCtrl = TextEditingController(text: '0');
    final deductionCtrl = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();
    final record = await showDialog<PayrollRecord>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tính lương nhanh'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nhân viên'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Nhập tên' : null,
                  ),
                  TextFormField(
                    controller: baseCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Lương cơ bản'),
                  ),
                  TextFormField(
                    controller: workCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Số công'),
                  ),
                  TextFormField(
                    controller: totalCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Công chuẩn'),
                  ),
                  TextFormField(
                    controller: allowanceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Phụ cấp'),
                  ),
                  TextFormField(
                    controller: deductionCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Khấu trừ'),
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
                  PayrollRecord(
                    id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
                    employeeName: nameCtrl.text,
                    baseSalary: double.tryParse(baseCtrl.text) ?? 0,
                    workingDays: int.tryParse(workCtrl.text) ?? 0,
                    totalWorkingDays: int.tryParse(totalCtrl.text) ?? 0,
                    allowance: double.tryParse(allowanceCtrl.text) ?? 0,
                    deduction: double.tryParse(deductionCtrl.text) ?? 0,
                    isPaid: false,
                  ),
                );
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
    if (record != null) {
      appState.upsertPayroll(record);
    }
    nameCtrl.dispose();
    baseCtrl.dispose();
    workCtrl.dispose();
    totalCtrl.dispose();
    allowanceCtrl.dispose();
    deductionCtrl.dispose();
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
    required this.onTogglePaid,
  });

  final String name;
  final String baseSalary;
  final String workdays;
  final String payout;
  final bool isPaid;
  final ValueChanged<bool> onTogglePaid;

  factory _EmployeeRow.fromRecord(PayrollRecord record, {required ValueChanged<bool> onTogglePaid}) {
    return _EmployeeRow(
      name: record.employeeName,
      baseSalary: formatCurrency(record.baseSalary),
      workdays: '${record.workingDays}/${record.totalWorkingDays} công',
      payout: formatCurrency(record.payout),
      isPaid: record.isPaid,
      onTogglePaid: onTogglePaid,
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
            Switch(
              value: isPaid,
              onChanged: onTogglePaid,
              activeThumbColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
