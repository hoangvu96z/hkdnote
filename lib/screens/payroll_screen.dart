import 'package:flutter/material.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          const _PayrollSummaryCard(),
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
          const _EmployeeRow(
            name: 'Nguyễn Văn B',
            baseSalary: '6.000.000 đ',
            workdays: '22/26 công',
            payout: '5.100.000 đ',
            isPaid: true,
          ),
          const _EmployeeRow(
            name: 'Trần Thị C',
            baseSalary: '5.500.000 đ',
            workdays: '20/26 công',
            payout: '4.230.000 đ',
            isPaid: false,
          ),
        ],
      ),
    );
  }
}

class _PayrollSummaryCard extends StatelessWidget {
  const _PayrollSummaryCard();

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
          Text('Quỹ lương: 12,8 triệu', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('2 nhân viên • 1 chưa trả', style: Theme.of(context).textTheme.bodySmall),
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
