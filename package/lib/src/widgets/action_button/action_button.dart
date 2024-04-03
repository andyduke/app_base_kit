import 'package:app_base_kit/src/utils/defaults.dart';
import 'package:app_base_kit/src/widgets/action_button/action_button_settings.dart';
import 'package:flutter/material.dart';

/*
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
  const ActionButton.custom({
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
*/

typedef ActionButtonCallback = Future<void> Function();

/// Action button.
///
/// The button can display a progress indicator and
/// prevent tapping while showing progress.
abstract class ActionButton implements Widget {
  static const bool defaultPrimary = true;
  static const bool defaultEnabled = true;

  /// Indicates that this is a primary action button.
  abstract final bool primary;

  /// The content of the button, usually the button's label.
  abstract final Widget child;

  /// Whether the button is enabled or disabled.
  abstract final bool enabled;

  factory ActionButton({
    Key? key,
    bool primary = defaultPrimary,
    required Widget child,
    bool enabled = defaultEnabled,
    required ActionButtonCallback onAction,
  }) {
    return _ActionButtonWithState(
      key: key,
      primary: primary,
      enabled: enabled,
      onAction: onAction,
      child: child,
    );
  }

  factory ActionButton.custom({
    Key? key,
    bool primary = defaultPrimary,
    required Widget child,
    bool enabled = defaultEnabled,
    required VoidCallback? onPressed,
    bool inProgress = false,
  }) {
    return _ActionButtonCustom(
      key: key,
      primary: primary,
      enabled: enabled,
      onPressed: onPressed,
      inProgress: inProgress,
      child: child,
    );
  }
}

class _ActionButtonCustom extends StatelessWidget implements ActionButton {
  /// Indicates that this is a primary action button.
  @override
  final bool primary;

  /// The content of the button, usually the button's label.
  @override
  final Widget child;

  /// Whether the button is enabled or disabled.
  @override
  final bool enabled;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// Indicates whether an action is currently running.
  final bool inProgress;

  const _ActionButtonCustom({
    super.key,
    this.primary = ActionButton.defaultPrimary,
    required this.child,
    this.enabled = ActionButton.defaultEnabled,
    required this.onPressed,
    this.inProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<ActionButtonDefaults>(context, ActionButtonDefaults.defaults);

    final indicatorBuilder = settings.indicatorBuilder ?? ActionButtonDefaults.defaults.indicatorBuilder;
    final primaryBuilder = settings.primaryBuilder ?? ActionButtonDefaults.defaults.primaryBuilder;
    final builder = settings.builder ?? ActionButtonDefaults.defaults.builder;

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
              child: indicatorBuilder!(context, 16),
            ),
          ),
      ],
    );

    return primary
        ? primaryBuilder!(context, body, enabled ? onPressed : null, inProgress)
        : builder!(context, body, enabled ? onPressed : null, inProgress);
  }
}

class _ActionButtonWithState extends StatefulWidget implements ActionButton {
  /// Indicates that this is a primary action button.
  @override
  final bool primary;

  /// The content of the button, usually the button's label.
  @override
  final Widget child;

  /// Whether the button is enabled or disabled.
  @override
  final bool enabled;

  /// Called when the button is tapped or otherwise activated.
  final ActionButtonCallback onAction;

  const _ActionButtonWithState({
    super.key,
    this.primary = ActionButton.defaultPrimary,
    required this.child,
    this.enabled = ActionButton.defaultEnabled,
    required this.onAction,
  });

  @override
  State<_ActionButtonWithState> createState() => _ActionButtonWithStateState();
}

class _ActionButtonWithStateState extends State<_ActionButtonWithState> {
  bool _inProgress = false;

  Future<void> _pressHandler() async {
    setState(() {
      _inProgress = true;
    });

    await widget.onAction();

    setState(() {
      _inProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ActionButtonCustom(
      primary: widget.primary,
      enabled: widget.enabled,
      inProgress: _inProgress,
      onPressed: _pressHandler,
      child: widget.child,
    );
  }
}
