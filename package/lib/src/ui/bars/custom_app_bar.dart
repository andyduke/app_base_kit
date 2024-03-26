import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// App bar with custom design.
///
/// Allows you to create an app bar with any design that matches the design of the application.
/// You can change the background, shadow, margins, placement of elements on the bar, define any layout.
///
/// Typically used as a replacement for [AppBar] from Material Design.
///
/// Can be used directly, for example:
/// ```dart
/// Scaffold(
///   appBar: CustomAppBar(
///     height: 120,
///     decoration: const BoxDecoration(
///       color: Colors.amber,
///       boxShadow: [
///         BoxShadow(offset: Offset(0, 1), blurRadius: 16, color: Colors.black.withOpacity(0.1)),
///       ],
///     ),
///     padding: const EdgeInsets.all(12.0),
///     child: const Text('App bar'),
///   ),
///   ...
/// )
/// ```
///
/// ...but it is **better** to inherit the widget from [CustomAppBar] and implement
/// [buildLayout] and [getDecoration] methods:
/// ```dart
/// class FancyAppBar extends CustomAppBar {
///   final Widget? title;
///
///   const FancyAppBar({super.key, this.title, required super.child})
///       : super(
///           height: 140,
///           padding: const EdgeInsets.all(12.0),
///         );
///
///   @override
///   Widget buildLayout(BuildContext context, Widget? child) {
///     return Row(
///       mainAxisAlignment: MainAxisAlignment.start,
///       children: [
///         if (title != null)
///           DefaultTextStyle(
///             style: Theme.of(context).textTheme.headlineMedium ?? TextStyle(),
///             child: title!,
///           ),
///         const Text(':)'),
///       ],
///     );
///   }
///
///   @override
///   Decoration? getDecoration(BuildContext context, Decoration? decoration) {
///     return BoxDecoration(
///       color: Colors.amber,
///       boxShadow: [
///         BoxShadow(offset: const Offset(0, 1), blurRadius: 16, color: Colors.black.withOpacity(0.1)),
///       ],
///     );
///   }
///
/// }
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar height.
  ///
  /// The application bar must be a fixed height, you must specify its height using this parameter.
  final double height;

  /// The decoration to paint behind the child.
  ///
  /// If the decoration is [BoxDecoration] or [ShapeDecoration],
  /// then the background color of the bar (including the *system statusbar*)
  /// will be determined from the `decoration` color, but the color of the bar
  /// (for the *system statusbar*) can also be specified in [backgroundColor].
  ///
  /// See also:
  /// * [backgroundColor], to specify the background color of the *system statusbar*.
  final Decoration? decoration;

  /// The background color of the bar indicating what color the *system statusbar* should be.
  ///
  /// See also:
  /// * [decoration], for automatically determining the background color of the *system statusbar*.
  final Color? backgroundColor;

  /// Empty space to inscribe inside the decoration. The child, if any, is placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration]; see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  /// The [child] element contained in the bar.
  final Widget? child;

  /// Creates a custom app bar.
  ///
  /// See also:
  /// * [CustomAppBar], to understand how to use a custom app bar.
  ///
  const CustomAppBar({
    super.key,
    required this.height,
    this.backgroundColor,
    this.decoration,
    this.padding,
    required this.child,
  });

  /// Creates a layout for the app bar, for example here you can add a logo
  /// or a vertical stack with additional widgets.
  Widget buildLayout(BuildContext context, Widget? child) {
    return child ?? const SizedBox.shrink();
  }

  /// Creates a [DecoratedBox] based on the [decoration] parameter and wraps it around [child].
  ///
  /// If [decoration] is null, simply return [child].
  Widget buildDecoration(BuildContext context, Widget child, Decoration? decoration) {
    if (decoration != null) {
      return DecoratedBox(
        decoration: decoration,
        child: child,
      );
    } else {
      return child;
    }
  }

  /// Allows you to create [decoration] in an inherited class.
  Decoration? getDecoration(BuildContext context, Decoration? decoration) {
    return decoration;
  }

  @override
  Widget build(BuildContext context) {
    Widget body = buildLayout(context, child);

    if (padding != null) {
      body = Padding(
        padding: padding!,
        child: body,
      );
    }

    final barDecoration = getDecoration(context, decoration);

    body = buildDecoration(context, body, barDecoration);

    final barColor = backgroundColor ?? _decorationColor(barDecoration);
    if (barColor != null) {
      body = AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: barColor,
          statusBarBrightness: (barColor.computeLuminance() > 0.5) ? Brightness.light : Brightness.dark,
          statusBarIconBrightness: (barColor.computeLuminance() > 0.5) ? Brightness.dark : Brightness.light,
        ),
        child: body,
      );
    }

    return body;
  }

  Color? _decorationColor(Decoration? decoration) {
    final color = switch (decoration) {
      BoxDecoration(color: var color) => color,
      ShapeDecoration(color: var color) => color,
      _ => null,
    };
    return color;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
