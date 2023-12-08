import 'package:app_base_kit/src/widgets/global_shortcuts.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Intent? intent;

  const Label(
    this.text, {
    super.key,
    this.intent,
  });

  @override
  Widget build(BuildContext context) {
    final parts = _splitText(text);
    if (parts.length < 3) return Text(text);

    final TextStyle defaultStyle = DefaultTextStyle.of(context).style;
    Widget body = RichText(
      text: TextSpan(
        children: parts.map((part) {
          if (part.startsWith('&')) {
            return TextSpan(
              text: part.substring(1),
              style: defaultStyle.copyWith(decoration: TextDecoration.underline),
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

    return body;
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
