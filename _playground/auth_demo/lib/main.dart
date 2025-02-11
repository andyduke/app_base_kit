import 'package:app_base_kit/app_base_kit.dart';
import 'package:auth_demo/api/api_client.dart';
import 'package:auth_demo/app_router/app_router.dart';
import 'package:auth_demo/auth/auth_service.dart';
import 'package:auth_demo/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static final _authState = AppAuthState();

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router(_authState),
      builder: (context, child) => MultiProvider(
        providers: [
          /// Auth state
          ChangeNotifierProvider.value(
            value: _authState,
          ),

          /// Api client
          ProxyProvider<AppAuthState, ApiClient>(
            update: (context, auth, client) => client ??= ApiClient(),
            dispose: (context, client) => client.dispose(),
          ),

          /// Auth service
          ProxyProvider2<AppAuthState, ApiClient, AppAuthService>(
            lazy: false,
            update: (context, authState, apiClient, prev) =>
                prev ??
                AppAuthService(
                  client: apiClient,
                  state: authState,
                ),
            dispose: (context, value) => value.dispose(),
          ),
        ],
        child: child,
      ),
    );
  }
}
