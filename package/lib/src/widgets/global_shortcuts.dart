import 'dart:io';
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

class _GlobalShortcutsState extends State<GlobalShortcuts> {
  bool _listening = false;

  late final Key _key = widget.key ?? UniqueKey();

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
      HardwareKeyboard.instance.addHandler(_listener);
      _listening = true;
    }
  }

  void _detachListener() {
    if (_listening) {
      HardwareKeyboard.instance.removeHandler(_listener);
      _listening = false;
    }
  }

  bool _listener(KeyEvent event) {
    if (mounted) {
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
    // VisibilityDetector prevents keydowns from being listened to within a non-top route
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
