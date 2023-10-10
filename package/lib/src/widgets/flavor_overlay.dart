import 'package:flutter/material.dart';

/// An overlay displayed on top of the entire application.
///
/// Typically used to display debugging information such as build type,
/// API host IP address, etc.
class FlavorOverlay extends StatelessWidget {
  static const Color defaultForegroundColor = Colors.white;
  static const Color defaultBackgroundColor = Color(0xB3FF3333); // Red with 70% opacity

  final String? flavorName;
  final Color foregroundColor;
  final Color backgroundColor;
  final Widget child;

  const FlavorOverlay({
    super.key,
    required this.flavorName,
    this.foregroundColor = defaultForegroundColor,
    this.backgroundColor = defaultBackgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (flavorName == null) {
      return child;
    }

    return Stack(
      children: [
        child,

        // Overlay
        _FlavorOverlayView(
          text: flavorName!,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
        ),
      ],
    );
  }
}

class _FlavorOverlayView extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final String text;

  const _FlavorOverlayView({
    // ignore: unused_element
    super.key,
    required this.text,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final topSafeZone = MediaQuery.of(context).viewPadding.top;

    return Positioned(
      top: topSafeZone + 2,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: true,
        child: Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.topCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                child: Text(
                  text.toUpperCase(),
                  style: TextStyle(fontSize: 11, height: 1.1, fontWeight: FontWeight.bold, color: foregroundColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
