import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Basic interface for implementing redirect classes.
abstract class GoRedirectBase {
  /// A handler that is called to process the redirect.
  ///
  /// See [GoRouter.redirect] for more details.
  ///
  /// **Attention!** Unlike GoRouter, the `state` parameter will
  /// contain the topmost route in the navigation stack.
  FutureOr<String?> handle(BuildContext context, GoRouterState state);
}

/// GoRedirect redirect callback signature.
typedef GoRedirectHandler = FutureOr<String?> Function(BuildContext context, GoRouterState state);

/// Helper class for specifying a redirect as a callback.
class GoRedirect implements GoRedirectBase {
  final GoRedirectHandler handler;

  GoRedirect(this.handler);

  @override
  FutureOr<String?> handle(BuildContext context, GoRouterState state) => handler(context, state);
}

/// Makes it easier to add groups of redirects, and also fixes a bug in GoRouter
/// when using mixed navigation (declarative and imperative).
class GoRedirector {
  final List<GoRedirectBase> redirects;

  GoRedirector(this.redirects);

  FutureOr<String?> call(BuildContext context, GoRouterState state) async {
    if (redirects.isEmpty) return null;

    final actualState = _actualState(context, state);
    for (var redirect in redirects) {
      final url = await redirect.handle(context, actualState);
      if (url != null) {
        return url;
      }
    }

    return null;
  }

  /// Workaround for issue #133985 (https://github.com/flutter/flutter/issues/133985) in GoRouter
  GoRouterState _actualState(BuildContext context, GoRouterState state) {
    // If state.topRoute exists, then there is a need to build a new GoRouterState for it:
    // search for it in the RouteMatchList and create a new GoRouterState using the
    // RouteMatchBase buildState method.

    if (state.topRoute != null) {
      if (context.widget case Router router) {
        if (router.routeInformationParser case GoRouteInformationParser goParser) {
          final matchList = (router.routerDelegate.currentConfiguration is RouteMatchList)
              ? router.routerDelegate.currentConfiguration as RouteMatchList
              : null;
          if (matchList != null && matchList.isNotEmpty) {
            final routeMatchIndex = matchList.matches.indexWhere((match) => match.route == state.topRoute);
            if (routeMatchIndex != -1) {
              final match = matchList.matches[routeMatchIndex];
              final state = match.buildState(goParser.configuration, matchList);
              return state;
            }
          }
        }
      }
    }

    return state;
  }
}
