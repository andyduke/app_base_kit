import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GlobalShortcuts extends StatefulWidget {
  final Map<ShortcutActivator, Intent> shortcuts;
  final Widget child;

  const GlobalShortcuts({
    super.key,
    required this.shortcuts,
    required this.child,
  });

  @override
  State<GlobalShortcuts> createState() => _GlobalShortcutsState();
}

/*
enum _KeyModifier {
  shiftKey,
  ctrlKey,
  altKey,
  metaKey,
}
*/

class _GlobalShortcutsState extends State<GlobalShortcuts> {
  bool _listening = false;

  late final Key _key = widget.key ?? UniqueKey();

  // final Set<_KeyModifier> _modifiers = {};

  @override
  void initState() {
    super.initState();
    _attachListener();
  }

  @override
  void dispose() {
    _detachListener();
    super.dispose();
  }

  void _attachListener() {
    if (!_listening) {
      ServicesBinding.instance.keyboard.addHandler(_listener);
      _listening = true;
    }
  }

  void _detachListener() {
    if (_listening) {
      ServicesBinding.instance.keyboard.removeHandler(_listener);
      _listening = false;
    }
  }

  /*
  LogicalKeyboardKey? _modifierLogicalKeyboardKey(_KeyModifier modifier) {
    switch (modifier) {
      case _KeyModifier.shiftKey:
        return LogicalKeyboardKey.shift;

      case _KeyModifier.ctrlKey:
        return LogicalKeyboardKey.control;

      case _KeyModifier.altKey:
        return LogicalKeyboardKey.alt;

      case _KeyModifier.metaKey:
        return LogicalKeyboardKey.meta;

      default:
        return null;
    }
  }

  Set<LogicalKeyboardKey> _shortcutOf(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.shift ||
        key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight ||
        key == LogicalKeyboardKey.control ||
        key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight ||
        key == LogicalKeyboardKey.alt ||
        key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight ||
        key == LogicalKeyboardKey.meta ||
        key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight) {
      return {};
    }

    final Set<LogicalKeyboardKey> shortcut = {};

    for (var modifier in _KeyModifier.values) {
      if (_modifiers.contains(modifier)) {
        shortcut.add(_modifierLogicalKeyboardKey(modifier)!);
      }
    }

    shortcut.add(key);

    return shortcut;
  }

  bool _keySetMatch(Iterable<LogicalKeyboardKey>? shortcut, LogicalKeyboardKey key) {
    if (shortcut == null) return false;

    Set<LogicalKeyboardKey> targetShortcut = Set.from(shortcut);
    targetShortcut = LogicalKeyboardKey.collapseSynonyms(targetShortcut);

    final Set<LogicalKeyboardKey> pressedShortcut = _shortcutOf(key);
    return setEquals(pressedShortcut, targetShortcut);
  }
  */

  bool _listener(KeyEvent event) {
    if (mounted) {
      /*
      if (event is KeyDownEvent) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.shift:
          case LogicalKeyboardKey.shiftLeft:
          case LogicalKeyboardKey.shiftRight:
            _modifiers.add(_KeyModifier.shiftKey);
            break;

          case LogicalKeyboardKey.control:
          case LogicalKeyboardKey.controlLeft:
          case LogicalKeyboardKey.controlRight:
            _modifiers.add(_KeyModifier.ctrlKey);
            break;

          case LogicalKeyboardKey.alt:
          case LogicalKeyboardKey.altLeft:
          case LogicalKeyboardKey.altRight:
            _modifiers.add(_KeyModifier.altKey);
            break;

          case LogicalKeyboardKey.meta:
          case LogicalKeyboardKey.metaLeft:
          case LogicalKeyboardKey.metaRight:
            _modifiers.add(_KeyModifier.metaKey);
            break;
        }
      }
      if (event is KeyUpEvent) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.shift:
          case LogicalKeyboardKey.shiftLeft:
          case LogicalKeyboardKey.shiftRight:
            _modifiers.remove(_KeyModifier.shiftKey);
            break;

          case LogicalKeyboardKey.control:
          case LogicalKeyboardKey.controlLeft:
          case LogicalKeyboardKey.controlRight:
            _modifiers.remove(_KeyModifier.ctrlKey);
            break;

          case LogicalKeyboardKey.alt:
          case LogicalKeyboardKey.altLeft:
          case LogicalKeyboardKey.altRight:
            _modifiers.remove(_KeyModifier.altKey);
            break;

          case LogicalKeyboardKey.meta:
          case LogicalKeyboardKey.metaLeft:
          case LogicalKeyboardKey.metaRight:
            _modifiers.remove(_KeyModifier.metaKey);
            break;
        }
      */
      if (event is KeyDownEvent) {
        // print('### Event: $event');

        for (final shortcut in widget.shortcuts.entries) {
          final char = event.character?.toLowerCase() ??
              // Ctrl+Char
              (event.logicalKey.keyLabel.length == 1 ? event.logicalKey.keyLabel.toLowerCase() : null);
          if (char == null) continue;

          final rawEvent = RawKeyEvent.fromMessage({
            'type': 'keydown',
            'keymap': Platform.operatingSystem,
            'key': char,
            'character': char,
            'characters': char,
            'codePoint': char.codeUnits.first,
            'unicodeScalarValues': char.codeUnits.first,
            'characterCodePoint': char.codeUnits.first,
          });
          final rawState = RawKeyboard.instance;

          if (shortcut.key.accepts(rawEvent, rawState)) {
            // if (_keySetMatch(shortcut.key.triggers, event.logicalKey)) {
            // TODO: How to find nested Actions?

            // Find parent actions
            final Action<Intent>? action = Actions.maybeFind<Intent>(
              context,
              intent: shortcut.value,
            );
            if (action != null) {
              final (bool enabled, Object? invokeResult) = Actions.of(context).invokeActionIfEnabled(
                action,
                shortcut.value,
                context,
              );
              if (enabled) {
                action.toKeyEventResult(shortcut.value, invokeResult);
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1) {
          _attachListener();
        } else {
          _detachListener();
        }
      },
      child: widget.child,
    );
  }
}
