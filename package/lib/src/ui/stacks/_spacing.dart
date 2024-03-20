part of 'stacks.dart';

/// Makes it possible to set an individual spacing between
/// two widgets in `VStack`/`HStack`, different from the
/// spacing specified in the stack itself.
///
/// See also:
/// * [HStack]
/// * [VStack]
class Spacing extends LeafRenderObjectWidget {
  final double size;

  /// Makes it possible to set an individual spacing between
  /// two widgets in `VStack`/`HStack`, different from the
  /// spacing specified in the stack itself.
  ///
  /// See also:
  /// * [HStack]
  /// * [VStack]
  const Spacing(
    this.size, {
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderStackSpacer();
  }
}

class _RenderStackSpacer extends RenderBox {
  @override
  void performLayout() {
    size = Size.zero;
  }
}
