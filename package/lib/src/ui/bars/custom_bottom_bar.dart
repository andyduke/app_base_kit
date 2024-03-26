import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Bottom bar with a custom design for use with [Scaffold].
///
/// Allows you to create a bottom bar with any design that matches the design of the application.
/// You can change the background, shadow, margins, placement of elements on the bar, define any layout.
///
/// Can be used directly, for example:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: CustomBottomBar(
///     decoration: const BoxDecoration(
///       color: Colors.amber,
///       boxShadow: [
///         BoxShadow(offset: Offset(0, -1), blurRadius: 16, color: Colors.black.withOpacity(0.1)),
///       ],
///     ),
///     padding: const EdgeInsets.all(12.0),
///     child: const Text('Bottom bar'),
///   ),
///   ...
/// )
/// ```
/// ...but it is **better** to inherit the widget from [CustomBottomBar] and implement
/// [buildLayout] and [getDecoration] methods:
/// ```dart
/// class FancyBottomBar extends CustomAppBar {
///   FancyBottomBar({required super.child})
///       : super(
///           padding: const EdgeInsets.all(12.0),
///         );
///
///   @override
///   Widget buildLayout(BuildContext context, Widget child) {
///     return Row(
///       mainAxisAlignment: MainAxisAlignment.spaceBetween,
///       children: [
///         child,
///         const Text('!'),
///       ],
///     );
///   }
///
///   @override
///   Decoration? getDecoration(BuildContext context, Decoration? decoration) {
///     return const BoxDecoration(
///       color: Theme.of(context).colorScheme.secondaryContainer,
///       boxShadow: [
///         BoxShadow(offset: Offset(0, -1), blurRadius: 16, color: Colors.black.withOpacity(0.1)),
///       ],
///     );
///   }
///
/// }
/// ```
class CustomBottomBar extends StatelessWidget {
  /// The decoration to paint behind the child.
  ///
  /// If the decoration is [BoxDecoration] or [ShapeDecoration],
  /// then the background color of the bar (including the *system navigation bar*)
  /// will be determined from the `decoration` color, but the color of the bar
  /// (for the *system navigation bar*) can also be specified in [backgroundColor].
  ///
  /// See also:
  /// * [backgroundColor], to specify the background color of the *system navigation bar*.
  final Decoration? decoration;

  /// The background color of the bar indicating what color the *system navigation bar* should be.
  ///
  /// See also:
  /// * [decoration], for automatically determining the background color of the *system navigation bar*.
  final Color? backgroundColor;

  /// Empty space to inscribe inside the decoration. The child, if any, is placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration]; see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  /// The [child] element contained in the bar.
  final Widget child;

  /// Creates a custom bottom bar.
  ///
  /// See also:
  /// * [CustomBottomBar], to understand how to use a custom bottom bar.
  ///
  const CustomBottomBar({
    super.key,
    this.backgroundColor,
    this.decoration,
    this.padding,
    required this.child,
  });

  /// Creates a layout for the bottom bar, for example here you can add additional widgets.
  Widget buildLayout(BuildContext context, Widget child) {
    return child;
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
          systemNavigationBarColor: barColor,
          systemNavigationBarIconBrightness: (barColor.computeLuminance() > 0.5) ? Brightness.dark : Brightness.light,
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
}
