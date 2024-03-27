import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class SectionContent extends StatelessWidget {
  static const EdgeInsets defaultPadding = EdgeInsets.zero;

  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SectionContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<SectionContentDefaults>(context, SectionContentDefaults.defaults);

    final effectivePadding = padding ?? settings.padding ?? defaultPadding;

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }
}

class SectionContentDefaults implements DefaultsData {
  static SectionContentDefaults defaults = SectionContentDefaults();

  final EdgeInsetsGeometry? padding;

  SectionContentDefaults({
    this.padding,
  });
}
