import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/calculations.dart';
import '../services/formatters.dart';
import '../state/app_state.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key, required this.appState});

  final AppState appState;

  @override
  LedgerScreenState createState() => LedgerScreenState();
}

class LedgerScreenState extends State<LedgerScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  void switchTab(int index) => _tabController.animateTo(index);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Thu/Chi nhanh'),
              Tab(text: 'Bán hàng'),
              Tab(text: 'OCR'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _QuickEntryTab(appState: widget.appState),
                _SalesEntryTab(appState: widget.appState),
                _OcrEntryTab(appState: widget.appState),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickEntryTab extends StatefulWidget {
  const _QuickEntryTab({required this.appState});

  final AppState appState;

  @override
  State<_QuickEntryTab> createState() => _QuickEntryTabState();
}

class _QuickEntryTabState extends State<_QuickEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _docNumberCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  TransactionType _type = TransactionType.expense;
  String _account = 'Tiền mặt';
  String _category = 'Nhập hàng';

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _docNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final transactions = widget.appState.transactions;
        final missingDocs = Calculations.missingDocumentCount(transactions);
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(title: 'Thu / Chi nhanh', actionLabel: 'Thêm chi tiết nâng cao'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tiền'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nhập số tiền';
                  final parsed = double.tryParse(value.replaceAll('.', ''));
                  if (parsed == null || parsed <= 0) return 'Số tiền không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TransactionType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Loại'),
                items: const [
                  DropdownMenuItem(value: TransactionType.income, child: Text('Thu')),
                  DropdownMenuItem(value: TransactionType.expense, child: Text('Chi')),
                  DropdownMenuItem(value: TransactionType.transfer, child: Text('Chuyển')),
                ],
                onChanged: (value) => setState(() => _type = value!),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ngày giao dịch'),
                subtitle: Text('${_date.day}/${_date.month}/${_date.year}'),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: _account,
                decoration: const InputDecoration(labelText: 'Ví/Tài khoản'),
                items: const [
                  DropdownMenuItem(value: 'Tiền mặt', child: Text('Tiền mặt')),
                  DropdownMenuItem(value: 'Ngân hàng BIDV', child: Text('Ngân hàng BIDV')),
                  DropdownMenuItem(value: 'Ngân hàng VCB', child: Text('Ngân hàng VCB')),
                  DropdownMenuItem(value: 'Ví điện tử', child: Text('Ví điện tử')),
                ],
                onChanged: (value) => setState(() => _account = value!),
              ),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Danh mục'),
                items: const [
                  DropdownMenuItem(value: 'Bán hàng', child: Text('Bán hàng')),
                  DropdownMenuItem(value: 'Nhập hàng', child: Text('Nhập hàng')),
                  DropdownMenuItem(value: 'Chi phí khác', child: Text('Chi phí khác')),
                  DropdownMenuItem(value: 'Lương', child: Text('Lương')),
                  DropdownMenuItem(value: 'Thuế', child: Text('Thuế')),
                  DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                ],
                onChanged: (value) => setState(() => _category = value!),
              ),
              TextFormField(
                controller: _docNumberCtrl,
                decoration: const InputDecoration(labelText: 'Số chứng từ (TT88)'),
              ),
              TextFormField(
                controller: _noteCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
              const SizedBox(height: 8),
              const _AiHint(text: 'Gợi ý danh mục: Nhập hàng hóa – Kho chính'),
              if (missingDocs > 0) ...[
                const SizedBox(height: 12),
                _WarningHint(
                  text: 'Có $missingDocs chứng từ thiếu số chứng từ theo TT88.',
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _save,
                child: const Text('Lưu giao dịch'),
              ),
              const SizedBox(height: 20),
              Text('Giao dịch gần đây', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...transactions.map(_RecentTransactionTile.fromTransaction),
            ],
          ),
        );
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtrl.text.replaceAll('.', '')) ?? 0;
    final tx = Transaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      date: _date,
      amount: amount,
      type: _type,
      category: _category,
      account: _account,
      note: _noteCtrl.text,
      documentNumber: _docNumberCtrl.text,
      taxType: _category == 'Bán hàng' ? TaxType.output : TaxType.input,
    );
    widget.appState.addTransaction(tx);
    _amountCtrl.clear();
    _noteCtrl.clear();
    _docNumberCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu giao dịch')));
  }
}

class _SalesEntryTab extends StatefulWidget {
  const _SalesEntryTab({required this.appState});
  final AppState appState;

  @override
  State<_SalesEntryTab> createState() => _SalesEntryTabState();
}

class _SalesEntryTabState extends State<_SalesEntryTab> {
  final List<_LineItem> _items = [];
  double _discount = 0;
  String _account = 'Tiền mặt';

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.qty * item.price);
  double get _tax => _items.fold(0, (sum, item) => sum + item.qty * item.price * item.taxRate);
  double get _total => _subtotal + _tax - _discount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'Hóa đơn bán lẻ / bán buôn', actionLabel: 'Lưu & In/Chia sẻ'),
        const SizedBox(height: 12),
        const _CustomerCard(),
        const SizedBox(height: 12),
        ..._items.map(
          (item) => _ProductRow(
            name: item.name,
            quantity: item.qty.toStringAsFixed(0),
            price: formatCurrency(item.price),
            onDelete: () => setState(() => _items.remove(item)),
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            final line = await _showAddItemDialog(context);
            if (line != null) setState(() => _items.add(line));
          },
          icon: const Icon(Icons.add),
          label: const Text('Hàng mới'),
        ),
        const SizedBox(height: 12),
        _TotalCard(
          subtotal: _subtotal,
          tax: _tax,
          discount: _discount,
          total: _total,
          onDiscountChanged: (v) => setState(() => _discount = v),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _account,
          decoration: const InputDecoration(labelText: 'Tài khoản nhận tiền'),
          items: const [
            DropdownMenuItem(value: 'Tiền mặt', child: Text('Tiền mặt')),
            DropdownMenuItem(value: 'Ngân hàng BIDV', child: Text('Ngân hàng BIDV')),
            DropdownMenuItem(value: 'Ngân hàng VCB', child: Text('Ngân hàng VCB')),
          ],
          onChanged: (v) => setState(() => _account = v!),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _items.isEmpty ? null : _saveInvoice,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Lưu hóa đơn'),
        ),
      ],
    );
  }

  Future<_LineItem?> _showAddItemDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final priceCtrl = TextEditingController();
    final taxCtrl = TextEditingController(text: '8'); // %
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<_LineItem>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm hàng hóa'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên hàng'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Nhập tên' : null,
                ),
                TextFormField(
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Số lượng'),
                  validator: (v) => (double.tryParse(v ?? '') ?? 0) > 0 ? null : 'SL > 0',
                ),
                TextFormField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Đơn giá'),
                  validator: (v) => (double.tryParse(v ?? '') ?? 0) > 0 ? null : 'Đơn giá > 0',
                ),
                TextFormField(
                  controller: taxCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Thuế (%)'),
                  validator: (v) => double.tryParse(v ?? '') != null ? null : 'Nhập %',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final line = _LineItem(
                  name: nameCtrl.text,
                  qty: double.parse(qtyCtrl.text),
                  price: double.parse(priceCtrl.text),
                  taxRate: (double.tryParse(taxCtrl.text) ?? 0) / 100,
                );
                Navigator.pop(context, line);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
    nameCtrl.dispose();
    qtyCtrl.dispose();
    priceCtrl.dispose();
    taxCtrl.dispose();
    return result;
  }

  void _saveInvoice() {
    final tx = Transaction(
      id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      amount: _total,
      type: TransactionType.income,
      category: 'Bán hàng',
      account: _account,
      note: 'Hóa đơn bán hàng (${_items.length} dòng)',
      documentNumber: 'S1-${widget.appState.transactions.length + 1}',
      taxType: TaxType.output,
    );
    widget.appState.addTransaction(tx);
    setState(() {
      _items.clear();
      _discount = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu hóa đơn')));
  }
}

class _LineItem {
  _LineItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.taxRate,
  });

  final String name;
  final double qty;
  final double price;
  final double taxRate;
}

class _OcrEntryTab extends StatefulWidget {
  const _OcrEntryTab({required this.appState});
  final AppState appState;

  @override
  State<_OcrEntryTab> createState() => _OcrEntryTabState();
}

class _OcrEntryTabState extends State<_OcrEntryTab> {
  final _ocrTextCtrl = TextEditingController();
  double? _detectedAmount;
  DateTime? _detectedDate;
  String? _detectedCategory;

  @override
  void dispose() {
    _ocrTextCtrl.dispose();
    super.dispose();
  }

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Khung camera / ảnh hóa đơn'),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _mockCapture,
                  icon: const Icon(Icons.document_scanner),
                  label: const Text('Giả lập chụp & OCR'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ocrTextCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Nội dung OCR (có thể chỉnh sửa)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _parseFields(),
        ),
        const SizedBox(height: 12),
        _AiHint(
          text:
              'AI gợi ý: ${_detectedCategory ?? 'Chưa nhận diện'} - Số tiền: ${_detectedAmount != null ? formatCurrency(_detectedAmount!) : '---'} - Ngày: ${_detectedDate != null ? '${_detectedDate!.day}/${_detectedDate!.month}' : '---'}',
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _accept,
          child: const Text('Chấp nhận → tạo phiếu'),
        ),
      ],
    );
  }

  void _mockCapture() {
    _ocrTextCtrl.text = 'Phiếu chi nhập hàng 2.150.000 ngày 05/12/2024 tiền mặt';
    _parseFields();
  }

  void _parseFields() {
    final text = _ocrTextCtrl.text;
    final amountMatch = RegExp(r'(\d[\d\.]{3,})').firstMatch(text);
    _detectedAmount = amountMatch != null
        ? double.tryParse(amountMatch.group(1)!.replaceAll('.', ''))
        : null;
    final dateMatch = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})').firstMatch(text);
    if (dateMatch != null) {
      _detectedDate = DateTime(
        int.parse(dateMatch.group(3)!),
        int.parse(dateMatch.group(2)!),
        int.parse(dateMatch.group(1)!),
      );
    }
    _detectedCategory = text.contains('nhap') || text.contains('nhập') ? 'Nhập hàng' : 'Chi phí khác';
    setState(() {});
  }

  void _accept() {
    final amount = _detectedAmount ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Chưa nhận diện được số tiền')));
      return;
    }
    final tx = Transaction(
      id: 'ocr_${DateTime.now().millisecondsSinceEpoch}',
      date: _detectedDate ?? DateTime.now(),
      amount: amount,
      type: TransactionType.expense,
      category: _detectedCategory ?? 'Chi phí khác',
      account: 'Tiền mặt',
      note: _ocrTextCtrl.text,
      documentNumber: '',
      taxType: TaxType.input,
    );
    widget.appState.addTransaction(tx);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Đã tạo phiếu từ OCR')));
    _ocrTextCtrl.clear();
    _detectedAmount = null;
    _detectedDate = null;
    _detectedCategory = null;
    setState(() {});
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

class _WarningHint extends StatelessWidget {
  const _WarningHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: Theme.of(context).colorScheme.error),
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

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.name,
    required this.quantity,
    required this.price,
    this.onDelete,
  });

  final String name;
  final String quantity;
  final String price;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text('SL: $quantity • Đơn giá: $price đ'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.onDiscountChanged,
  });

  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final ValueChanged<double> onDiscountChanged;

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
        children: [
          _TotalRow(label: 'Tổng tiền', value: formatCurrency(subtotal)),
          _TotalRow(label: 'Thuế', value: formatCurrency(tax)),
          TextFormField(
            initialValue: discount.toStringAsFixed(0),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Giảm giá'),
            onChanged: (v) => onDiscountChanged(double.tryParse(v) ?? 0),
          ),
          const Divider(),
          _TotalRow(label: 'Khách trả', value: formatCurrency(total)),
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

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool isIncome;

  factory _RecentTransactionTile.fromTransaction(Transaction transaction) {
    return _RecentTransactionTile(
      title: transaction.category,
      subtitle: transaction.note,
      amount: formatCurrency(transaction.amount),
      isIncome: transaction.type == TransactionType.income,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isIncome ? Icons.call_received : Icons.call_made,
          color: isIncome ? Colors.green : Colors.red,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          amount,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isIncome ? Colors.green : Colors.red,
              ),
        ),
      ),
    );
  }
}
