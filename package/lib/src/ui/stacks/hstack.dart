import 'package:app_base_kit/src/defaults.dart';
import 'package:flutter/widgets.dart';

class HStack extends StatelessWidget {
  static const double defaultSpacing = 0;
  static const CrossAxisAlignment defaultAlignment = CrossAxisAlignment.start;
  static const bool defaultCollapse = false;

  final double? spacing;
  final CrossAxisAlignment? alignment;
  final bool? collapse;
  final List<Widget> children;

  const HStack({
    super.key,
    this.spacing,
    this.alignment,
    this.collapse,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<HStackDefaults>(context, HStackDefaults.defaults);

    final effectiveSpacing = spacing ?? settings.spacing;
    final effectiveAlignment = alignment ?? settings.alignment;
    final effectiveCollapse = collapse ?? settings.collapse;

    return Row(
      crossAxisAlignment: effectiveAlignment,
      mainAxisSize: effectiveCollapse ? MainAxisSize.min : MainAxisSize.max,
      children: [
        ...children.fold(
          [],
          (prev, c) => [
            ...prev,
            if (prev.isNotEmpty) SizedBox(width: effectiveSpacing),
            c,
          ],
        ),
      ],
    );
  }
}

class HStackDefaults implements DefaultsData {
  static HStackDefaults defaults = HStackDefaults();

  final double spacing;
  final CrossAxisAlignment alignment;
  final bool collapse;

  HStackDefaults({
    this.spacing = HStack.defaultSpacing,
    this.alignment = HStack.defaultAlignment,
    this.collapse = HStack.defaultCollapse,
  });
}
