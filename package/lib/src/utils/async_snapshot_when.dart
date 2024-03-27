import 'package:app_base_kit/src/utils/defaults.dart';
import 'package:flutter/material.dart';

/// Callback signature for building a widget for the [AsyncSnapshot] **error state**.
typedef AsyncSnapshotWhenErrorCallback = Widget Function(BuildContext context, Object error, StackTrace stackTrace);

/// Callback signature for building a widget for the [AsyncSnapshot] **loading state**.
typedef AsyncSnapshotWhenLoadingCallback = Widget Function(BuildContext context);

/// A settings class that allows you to specify default settings for the [when] extension for [AsyncSnapshot] using [Defaults].
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return MaterialApp(
///     ...
///     builder: (context, child) => Defaults(
///       [
///         AsyncSnapshotDefaults(
///           loading: (context) => const CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
///         ),
///       ],
///       child: child ?? const SizedBox.shrink(),
///     ),
///     ...
///   );
/// }
/// ```
class AsyncSnapshotDefaults implements DefaultsData {
  static final AsyncSnapshotDefaults defaults = AsyncSnapshotDefaults(
    error: (context, error, stack) => Error.throwWithStackTrace(error, stack),
    loading: (context) => const CircularProgressIndicator.adaptive(),
  );

  final AsyncSnapshotWhenErrorCallback? error;
  final AsyncSnapshotWhenLoadingCallback? loading;

  AsyncSnapshotDefaults({
    this.error,
    this.loading,
  });
}

extension AsyncSnapshotWhenCustom<T> on AsyncSnapshot<T> {
  /// Creates a widget based on the [AsyncSnapshot] state using one of the provided callbacks.
  ///
  /// If the snapshot contains data (**hasData is true**),
  /// then the [data] callback is used to create the resulting widget.
  ///
  /// If the snapshot contains an error (**hasError is true**),
  /// then the [error] callback is used to create the resulting widget.
  ///
  /// Otherwise, the [loading] callback is used to create the resulting widget.
  ///
  /// See also:
  /// * [when], implementation with default [error] and [loading] callbacks.
  ///
  R whenCustom<R>({
    required R Function(T data) data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
  }) {
    return switch (this) {
      AsyncSnapshot(hasData: true, data: T d) => data(d),
      AsyncSnapshot(hasError: true, error: Object e, stackTrace: StackTrace s) => error(e, s),
      _ => loading(),
    };
  }
}

extension AsyncSnapshotWhenDefaults<T> on AsyncSnapshot<T> {
  /// Creates a widget based on the [AsyncSnapshot] state using one of the provided callbacks.
  ///
  /// Works the same as [whenCustom], but provides a default implementation of the [error] and [loading] callbacks,
  /// which can be overridden using [AsyncSnapshotDefaults].
  ///
  /// This extension is convenient to use with [FutureBuilder] and [StreamBuilder], for example:
  /// ```dart
  /// child: FutureBuilder<String>(
  ///   future: helloFuture,
  ///   builder: (context, snapshot) => snapshot.when(context, data: (user) => Text('Hello, $user!'))
  /// ),
  /// ```
  /// ...or...
  /// ```dart
  /// child: StreamBuilder<int>(
  ///   stream: counterStream,
  ///   builder: (context, snapshot) => snapshot.when(context, data: (d) => Text('Counter: $d'))
  /// ),
  /// ```
  ///
  /// See also:
  /// * [whenCustom], version without default implementation;
  /// * [AsyncSnapshotDefaults], a class for setting up the default implementation of [error] and [loading];
  /// * [Defaults], with which you can set the default [AsyncSnapshotDefaults] settings.
  ///
  Widget when(
    BuildContext context, {
    required Widget Function(BuildContext context, T data) data,
    Widget Function(BuildContext context, Object error, StackTrace stackTrace)? error,
    Widget Function(BuildContext context)? loading,
  }) {
    return whenCustom(
      data: (d) => data(context, d),
      error: (e, s) => (error ??
          Defaults.defaultsOf<AsyncSnapshotDefaults>(context, AsyncSnapshotDefaults.defaults).error!)(context, e, s),
      loading: () => (loading ??
          Defaults.defaultsOf<AsyncSnapshotDefaults>(context, AsyncSnapshotDefaults.defaults).loading!)(context),
    );
  }
}
