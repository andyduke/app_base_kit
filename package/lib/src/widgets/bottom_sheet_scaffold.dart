import 'package:flutter/material.dart';

/// Bottom Sheet Scaffold Builder Signature.
typedef ScrollableWidgetBuilder = Widget Function(BuildContext context, ScrollController controller);

/// Scaffolding Scrollable Bottom Sheet.
class BottomSheetScaffold extends StatelessWidget {
  static const double defaultInitialChildSize = 0.5;
  static const double defaultMinChildSize = 0.3;
  static const double defaultMaxChildSize = 0.9;
  static const bool defaultShouldCloseOnMinExtent = true;
  static const BorderRadius defaultBorderRadius = BorderRadius.vertical(top: Radius.circular(8));

  /// Builder creating a scrollable area with content.
  final ScrollableWidgetBuilder builder;

  /// AppBar displayed at the top of the screen.
  final PreferredSizeWidget? appBar;

  /// Bar displayed at the bottom of the screen.
  final Widget? bottomBar;

  /// The initial fractional value of the parent container's height to use when displaying the BottomSheetScaffold.
  final double initialChildSize;

  /// The minimum fractional value of the parent container's height to use when displaying the BottomSheetScaffold.
  final double minChildSize;

  /// The maximum fractional value of the parent container's height to use when displaying the BottomSheetScaffold.
  final double maxChildSize;

  /// Whether the sheet, when dragged (or flung) to its minimum size, should cause its parent sheet to close.
  final bool shouldCloseOnMinExtent;

  /// Sheet background color.
  final Color? backgroundColor;

  /// Sheet Corner Radius.
  final BorderRadius borderRadius;

  /// Creates a Scaffolding Scrollable Bottom Sheet.
  const BottomSheetScaffold({
    super.key,
    required this.builder,
    this.appBar,
    this.bottomBar,
    this.backgroundColor,
    this.initialChildSize = defaultInitialChildSize,
    this.minChildSize = defaultMinChildSize,
    this.maxChildSize = defaultMaxChildSize,
    this.shouldCloseOnMinExtent = defaultShouldCloseOnMinExtent,
    this.borderRadius = defaultBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sheetTheme = theme.bottomSheetTheme;

    double initialSize = initialChildSize;
    double minSize = minChildSize;
    double maxSize = maxChildSize;

    if (minSize < 0) minSize = 0;
    if (maxSize > 1.0) maxSize = 1.0;
    if (initialSize > maxSize) initialSize = maxSize;
    if (minSize > initialSize) initialSize = minSize;

    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
      expand: false,
      shouldCloseOnMinExtent: shouldCloseOnMinExtent,
      builder: (BuildContext context, ScrollController scrollController) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _BottomSheetSafeArea(
            child: Material(
              elevation: sheetTheme.modalElevation ?? 0,
              type: MaterialType.canvas,
              clipBehavior: Clip.antiAlias,
              borderRadius: borderRadius,
              shape: sheetTheme.shape,
              shadowColor: sheetTheme.shadowColor,
              surfaceTintColor: sheetTheme.surfaceTintColor,
              child: ConstrainedBox(
                constraints: sheetTheme.constraints ?? const BoxConstraints(maxWidth: 560),
                child: Scaffold(
                  backgroundColor: backgroundColor ?? sheetTheme.modalBackgroundColor ?? theme.canvasColor,
                  appBar: appBar,
                  body: Column(
                    children: [
                      // Body
                      Expanded(
                        child: builder(context, scrollController),
                      ),

                      // Bottom Bar
                      if (bottomBar != null) bottomBar!,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A widget that inserts enough padding into the Bottom Sheet widget
/// to avoid overlapping operating system safe zones
class _BottomSheetSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const _BottomSheetSafeArea({
    super.key, // ignore: unused_element
    required this.child,
    this.top = true, // ignore: unused_element
    this.bottom = true, // ignore: unused_element
    this.left = true, // ignore: unused_element
    this.right = true, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      // Safe zones
      padding: EdgeInsets.only(
        top: top ? MediaQueryData.fromView(View.of(context)).padding.top : 0,
        bottom: bottom ? MediaQuery.of(context).viewInsets.bottom : 0,
        left: left ? MediaQueryData.fromView(View.of(context)).padding.left : 0,
        right: right ? MediaQueryData.fromView(View.of(context)).padding.right : 0,
      ),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,

      // Child
      child: child,
    );
  }
}
