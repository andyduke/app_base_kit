import 'package:auth_demo/app_router/app_router.dart';
import 'package:auth_demo/auth/auth_credentials.dart';
import 'package:auth_demo/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed(AppRoutes.help.name);
            },
            icon: const Icon(Icons.help),
          ),
        ],
      ),
      body: Center(
        child: FilledButton.tonal(
          onPressed: () {
            context.read<AppAuthService>().login(
                  const AppLoginCredentials(
                    username: 'johndoe',
                    password: '123',
                  ),
                );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
