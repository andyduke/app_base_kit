import 'package:go_router/go_router.dart';

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
