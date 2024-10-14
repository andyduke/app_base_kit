import 'dart:async';

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

class EventBus {
  final StreamController _streamController = StreamController.broadcast();

  /// Метод, возвращает стрим при изменении события
  Stream<T> on<T extends Event>(Type? eventType) {
    if (eventType == null) {
      assert(T != dynamic,
          'When using "on", you must specify the event type in the generic parameter or in the method parameter.');
      return _streamController.stream.where((event) => event is T).cast<T>();
    } else {
      return _streamController.stream.where((event) => event.runtimeType == eventType).cast<T>();
    }
  }

  /// Добавление события в шину
  void dispatchEvent(Event event) {
    _streamController.add(event);
  }

  /// Закрытие контроллера. В основном, данный метод не нужен.
  /// Так как поток шины событий, должен работать пока работает
  /// приложение. Так же, перед закрытием лучше проверить наличие
  /// подписчиков.
  void dispose() {
    _streamController.close();
  }
}
