part of 'auth_router.dart';

abstract class AuthRoute<T extends AuthRoute<dynamic>> {
  /// Optional name of the route.
  final String name;

  /// The path of this go route.
  final String path;

  const AuthRoute({
    required this.name,
    required this.path,
  });

  @override
  bool operator ==(covariant AuthRoute other) => other is T;

  @override
  int get hashCode => runtimeType.hashCode;

  @protected
  GoRoute build(AuthRouter router);
}

class StartRoute extends AuthRoute<StartRoute> {
  static const defaultName = 'start';
  static const defaultPath = '/start';

  const StartRoute({
    super.path = defaultPath,
    super.name = defaultName,
  });

  @override
  GoRoute build(AuthRouter router) {
    return GoRoute(
      path: path,
      name: name,
      redirect: (context, state) {
        final auth = router.authState;
        final isReady = auth.isReady;
        final isLoggedIn = auth.isLogged;

        if (isReady && isLoggedIn) {
          return state.namedLocation(router.initialProtectedRoute);
        }
        return state.namedLocation(router.loadingRoute.name);
      },
    );
  }
}

class LoadingRoute extends AuthRoute<LoadingRoute> {
  static const defaultName = 'loading';
  static const defaultPath = '/loading';

  /// A custom builder for this route.
  final GoRouterWidgetBuilder? builder;

  /// A page builder for this route.
  final GoRouterPageBuilder? pageBuilder;

  const LoadingRoute({
    super.path = defaultPath,
    super.name = defaultName,
    this.builder,
    this.pageBuilder,
  }) : assert(pageBuilder != null || builder != null, 'builder, or pageBuilder must be provided');

  @override
  GoRoute build(AuthRouter router) {
    return GoRoute(
      path: path,
      name: name,
      builder: builder,
      pageBuilder: pageBuilder,
    );
  }
}

class LoginRoute extends AuthRoute<LoginRoute> {
  static const defaultName = 'login';
  static const defaultPath = '/login';

  /// A custom builder for this route.
  final GoRouterWidgetBuilder? builder;

  /// A page builder for this route.
  final GoRouterPageBuilder? pageBuilder;

  const LoginRoute({
    super.path = defaultPath,
    super.name = defaultName,
    this.builder,
    this.pageBuilder,
  }) : assert(pageBuilder != null || builder != null, 'builder, or pageBuilder must be provided');

  @override
  GoRoute build(AuthRouter router) {
    return GoRoute(
      path: path,
      name: name,
      builder: builder,
      pageBuilder: pageBuilder,
    );
  }
}

class LoggedInRoute extends AuthRoute<LoggedInRoute> {
  static const defaultName = 'logged-in';
  static const defaultPath = '/logged-in';

  const LoggedInRoute({
    super.path = defaultPath,
    super.name = defaultName,
  });

  @override
  GoRoute build(AuthRouter router) {
    return GoRoute(
      path: path,
      name: name,
      redirect: (context, state) => router.authState.isLogged
          ? router.initialLocation
          : (state.uri.queryParameters['referrer'] ?? router.initialLocation),
    );
  }
}

class LogoutRoute extends AuthRoute<LogoutRoute> {
  static const defaultName = 'logout';
  static const defaultPath = '/logout';

  const LogoutRoute({
    super.path = defaultPath,
    super.name = defaultName,
  });

  @override
  GoRoute build(AuthRouter router) {
    return GoRoute(
      path: path,
      name: name,
      redirect: (BuildContext context, GoRouterState state) async => router.initialLocation,
    );
  }
}
