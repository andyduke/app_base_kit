import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

abstract interface class DefaultsData {}

/// A generic [InheritedWidget] that defines a set of defaults for underlying widgets.
///
/// Example:
/// ```dart
/// /// Defaults class
/// class ActionButtonDefaults implements DefaultsData {
///
///   static ActionButtonDefaults defaults = ActionButtonDefaults(
///     builder: (context, child, onPressed) => ElevatedButton(
///       onPressed: onPressed,
///       child: child,
///     ),
///   );
///
///   final Widget Function(BuildContext context, Widget child, VoidCallback? onPressed) builder;
///
///   ActionButtonDefaults({
///     required this.builder,
///   });
///
/// }
///
/// /// Widget that uses defaults
/// class ActionButton extends StatelessWidget {
///
///   final Widget child;
///   final VoidCallback? onPressed;
///
///   const ActionButton({
///     required this.child,
///     required this.onPressed,
///   });
///
///   @override
///   Widget build(BuildContext context) {
///     // Getting defaults
///     final settings = Defaults.defaultsOf<ActionButtonDefaults>(context, ActionButtonDefaults.defaults);
///
///     return ConstrainedBox(
///       constraints: const BoxConstraints(
///         minWidth: 200,
///       ),
///       child: settings.builder(
///         context,
///         child,
///         onPressed,
///       ),
///     );
///   }
///
/// }
///
/// void main() {
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       theme: ThemeData.light(),
///       debugShowCheckedModeBanner: false,
///       home: Scaffold(
///         body: Center(
///           child: Column(
///             mainAxisSize: MainAxisSize.min,
///             children: [
///
///               // Defining defaults for underlying widgets
///               Defaults(
///                 [
///                   ActionButtonDefaults(
///                     builder: (context, child, onPressed) => OutlinedButton(
///                       onPressed: onPressed,
///                       child: child,
///                     ),
///                   ),
///                 ],
///                 child: MyWidget(),
///               ),
///
///               //
///               const Divider(),
///
///               //
///               MyWidget(),
///             ],
///           ),
///         ),
///       ),
///     );
///   }
/// }
///
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return ActionButton(
///       onPressed: () {},
///       child: const Text('OK'),
///     );
///   }
/// }
///
/// ```
class Defaults extends StatefulWidget {
  final List<DefaultsData> data;
  final Widget child;

  const Defaults(
    this.data, {
    super.key,
    required this.child,
  });

  @override
  State<Defaults> createState() => _DefaultsState();

  static T? maybeDefaultsOf<T extends DefaultsData>(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<_DefaultsScope>()?.state.data;
    return (settings?.firstWhereOrNull((s) => s is T) as T?);
  }

  static T defaultsOf<T extends DefaultsData>(BuildContext context, T defaults) {
    return maybeDefaultsOf<T>(context) ?? defaults;
  }

  static List<DefaultsData>? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_DefaultsScope>()?.state.data;
  }

  static List<DefaultsData> of(BuildContext context) {
    final List<DefaultsData>? result = maybeOf(context);
    assert(result != null, 'No Defaults found in context');
    return result!;
  }
}

class _DefaultsState extends State<Defaults> {
  List<DefaultsData> parentData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final parent = context.findAncestorWidgetOfExactType<_DefaultsScope>()?.state.data;
    parentData
      ..clear()
      ..addAll(parent ?? []);
  }

  List<DefaultsData> get data => [
        ...parentData,
        ...widget.data,
      ];

  @override
  Widget build(BuildContext context) {
    return _DefaultsScope(
      state: this,
      child: widget.child,
    );
  }
}

class _DefaultsScope extends InheritedWidget {
  final _DefaultsState state;

  const _DefaultsScope({
    // super.key,
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_DefaultsScope oldWidget) => state.data != oldWidget.state.data;
}
