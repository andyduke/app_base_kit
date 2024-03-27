// ignore_for_file: avoid_print

import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:helper_widgets_proto/screens/buttons/widgets/primary_button.dart';

class LabelsScreen extends StatefulWidget {
  const LabelsScreen({super.key});

  @override
  State<LabelsScreen> createState() => _LabelsScreenState();
}

class _LabelsScreenState extends State<LabelsScreen> {
  final fieldFocusNode = FocusNode();
  final field2FocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labels'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VStack(
            spacing: 24,
            crossAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryButton(
                onPressed: () {
                  print('Primary Button Pressed!');
                },
                // child: const Text('Primary Button'),
                child: const Label('Primary &Button'),
              ),

              //
              const Divider(),

              //
              Theme(
                data: Theme.of(context).copyWith(
                  extensions: [
                    LabelTheme(
                      textStyle: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.blue),
                      acceleratorTextStyle: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),

                // Custom label styles
                child: Actions(
                  actions: <Type, Action<Intent>>{
                    ActivateIntent: CallbackAction<Intent>(
                      onInvoke: (Intent intent) {
                        fieldFocusNode.requestFocus();
                        return null;
                      },
                    ),
                  },
                  child: VStack(
                    children: [
                      const Label('Test &Label', interactive: true),
                      TextField(focusNode: fieldFocusNode),
                    ],
                  ),
                ),
              ),

              // Labeled text field without focus
              const LabeledContent(
                label: Label('Field w/&o focus'),
                child: TextField(),
              ),

              // Labeled text field
              LabeledContent(
                label: const Label('&Field'),
                builder: (context, focusNode, child) => TextField(focusNode: focusNode),
              ),

              // Labeled text field with external focus
              LabeledContent(
                focusNode: field2FocusNode,
                label: const Label('Field (with e&xternal focus)'),
                builder: (context, focusNode, child) => TextField(focusNode: focusNode),
              ),
              TextButton(
                onPressed: () {
                  field2FocusNode.requestFocus();
                },
                child: const Text('Focus field ^'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
