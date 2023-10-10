import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum GenericDropdownAlignmentSide {
  left,
  right,
}

typedef GenericDropdownBuilder<T> = Widget Function(BuildContext context, T data, Widget? child);

/// A generalized dropdown button widget that implements all functionality without a user interface.
///
/// Used to create dropdown buttons with a custom user interface.
/// Allows you to define the implementation of the user interface.
class GenericDropdown<T> extends StatefulWidget {
  static const double kScreenPadding = 8.0;

  final Widget? child;
  final GenericDropdownBuilder<bool>? builder;
  final WidgetBuilder dropdownBuilder;
  final bool barrierDismissible;
  final Color barrierColor;
  final Offset offset;
  final GenericDropdownAlignmentSide dropdownAlignment;
  final ValueChanged<T>? onClose;
  final double screenPadding;

  const GenericDropdown({
    Key? key,
    this.child,
    this.builder,
    required this.dropdownBuilder,
    this.barrierDismissible = true,
    this.barrierColor = Colors.transparent,
    this.offset = Offset.zero,
    this.dropdownAlignment = GenericDropdownAlignmentSide.right,
    this.onClose,
    this.screenPadding = kScreenPadding,
  })  : assert(child != null || builder != null, 'Either "child" or "builder" must be specified.'),
        super(key: key);

  @override
  State<GenericDropdown<T?>> createState() => _GenericDropdownState<T>();
}

class _GenericDropdownState<T> extends State<GenericDropdown<T?>> {
  bool isOpen = false;

  void _toggleDropdown(BuildContext context) async {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final OverlayState overlayState = Overlay.of(context);
    if (button == null) return;

    final RenderBox overlay = overlayState.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(/*offset*/ Offset.zero, ancestor: overlay),
        button.localToGlobal(
            (widget.dropdownAlignment == GenericDropdownAlignmentSide.left)
                ? button.size.bottomLeft(Offset.zero)
                : button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final Widget dropdown = Stack(
      children: [
        _GenericPositionWidget(
          targetRect: Rect.fromLTWH(position.left, position.top, button.size.width, button.size.height),
          offset: widget.offset,
          alignment: widget.dropdownAlignment,
          constraints: BoxConstraints(
            maxWidth: overlay.size.width,
            maxHeight: overlay.size.height,
          ),
          screenPadding: widget.screenPadding,
          child: widget.dropdownBuilder(context),
        ),
      ],
    );

    setState(() {
      isOpen = true;
    });

    final T? result = await Navigator.of(context).push<T>(
      _GenericDropdownRoute<T>(
        child: dropdown,
        barrierDismissible: widget.barrierDismissible,
        barrierColor: widget.barrierColor,
      ),
    );

    if (mounted) {
      setState(() {
        isOpen = false;
      });
    }

    widget.onClose?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final Widget? body = (widget.builder != null) ? widget.builder!(context, isOpen, widget.child) : widget.child;
    return Builder(
      builder: (context) {
        return InkResponse(
          highlightShape: BoxShape.rectangle,
          highlightColor: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4),
          splashColor: Colors.transparent,
          onTap: () => _toggleDropdown(context),
          child: body,
        );
      },
    );
  }
}

class _GenericDropdownRoute<T> extends PopupRoute<T> {
  final Widget _child;
  final Color? _barrierColor;
  final bool _barrierDismissible;

  _GenericDropdownRoute({
    required Widget child,
    Color? barrierColor,
    bool barrierDismissible = true,
  })  : _child = child,
        _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible,
        super();

  @override
  Color? get barrierColor => _barrierColor;

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 170);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _child;
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, lerpDouble(-8, 0, animation.value)!),
          child: child,
        ),
      ),
    );
  }
}

class _GenericPositionWidget extends SingleChildRenderObjectWidget {
  final Rect targetRect;
  final Offset offset;
  final GenericDropdownAlignmentSide alignment;
  final BoxConstraints constraints;
  final double screenPadding;

  const _GenericPositionWidget({
    required this.targetRect,
    required this.offset,
    required this.constraints,
    required this.alignment,
    this.screenPadding = 0,
    Widget? child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _GenericPositionRenderObject(
      targetRect: targetRect,
      offset: offset,
      constraints: constraints,
      alignment: alignment,
      screenPadding: screenPadding,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _GenericPositionRenderObject renderObject,
  ) {
    renderObject
      ..targetRect = targetRect
      ..offset = offset
      ..additionalConstraints = constraints
      ..alignment = alignment
      ..screenPadding = screenPadding;
  }
}

class _GenericPositionRenderObject extends RenderShiftedBox {
  late Rect _targetRect;
  late Offset _offset;
  late BoxConstraints _additionalConstraints;
  late GenericDropdownAlignmentSide _alignment;
  late double _screenPadding;

  _GenericPositionRenderObject({
    RenderBox? child,
    required Rect targetRect,
    required Offset offset,
    required BoxConstraints constraints,
    required GenericDropdownAlignmentSide alignment,
    double screenPadding = 0,
  }) : super(child) {
    _targetRect = targetRect;
    _offset = offset;
    _additionalConstraints = constraints;
    _alignment = alignment;
    _screenPadding = screenPadding;
  }

  BoxConstraints get additionalConstraints => _additionalConstraints;
  set additionalConstraints(BoxConstraints value) {
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  Offset get offset => _offset;
  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsLayout();
  }

  Rect get targetRect => _targetRect;
  set targetRect(Rect value) {
    if (_targetRect == value) return;
    _targetRect = value;
    markNeedsLayout();
  }

  GenericDropdownAlignmentSide get alignment => _alignment;
  set alignment(GenericDropdownAlignmentSide value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  double get screenPadding => _screenPadding;
  set screenPadding(double value) {
    if (_screenPadding == value) return;
    _screenPadding = value;
    markNeedsLayout();
  }

  Offset calculateOffset(Size size, Size areaSize) {
    double top = targetRect.bottom + offset.dy;
    if ((top + size.height + screenPadding) > areaSize.height) {
      top = areaSize.height - size.height - screenPadding;
      if (top < screenPadding) top = screenPadding;
    }

    double left;
    // double right;
    if (alignment == GenericDropdownAlignmentSide.left) {
      // Left
      left = targetRect.left + offset.dx;
      if ((left + size.width + screenPadding) > areaSize.width) {
        left = areaSize.width - screenPadding;
      }
    } else {
      // Right
      left = (targetRect.right - offset.dx) - size.width;
    }
    if (left < screenPadding) left = screenPadding;

    return Offset(left, top);
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(
        _additionalConstraints.enforce(constraints),
        parentUsesSize: true,
      );
      size = Size(constraints.maxWidth, constraints.maxHeight);
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      childParentData.offset = calculateOffset(child!.size, size);
    }
  }
}
