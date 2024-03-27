// ignore_for_file: avoid_print

import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helper_widgets_proto/screens/buttons/widgets/primary_button.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VStack(
            spacing: 24,
            crossAlignment: CrossAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Sample input',
                ),
              ),
              PrimaryButton(
                onPressed: () {
                  print('Primary Button Pressed!');
                },
                // child: const Text('Primary Button'),
                child: const Label('Primary &Button', interactive: false),
              ),

              //
              Actions(
                actions: {
                  ActivateIntent: CallbackAction<ActivateIntent>(
                    onInvoke: (_) {
                      print('!!! Ctrl-G');
                      return null;
                    },
                  ),
                },
                child: GlobalShortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyG): const ActivateIntent(),
                  },
                  child: Container(
                    color: Colors.blue.shade200,
                    padding: const EdgeInsets.all(16.0),
                    child: const Text('Ctrl-G'),
                  ),
                ),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: const Text('Next screen')),
                      ),
                    ),
                  );
                },
                child: const Label('Open &Next Screen', interactive: false),
              ),

              //
              const Divider(),

              //
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 150,
                    maxWidth: 200,
                  ),
                  child: ActionButton(
                    // primary: false,
                    child: const Text('Action Button'),
                    onAction: () async => Future.delayed(const Duration(seconds: 2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
