import 'package:app_base_kit/src/themes/waiting_theme.dart';
import 'package:flutter/material.dart';

/// Waiting indicator size
enum WaitingSize {
  small(size: 20, storkeWidth: 2),
  large(size: 36, storkeWidth: 3);

  final double size;
  final double storkeWidth;

  const WaitingSize({
    required this.size,
    required this.storkeWidth,
  });
}

/// Waiting indicator
class Waiting extends StatelessWidget {
  final bool primary;
  final WaitingSize size;
  final EdgeInsets? padding;

  const Waiting({
    super.key,
    this.primary = true,
    this.size = WaitingSize.large,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final waitingTheme = Theme.of(context).extension<WaitingTheme>() ?? WaitingTheme.defaultsOf(context);

    return Padding(
      padding: padding ?? waitingTheme.padding.resolve(size),
      child: SizedBox.square(
        dimension: size.size,
        child: CircularProgressIndicator(
          strokeWidth: size.storkeWidth,
          color: primary ? waitingTheme.primaryColor : waitingTheme.color,
        ),
      ),
    );
  }
}
