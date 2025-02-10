import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final controller = FetchViewController<String>(
    onFetch: (isReload) async {
      // return Future.delayed(const Duration(seconds: 1), () {
      //   throw Exception('Test');
      // });

      return Future.delayed(const Duration(seconds: 1), () {
        return 'Test';
      });
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FetchView(
          controller: controller,
          builder: (context, data) => Text(data),
        ),
      ),
    );
  }
}
