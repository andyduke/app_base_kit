import 'package:flutter/material.dart';

class LabelTheme extends ThemeExtension<LabelTheme> {
  final TextStyle textStyle;
  final TextStyle? acceleratorTextStyle;

  LabelTheme({
    required this.textStyle,
    this.acceleratorTextStyle,
  });

  @override
  LabelTheme copyWith({
    TextStyle? textStyle,
    TextStyle? acceleratorTextStyle,
  }) {
    return LabelTheme(
      textStyle: textStyle ?? this.textStyle,
      acceleratorTextStyle: acceleratorTextStyle ?? this.acceleratorTextStyle,
    );
  }

  @override
  LabelTheme lerp(ThemeExtension<LabelTheme>? other, double t) {
    if (other is! LabelTheme) {
      return this;
    }
    return LabelTheme(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      acceleratorTextStyle: TextStyle.lerp(acceleratorTextStyle, other.acceleratorTextStyle, t),
    );
  }

  @override
  String toString() => 'LabelTheme(textStyle: $textStyle, acceleratorTextStyle: $acceleratorTextStyle)';
}
