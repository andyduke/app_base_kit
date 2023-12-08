import 'dart:async';
import 'package:flutter/material.dart';

// https://gist.github.com/andyduke/ca2c9532e621ca69c77dfc9742ac3c14

enum ButtonState {
  focused,
  hovered,
  pressed,
  disabled,
}

abstract class Button extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  final bool enabled;

  /// True if this widget will be selected as the initial focus when no other node in its scope is currently focused.
  final bool autofocus;

  /// An optional focus node to use as the focus node for this widget.
  final FocusNode? focusNode;

  /// If true, this widget may request the primary focus.
  final bool canRequestFocus;

  final bool enableFeedback;

  /*
  factory Button.text({
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
  */

  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.enableFeedback = true,
  });

  Widget builder(BuildContext context, Set<ButtonState> states, Widget child);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  final Set<ButtonState> _states = {};

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activateOnIntent),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(onInvoke: _activateOnIntent),
  };

  // TODO: Make customizable
  // static const Duration _activationDuration = Duration(milliseconds: 100);
  static const Duration _activationDuration = Duration(milliseconds: 300);
  Timer? _activationTimer;

  @override
  void initState() {
    super.initState();

    _handleDisabledUpdate(widget.enabled, silent: true);
  }

  @override
  void dispose() {
    _activationTimer?.cancel();
    _activationTimer = null;

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Button oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled) {
      _handleDisabledUpdate(widget.enabled, silent: true);
    }
  }

  bool get _enabled => !_states.contains(ButtonState.disabled);

  void _handleDisabledUpdate(bool enabled, {bool silent = false}) {
    if (enabled) {
      _states.remove(ButtonState.disabled);
    } else {
      _states.add(ButtonState.disabled);
    }

    if (!silent) {
      setState(() {});
    }
  }

  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return _enabled && widget.canRequestFocus;
      case NavigationMode.directional:
        return true;
    }
  }

  void _handleFocusUpdate(bool hasFocus) {
    setState(() {
      if (hasFocus) {
        _states.add(ButtonState.focused);
      } else {
        _states.remove(ButtonState.focused);
      }
    });
  }

  void _handleHoverUpdate(bool hasHover) {
    if (_enabled) {
      setState(() {
        if (hasHover) {
          _states.add(ButtonState.hovered);
        } else {
          _states.remove(ButtonState.hovered);
        }
      });
    }
  }

  void _handlePressedUpdate(bool pressed) {
    if (_enabled) {
      setState(() {
        if (pressed) {
          _states.add(ButtonState.pressed);
        } else {
          _states.remove(ButtonState.pressed);
        }
      });
    }
  }

  void _handleTapFeedback() {
    if (widget.enableFeedback) {
      Feedback.forTap(context);
    }
  }

  void _handlePressedDown() {
    if (_enabled) {
      _activationTimer?.cancel();
      _activationTimer = null;

      _handlePressedUpdate(true);
    }
  }

  void _handlePressedUp() {
    if (_enabled) {
      _handleTapFeedback();
      widget.onPressed();

      // Delay the call to `_handlePressedUpdate` to simulate a pressed delay.
      _activationTimer = Timer(_activationDuration ~/ 2, () {
        _handlePressedUpdate(false);
      });
    }
  }

  void _handlePressCancelled() {
    if (_enabled) {
      // Delay the call to `_handlePressedUpdate` to simulate a pressed delay.
      _activationTimer = Timer(_activationDuration ~/ 2, () {
        _handlePressedUpdate(false);
      });
    }
  }

  void _activateOnIntent(Intent? intent) {
    if (_enabled) {
      _activationTimer?.cancel();
      _activationTimer = null;

      _handlePressedUpdate(true);

      _handleTapFeedback();
      widget.onPressed();

      // Delay the call to `_handlePressedUpdate` to simulate a pressed delay.
      _activationTimer = Timer(_activationDuration, () {
        _handlePressedUpdate(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: _actionMap,
      child: Focus(
        focusNode: widget.focusNode,
        canRequestFocus: _canRequestFocus,
        onFocusChange: _handleFocusUpdate,
        autofocus: widget.autofocus,
        child: MouseRegion(
          onEnter: (event) {
            _handleHoverUpdate(true);
          },
          onExit: (event) {
            _handleHoverUpdate(false);
          },
          cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) {
              _handlePressedDown();
            },
            onTapUp: (_) {
              _handlePressedUp();
            },
            onTapCancel: _handlePressCancelled,
            child: widget.builder(context, _states, widget.child),
          ),
        ),
      ),
    );
  }
}

/*
class TextButton extends Button {
  
  const TextButton({required super.onPressed, required super.child});

  @override
  Widget builder(BuildContext context, Set<ButtonState> states, Widget child) {
    / *
    var body = child;
    
    if (states.contains(ButtonState.hover)) {
      body = DefaultTextStyle.merge(
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        child: body,
      );
    }
    
    return body;
    * /
    
    final DefaultTextStyle parent = DefaultTextStyle.of(context);
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      style: states.contains(ButtonState.hover)
        ? parent.style.merge(const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))
        : parent.style,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      ),
    );
  }
  
}
*/
