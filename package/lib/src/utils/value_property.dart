/// Interface for classes that [resolve] to a value of type `T` based
/// on a widget's interactive "value".
///
/// ValueProperty **lerp** *imlementation* example:
/// ```dart
/// class WaitingSizeProperty<T> implements ValueProperty<T, WaitingSize> {
///
///   static WaitingSizeProperty<T>? lerp<T>(
///     WaitingSizeProperty<T>? a,
///     WaitingSizeProperty<T>? b,
///     double t,
///     T Function(T? a, T? b, double t) lerpValue,
///   ) {
///     if (a == null && b == null) {
///       return null;
///     }
///
///     return WaitingSizeProperty<T>(
///       small: lerpValue(a?.small, b?.small, t),
///       large: lerpValue(a?.large, b?.large, t),
///     );
///   }
///
/// }
/// ```
///
/// ValueProperty **lerp** *usage* example:
/// ```dart
/// padding: WaitingSizeProperty.lerp<EdgeInsetsGeometry>(
///   padding,
///   other.padding,
///   t,
///   (a, b, t) => EdgeInsetsGeometry.lerp(a, b, t)!,
/// )!,
/// ```
abstract class ValueProperty<T, S> {
  /// Returns a value of type `T` that depends on [value].
  T resolve(S value);
}
