import 'package:flutter/material.dart';

/// A widget that displays summary content and expandable long-form content.
///
/// Can be used to display error message and stack trace as detailed content.
class ExpansionDetails extends StatefulWidget {
  final Widget child;
  final Color? childCollapsedColor;
  final Color? childExpandedColor;
  final MainAxisAlignment childAlignment;
  final Widget details;
  final EdgeInsetsGeometry detailsPadding;
  final Alignment detailsAlignment;
  final Widget? leading;
  final Widget? trailing;
  final bool maintainState;
  final Duration expandDuration;
  final bool initiallyExpanded;
  final bool forceExpand;
  final ValueChanged<bool>? onExpansionChanged;

  const ExpansionDetails({
    Key? key,
    required this.child,
    this.childCollapsedColor,
    this.childExpandedColor,
    this.childAlignment = MainAxisAlignment.center,
    required this.details,
    this.detailsPadding = const EdgeInsets.symmetric(vertical: 16),
    this.detailsAlignment = Alignment.center,
    this.leading,
    this.trailing,
    this.maintainState = false,
    this.expandDuration = const Duration(milliseconds: 200),
    this.initiallyExpanded = false,
    this.forceExpand = false,
    this.onExpansionChanged,
  }) : super(key: key);

  @override
  ExpansionDetailsState createState() => ExpansionDetailsState();
}

class ExpansionDetailsState extends State<ExpansionDetails> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _headerColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<double> _opacityFactor;
  late Animation<Color?> _headerColor;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.expandDuration, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _opacityFactor = CurvedAnimation(
      curve: Curves.easeInExpo,
      parent: _controller.drive(_opacityTween),
    );
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));

    _isExpanded = PageStorage.of(context).readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant ExpansionDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.forceExpand != widget.forceExpand) {
      if (widget.forceExpand) {
        _expand();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _expand() {
    _isExpanded = true;
    _controller.forward();
  }

  void _collapse() {
    _isExpanded = false;
    _controller.reverse().then<void>((void value) {
      if (!mounted) return;
      setState(() {
        // Rebuild without widget.children.
      });
    });
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expand();
      } else {
        _collapse();
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) widget.onExpansionChanged!(_isExpanded);
  }

  Widget _buildDetails(BuildContext context, Widget? child) {
    return Transform.translate(
      offset: const Offset(0, -12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Details button
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: _handleTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: _headerColor.value),
                  child: Row(
                    mainAxisAlignment: widget.childAlignment,
                    children: [
                      // Leading
                      if (widget.leading != null) widget.leading!,

                      // Child
                      widget.child,

                      // Trailing
                      widget.trailing ??
                          RotationTransition(
                            turns: _iconTurns,
                            child: Icon(Icons.expand_more, color: _headerColor.value),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Details
          ClipRect(
            child: Opacity(
              opacity: _opacityFactor.value,
              child: Align(
                alignment: widget.detailsAlignment,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _headerColorTween
      ..begin = widget.childCollapsedColor ?? theme.textTheme.titleMedium!.color
      ..end = widget.childExpandedColor ?? theme.colorScheme.secondary;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.detailsPadding,
          child: widget.details,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildDetails,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
