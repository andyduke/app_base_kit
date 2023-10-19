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
class Defaults extends InheritedWidget {
  final List<DefaultsData> data;

  const Defaults(
    this.data, {
    super.key,
    required super.child,
  });

  static T? maybeDefaultsOf<T extends DefaultsData>(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<Defaults>()?.data;
    return (settings?.firstWhereOrNull((s) => s is T) as T?);
  }

  static T defaultsOf<T extends DefaultsData>(BuildContext context, T defaults) {
    return maybeDefaultsOf<T>(context) ?? defaults;
  }

  static List<DefaultsData>? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Defaults>()?.data;
  }

  static List<DefaultsData> of(BuildContext context) {
    final List<DefaultsData>? result = maybeOf(context);
    assert(result != null, 'No Defaults found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Defaults oldWidget) => data != oldWidget.data;
}
