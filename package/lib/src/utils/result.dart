import 'dart:async';

// https://dartpad.dev/?id=b06a6b71203972a5332e6c2f7724bb93

typedef SuccessCallback<R, T> = R Function(T success);
typedef ErrorCallback<R> = R Function(Object error, StackTrace? stackTrace);

abstract class Result<T> {
  
  bool get hasData;
  
  bool get hasError;
  
  const Result();
  
  const factory Result.success(T data) = ResultSuccess;
  
  const factory Result.error(Object error, [StackTrace? stackTrace]) = ResultError;
  
  /// Wrap a [computation] function in a try/catch and return an [Result] with
  /// either a value or an error, based on whether an exception was thrown or not.
  static FutureOr<Result<T>> guard<T>(FutureOr<T> Function() computation) async {
    try {
      return Result.success(await computation());
    } catch (e, s) {
      return Result.error(e, s);
    }
  }
  
  /// Handle the result when success or error
  ///
  /// if the result is an error, it will be returned in [whenError]
  /// if it is a success it will be returned in [whenSuccess]
  R when<R>(
    SuccessCallback<R, T> whenSuccess,
    ErrorCallback<R> whenError,
  );
  
  /// Execute [whenSuccess] if the [Result] is a success.
  R? whenSuccess<R>(
    SuccessCallback<R, T> whenSuccess,
  );

  /// Execute [whenError] if the [Result] is an error.
  R? whenError<R>(
    ErrorCallback<R> whenError,
  );

}

class ResultSuccess<T> extends Result<T> {
  
  final T data;

  const ResultSuccess(this.data);
  
  @override
  bool get hasData => true;
  
  @override
  bool get hasError => false;
  
  @override
  R when<R>(
    SuccessCallback<R, T> whenSuccess,
    ErrorCallback<R> whenError,
  ) => whenSuccess(data);

  @override
  R whenSuccess<R>(SuccessCallback<R, T> whenSuccess) {
    return whenSuccess(data);
  }

  @override
  R? whenError<R>(ErrorCallback<R> whenError) => null;
  
  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant ResultSuccess<T> other) {
    return other.data == data;
  }
 
}

class ResultError<T> extends Result<T>{
  
  final Object error;
  final StackTrace? stackTrace;

  const ResultError(
    this.error, [
    this.stackTrace,
  ]);
  
  @override
  bool get hasData => false;
  
  @override
  bool get hasError => true;

  @override
  R when<R>(
    SuccessCallback<R, T> whenSuccess,
    ErrorCallback<R> whenError,
  ) => whenError(error, stackTrace);

  @override
  R? whenSuccess<R>(SuccessCallback<R, T> whenSuccess) => null;

  @override
  R whenError<R>(ErrorCallback<R> whenError) => whenError(error, stackTrace);

  @override
  int get hashCode => Object.hash(error, stackTrace);

  @override
  bool operator ==(covariant ResultError<T> other) {
    return (other.error == error) && (other.stackTrace == stackTrace);
  }

}
