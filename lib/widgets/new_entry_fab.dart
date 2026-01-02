import 'package:flutter/material.dart';

class NewEntryFab extends StatelessWidget {
  const NewEntryFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
