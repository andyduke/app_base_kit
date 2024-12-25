import 'dart:async';
import 'package:flutter/foundation.dart';

/// An abstract event class. Any events dispatched via EventBus must inherit from this class.
///
/// See also:
/// - [EventBus], which allows you to dispatch events to descendants of this class.
abstract class Event<T> {
  const Event(this.data);

  final T data;

  @override
  bool operator ==(covariant Event<T> other) => data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => '$runtimeType($data)';
}

/// An event bus that makes it possible to subscribe and dispatch events of a certain type.
///
/// Can be used as a standalone **class** or as a **mixin** to another class,
/// such as a controller.
mixin class EventBus {
  final StreamController _streamController = StreamController.broadcast();

  /// Subscribe to an event of a certain type, returns a stream
  Stream<T> on<T extends Event>([Type? eventType]) {
    if (eventType == null) {
      assert(T != dynamic,
          'When using "on", you must specify the event type in the generic parameter or in the method parameter.');
      return _streamController.stream.where((event) => event is T).cast<T>();
    } else {
      return _streamController.stream.where((event) => event.runtimeType == eventType).cast<T>();
    }
  }

  /// Dispatch event to event stream
  void dispatchEvent(Event event) {
    _streamController.add(event);
  }

  @mustCallSuper
  void dispose() {
    _streamController.close();
  }
}
