import 'package:flutter/widgets.dart';

/// A widget that defines how focus should be displayed around the nested widget.
class FocusBuilder extends StatefulWidget {
  final FocusNode focusNode;
  final Widget? child;
  final ValueWidgetBuilder<bool> builder;

  const FocusBuilder({
    super.key,
    required this.focusNode,
    this.child,
    required this.builder,
  });

  @override
  State<FocusBuilder> createState() => FocusBuilderState();
}

class FocusBuilderState extends State<FocusBuilder> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode;
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(covariant FocusBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_rebuild);
      _focusNode = widget.focusNode;
      _focusNode.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFocus = _focusNode.hasFocus;
    return widget.builder(context, hasFocus, widget.child);
  }
}
