import 'package:app_base_kit/src/defaults.dart';
import 'package:flutter/widgets.dart';

class HStack extends StatelessWidget {
  static const double defaultSpacing = 0;
  static const CrossAxisAlignment defaultAlignment = CrossAxisAlignment.start;

  final double? spacing;
  final CrossAxisAlignment? alignment;
  final List<Widget> children;

  const HStack({
    super.key,
    this.spacing,
    this.alignment,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<HStackDefaults>(context, HStackDefaults.defaults);

    final effectiveSpacing = spacing ?? settings.spacing;
    final effectiveAlignment = alignment ?? settings.alignment;

    return Row(
      crossAxisAlignment: effectiveAlignment,
      children: [
        ...children.fold(
          [],
          (prev, c) => [
            ...prev,
            SizedBox(width: effectiveSpacing),
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

  HStackDefaults({
    this.spacing = HStack.defaultSpacing,
    this.alignment = HStack.defaultAlignment,
  });
}
