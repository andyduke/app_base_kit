/// Interface for classes that [resolve] to a value of type `T` based
/// on a widget's interactive "value".
abstract class ValueProperty<T, S> {
  /// Returns a value of type `T` that depends on [value].
  T resolve(S value);

  /// Linearly interpolate between two `S`.
  static P? lerp<P extends ValueProperty<T, S>, T, S>(
    P? a,
    P? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
  ) {
    // Avoid creating a _ValueLerpProperties object for a common case.
    if (a == null && b == null) {
      return null;
    }
    return _ValueLerpProperties<P, T, S>(a, b, t, lerpFunction) as P;
  }
}

class _ValueLerpProperties<P extends ValueProperty<T, S>, T, S> implements ValueProperty<T?, S> {
  const _ValueLerpProperties(this.a, this.b, this.t, this.lerpFunction);

  final P? a;
  final P? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;

  @override
  T? resolve(S value) {
    final T? resolvedA = a?.resolve(value);
    final T? resolvedB = b?.resolve(value);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}
