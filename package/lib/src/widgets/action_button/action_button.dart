import 'package:app_base_kit/src/defaults.dart';
import 'package:app_base_kit/src/widgets/action_button/action_button_settings.dart';
import 'package:flutter/material.dart';

/// Action button.
///
/// The button can display a progress indicator and
/// prevent tapping while showing progress.
class ActionButton extends StatelessWidget {
  /// Indicates that this is a primary action button.
  final bool primary;

  /// The content of the button, usually the button's label.
  final Widget child;

  /// Whether the button is enabled or disabled.
  final bool enabled;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// Indicates whether an action is currently running.
  final bool inProgress;

  /// Creates an action button.
  const ActionButton({
    super.key,
    this.primary = true,
    required this.child,
    this.enabled = true,
    required this.onPressed,
    this.inProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<ActionButtonDefaults>(context, ActionButtonDefaults.defaults);

    final body = Stack(
      children: [
        // Child
        Visibility(
          visible: !inProgress,
          child: child,
        ),

        // Progress indicator
        if (inProgress)
          Center(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: settings.indicatorBuilder!(context, 16),
            ),
          ),
      ],
    );

    return primary
        ? settings.primaryBuilder!(context, body, enabled ? onPressed : null, inProgress)
        : settings.builder!(context, body, enabled ? onPressed : null, inProgress);
  }
}
