part of 'stacks.dart';

/// A view that arranges its subviews in a horizontal line.
///
/// It is a wrapper around `Row`, but adds the ability to control
/// spacing between widgets in `Row`.
///
/// Additionally, `HStack` by default aligns widgets to the top,
/// unlike `Row`.
///
/// See also:
/// * [Spacing], for individual control of spacing;
/// * [HStackDefaults], to set the default spacing and alignment values.
///
class HStack extends _Stack {
  static const double defaultSpacing = 0;
  static const XStackAlignment defaultAlignment = XStackAlignment.start;
  static const XStackCrossAlignment defaultCrossAlignment = XStackCrossAlignment.start;
  static const bool defaultExpanded = true;

  /// Creates a horizontal array of widgets.
  ///
  /// It is a wrapper around `Row`, but adds the ability to control
  /// spacing between widgets in `Row`.
  ///
  /// Additionally, `HStack` by default aligns widgets to the top,
  /// unlike `Row`.
  ///
  /// See also:
  /// * [Spacing], for individual control of spacing;
  /// * [HStackDefaults], to set the default spacing and alignment values.
  ///
  const HStack({
    super.key,
    required super.children,
    super.spacing,
    super.alignment,
    super.crossAlignment,
    super.expanded,
    this.textBaseline,
  });

  const HStack.shrink({
    super.key,
    required super.children,
    super.spacing,
    super.alignment,
    super.crossAlignment,
    this.textBaseline,
  }) : super(expanded: false);

  final TextBaseline? textBaseline;

  @override
  Widget buildLayout(BuildContext context, Iterable<Widget> children) {
    final settings = Defaults.defaultsOf<HStackDefaults>(context, HStackDefaults.defaults);

    final effectiveAlignment = alignment ?? settings.alignment;
    final effectiveCrossAlignment = crossAlignment ?? settings.crossAlignment;
    final effectiveExpanded = expanded ?? settings.expanded;
    final effectiveTextBaseline = textBaseline ?? settings.textBaseline;

    return Row(
      mainAxisAlignment: effectiveAlignment,
      crossAxisAlignment: effectiveCrossAlignment,
      mainAxisSize: !effectiveExpanded ? MainAxisSize.min : MainAxisSize.max,
      textBaseline: effectiveTextBaseline,
      children: children.toList(growable: false),
    );
  }

  @override
  Widget? buildSpacer(BuildContext context, double? size) {
    final settings = Defaults.defaultsOf<HStackDefaults>(context, HStackDefaults.defaults);

    final effectiveSpacing = size ?? settings.spacing;

    return (effectiveSpacing > 0) ? SizedBox(width: effectiveSpacing) : null;
  }
}

class HStackDefaults implements DefaultsData {
  static HStackDefaults defaults = HStackDefaults();

  final double spacing;
  final XStackAlignment alignment;
  final XStackCrossAlignment crossAlignment;
  final bool expanded;
  final TextBaseline? textBaseline;

  HStackDefaults({
    this.spacing = HStack.defaultSpacing,
    this.alignment = HStack.defaultAlignment,
    this.crossAlignment = HStack.defaultCrossAlignment,
    this.expanded = HStack.defaultExpanded,
    this.textBaseline,
  });
}
