import 'dart:io';
import 'package:app_base_kit/src/widgets/global_shortcuts.dart';
import 'package:app_base_kit/src/widgets/label/label_theme.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Intent? intent;
  final bool interactive;

  const Label(
    this.text, {
    super.key,
    this.intent,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!_supportsAccelerator) return Text(text);

    final parts = _splitText(text);
    if (parts.length < 2) return Text(text);

    final TextStyle defaultStyle =
        Theme.of(context).extension<LabelTheme>()?.textStyle ?? DefaultTextStyle.of(context).style;
    final TextStyle acceleratorStyle = Theme.of(context).extension<LabelTheme>()?.acceleratorTextStyle ??
        defaultStyle.copyWith(decoration: TextDecoration.underline);

    Widget body = RichText(
      text: TextSpan(
        children: parts.map((part) {
          if (part.startsWith('&')) {
            return TextSpan(
              text: part.substring(1),
              style: acceleratorStyle,
            );
          } else {
            return TextSpan(text: part, style: defaultStyle);
          }
        }).toList(growable: false),
      ),
    );

    final accelerator = _extractAcceleratorFromParts(parts);
    // print('! Accelerator: $accelerator');
    if (accelerator != null) {
      final effectiveIntent = intent ?? const ActivateIntent();

      body = GlobalShortcuts(
        shortcuts: {
          CharacterActivator(accelerator.toLowerCase(), alt: true): effectiveIntent,
        },
        child: body,
      );
    }

    if (interactive) {
      body = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleTap(context),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: body,
        ),
      );
    }

    return body;
  }

  bool get _supportsAccelerator => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  void _handleTap(BuildContext context) {
    const intent = ActivateIntent();

    // Find parent actions
    final Action<Intent>? action = Actions.maybeFind<Intent>(
      context,
      intent: intent,
    );
    if (action != null) {
      final (bool enabled, Object? invokeResult) = Actions.of(context).invokeActionIfEnabled(
        action,
        intent,
        context,
      );
      if (enabled) {
        action.toKeyEventResult(intent, invokeResult);
      }
    }
  }

  String? _extractAcceleratorFromParts(List<String> parts) {
    return parts.firstWhereOrNull((part) => part.startsWith('&'))?.replaceAll('&', '');
  }

  List<String> _splitText(String text) {
    final acceleratorRegExp = RegExp(r'&([a-z0-9]{1})', caseSensitive: false);
    final match = acceleratorRegExp.firstMatch(text);
    if (match == null) return [text];

    final parts = <String>[];

    // Add prefix
    if (match.start > 0) {
      parts.add(text.substring(0, match.start));
    }

    // Add accelerator
    parts.add(text.substring(match.start, match.end));

    // Add suffix
    if (match.end < text.length) {
      parts.add(text.substring(match.end));
    }

    return parts;
  }
}
