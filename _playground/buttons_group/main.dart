import 'package:flutter/material.dart';

// ---

typedef ButtonWidgetBuilder<T> = Widget Function(BuildContext context, T value, VoidCallback? onPressed);
typedef ButtonsGroupLayoutWidgetBuilder<T> = Widget Function(BuildContext context, T value);

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
    final buttons = values.map((value) => buttonBuilder(context, value, (onPressed != null) ? () => onPressed!.call(value) : null)).toList(growable: false);
    return this.layoutBuilder(context, buttons);
  }
  
}

// ---

class Label extends StatelessWidget {
  final Widget label;
  final Widget child;
  final VoidCallback? onPressed;

  const Label({super.key, required this.label, required this.child, this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(width: 4),
          label,
        ],
      ),
    );
  }
}

// ---

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? selectedRadio;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Buttons
              ButtonsGroup<DateTime>(
                values: [DateTime(2022, 4, 9), DateTime(2022, 4, 10)],
                buttonBuilder: (context, value, onPressed) => OutlinedButton(
                  onPressed: onPressed,
                  child: Text('$value'),
                ),
                onPressed: (date) {
                  print('Pressed: $date');
                },
              ),
              
              //
              const SizedBox(height: 24),
              
              // Radio Buttons
              StatefulBuilder(
                builder: (context, setState) {
                  return ButtonsGroup<DateTime>(
                    values: [DateTime(2022, 4, 9), DateTime(2022, 4, 10)],
                    buttonBuilder: (context, value, onPressed) => Label(
                      label: Text('$value'),
                      onPressed: onPressed,
                      child: Radio<DateTime>(
                        value: value,
                        groupValue: selectedRadio,
                        onChanged: (DateTime? value) => onPressed?.call(),
                      ),
                    ),
                    onPressed: (date) {
                      print('Pressed: $date');
                      
                      setState(() => selectedRadio = date);
                    },
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
