import 'package:app_base_kit/app_base_kit.dart';
import 'package:auth_demo/screens/favorites_screen.dart';
import 'package:auth_demo/screens/home_screen.dart';
import 'package:auth_demo/screens/loading_screen.dart';
import 'package:auth_demo/screens/login_screen.dart';
import 'package:auth_demo/screens/settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  /*
  start('start'),
  loading('loading'),
  */
  protected('protected', '/user'),
  home('home'),
  favorites('favorites'),
  settings('settings'),
  /*
  login('login'),
  loggedIn('logged-in', '/loggedIn'),
  logout('logout')
  */
  ;

  final String name;
  final String? _path;

  String get path => _path ?? '/$name';

  const AppRoutes(this.name, [this._path]);
}

abstract class AppRouter {
  static RouterConfig<RouteMatchList> router(AuthState authState) => _router ??= buildRouter(authState);
  static RouterConfig<RouteMatchList>? _router;

  @protected
  static RouterConfig<RouteMatchList> buildRouter(AuthState authState) {
    return AuthRouter(
      debugLogDiagnostics: kDebugMode,
      authState: authState,
      authRoutes: {
        LoadingRoute(
          builder: (context, state) => const LoadingScreen(),
        ),
        LoginRoute(
          builder: (context, state) => const LoginScreen(),
        ),
      },
      protectedRoutes: [
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
      ],
    );
  }
}
