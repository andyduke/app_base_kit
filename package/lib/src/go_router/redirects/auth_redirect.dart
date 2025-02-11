import 'dart:async';
import 'package:app_base_kit/src/go_router/go_redirector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension AuthRedirectBuildContext on BuildContext {
  /// Goes to the login route, saving in the route state the
  /// path of the route from which the login route was called.
  void goLogin(String loginRouteName) {
    final currentPath = GoRouterState.of(this).path;
    if (currentPath != GoRouterState.of(this).namedLocation(loginRouteName)) {
      GoRouter.of(this).pushNamed(loginRouteName, extra: {'referrer': currentPath});
    }
  }
}

abstract class AuthRedirect extends GoRedirectBase {
  final String loginRouteName;
  final List<String> protectedRouteNames;
  final String loggedInRouteName;
  final String logoutRouteName;

  AuthRedirect({
    required this.loginRouteName,
    required Iterable<String> protectedRouteNames,
    required this.loggedInRouteName,
    required this.logoutRouteName,
  }) : protectedRouteNames = List.from(protectedRouteNames);

  bool isLogged(BuildContext context);

  @override
  FutureOr<String?> handle(BuildContext context, GoRouterState state) {
    final bool isLoggedIn = isLogged(context);
    final bool isLoginRoute = state.matchedLocation == state.namedLocation(loginRouteName);

    final bool isInsideProtectedRoute = protectedRouteNames.indexWhere(
          (protectedRouteName) => state.matchedLocation.startsWith(state.namedLocation(protectedRouteName)),
        ) !=
        -1;

    if (isLoggedIn && isLoginRoute) {
      if (state.extra case {'referrer': String referrer}) {
        return state.namedLocation(loggedInRouteName, queryParameters: {'referrer': referrer});
      }

      return state.namedLocation(loggedInRouteName);
    }
    if (!isLoggedIn && isInsideProtectedRoute) {
      return state.namedLocation(logoutRouteName);
    }

    return null;
  }
}
