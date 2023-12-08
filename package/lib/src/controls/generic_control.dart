import 'package:flutter/material.dart';

enum ControlState {
  focused,
  hovered,
  disabled,
}

typedef GenericControlBuilder = Widget Function(BuildContext context, Set<ControlState> states, Widget? child);

/// General input control widget, without UI, but with state management and processing of focus, click, hover, etc.
abstract class GenericControl extends StatefulWidget {
  final Widget? child;
  final GenericControlBuilder? builder;

  final bool enabled;

  /// True if this widget will be selected as the initial focus when no other node in its scope is currently focused.
  final bool autofocus;

  /// An optional focus node to use as the focus node for this widget.
  final FocusNode? focusNode;

  /// If true, this widget may request the primary focus.
  final bool canRequestFocus;

  const GenericControl({
    super.key,
    this.builder,
    this.child,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.canRequestFocus = false,
  });

  Widget controlBuilder(BuildContext context, Set<ControlState> states, Widget? child) =>
      builder?.call(context, states, child) ?? const SizedBox.shrink();

  @override
  State<GenericControl> createState() => _ControlState();
}

class _ControlState extends State<GenericControl> {
  final Set<ControlState> _states = {};

  @override
  void initState() {
    super.initState();

    _handleDisabledUpdate(widget.enabled, silent: true);
  }

  @override
  void didUpdateWidget(covariant GenericControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled) {
      _handleDisabledUpdate(widget.enabled, silent: true);
    }
  }

  bool get _enabled => !_states.contains(ControlState.disabled);

  void _handleDisabledUpdate(bool enabled, {bool silent = false}) {
    if (enabled) {
      _states.remove(ControlState.disabled);
    } else {
      _states.add(ControlState.disabled);
    }

    if (!silent) {
      setState(() {});
    }
  }

  bool get _canRequestFocus {
    return _enabled && (widget.focusNode?.canRequestFocus ?? widget.canRequestFocus);
  }

  void _handleFocusUpdate(bool hasFocus) {
    setState(() {
      if (hasFocus) {
        _states.add(ControlState.focused);
      } else {
        _states.remove(ControlState.focused);
      }
    });
  }

  void _handleHoverUpdate(bool hasHover) {
    if (_enabled) {
      setState(() {
        if (hasHover) {
          _states.add(ControlState.hovered);
        } else {
          _states.remove(ControlState.hovered);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
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
        cursor: _enabled ? MouseCursor.defer : SystemMouseCursors.basic,
        child: widget.controlBuilder(context, _states, widget.child),
      ),
    );
  }
}
