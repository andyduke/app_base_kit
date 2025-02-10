import 'dart:async';
import 'package:flutter/material.dart';

/// Secure storage (abstraction over real implementation)
abstract class SecureStorage {
  SecureStorage() {
    _initialize();
  }

  /// Is the secure storage already loaded or not yet?
  Future<void> get ready => _ready.future;
  final _ready = Completer();

  /// Initializes the storage.
  @protected
  Future<void> initialize();

  Future<void> _initialize() async {
    await initialize();
    _ready.complete();
  }

  /// Checks if the value with key [key] is present in the store.
  Future<bool> has(String key);

  /// Returns the value from the storage for the key [key]
  Future<String?> read(String key);

  /// Writes value [value] to storage with key [key]
  Future<void> write(String key, String value);

  /// Deletes the value for key [key] from storage
  Future<void> delete(String key);

  /// Clears storage
  Future<void> clear();
}
