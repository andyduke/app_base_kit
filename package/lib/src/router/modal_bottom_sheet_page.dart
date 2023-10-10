import 'package:flutter/material.dart';

/// Modal route page Bottom Sheet for Navigator 2.0
///
/// Used in conjunction with BottomSheetScaffold.
class ModalBottomSheetPage<T> extends Page<T> {
  /// Creates a material page.
  const ModalBottomSheetPage({
    required this.builder,
    required this.isScrollControlled,
    this.isDismissible = true,
    this.maintainState = true,
    this.useSafeArea = false,
    this.fullscreenDialog = false,
    this.backgroundColor = Colors.transparent,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(key: key, name: name, arguments: arguments, restorationId: restorationId);

  /// The content to be shown in the [Route] created by this page.
  final WidgetBuilder builder;

  /// Specifies whether this is a route for a bottom sheet that will utilize
  /// [DraggableScrollableSheet].
  ///
  /// Consider setting this parameter to true if this bottom sheet has
  /// a scrollable child, such as a [ListView] or a [GridView],
  /// to have the bottom sheet be draggable.
  final bool isScrollControlled;

  /// Specifies whether the bottom sheet will be dismissed
  /// when user taps on the scrim.
  ///
  /// If true, the bottom sheet will be dismissed when user taps on the scrim.
  ///
  /// Defaults to true.
  final bool isDismissible;

  /// Whether to avoid system intrusions on the top, left, and right.
  ///
  /// If true, a [SafeArea] is inserted to keep the bottom sheet away from
  /// system intrusions at the top, left, and right sides of the screen.
  ///
  /// If false, the bottom sheet isn't exposed to the top padding of the
  /// MediaQuery.
  ///
  /// In either case, the bottom sheet extends all the way to the bottom of
  /// the screen, including any system intrusions.
  ///
  /// The default is false.
  final bool useSafeArea;

  /// Background color under the route widget.
  final Color? backgroundColor;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      builder: builder,
      isScrollControlled: isScrollControlled,
      settings: this,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      useSafeArea: useSafeArea,
    );
  }
}
