import 'package:flutter/painting.dart';

/// Description of a pair of colors: foreground and background
class ColorSet {
  final Color foreground;
  final Color background;

  const ColorSet({
    required this.foreground,
    required this.background,
  });

  @override
  bool operator ==(covariant ColorSet other) => (foreground == other.foreground) && (background == other.background);

  @override
  int get hashCode => Object.hash(foreground, background);

  @override
  String toString() => 'ColorSet(foreground: $foreground, background: $background)';

  static ColorSet? lerp(ColorSet? a, ColorSet? b, double t) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return ColorSet(
        foreground: Color.lerp(null, b!.foreground, t)!,
        background: Color.lerp(null, b.background, t)!,
      );
    }

    if (b == null) {
      return ColorSet(
        foreground: Color.lerp(a.foreground, null, t)!,
        background: Color.lerp(a.background, null, t)!,
      );
    }

    return ColorSet(
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      background: Color.lerp(a.background, b.background, t)!,
    );
  }
}
