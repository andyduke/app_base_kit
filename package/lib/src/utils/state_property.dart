/// Interface for classes that [resolve] to a value of type `T` based
/// on a widget's interactive "state", which is defined as a set
/// of `S` states.
abstract class StateProperty<T, S> {
  /// Returns a value of type `T` that depends on [states].
  T resolve(Set<S> states);

  /// Linearly interpolate between two `S`.
  static P? lerp<P extends StateProperty<T, S>, T, S>(
    P? a,
    P? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
  ) {
    // Avoid creating a _StateLerpProperties object for a common case.
    if (a == null && b == null) {
      return null;
    }
    return _StateLerpProperties<P, T, S>(a, b, t, lerpFunction) as P;
  }
}

class _StateLerpProperties<P extends StateProperty<T, S>, T, S> implements StateProperty<T?, S> {
  const _StateLerpProperties(this.a, this.b, this.t, this.lerpFunction);

  final P? a;
  final P? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;

  @override
  T? resolve(Set<S> states) {
    final T? resolvedA = a?.resolve(states);
    final T? resolvedB = b?.resolve(states);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}
