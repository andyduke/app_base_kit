import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/widgets.dart';

typedef FormLabelGroupBuilder = Widget Function(BuildContext context, Widget label, Widget child);

@Deprecated('Legacy')
class FormLabelGroup extends StatelessWidget {
  final Widget label;
  final Widget child;
  final FormLabelGroupBuilder? builder;

  const FormLabelGroup({
    super.key,
    required this.label,
    required this.child,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<FormLabelGroupDefaults>(context, FormLabelGroupDefaults.defaults);

    final effectiveBuilder = builder ?? settings.builder;
    final body = effectiveBuilder?.call(context, label, child) ?? HStack(children: [label, child]);

    return body;
  }
}

class FormLabelGroupDefaults implements DefaultsData {
  static FormLabelGroupDefaults defaults = FormLabelGroupDefaults();

  final FormLabelGroupBuilder? builder;

  FormLabelGroupDefaults({
    this.builder,
  });
}
