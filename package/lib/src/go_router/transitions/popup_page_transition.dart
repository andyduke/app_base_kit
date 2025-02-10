import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class PopupPageTransition<T> extends CustomTransitionPage<T> {
  static const defaultBarrierColor = Colors.black54;
  static const defaultDuration = Duration(milliseconds: 300);

  static double fullscreenMinWidth = 700;

  const PopupPageTransition({
    required super.child,
    super.transitionDuration = defaultDuration,
    super.reverseTransitionDuration = defaultDuration,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = false,
    super.barrierDismissible = false,
    super.barrierLabel,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.barrierColor = defaultBarrierColor,
  }) : super(
          transitionsBuilder: _transitionsBuilder,
        );

  static bool isFullscreenPage(BuildContext context) {
    final viewportSize = MediaQuery.sizeOf(context);
    final isFullscreen = (viewportSize.width <= fullscreenMinWidth);
    return isFullscreen;
  }

  static Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isFullscreen = isFullscreenPage(context);
    return isFullscreen //
        ? _fullscreenTransitionsBuilder(context, animation, secondaryAnimation, child)
        : _popupTransitionsBuilder(context, animation, secondaryAnimation, child);
  }

  static Widget _fullscreenTransitionsBuilder(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  static Widget _popupTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    final theme = Theme.of(context).extension<PopupPageTheme>() ?? PopupPageTheme.themeDefaults;
    final borderRadius = BorderRadius.vertical(top: Radius.circular(theme.borderRadius));

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.pop(context);
        }
      },
      child: Focus(
        autofocus: true,
        child: SlideTransition(
          position: offsetAnimation,
          child: Center(
            child: ConstrainedBox(
              constraints: theme.constraints,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  boxShadow: theme.shadow,
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---

class PopupPageTheme extends ThemeExtension<PopupPageTheme> with Diagnosticable {
  static const themeDefaults = PopupPageTheme(
    constraints: BoxConstraints(
      minWidth: 280,
      maxWidth: 420,
      maxHeight: 600,
    ),
    borderRadius: 4,
    shadow: [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 24,
        color: Color(0x14000D80),
      ),
    ],
  );

  /// Sets popup size limits
  final BoxConstraints constraints;

  /// Popup corner rounding radius
  final double borderRadius;

  /// Popup shadow
  final List<BoxShadow> shadow;

  const PopupPageTheme({
    required this.constraints,
    required this.borderRadius,
    required this.shadow,
  });

  @override
  PopupPageTheme copyWith({
    BoxConstraints? constraints,
    double? borderRadius,
    List<BoxShadow>? shadow,
  }) {
    return PopupPageTheme(
      constraints: constraints ?? this.constraints,
      borderRadius: borderRadius ?? this.borderRadius,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  PopupPageTheme lerp(PopupPageTheme? other, double t) {
    if (other is! PopupPageTheme) {
      return this;
    }
    return PopupPageTheme(
      constraints: BoxConstraints.lerp(constraints, other.constraints, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      shadow: BoxShadow.lerpList(shadow, other.shadow, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints));
    properties.add(DoubleProperty('borderRadius', borderRadius));
    properties.add(IterableProperty<BoxShadow>('shadow', shadow));
  }
}
