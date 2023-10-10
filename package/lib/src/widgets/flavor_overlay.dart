import 'package:flutter/material.dart';

/// An overlay displayed on top of the entire application.
///
/// Typically used to display debugging information such as build type,
/// API host IP address, etc.
class FlavorOverlay extends StatefulWidget {
  static const Color defaultForegroundColor = Colors.white;
  static const Color defaultBackgroundColor = Color(0xB3FF0000); // Red with 70% opacity

  final String? flavorName;
  final GlobalKey<NavigatorState> rootNavigatorKey;
  final Color foregroundColor;
  final Color backgroundColor;
  final Widget child;

  const FlavorOverlay({
    super.key,
    required this.flavorName,
    required this.rootNavigatorKey,
    this.foregroundColor = defaultForegroundColor,
    this.backgroundColor = defaultBackgroundColor,
    required this.child,
  });

  @override
  State<FlavorOverlay> createState() => _FlavorOverlayState();
}

class _FlavorOverlayState extends State<FlavorOverlay> {
  OverlayEntry? _overlayEntry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_overlayEntry == null && (widget.flavorName != null) && (widget.rootNavigatorKey.currentContext != null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _buildOverlay());
    }
  }

  void _buildOverlay() {
    final overlay = Overlay.of(context);
    final flavorName = widget.flavorName;
    if (flavorName != null) {
      _overlayEntry = OverlayEntry(
        builder: (_) => _FlavorOverlayView(
          text: flavorName,
          foregroundColor: widget.foregroundColor,
          backgroundColor: widget.backgroundColor,
        ),
      );
      overlay.insert(_overlayEntry!);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
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
    );
  }
}
