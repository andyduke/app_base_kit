import 'package:auth_demo/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed(AppRoutes.home.name);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
