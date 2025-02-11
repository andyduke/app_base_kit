import 'package:auth_demo/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        actions: [
          CloseButton(
            onPressed: () => context.goNamed(AppRoutes.start.name),
          ),
        ],
      ),
    );
  }
}
