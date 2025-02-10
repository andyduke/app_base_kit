import 'dart:async';
import 'package:app_base_kit/src/auth_kit/auth_kit.dart';
import 'package:app_base_kit/src/go_router/go_redirector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingRedirect extends GoRedirectBase {
  final AuthState authState;
  final String loadingRouteName;
  final String loadedRouteName;

  LoadingRedirect({
    required this.authState,
    required this.loadingRouteName,
    required this.loadedRouteName,
  });

  @override
  FutureOr<String?> handle(BuildContext context, GoRouterState state) {
    if (context.mounted) {
      final loadingRoute = state.namedLocation(loadingRouteName);
      final bool isLoadingRoute = state.matchedLocation == loadingRoute;

      if (!authState.isReady && !isLoadingRoute) {
        return loadingRoute;
      }
      if (authState.isReady && isLoadingRoute) {
        final loadedRoute = state.namedLocation(loadedRouteName);
        return loadedRoute;
      }
    }

    return null;
  }
}
