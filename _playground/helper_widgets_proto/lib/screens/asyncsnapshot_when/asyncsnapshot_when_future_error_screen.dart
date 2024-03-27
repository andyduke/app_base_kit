// ignore_for_file: avoid_print

import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';

class AsyncSnapshotWhenFutureErrorScreen extends StatefulWidget {
  const AsyncSnapshotWhenFutureErrorScreen({super.key});

  @override
  State<AsyncSnapshotWhenFutureErrorScreen> createState() => _AsyncSnapshotWhenScreenFutureErrorState();
}

class _AsyncSnapshotWhenScreenFutureErrorState extends State<AsyncSnapshotWhenFutureErrorScreen> {
  final helloFuture = Future.delayed(
    const Duration(seconds: 2),
    () => throw UnimplementedError(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncSnapshot.when Future Error'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            future: helloFuture,
            builder: (context, snapshot) => snapshot.when(
              context,
              data: (_, user) => Text('Hello, $user!'),
              error: (context, error, stackTrace) => Text(
                'Error: $error',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
