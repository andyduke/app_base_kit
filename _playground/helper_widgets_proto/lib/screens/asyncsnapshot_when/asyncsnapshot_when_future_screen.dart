// ignore_for_file: avoid_print

import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class AsyncSnapshotWhenFutureScreen extends StatefulWidget {
  const AsyncSnapshotWhenFutureScreen({super.key});

  @override
  State<AsyncSnapshotWhenFutureScreen> createState() => _AsyncSnapshotWhenScreenFutureState();
}

class _AsyncSnapshotWhenScreenFutureState extends State<AsyncSnapshotWhenFutureScreen> {
  final helloFuture = Future.delayed(
    const Duration(seconds: 2),
    () => 'World',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncSnapshot.when Future'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            future: helloFuture,
            builder: (context, snapshot) => snapshot.when(context, data: (_, user) => Text('Hello, $user!')),
          ),
        ),
      ),
    );
  }
}
