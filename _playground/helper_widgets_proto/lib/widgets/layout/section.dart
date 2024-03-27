import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/widgets.dart';

typedef SectionBuilder = Widget Function(
  BuildContext context,
  List<Widget> children,
  Widget? header,
  double headerSpacing,
  Widget? footer,
  double footerSpacing,
  bool? isExpanded,
);

class Section extends StatelessWidget {
  static const double defaultHeaderSpacing = 0.0;
  static const double defaultFooterSpacing = 0.0;

  final Widget? header;
  final TextStyle? headerStyle;
  final double? headerSpacing;
  final Widget? footer;
  final TextStyle? footerStyle;
  final double? footerSpacing;
  final bool? isExpanded;
  final List<Widget> children;
  final SectionBuilder? builder;

  const Section({
    super.key,
    this.header,
    this.headerStyle,
    this.headerSpacing,
    this.footer,
    this.footerStyle,
    this.footerSpacing,
    this.isExpanded,
    required this.children,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<SectionDefaults>(context, SectionDefaults.defaults);

    final effectiveHeaderSpacing = headerSpacing ?? settings.headerSpacing ?? defaultHeaderSpacing;
    final effectiveFooterSpacing = footerSpacing ?? settings.footerSpacing ?? defaultFooterSpacing;
    final effectiveHeaderStyle = headerStyle ?? settings.headerStyle;
    final effectiveHeader = (header != null)
        ? ((effectiveHeaderStyle != null)
            ? DefaultTextStyle.merge(style: effectiveHeaderStyle, child: header!)
            : header)
        : null;
    final effectiveFooterStyle = footerStyle ?? settings.footerStyle;
    final effectiveFooter = (footer != null)
        ? ((effectiveFooterStyle != null)
            ? DefaultTextStyle.merge(style: effectiveFooterStyle, child: footer!)
            : footer)
        : null;
    final effectiveBuilder = builder ??
        settings.builder ??
        (
          BuildContext context,
          List<Widget> children,
          Widget? header,
          double headerSpacing,
          Widget? footer,
          double footerSpacing,
          bool? isExpanded,
        ) =>
            VStack(
              crossAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: headerSpacing),
                    child: header,
                  ),
                ...children,
                if (footer != null)
                  Padding(
                    padding: EdgeInsets.only(top: footerSpacing),
                    child: footer,
                  ),
              ],
            );

    final body = effectiveBuilder.call(
      context,
      children,
      effectiveHeader,
      effectiveHeaderSpacing,
      effectiveFooter,
      effectiveFooterSpacing,
      isExpanded,
    );

    return body;
  }
}

class SectionDefaults implements DefaultsData {
  static SectionDefaults defaults = SectionDefaults();

  final TextStyle? headerStyle;
  final double? headerSpacing;
  final TextStyle? footerStyle;
  final double? footerSpacing;
  final SectionBuilder? builder;

  SectionDefaults({
    this.headerStyle,
    this.headerSpacing,
    this.footerStyle,
    this.footerSpacing,
    this.builder,
  });
}

class FormSectionMaterial3Defaults extends SectionDefaults {}

class FormSectionCupertinoDefaults extends SectionDefaults {}
