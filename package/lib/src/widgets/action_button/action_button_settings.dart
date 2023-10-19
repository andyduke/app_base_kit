import 'package:app_base_kit/src/defaults.dart';
import 'package:flutter/material.dart';

typedef ActionButtonBuilder = Widget Function(
  BuildContext context,
  Widget child,
  VoidCallback? onPressed,
  bool inProgress,
);

typedef ActionButtonIndicatorBuilder = Widget Function(BuildContext context, double size);

class ActionButtonDefaults implements DefaultsData {
  static ActionButtonDefaults defaults = ActionButtonDefaults(
    primaryBuilder: (context, child, onPressed, inProgress) {
      final theme = Theme.of(context);
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: !inProgress ? onPressed : null,
        child: child,
      );
    },
    builder: (context, child, onPressed, inProgress) => OutlinedButton(
      onPressed: !inProgress ? onPressed : null,
      child: child,
    ),
    indicatorBuilder: (context, size) => SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: (size < 64) ? 2 : 3,
      ),
    ),
  );

  final ActionButtonBuilder? primaryBuilder;
  final ActionButtonBuilder? builder;
  final ActionButtonIndicatorBuilder? indicatorBuilder;

  ActionButtonDefaults({
    this.primaryBuilder,
    this.builder,
    this.indicatorBuilder,
  });
}
