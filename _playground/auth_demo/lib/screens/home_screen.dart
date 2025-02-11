import 'package:auth_demo/app_router/app_router.dart';
import 'package:auth_demo/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AppAuthService>().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.tonal(
              onPressed: () {
                context.goNamed(AppRoutes.settings.name);
              },
              child: const Text('Settings'),
            ),

            //
            const SizedBox(height: 24),

            //
            FilledButton.tonal(
              onPressed: () {
                context.goNamed(AppRoutes.favorites.name);
              },
              child: const Text('Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
