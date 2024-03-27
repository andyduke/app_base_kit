// ignore_for_file: avoid_print

import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class AsyncSnapshotWhenStreamScreen extends StatefulWidget {
  const AsyncSnapshotWhenStreamScreen({super.key});

  @override
  State<AsyncSnapshotWhenStreamScreen> createState() => _AsyncSnapshotWhenScreenStreamState();
}

class _AsyncSnapshotWhenScreenStreamState extends State<AsyncSnapshotWhenStreamScreen> {
  final counterStream = () async* {
    await Future.delayed(const Duration(seconds: 2));

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield i;
    }
  }();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncSnapshot.when Stream'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<int>(
            stream: counterStream,
            builder: (context, snapshot) => snapshot.when(context, data: (_, d) => Text('Counter: $d')),
          ),
        ),
      ),
    );
  }
}
