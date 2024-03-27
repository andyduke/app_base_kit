import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class CustomInputControl extends GenericControl {
  static const animationDuration = Duration(milliseconds: 300);

  const CustomInputControl({
    super.key,
    super.child,
    super.enabled,
    super.autofocus,
    super.focusNode,
    super.canRequestFocus,
  }) : super(
          builder: _controlBuilder,
        );

  static Widget _controlBuilder(BuildContext context, Set<ControlState> states, Widget? child) {
    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: switch (states) {
          Set<ControlState>() when states.contains(ControlState.focused) => Border.all(color: Colors.teal, width: 2.0),
          Set<ControlState>() => Border.all(color: Colors.transparent, width: 2.0),
        },
        color: switch (states) {
          Set<ControlState>() when states.contains(ControlState.hovered) => Colors.teal.shade200,
          Set<ControlState>() when states.contains(ControlState.disabled) => Colors.grey.shade300,
          _ => Colors.teal.shade100,
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        child: child,
      ),
    );
  }
}
