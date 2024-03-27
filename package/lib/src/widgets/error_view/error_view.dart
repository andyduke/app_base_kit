import 'package:app_base_kit/src/widgets/error_view/error_view_theme.dart';
import 'package:app_base_kit/src/widgets/expansion_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef ErrorViewRefreshCallback = Future<void> Function();

enum ErrorViewRefreshMode {
  button,
  pullToRefresh,
}

/// A widget that displays an error message, a detailed error
/// message (for example, a stack trace) that expands by button,
/// and an optional "Retry" button.
class ErrorView extends StatelessWidget {
  static const Icon defaultIcon = Icon(Icons.error);
  static const String defaultTitle = 'Something went wrong';
  static const String defaultDetailsButtonText = 'Details';
  static const String defaultRefreshButtonText = 'Try again';

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(16.0);

  final Widget? icon;
  final String title;
  final String? subtitle;
  final String detailsButtonText;
  final Object? error;
  final ErrorViewRefreshCallback? onRefresh;
  final ErrorViewRefreshMode refreshMode;
  final String refreshButtonText;
  final EdgeInsetsGeometry padding;
  final bool isDebugMode;

  const ErrorView({
    super.key,
    this.icon = defaultIcon,
    this.title = defaultTitle,
    this.subtitle,
    this.detailsButtonText = defaultDetailsButtonText,
    this.error,
    this.padding = defaultPadding,
    this.isDebugMode = kDebugMode,
  })  : assert(error != null),
        onRefresh = null,
        refreshMode = ErrorViewRefreshMode.button,
        refreshButtonText = defaultRefreshButtonText;

  const ErrorView.refreshable({
    super.key,
    this.icon = defaultIcon,
    this.title = defaultTitle,
    this.subtitle,
    this.detailsButtonText = defaultDetailsButtonText,
    this.error,
    required this.onRefresh,
    this.refreshMode = ErrorViewRefreshMode.button,
    this.refreshButtonText = defaultRefreshButtonText,
    this.padding = defaultPadding,
    this.isDebugMode = kDebugMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ErrorViewTheme>();
    final foregroundColor = Theme.of(context).colorScheme.onSurface;

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: IconTheme.merge(
            data: IconThemeData(size: 40, color: theme?.iconColor ?? foregroundColor),
            child: icon ?? const Text('😞', style: TextStyle(fontSize: 32), textAlign: TextAlign.center),
          ),
        ),
        Text(title,
            style:
                theme?.titleTextStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: foregroundColor)),

        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(subtitle!, style: theme?.subtitleTextStyle ?? TextStyle(fontSize: 16, color: foregroundColor)),
          ),

        if ((onRefresh != null) && (refreshMode == ErrorViewRefreshMode.button))
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: FilledButton.tonal(
              onPressed: onRefresh,
              child: Text(refreshButtonText),
            ),
          ),

        // Error details
        if ((error != null) || isDebugMode)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ExpansionDetails(
              details: SelectionArea(
                child: Text(
                  '$error',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              childCollapsedColor: Theme.of(context).colorScheme.primary,
              child: Text(detailsButtonText),
            ),
          ),
      ],
    );

    if ((onRefresh != null) && (refreshMode == ErrorViewRefreshMode.pullToRefresh)) {
      final scrollableBody = body;
      body = RefreshIndicator(
        onRefresh: onRefresh!,
        child: Scrollable(
          axisDirection: AxisDirection.down,
          physics: const AlwaysScrollableScrollPhysics(),
          viewportBuilder: (context, position) => Viewport(
            offset: position,
            axisDirection: AxisDirection.down,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Center(
                  child: SingleChildScrollView(
                    padding: padding,
                    child: scrollableBody,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      body = Padding(
        padding: padding,
        child: body,
      );
    }

    return body;
  }
}
