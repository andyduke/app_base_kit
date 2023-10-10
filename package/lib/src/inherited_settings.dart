import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

abstract interface class InheritedSettingsData {}

/// A generic [InheritedWidget] that defines a set of settings for underlying widgets.
///
/// Example:
/// ```dart
/// /// Settings class
/// class ActionButtonSettings implements InheritedSettingsData {
///
///   static ActionButtonSettings defaultSettings = ActionButtonSettings(
///     builder: (context, child, onPressed) => ElevatedButton(
///       onPressed: onPressed,
///       child: child,
///     ),
///   );
///
///   final Widget Function(BuildContext context, Widget child, VoidCallback? onPressed) builder;
///
///   ActionButtonSettings({
///     required this.builder,
///   });
///
/// }
///
/// /// Widget that uses settings
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
///     // Getting Settings
///     final settings = InheritedSettings.settingsOf<ActionButtonSettings>(context, ActionButtonSettings.defaultSettings);
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
///               // Defining settings for underlying widgets
///               InheritedSettings(
///                 settings: [
///                   ActionButtonSettings(
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
class InheritedSettings extends InheritedWidget {
  final List<InheritedSettingsData> settings;

  const InheritedSettings({
    super.key,
    required super.child,
    required this.settings,
  });

  static T? maybeSettingsOf<T extends InheritedSettingsData>(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<InheritedSettings>()?.settings;
    return (settings?.firstWhereOrNull((s) => s is T) as T?);
  }

  static T settingsOf<T extends InheritedSettingsData>(BuildContext context, T defaultSettings) {
    return maybeSettingsOf<T>(context) ?? defaultSettings;
  }

  static List<InheritedSettingsData>? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedSettings>()?.settings;
  }

  static List<InheritedSettingsData> of(BuildContext context) {
    final List<InheritedSettingsData>? result = maybeOf(context);
    assert(result != null, 'No InheritedSettings found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedSettings oldWidget) => settings != oldWidget.settings;
}
