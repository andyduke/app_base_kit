import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:helper_widgets_proto/screens/asyncsnapshot_when/asyncsnapshot_when_future_error_screen.dart';
import 'package:helper_widgets_proto/screens/asyncsnapshot_when/asyncsnapshot_when_future_screen.dart';
import 'package:helper_widgets_proto/screens/asyncsnapshot_when/asyncsnapshot_when_stream_screen.dart';
import 'package:helper_widgets_proto/screens/buttons/buttons_screen.dart';
import 'package:helper_widgets_proto/screens/controls/controls_screen.dart';
import 'package:helper_widgets_proto/screens/labels/labels_screen.dart';
import 'package:helper_widgets_proto/screens/layout/layout_screen.dart';
import 'package:helper_widgets_proto/screens/stacks/stacks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Widgets Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VStack(
            // collapse: true,
            spacing: 32,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LayoutScreen(),
                    ),
                  );
                },
                child: const Text('Layout demo'),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const StacksScreen(),
                    ),
                  );
                },
                child: const Text('Stacks demo'),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ButtonsScreen(),
                    ),
                  );
                },
                child: const Text('Buttons demo'),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LabelsScreen(),
                    ),
                  );
                },
                child: const Text('Labels demo'),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ControlsScreen(),
                    ),
                  );
                },
                child: const Text('Controls demo'),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AsyncSnapshotWhenFutureScreen(),
                    ),
                  );
                },
                child: const Text('AsyncSnapshot.when Future demo'),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AsyncSnapshotWhenFutureErrorScreen(),
                    ),
                  );
                },
                child: const Text('AsyncSnapshot.when Future error handling demo'),
              ),

              //
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AsyncSnapshotWhenStreamScreen(),
                    ),
                  );
                },
                child: const Text('AsyncSnapshot.when Stream demo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
