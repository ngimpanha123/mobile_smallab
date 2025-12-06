import 'package:flutter/material.dart';

class ProfileMenuSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onChangePassword;
  final VoidCallback onLogs;

  const ProfileMenuSheet({
    super.key,
    required this.onEdit,
    required this.onChangePassword,
    required this.onLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("កែប្រែ-Profile"),
          onTap: onEdit,
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text("ប្ដូរលេខសម្ងាត់"),
          onTap: onChangePassword,
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text("ប្រតិបត្តិការ Log"),
          onTap: onLogs,
        ),
      ],
    );
  }
}
