import 'package:flutter/material.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Ghi sổ',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Thu/Chi nhanh'),
                Tab(text: 'Bán hàng'),
                Tab(text: 'OCR'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _QuickEntryTab(),
                  _SalesEntryTab(),
                  _OcrEntryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickEntryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'Thu / Chi nhanh', actionLabel: 'Thêm chi tiết nâng cao'),
        const SizedBox(height: 12),
        const _AmountInput(),
        const SizedBox(height: 16),
        const _DropdownField(label: 'Ngày giao dịch', value: 'Hôm nay, 24/12/2024'),
        const _DropdownField(label: 'Ví/Tài khoản', value: 'Tiền mặt'),
        const _DropdownField(label: 'Danh mục', value: 'Nhập hàng'),
        const _TextField(label: 'Ghi chú'),
        const SizedBox(height: 8),
        const _AiHint(text: 'Gợi ý danh mục: Nhập hàng hóa – Kho chính'),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {},
          child: const Text('Lưu giao dịch'),
        ),
      ],
    );
  }
}

class _SalesEntryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'Hóa đơn bán lẻ / bán buôn', actionLabel: 'Lưu & In/Chia sẻ'),
        const SizedBox(height: 12),
        const _CustomerCard(),
        const SizedBox(height: 12),
        const _ProductTable(),
        const SizedBox(height: 12),
        const _TotalCard(),
        const SizedBox(height: 16),
        const _DropdownField(label: 'Tài khoản nhận tiền', value: 'Ngân hàng BIDV'),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.save_outlined),
          label: const Text('Lưu hóa đơn'),
        ),
      ],
    );
  }
}

class _OcrEntryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'OCR / Hóa đơn', actionLabel: 'Chụp hóa đơn'),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: const Center(
            child: Text('Khung camera / ảnh hóa đơn'),
          ),
        ),
        const SizedBox(height: 12),
        const _TextField(label: 'Nội dung OCR (có thể chỉnh sửa)'),
        const SizedBox(height: 12),
        const _AiHint(text: 'AI gợi ý: Phiếu chi - Nhập hàng - 2.000.000đ'),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {},
          child: const Text('Chấp nhận → tạo phiếu'),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel});

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        TextButton(onPressed: () {}, child: Text(actionLabel)),
      ],
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Số tiền', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(
            '2.000.000 đ',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: () {},
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 2,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AiHint extends StatelessWidget {
  const _AiHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_outlined, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Khách hàng'),
        subtitle: const Text('Nguyễn Văn A • 0909 999 888'),
        trailing: const Icon(Icons.edit_outlined),
        onTap: () {},
      ),
    );
  }
}

class _ProductTable extends StatelessWidget {
  const _ProductTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Hàng hóa', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Hàng mới'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _ProductRow(name: 'Nước ngọt', quantity: '10', price: '15.000'),
        _ProductRow(name: 'Bánh mì', quantity: '5', price: '12.000'),
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.name, required this.quantity, required this.price});

  final String name;
  final String quantity;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text('SL: $quantity • Đơn giá: $price đ'),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TotalRow(label: 'Tổng tiền', value: '210.000 đ'),
          _TotalRow(label: 'Thuế', value: '10.500 đ'),
          _TotalRow(label: 'Giảm giá', value: '0 đ'),
          Divider(),
          _TotalRow(label: 'Khách trả', value: '220.000 đ'),
          _TotalRow(label: 'Còn nợ', value: '0 đ'),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
