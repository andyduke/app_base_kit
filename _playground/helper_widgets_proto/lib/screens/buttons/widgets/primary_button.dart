import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends Button {
  static const animationDuration = Duration(milliseconds: 300);

  const PrimaryButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.enabled,
    super.autofocus,
    super.focusNode,
    super.canRequestFocus,
    super.enableFeedback,
  }) : super(
          pressedDuration: animationDuration,
        );

  @override
  Widget builder(BuildContext context, Set<ButtonState> states, Widget child) {
    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: switch (states) {
          Set<ButtonState>() when states.contains(ButtonState.focused) => Border.all(color: Colors.teal, width: 2.0),
          Set<ButtonState>() => Border.all(color: Colors.transparent, width: 2.0),
        },
        color: switch (states) {
          Set<ButtonState>() when states.contains(ButtonState.pressed) => Colors.teal.shade300,
          Set<ButtonState>() when states.contains(ButtonState.hovered) => Colors.teal.shade200,
          Set<ButtonState>() when states.contains(ButtonState.disabled) => Colors.grey.shade300,
          _ => Colors.teal.shade100,
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      ),
    );
  }
}
