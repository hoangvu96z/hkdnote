import 'package:flutter/material.dart';

class NewEntryFab extends StatelessWidget {
  const NewEntryFab({
    super.key,
    required this.onQuickAdd,
  });

  final VoidCallback onQuickAdd;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onQuickAdd,
      child: const Icon(Icons.add),
    );
  }
}
