import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Defaults(
        [
          TestDefaults(data: 'test1'),
        ],
        child: Defaults(
          [
            Test2Defaults(label: 'test-label'),
          ],
          child: const TestWidget(
            child: Test2Widget(),
          ),
        ),
      ),
    );
  }
}

// ---

class TestWidget extends StatelessWidget {
  final Widget child;

  const TestWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<TestDefaults>(context, TestDefaults.defaults);

    final value = settings.data ?? 'n/a';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value),
        child,
      ],
    );
  }
}

class TestDefaults implements DefaultsData {
  static TestDefaults defaults = TestDefaults();

  final String? data;

  TestDefaults({
    this.data,
  });
}

// ---

class Test2Widget extends StatelessWidget {
  const Test2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<Test2Defaults>(context, Test2Defaults.defaults);

    final value = settings.label ?? 'none';

    return Text(value);
  }
}

class Test2Defaults implements DefaultsData {
  static Test2Defaults defaults = Test2Defaults();

  final String? label;

  Test2Defaults({
    this.label,
  });
}
