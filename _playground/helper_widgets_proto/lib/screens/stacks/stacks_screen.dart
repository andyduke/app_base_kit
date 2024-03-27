import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class StacksScreen extends StatelessWidget {
  const StacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stacks demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Heading('VStack'),
            VStack(
              children: [
                SizedBox(
                  height: 100,
                  child: ColoredBox(color: Colors.amber.shade200),
                ),
                SizedBox(
                  height: 50,
                  child: ColoredBox(color: Colors.blueGrey.shade100),
                ),
                const Spacing(10),
                SizedBox(
                  height: 30,
                  child: ColoredBox(color: Colors.indigo.shade50),
                ),
              ],
            ),

            //
            const Divider(height: 32),

            const _Heading('VStack with spacing = 16'),
            VStack(
              spacing: 16,
              children: [
                SizedBox(
                  height: 100,
                  child: ColoredBox(color: Colors.amber.shade200),
                ),
                SizedBox(
                  height: 50,
                  child: ColoredBox(color: Colors.blueGrey.shade100),
                ),
                const Spacing(2),
                SizedBox(
                  height: 30,
                  child: ColoredBox(color: Colors.indigo.shade50),
                ),
              ],
            ),

            //
            const Divider(height: 32),

            //
            const _Heading('HStack'),
            HStack(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ColoredBox(color: Colors.amber.shade200),
                ),
                SizedBox(
                  width: 50,
                  height: 70,
                  child: ColoredBox(color: Colors.blueGrey.shade100),
                ),
                const Spacing(10),
                Expanded(
                  child: SizedBox(
                    width: 30,
                    height: 100,
                    child: ColoredBox(color: Colors.indigo.shade50),
                  ),
                ),
              ],
            ),

            //
            const Divider(height: 32),

            //
            const _Heading('VStack with defaults (spacing = 48)'),
            Defaults(
              [
                HStackDefaults(spacing: 48),
              ],
              child: HStack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ColoredBox(color: Colors.amber.shade200),
                  ),
                  SizedBox(
                    width: 50,
                    height: 100,
                    child: ColoredBox(color: Colors.blueGrey.shade100),
                  ),
                  const Spacing(10),
                  Expanded(
                    child: SizedBox(
                      width: 30,
                      height: 100,
                      child: ColoredBox(color: Colors.indigo.shade50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;

  const _Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
