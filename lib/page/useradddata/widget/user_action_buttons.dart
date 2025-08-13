import 'package:fingerprint_auth_example/page/useradddata/logic/user_add_controller.dart';
import 'package:flutter/material.dart';

class UserActionButtons extends StatelessWidget {
  final UserAddController controller;

  const UserActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: () {
            controller.clearForm();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم مسح النموذج')),
            );
          },
          icon: const Icon(Icons.clear_all, size: 16),
          label: const Text('مسح النموذج'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
