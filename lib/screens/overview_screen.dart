import 'package:flutter/material.dart';

import '../services/calculations.dart';
import '../services/formatters.dart';
import '../services/sample_data.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = SampleData.transactions();
    final totalIncome = Calculations.totalIncome(transactions);
    final totalExpense = Calculations.totalExpense(transactions);
    final profit = Calculations.profit(transactions);
    final estimatedTax = Calculations.estimatedTax(transactions);
    final missingDocs = Calculations.missingDocumentCount(transactions);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderSection(onPeriodTap: () {}),
          const SizedBox(height: 16),
          _KpiRow(
            totalIncome: formatCurrency(totalIncome),
            totalExpense: formatCurrency(totalExpense),
            profit: formatCurrency(profit),
          ),
          const SizedBox(height: 16),
          _KpiRowSecondary(
            estimatedTax: formatCurrency(estimatedTax),
            missingDocs: missingDocs,
          ),
          const SizedBox(height: 16),
          _ChartPlaceholder(),
          const SizedBox(height: 16),
          Text('Gợi ý AI', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const _AiSuggestionCard(
            title: 'Hôm nay chưa ghi sổ',
            description: 'Có 2 giao dịch từ ngân hàng chưa phân loại.',
          ),
          const _AiSuggestionCard(
            title: 'Có 2 hóa đơn chụp chưa xử lý',
            description: 'Chạm để xem danh sách OCR đang chờ.',
          ),
          const _AiSuggestionCard(
            title: 'Doanh thu tuần này tăng 12%',
            description: 'Top hàng hóa: Nước ngọt, bánh mì.',
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.library_books_outlined),
                label: const Text('Sổ sách S1–S7'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.smart_toy_outlined),
                label: const Text('Trợ lý AI'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.onPeriodTap});

  final VoidCallback onPeriodTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hộ kinh doanh Minh Anh',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Kỳ: Tháng 12/2024',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onPeriodTap,
          icon: const Icon(Icons.calendar_month_outlined),
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({
    required this.totalIncome,
    required this.totalExpense,
    required this.profit,
  });

  final String totalIncome;
  final String totalExpense;
  final String profit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            title: 'Doanh thu',
            value: totalIncome,
            icon: Icons.trending_up,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            title: 'Chi phí',
            value: totalExpense,
            icon: Icons.trending_down,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            title: 'Lợi nhuận',
            value: profit,
            icon: Icons.savings_outlined,
          ),
        ),
      ],
    );
  }
}

class _KpiRowSecondary extends StatelessWidget {
  const _KpiRowSecondary({
    required this.estimatedTax,
    required this.missingDocs,
  });

  final String estimatedTax;
  final int missingDocs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            title: 'Thuế ước tính',
            value: estimatedTax,
            icon: Icons.account_balance_wallet_outlined,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            title: 'Tình trạng sổ',
            value: '$missingDocs chứng từ thiếu số',
            icon: Icons.event_busy_outlined,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _ChartPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thu/Chi theo ngày',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                8,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 20.0 + (index * 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiSuggestionCard extends StatelessWidget {
  const _AiSuggestionCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.auto_awesome_outlined),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
