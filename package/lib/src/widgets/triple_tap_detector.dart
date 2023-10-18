import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Widget that recognizes triple tap.
class TripleTapDetector extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// The user quickly tapped the screen three times with the primary button in the same location.
  final VoidCallback onTripleTap;

  const TripleTapDetector({
    super.key,
    required this.child,
    required this.onTripleTap,
  });

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        SerialTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<SerialTapGestureRecognizer>(
            SerialTapGestureRecognizer.new, (SerialTapGestureRecognizer instance) {
          instance.onSerialTapDown = (SerialTapDownDetails details) {
            if (details.count == 3) {
              onTripleTap();
            }
          };
        })
      },
      child: child,
    );
  }
}
