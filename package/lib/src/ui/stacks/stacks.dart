import 'package:app_base_kit/src/utils/defaults.dart';
import 'package:flutter/widgets.dart';

part '_spacing.dart';
part '_hstack.dart';
part '_vstack.dart';

typedef XStackAlignment = MainAxisAlignment;
typedef XStackCrossAlignment = CrossAxisAlignment;

/// Base class for implementing a vertical or horizontal stack.
abstract class _Stack extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final XStackAlignment? alignment;
  final XStackCrossAlignment? crossAlignment;
  final bool? expanded;

  const _Stack({
    super.key,
    required this.children,
    this.spacing,
    this.alignment,
    this.crossAlignment,
    this.expanded,
  });

  Widget buildLayout(BuildContext context, Iterable<Widget> children);

  Widget? buildSpacer(BuildContext context, double? size);

  @override
  Widget build(BuildContext context) {
    final items = <Widget?>[];

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (child is Spacing) {
        items.add(buildSpacer(context, child.size));
      } else {
        final prev = (i > 0) ? children[i - 1] : null;

        if (items.isNotEmpty && prev is! Spacing) {
          items.addAll([
            buildSpacer(context, spacing),
            child,
          ]);
        } else {
          items.add(child);
        }
      }
    }

    return buildLayout(context, items.where((w) => w != null).cast<Widget>());
  }
}
