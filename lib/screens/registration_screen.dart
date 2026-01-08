import 'package:flutter/material.dart';

import '../models/business_profile.dart';
import '../state/app_state.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    super.key,
    required this.onLoginTap,
    required this.showLoginAction,
  });

  final VoidCallback onLoginTap;
  final bool showLoginAction;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameCtrl = TextEditingController();
  final _taxCodeCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  DateTime _startDate = DateTime(DateTime.now().year, 1, 1);
  String _taxMethod = 'Phương pháp kê khai';
  bool _enableCash = true;
  bool _enableBank = false;

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _taxCodeCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: widget.showLoginAction ? widget.onLoginTap : null,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Thiết lập hộ kinh doanh'),
        actions: widget.showLoginAction
            ? [
                TextButton(
                  onPressed: widget.onLoginTap,
                  child: const Text('Đăng nhập'),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle(title: 'Thông tin chung'),
              TextFormField(
                controller: _businessNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên hộ kinh doanh *',
                  hintText: 'Ví dụ: Hộ Kinh Doanh Nguyễn Văn A',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Bắt buộc' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _taxCodeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mã số thuế (MST) *',
                  hintText: 'Nhập mã số thuế...',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Bắt buộc' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ kinh doanh',
                  hintText: 'Số nhà, đường, phường/xã...',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: _SectionTitle(title: 'Cấu hình kế toán')),
                  _InfoBadge(text: 'TT 88/2021/TT-BTC'),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _taxMethod,
                items: const [
                  DropdownMenuItem(value: 'Phương pháp kê khai', child: Text('Phương pháp kê khai')),
                  DropdownMenuItem(value: 'Phương pháp khoán', child: Text('Phương pháp khoán')),
                ],
                onChanged: (value) => setState(() => _taxMethod = value ?? _taxMethod),
                decoration: const InputDecoration(labelText: 'Phương pháp tính thuế'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ngày bắt đầu kỳ kế toán'),
                subtitle: Text('${_startDate.day.toString().padLeft(2, '0')}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.year}'),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickStartDate,
              ),
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Tài khoản ban đầu'),
              const SizedBox(height: 8),
              _AccountToggleCard(
                title: 'Tiền mặt (VND)',
                subtitle: 'Quỹ tiền mặt tại cửa hàng',
                icon: Icons.payments_outlined,
                value: _enableCash,
                onChanged: (v) => setState(() => _enableCash = v),
              ),
              const SizedBox(height: 12),
              _AccountToggleCard(
                title: 'Tài khoản ngân hàng',
                subtitle: 'Vietcombank, Techcombank...',
                icon: Icons.account_balance_outlined,
                value: _enableBank,
                onChanged: (v) => setState(() => _enableBank = v),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: const Text('Lưu thông tin'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final profile = BusinessProfile(
      businessName: _businessNameCtrl.text,
      taxCode: _taxCodeCtrl.text,
      address: _addressCtrl.text,
      taxMethod: _taxMethod,
      periodStartDate: _startDate,
      enableCash: _enableCash,
      enableBank: _enableBank,
    );
    AppStateScope.of(context).completeOnboarding(profile);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: scheme.primary, fontSize: 12),
      ),
    );
  }
}

class _AccountToggleCard extends StatelessWidget {
  const _AccountToggleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: scheme.surfaceContainerHighest.withOpacity(0.6),
            child: Icon(icon, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
