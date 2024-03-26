part of 'stacks.dart';

/// A view that arranges its subviews in a vertical line.
///
/// It is a wrapper around `Column`, but adds the ability to control
/// spacing between widgets in `Column`.
///
/// Additionally, `VStack` by default stretches widgets to full width,
/// unlike `Column`.
///
/// See also:
/// * [Spacing], for individual control of spacing;
/// * [VStackDefaults], to set the default spacing and alignment values.
///
class VStack extends _Stack {
  static const double defaultSpacing = 0;
  static const XStackAlignment defaultAlignment = XStackAlignment.start;
  static const XStackCrossAlignment defaultCrossAlignment = XStackCrossAlignment.stretch;
  static const bool defaultExpanded = false;

  /// Creates a vertical array of widgets.
  ///
  /// It is a wrapper around `Column`, but adds the ability to control
  /// spacing between widgets in `Column`.
  ///
  /// Additionally, `VStack` by default stretches widgets to full width,
  /// unlike `Column`.
  ///
  /// See also:
  /// * [Spacing], for individual control of spacing;
  /// * [VStackDefaults], to set the default spacing and alignment values.
  ///
  const VStack({
    super.key,
    required super.children,
    super.spacing,
    super.alignment,
    super.crossAlignment,
    super.expanded,
  });

  const VStack.expand({
    super.key,
    required super.children,
    super.spacing,
    super.alignment,
    super.crossAlignment,
  }) : super(expanded: true);

  @override
  Widget buildLayout(BuildContext context, Iterable<Widget> children) {
    final settings = Defaults.defaultsOf<VStackDefaults>(context, VStackDefaults.defaults);

    final effectiveAlignment = alignment ?? settings.alignment;
    final effectiveCrossAlignment = crossAlignment ?? settings.crossAlignment;
    final effectiveExpanded = expanded ?? settings.expanded;

    return Column(
      mainAxisAlignment: effectiveAlignment,
      crossAxisAlignment: effectiveCrossAlignment,
      mainAxisSize: !effectiveExpanded ? MainAxisSize.min : MainAxisSize.max,
      children: children.toList(growable: false),
    );
  }

  @override
  Widget? buildSpacer(BuildContext context, double? size) {
    final settings = Defaults.defaultsOf<VStackDefaults>(context, VStackDefaults.defaults);

    final effectiveSpacing = size ?? settings.spacing;

    return (effectiveSpacing > 0) ? SizedBox(height: effectiveSpacing) : null;
  }
}

class VStackDefaults implements DefaultsData {
  static VStackDefaults defaults = VStackDefaults();

  final double spacing;
  final XStackAlignment alignment;
  final XStackCrossAlignment crossAlignment;
  final bool expanded;

  VStackDefaults({
    this.spacing = VStack.defaultSpacing,
    this.alignment = VStack.defaultAlignment,
    this.crossAlignment = VStack.defaultCrossAlignment,
    this.expanded = VStack.defaultExpanded,
  });
}
