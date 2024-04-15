/// Interface for classes that [resolve] to a value of type `T` based
/// on a widget's interactive "value".
abstract class ValueProperty<T, S> {
  /// Returns a value of type `T` that depends on [value].
  T resolve(S value);

  /// Linearly interpolate between two `S`.
  static ValueProperty<T, S>? lerp<T, S>(
    ValueProperty<T, S>? a,
    ValueProperty<T, S>? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
    ValueProperty<T, S> defaultValue,
  ) {
    // Avoid creating a _ValueLerpProperties object for a common case.
    if (a == null && b == null) {
      return null;
    }
    // TODO: Fix cast issue
    return _ValueLerpProperties<T, S>(a, b, t, lerpFunction, defaultValue);
  }
}

class _ValueLerpProperties<T, S> implements ValueProperty<T, S> {
  const _ValueLerpProperties(this.a, this.b, this.t, this.lerpFunction, this.defaultValue);

  final ValueProperty<T, S>? a;
  final ValueProperty<T, S>? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;
  final ValueProperty<T, S> defaultValue;

  @override
  T resolve(S value) {
    final T? resolvedA = a?.resolve(value);
    final T? resolvedB = b?.resolve(value);
    return lerpFunction(resolvedA, resolvedB, t) ?? defaultValue.resolve(value);
  }
}
