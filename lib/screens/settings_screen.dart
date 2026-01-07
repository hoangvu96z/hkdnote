import 'package:flutter/material.dart';

import '../state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final profile = appState.profile;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Cài đặt', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const _SectionTitle(title: 'Hộ kinh doanh'),
          const _SettingsTile(
            title: 'Thông tin cơ bản',
            subtitle: 'Tên hộ, MST, địa chỉ',
            icon: Icons.storefront_outlined,
          ),
          const _SettingsTile(
            title: 'Kỳ kế toán',
            subtitle: 'Theo tháng/quý',
            icon: Icons.event_available_outlined,
          ),
          if (profile != null)
            _SettingsTile(
              title: 'Tên hộ',
              subtitle: profile.businessName,
              icon: Icons.badge_outlined,
            ),
          const _SectionTitle(title: 'Tài khoản & ví'),
          const _SettingsTile(
            title: 'Ví tiền mặt',
            subtitle: 'Số dư: 12,5 triệu',
            icon: Icons.account_balance_wallet_outlined,
          ),
          const _SettingsTile(
            title: 'Tài khoản ngân hàng',
            subtitle: 'BIDV • Vietcombank',
            icon: Icons.account_balance_outlined,
          ),
          const _SectionTitle(title: 'Sao lưu & bảo mật'),
          const _SettingsTile(
            title: 'Đăng nhập / OTP',
            subtitle: 'Liên kết số điện thoại',
            icon: Icons.lock_outline,
          ),
          const _SettingsTile(
            title: 'Sao lưu cloud',
            subtitle: 'Firebase / Supabase',
            icon: Icons.cloud_outlined,
          ),
          const _SectionTitle(title: 'Nâng cao'),
          const _SettingsTile(
            title: 'Mapping danh mục ↔ sổ',
            subtitle: 'S1–S7 theo TT88',
            icon: Icons.table_chart_outlined,
          ),
          const _SettingsTile(
            title: 'Bật/tắt AI gợi ý',
            subtitle: 'Học thói quen nhập liệu',
            icon: Icons.auto_awesome_outlined,
          ),
          const _SettingsTile(
            title: 'Chất lượng OCR',
            subtitle: 'Chuẩn, Nâng cao',
            icon: Icons.document_scanner_outlined,
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: const Text('Giao diện tối cho toàn bộ ứng dụng'),
              value: appState.isDarkMode,
              onChanged: appState.setDarkMode,
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: appState.signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
