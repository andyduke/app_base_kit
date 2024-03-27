import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:helper_widgets_proto/screens/controls/widgets/custom_input_control.dart';
import 'package:helper_widgets_proto/screens/controls/widgets/custom_text_field.dart';

class ControlsScreen extends StatefulWidget {
  const ControlsScreen({super.key});

  @override
  State<ControlsScreen> createState() => _ControlsScreenState();
}

class _ControlsScreenState extends State<ControlsScreen> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controls'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VStack(
            spacing: 24,
            crossAlignment: CrossAxisAlignment.center,
            children: [
              /*
              Actions(
                actions: <Type, Action<Intent>>{
                  ButtonActivateIntent: RequestFocusAction(),
                },
                child: HStack(
                  spacing: 6,
                  alignment: CrossAxisAlignment.center,
                  children: [
                    Switch(
                      value: enabled,
                      onChanged: (newState) => setState(() {
                        enabled = newState;
                      }),
                    ),
                    const Label('&Enabled', interactive: true, intent: ButtonActivateIntent()),
                  ],
                ),
              ),
              */
              SwitchControl(
                value: enabled,
                text: '&Enabled',
                onChange: (value) => setState(() {
                  enabled = value;
                }),
              ),

              //
              CustomInputControl(
                enabled: enabled,
                child: TextField(
                  enabled: enabled,
                  decoration: const InputDecoration(
                    hintText: 'Custom input field',
                    border: InputBorder.none,
                  ),
                ),
              ),

              //
              CustomTextField(
                enabled: enabled,
                hintText: 'Custom text field',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: Labeled Control
class SwitchControl extends StatefulWidget {
  final String text;
  final bool value;
  final ValueChanged<bool>? onChange;

  const SwitchControl({
    super.key,
    required this.text,
    this.value = true,
    this.onChange,
  });

  @override
  State<SwitchControl> createState() => _SwitchControlState();
}

class _SwitchControlState extends State<SwitchControl> {
  bool get value => _value;
  late bool _value = widget.value;
  set value(bool newValue) {
    if (_value != newValue) {
      setState(() {
        _value = newValue;
      });
      widget.onChange?.call(_value);
    }
  }

  @override
  void didUpdateWidget(covariant SwitchControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VStack(
      spacing: 24,
      crossAlignment: CrossAxisAlignment.center,
      children: [
        Actions(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<Intent>(
              onInvoke: (Intent intent) {
                value = !value;
                return null;
              },
            ),
          },
          child: HStack(
            spacing: 6,
            crossAlignment: CrossAxisAlignment.center,
            children: [
              Switch(
                value: value,
                onChanged: (newState) => value = newState,
              ),
              Label(widget.text, interactive: true),
            ],
          ),
        ),
      ],
    );
  }
}
