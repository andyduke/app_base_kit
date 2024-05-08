import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class OfflineTracker with ChangeNotifier implements ValueListenable<bool> {
  final Completer _ready = Completer();
  Future get readyFuture => _ready.future;

  // ConnectivityResult? status;
  List<ConnectivityResult>? status;

  // StreamSubscription<ConnectivityResult>? _subscription;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOffline = false;

  bool get isOffline => _isOffline;
  bool get isOnline => !_isOffline;

  static OfflineTracker? _instance;
  static OfflineTracker get state => _instance ??= OfflineTracker();

  OfflineTracker() {
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    /*
    final ConnectivityResult connectivity = await (Connectivity().checkConnectivity());
    status = connectivity;
    _isOffline = (connectivity == ConnectivityResult.none);
    */

    final List<ConnectivityResult> connectivity = await (Connectivity().checkConnectivity());
    status = connectivity;
    _isOffline = connectivity.every((s) => s == ConnectivityResult.none);

    _ready.complete();
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (hasListeners && _subscription == null) {
      _subscription = Connectivity().onConnectivityChanged.listen(_connectivityChanged);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners && _subscription != null) {
      _subscription!.cancel();
    }
  }

  /*
  void _connectivityChanged(ConnectivityResult result) {
    if (((status == ConnectivityResult.none) && (result != ConnectivityResult.none)) ||
        ((status != ConnectivityResult.none) && (result == ConnectivityResult.none))) {
      _isOffline = (result == ConnectivityResult.none);
      notifyListeners();
    }

    status = result;
  }
  */

  void _connectivityChanged(List<ConnectivityResult> result) {
    final newValue = result.every((s) => s == ConnectivityResult.none);
    if (newValue != _isOffline) {
      _isOffline = newValue;
      notifyListeners();
    }

    status = result;
  }

  @override
  bool get value => isOffline;

  @override
  String toString() => '${describeIdentity(this)}($isOffline)';
}
