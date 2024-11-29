part of 'fetch_view.dart';

typedef FetchViewControllerFetcher<T> = Future<T> Function(bool isReload);

class FetchViewController<T> extends SafeChangeNotifier {
  final FetchViewControllerFetcher<T> onFetch;

  FetchViewController({
    required this.onFetch,
  });

  Result<T>? get data => _data;
  Result<T>? _data;

  Future<void> fetch({bool isReload = false}) async {
    if (!isReload) {
      _data = null;
      notifyListeners();
    }

    try {
      final result = await onFetch(isReload);
      _data = ResultSuccess<T>(result);
    } catch (error, stackTrace) {
      _data = ResultError<T>(error, stackTrace);
    } finally {
      notifyListeners();
    }
  }

  Future<void> reload() => fetch(isReload: true);
}
