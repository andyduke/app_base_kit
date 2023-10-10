import 'package:flutter/material.dart';

class ErrorViewTheme extends ThemeExtension<ErrorViewTheme> {
  final Color iconColor;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;

  ErrorViewTheme({
    required this.iconColor,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
  });

  @override
  ErrorViewTheme copyWith({
    Color? iconColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
  }) {
    return ErrorViewTheme(
      iconColor: iconColor ?? this.iconColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
    );
  }

  @override
  ErrorViewTheme lerp(ThemeExtension<ErrorViewTheme>? other, double t) {
    if (other is! ErrorViewTheme) {
      return this;
    }
    return ErrorViewTheme(
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t)!,
      subtitleTextStyle: TextStyle.lerp(subtitleTextStyle, other.subtitleTextStyle, t)!,
    );
  }

  @override
  String toString() =>
      'ErrorViewTheme(iconColor: $iconColor, titleTextStyle: $titleTextStyle, subtitleTextStyle: $subtitleTextStyle)';
}
