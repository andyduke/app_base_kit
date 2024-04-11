import 'package:flutter/widgets.dart';

typedef ButtonWidgetBuilder<T> = Widget Function(BuildContext context, T value, VoidCallback? onPressed);
typedef ButtonsGroupLayoutWidgetBuilder<T> = Widget Function(BuildContext context, T value);

/// Creates a group of buttons for a specific list of values of type `<T>`.
///
/// Example:
/// ```dart
/// ButtonsGroup<DateTime>(
///   values: [DateTime(2022, 4, 9), DateTime(2022, 4, 10)],
///   buttonBuilder: (context, value, onPressed) => OutlinedButton(
///     onPressed: onPressed,
///     child: Text('$value'),
///   ),
///   onPressed: (date) {
///     print('Pressed: $date');
///   },
/// ),
/// ```
///
class ButtonsGroup<T> extends StatelessWidget {
  final List<T> values;
  final ButtonWidgetBuilder<T> buttonBuilder;
  final ButtonsGroupLayoutWidgetBuilder<List<Widget>> layoutBuilder;
  final ValueChanged<T>? onPressed;

  const ButtonsGroup({
    super.key,
    required this.values,
    required this.buttonBuilder,
    this.layoutBuilder = _defaultLayoutBuilder,
    this.onPressed,
  });

  static Widget _defaultLayoutBuilder(BuildContext context, List<Widget> buttons) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = values
        .map((value) => buttonBuilder(context, value, (onPressed != null) ? () => onPressed!.call(value) : null))
        .toList(growable: false);
    return this.layoutBuilder(context, buttons);
  }
}
