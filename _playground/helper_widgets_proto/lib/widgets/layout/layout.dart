import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/widgets.dart';

typedef LayoutBuilder = Widget Function(BuildContext context, List<Widget> children, double spacing);

class Layout extends StatelessWidget {
  static const double defaultSpacing = 16.0;

  final double? spacing;
  final LayoutBuilder? builder;
  final List<Widget> children;

  const Layout({
    super.key,
    this.spacing,
    this.builder,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<LayoutDefaults>(context, LayoutDefaults.defaults);

    final effectiveSpacing = spacing ?? settings.spacing ?? defaultSpacing;
    final effectiveBuilder = builder ?? settings.builder;
    final body = effectiveBuilder?.call(context, children, effectiveSpacing) ??
        VStack(
          spacing: effectiveSpacing,
          children: children,
        );

    return Defaults(
      [
        LabeledContentDefaults(
          labelSpacing: 8.0,
          layoutBuilder: (context, child, label, headerSpacing) => HStack(
            spacing: headerSpacing,
            crossAlignment: CrossAxisAlignment.center,
            children: [if (label != null) SizedBox(width: 120, child: label), Expanded(child: child)],
          ),
        ),
      ],
      child: body,
    );
  }
}

class LayoutDefaults implements DefaultsData {
  static LayoutDefaults defaults = LayoutDefaults();

  final double? spacing;
  final LayoutBuilder? builder;

  LayoutDefaults({
    this.spacing,
    this.builder,
  });
}
