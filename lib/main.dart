import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/ledger_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/payroll_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/settings_screen.dart';
import 'state/app_state.dart';
import 'widgets/new_entry_fab.dart';

void main() {
  final appState = AppState(
    initialTransactions: const [],
    initialInventory: const [],
    initialPayroll: const [],
  );
  runApp(HKDNoteApp(appState: appState));
}

class HKDNoteApp extends StatelessWidget {
  const HKDNoteApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: appState,
      child: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HKD Note',
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            home: AuthGate(appState: appState),
          );
        },
      ),
    );
  }
}

ThemeData _buildLightTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1C6EF2));
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

ThemeData _buildDarkTheme() {
  const scheme = ColorScheme.dark(
    primary: Color(0xFF1E6FFF),
    surface: Color(0xFF0F141E),
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF1B2130),
    outlineVariant: Color(0xFF2B3446),
  );
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2B3446)),
      ),
    ),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        if (appState.isLoggedIn) {
          return HomeShell(appState: appState);
        }
        return AuthFlow(appState: appState);
      },
    );
  }
}

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.appState});

  final AppState appState;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  late bool _showLogin = widget.appState.profile != null;

  @override
  Widget build(BuildContext context) {
    return _showLogin
        ? LoginScreen(
            onRegisterTap: () => setState(() => _showLogin = false),
            onLogin: widget.appState.signIn,
          )
        : RegistrationScreen(
            onLoginTap: () => setState(() => _showLogin = true),
            showLoginAction: widget.appState.profile != null,
          );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.appState});

  final AppState appState;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final GlobalKey<LedgerScreenState> _ledgerKey = GlobalKey<LedgerScreenState>();

  late final List<Widget> _screens = [
    OverviewScreen(appState: widget.appState),
    LedgerScreen(key: _ledgerKey, appState: widget.appState),
    InventoryScreen(appState: widget.appState),
    PayrollScreen(appState: widget.appState),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: NewEntryFab(
        onQuickAdd: () => _showQuickActionSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.dashboard_outlined,
              label: 'Tổng quan',
              isActive: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            _NavItem(
              icon: Icons.receipt_long_outlined,
              label: 'Ghi sổ',
              isActive: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(width: 48),
            _NavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Kho',
              isActive: _currentIndex == 2,
              onTap: () => setState(() => _currentIndex = 2),
            ),
            _NavItem(
              icon: Icons.people_outline,
              label: 'Lương',
              isActive: _currentIndex == 3,
              onTap: () => setState(() => _currentIndex = 3),
            ),
            _NavItem(
              icon: Icons.settings_outlined,
              label: 'Cài đặt',
              isActive: _currentIndex == 4,
              onTap: () => setState(() => _currentIndex = 4),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo nhanh giao dịch',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _QuickActionChip(
                    label: 'Thu tiền',
                    icon: Icons.call_received,
                    onPressed: () => _openLedgerTab(0),
                  ),
                  _QuickActionChip(
                    label: 'Chi tiền',
                    icon: Icons.call_made,
                    onPressed: () => _openLedgerTab(0),
                  ),
                  _QuickActionChip(
                    label: 'Bán hàng',
                    icon: Icons.point_of_sale,
                    onPressed: () => _openLedgerTab(1),
                  ),
                  _QuickActionChip(
                    label: 'OCR hóa đơn',
                    icon: Icons.document_scanner,
                    onPressed: () => _openLedgerTab(2),
                  ),
                  _QuickActionChip(
                    label: 'AI note',
                    icon: Icons.smart_toy,
                    onPressed: () => _openLedgerTab(0),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Chọn thao tác để mở form nhập nhanh hoặc quét chứng từ.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }

  void _openLedgerTab(int tabIndex) {
    Navigator.of(context).pop();
    setState(() => _currentIndex = 1);
    _ledgerKey.currentState?.switchTab(tabIndex);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Theme.of(context).colorScheme.primary : Colors.grey;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({required this.label, required this.icon, required this.onPressed});

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
