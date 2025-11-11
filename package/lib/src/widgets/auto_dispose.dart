import 'package:flutter/material.dart';

abstract interface class Disposable {
  void dispose();
}

/// Allows adding controllers and `ChangeNotifiers` to a pool
/// for automatic disposal when the `State` class is disposed.
///
/// Supports `ChangeNotifier` and its subclasses,
/// `AnimationController`, `SearchDelegate`, and objects
/// implementing the `Disposable` interface.
///
/// Example:
/// ```dart
/// class _SomeState extends State<SomeWidget> with AutoDispose {
///   late final controller = TestController()..autoDispose(this);
/// }
/// ```
mixin AutoDispose<T extends StatefulWidget> on State<T> {
  final _disposables = [];

  void autoDispose(Object obj) {
    _disposables.add(obj);
  }

  @override
  void dispose() {
    for (final obj in _disposables) {
      final d = obj as dynamic;
      try {
        d.dispose();
      } catch (_) {}
    }
    _disposables.clear();

    super.dispose();
  }
}

extension ChangeNotifierAutoDispose on ChangeNotifier {
  void autoDispose(AutoDispose owner) {
    owner.autoDispose(this);
  }
}

extension AnimationControllerAutoDispose on AnimationController {
  void autoDispose(AutoDispose owner) {
    owner.autoDispose(this);
  }
}

extension SearchDelegateAutoDispose on SearchDelegate {
  void autoDispose(AutoDispose owner) {
    owner.autoDispose(this);
  }
}
