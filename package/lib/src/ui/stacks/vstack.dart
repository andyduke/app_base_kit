import 'package:app_base_kit/src/defaults.dart';
import 'package:flutter/widgets.dart';

class VStack extends StatelessWidget {
  static const double defaultSpacing = 0;
  static const CrossAxisAlignment defaultAlignment = CrossAxisAlignment.start;
  static const bool defaultCollapse = false;

  final double? spacing;
  final CrossAxisAlignment? alignment;
  final bool? collapse;
  final List<Widget> children;

  const VStack({
    super.key,
    this.spacing,
    this.alignment,
    this.collapse,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<VStackDefaults>(context, VStackDefaults.defaults);

    final effectiveSpacing = spacing ?? settings.spacing;
    final effectiveAlignment = alignment ?? settings.alignment;
    final effectiveCollapse = collapse ?? settings.collapse;

    return Column(
      crossAxisAlignment: effectiveAlignment,
      mainAxisSize: effectiveCollapse ? MainAxisSize.min : MainAxisSize.max,
      children: children.fold(
        [],
        (prev, c) => [
          ...prev,
          SizedBox(height: effectiveSpacing),
          c,
        ],
      ),
    );
  }
}

class VStackDefaults implements DefaultsData {
  static VStackDefaults defaults = VStackDefaults();

  final double spacing;
  final CrossAxisAlignment alignment;
  final bool collapse;

  VStackDefaults({
    this.spacing = VStack.defaultSpacing,
    this.alignment = VStack.defaultAlignment,
    this.collapse = VStack.defaultCollapse,
  });
}
