// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hkdnote/main.dart';
import 'package:hkdnote/state/app_state.dart';

void main() {
  testWidgets('FAB mở sheet tạo nhanh', (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(HKDNoteApp(appState: appState));
    await tester.pumpAndSettle();

    expect(find.text('Tổng quan'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Tạo nhanh giao dịch'), findsOneWidget);
  });
}
