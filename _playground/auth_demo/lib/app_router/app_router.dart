import 'package:app_base_kit/app_base_kit.dart';
import 'package:auth_demo/auth/auth_state.dart';
import 'package:auth_demo/screens/favorites_screen.dart';
import 'package:auth_demo/screens/home_screen.dart';
import 'package:auth_demo/screens/loading_screen.dart';
import 'package:auth_demo/screens/login_screen.dart';
import 'package:auth_demo/screens/settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum AppRoutes {
  start('start'),
  loading('loading'),
  protected('protected', '/user'),
  home('home'),
  favorites('favorites'),
  settings('settings'),
  login('login'),
  loggedIn('logged-in', '/loggedIn'),
  logout('logout');

  final String name;
  final String? _path;

  String get path => _path ?? '/$name';

  const AppRoutes(this.name, [this._path]);
}

abstract class AppRouter {
  static GoRouter router(AuthState authState) => _router ??= buildRouter(authState);
  static GoRouter? _router;

  static final String initialLocation = AppRoutes.start.path;
  // static final String initialLocation = AppRoutes.home.path;

  @protected
  static GoRouter buildRouter(AuthState authState) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      redirectLimit: 12,
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          name: AppRoutes.start.name,
          path: AppRoutes.start.path,
          redirect: (context, state) {
            final auth = context.read<AppAuthState>();
            final isReady = auth.isReady;
            final isLoggedIn = auth.isLogged;

            if (isReady && isLoggedIn) {
              return state.namedLocation(AppRoutes.protected.name);
            }
            return state.namedLocation(AppRoutes.loading.name);
          },
        ),
        GoRouteGroup(
          name: AppRoutes.protected.name,
          path: AppRoutes.protected.path,
          // initialRoute: AppRoutes.home.name,
          routes: [
            GoRoute(
              name: AppRoutes.home.name,
              path: AppRoutes.home.path,
              pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
              routes: [
                GoRoute(
                  name: AppRoutes.favorites.name,
                  path: AppRoutes.favorites.path,
                  builder: (context, state) => const FavoritesScreen(),
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.settings.name,
              path: AppRoutes.settings.path,
              pageBuilder: (context, state) => const PopupPageTransition(child: SettingsScreen()),
            ),
          ],
        ),

        /*
        GoRoute(
          name: AppRoutes.home.name,
          path: AppRoutes.home.path,
          builder: (context, state) => const HomeScreen(),
        ),
        */
        GoRoute(
          name: AppRoutes.loading.name,
          path: AppRoutes.loading.path,
          builder: (context, state) => const LoadingScreen(),
        ),
        GoRoute(
          name: AppRoutes.login.name,
          path: AppRoutes.login.path,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: AppRoutes.loggedIn.name,
          path: AppRoutes.loggedIn.path,
          redirect: (context, state) => context.read<AppAuthState>().isLogged
              ? initialLocation
              : (state.uri.queryParameters['referrer'] ?? initialLocation),
        ),
        GoRoute(
          name: AppRoutes.logout.name,
          path: AppRoutes.logout.path,
          redirect: (BuildContext context, GoRouterState state) async => initialLocation,
        ),
      ],

      refreshListenable: authState,
      // ignore: implicit_call_tearoffs
      redirect: GoRedirector(
        [
          /*
          LoadingRedirect(
            loadingRouteName: loadingRouteName,
            loadedRouteName: loginRouteName,
          ),
          AuthRedirect(
            loginRouteName: loginRouteName,
            protectedRouteNames: [dashRouteName, schoolSelectRouteName],
            loggedInRouteName: loggedInRouteName,
            logoutRouteName: logoutRouteName,
            errorRouteName: authErrorRouteName,
          ),
          */

          LoadingRedirect(
            authState: authState,
            loadingRouteName: AppRoutes.loading.name,
            loadedRouteName: AppRoutes.login.name,
          ),
          AppAuthRedirect(
            loginRouteName: AppRoutes.login.name,
            protectedRouteNames: [
              AppRoutes.protected.name,
              // accountRouteName,
              // favoritesRouteName,
            ],
            loggedInRouteName: AppRoutes.loggedIn.name,
            logoutRouteName: AppRoutes.logout.name,
          ),
        ],
      ),
    );
  }
}

class AppAuthRedirect extends AuthRedirect {
  AppAuthRedirect({
    required super.loginRouteName,
    required super.protectedRouteNames,
    required super.loggedInRouteName,
    required super.logoutRouteName,
  });

  @override
  bool isLogged(BuildContext context) => context.read<AppAuthState>().isLogged;
}

// TODO: Extract to AppBaseKit
class GoRouteGroup extends GoRoute {
  /// The name of the route to which a redirect will occur when switching to the group route.
  final String? initialRoute;

  GoRouteGroup({
    required super.path,
    required String super.name,
    super.parentNavigatorKey,
    super.onExit,
    super.routes,
    this.initialRoute,
  }) : super(
          redirect: (context, state) {
            final bool isSelf = state.fullPath == state.namedLocation(name);

            if (isSelf) {
              final targetRoute = initialRoute ?? ((routes.first is GoRoute) ? (routes.first as GoRoute).name : null);
              if (targetRoute == null) {
                throw Exception(
                  '[GoRouteGroup] You need to set an initialRoute to which the redirect will occur '
                  'when going to the group route, or the first route in the routes must be a named GoRoute.',
                );
              }

              return state.namedLocation(targetRoute);
            }

            // no need to redirect at all
            return null;
          },
        );
}
