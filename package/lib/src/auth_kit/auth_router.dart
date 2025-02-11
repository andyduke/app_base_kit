import 'dart:async';
import 'package:app_base_kit/src/auth_kit/auth_kit.dart';
import 'package:app_base_kit/src/go_router/go_redirector.dart';
import 'package:app_base_kit/src/go_router/redirects/auth_redirect.dart';
import 'package:app_base_kit/src/go_router/redirects/loading_redirect.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part '_auth_routes.dart';

typedef AuthRouterGoBuilder = GoRouter Function(
  String initialLocation,
  List<RouteBase> routes,
  AuthState authState,
  GoRouterRedirect redirect,
  bool debugLogDiagnostics,
  int redirectLimit,
);

class AuthRouter implements RouterConfig<RouteMatchList> {
  static const defaultRedirectLimit = 12;

  late final String initialLocation;
  final AuthState authState;
  final List<RouteBase> routes;
  final List<GoRoute> protectedRoutes;
  late final Set<AuthRoute> authRoutes;
  final AuthRouterGoBuilder? goRouterBuilder;
  final Iterable<GoRedirectBase> redirects;
  final bool debugLogDiagnostics;
  final int redirectLimit;

  @protected
  late final StartRoute startRoute;

  @protected
  late final LoadingRoute loadingRoute;

  @protected
  late final LoginRoute loginRoute;

  @protected
  late final LoggedInRoute loggedInRoute;

  @protected
  late final LogoutRoute logoutRoute;

  @protected
  late final String initialProtectedRoute;

  AuthRouter({
    String? initialLocation,
    required this.authState,
    this.routes = const [],
    required this.protectedRoutes,
    String? initialProtectedRoute,
    Set<AuthRoute> authRoutes = const {},
    this.goRouterBuilder,
    this.redirects = const [],
    this.debugLogDiagnostics = false,
    this.redirectLimit = defaultRedirectLimit,
  }) {
    assert(authRoutes.whereType<LoadingRoute>().isNotEmpty, 'The "authRoutes" parameter must specify LoadingRoute.');
    assert(authRoutes.whereType<LoginRoute>().isNotEmpty, 'The "authRoutes" parameter must specify LoginRoute.');
    assert(protectedRoutes.isNotEmpty, 'In "protectedRoutes", you must specify one or more routes of type GoRoute.');

    this.authRoutes = {
      ...authRoutes,
      const StartRoute(),
      const LoggedInRoute(),
      const LogoutRoute(),
    };

    startRoute = this.authRoutes.whereType<StartRoute>().first;
    loadingRoute = this.authRoutes.whereType<LoadingRoute>().first;
    loginRoute = this.authRoutes.whereType<LoginRoute>().first;
    loggedInRoute = this.authRoutes.whereType<LoggedInRoute>().first;
    logoutRoute = this.authRoutes.whereType<LogoutRoute>().first;

    this.initialLocation = initialLocation ?? startRoute.path;
    this.initialProtectedRoute =
        initialProtectedRoute ?? protectedRoutes.whereType<GoRoute>().first.name!; // TODO: Test first.name is not null

    final goRoutes = [
      ...this.authRoutes.map((r) => r.build(this)),
      ...protectedRoutes,
      ...routes,
    ];

    goRouter = (goRouterBuilder ?? defaultGoRouterBuilder).call(
      this.initialLocation,
      goRoutes,
      authState,
      redirect,
      debugLogDiagnostics,
      redirectLimit,
    );
  }

  @protected
  GoRouter defaultGoRouterBuilder(
    String initialLocation,
    List<RouteBase> routes,
    AuthState authState,
    GoRouterRedirect redirect,
    bool debugLogDiagnostics,
    int redirectLimit,
  ) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: routes,
      refreshListenable: authState,
      redirect: redirect,
      debugLogDiagnostics: debugLogDiagnostics,
      redirectLimit: redirectLimit,
    );
  }

  @protected
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return GoRedirector(
      [
        LoadingRedirect(
          authState: authState,
          loadingRouteName: loadingRoute.name,
          loadedRouteName: loginRoute.name,
        ),
        _AuthRedirect(
          appState: authState,
          loginRouteName: loginRoute.name,
          protectedRouteNames: protectedRoutes.map((r) => r.name!),
          loggedInRouteName: loggedInRoute.name,
          logoutRouteName: logoutRoute.name,
        ),
        ...redirects,
      ],
    ).call(context, state);
  }

  @protected
  late final GoRouter goRouter;

  /// The [RouteInformationProvider] that is used to configure the [Router].
  @override
  RouteInformationProvider get routeInformationProvider => goRouter.routeInformationProvider;

  /// The [RouteInformationParser] that is used to configure the [Router].
  @override
  RouteInformationParser<RouteMatchList> get routeInformationParser => goRouter.routeInformationParser;

  /// The [RouterDelegate] that is used to configure the [Router].
  @override
  RouterDelegate<RouteMatchList> get routerDelegate => goRouter.routerDelegate;

  /// The [BackButtonDispatcher] that is used to configure the [Router].
  @override
  BackButtonDispatcher get backButtonDispatcher => goRouter.backButtonDispatcher;
}

class _AuthRedirect extends AuthRedirect {
  final AuthState appState;

  _AuthRedirect({
    required this.appState,
    required super.loginRouteName,
    required super.protectedRouteNames,
    required super.loggedInRouteName,
    required super.logoutRouteName,
  });

  @override
  bool isLogged(BuildContext context) => appState.isLogged;
}
