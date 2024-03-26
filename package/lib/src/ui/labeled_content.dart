import 'package:app_base_kit/src/ui/stacks/stacks.dart';
import 'package:app_base_kit/src/utils/defaults.dart';
import 'package:flutter/material.dart';

typedef LabeledContentLabelBuilder = Widget Function(
  BuildContext context,
  Widget label,
);

typedef LabeledContentLayoutBuilder = Widget Function(
  BuildContext context,
  Widget child,
  Widget? label,
  double labelSpacing,
);

typedef LabeledContentBuilder = Widget Function(
  BuildContext context,
  FocusNode? focusNode,
  Widget? child,
);

class LabeledContent extends StatefulWidget {
  static const double defaultLabelSpacing = 0.0;

  final Widget? label;
  final TextStyle? labelStyle;
  final double? labelSpacing;
  final FocusNode? focusNode;
  final Widget? child;
  final LabeledContentLabelBuilder? labelBuilder;
  final LabeledContentBuilder? builder;
  final LabeledContentLayoutBuilder? layoutBuilder;

  const LabeledContent({
    super.key,
    this.label,
    this.labelStyle,
    this.labelSpacing,
    this.focusNode,
    this.child,
    this.labelBuilder,
    this.builder,
    this.layoutBuilder,
  }) : assert(child != null || builder != null);

  @override
  State<LabeledContent> createState() => _LabeledContentState();
}

class _LabeledContentState extends State<LabeledContent> {
  late final focusNode = widget.focusNode ?? FocusNode();

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<LabeledContentDefaults>(context, LabeledContentDefaults.defaults);

    final effectiveLabelSpacing = widget.labelSpacing ?? settings.labelSpacing ?? LabeledContent.defaultLabelSpacing;
    final effectiveLabelStyle = widget.labelStyle ?? settings.labelStyle;
    final effectiveLabelBuilder = widget.labelBuilder ?? settings.labelBuilder;
    var effectiveLabel = (widget.label != null)
        ? effectiveLabelBuilder?.call(context, widget.label!) ??
            ((effectiveLabelStyle != null)
                ? DefaultTextStyle.merge(style: effectiveLabelStyle, child: widget.label!)
                : widget.label)
        : null;

    if (effectiveLabel != null) {
      effectiveLabel = Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              focusNode.requestFocus();
              return null;
            },
          ),
        },
        child: effectiveLabel,
      );
    }

    final effectiveLayoutBuilder = widget.layoutBuilder ?? settings.layoutBuilder;
    final effectiveBuilder = widget.builder ?? settings.builder;

    final content = effectiveBuilder?.call(context, focusNode, widget.child) ?? widget.child ?? const SizedBox.shrink();
    final body = effectiveLayoutBuilder?.call(context, content, effectiveLabel, effectiveLabelSpacing) ??
        VStack(
          crossAlignment: CrossAxisAlignment.stretch,
          spacing: effectiveLabelSpacing,
          children: [
            if (effectiveLabel != null) effectiveLabel,
            if (widget.child != null) widget.child!,
          ],
        );

    return body;
  }
}

class LabeledContentDefaults implements DefaultsData {
  static LabeledContentDefaults defaults = LabeledContentDefaults(
    labelSpacing: 4.0,
    labelBuilder: (context, label) {
      final labelStyle = Theme.of(context).textTheme.labelLarge;
      return DefaultTextStyle.merge(style: labelStyle, child: label);
    },
    layoutBuilder: (context, child, label, labelSpacing) => VStack(
      crossAlignment: CrossAxisAlignment.stretch,
      spacing: labelSpacing,
      children: [
        if (label != null) label,
        child,
      ],
    ),
  );

  final TextStyle? labelStyle;
  final double? labelSpacing;
  final LabeledContentLabelBuilder? labelBuilder;
  final LabeledContentBuilder? builder;
  final LabeledContentLayoutBuilder? layoutBuilder;

  LabeledContentDefaults({
    this.labelStyle,
    this.labelSpacing,
    this.labelBuilder,
    this.builder,
    this.layoutBuilder,
  });
}
