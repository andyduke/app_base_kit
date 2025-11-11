import 'package:app_base_kit/src/utils/value_property.dart';
import 'package:app_base_kit/src/widgets/waiting.dart';
import 'package:flutter/material.dart';

/// Waiting indicator theme
class WaitingTheme extends ThemeExtension<WaitingTheme> {
  static WaitingTheme defaultsOf(BuildContext context) {
    final theme = Theme.of(context);

    return WaitingTheme(
      primaryColor: theme.colorScheme.primary,
      color: theme.colorScheme.onSurface,
      padding: WaitingSizeProperty<EdgeInsetsGeometry>(
        small: const EdgeInsets.all(16),
        large: const EdgeInsets.all(24),
      ),
    );
  }

  /// Indicator primary color
  final Color primaryColor;

  /// Indicator color
  final Color color;

  /// Spacing around indicator
  final WaitingSizeProperty<EdgeInsetsGeometry> padding;

  WaitingTheme({
    required this.primaryColor,
    required this.color,
    required this.padding,
  });

  @override
  WaitingTheme copyWith({
    Color? primaryColor,
    Color? color,
    WaitingSizeProperty<EdgeInsetsGeometry>? padding,
  }) {
    return WaitingTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      color: color ?? this.color,
      padding: padding ?? this.padding,
    );
  }

  @override
  WaitingTheme lerp(ThemeExtension<WaitingTheme>? other, double t) {
    if (other is! WaitingTheme) {
      return this;
    }
    return WaitingTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      color: Color.lerp(color, other.color, t)!,
      padding: WaitingSizeProperty.lerp<EdgeInsetsGeometry>(
        padding,
        other.padding,
        t,
        (a, b, t) => EdgeInsetsGeometry.lerp(a, b, t)!,
      )!,
    );
  }

  @override
  String toString() => 'WaitingTheme(primaryColor: $primaryColor, color: $color, padding: $padding)';
}

/// State property calculated based on the spinner size
class WaitingSizeProperty<T> implements ValueProperty<T, WaitingSize> {
  final T small;
  final T large;

  WaitingSizeProperty({
    required this.small,
    required this.large,
  });

  @override
  T resolve(WaitingSize size) {
    final result = switch (size) {
      WaitingSize.small => small,
      WaitingSize.large => large,
    };
    return result;
  }

  static WaitingSizeProperty<T>? lerp<T>(
    WaitingSizeProperty<T>? a,
    WaitingSizeProperty<T>? b,
    double t,
    T Function(T? a, T? b, double t) lerpValue,
  ) {
    if (a == null && b == null) {
      return null;
    }

    return WaitingSizeProperty<T>(
      small: lerpValue(a?.small, b?.small, t),
      large: lerpValue(a?.large, b?.large, t),
    );
  }

  @override
  String toString() => 'WaitingSizeProperty(small: $small, large: $large)';
}
