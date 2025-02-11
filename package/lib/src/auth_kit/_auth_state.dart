part of 'auth_kit.dart';

abstract class AuthState<U> extends SafeChangeNotifier {
  AuthCredentials? get credentials => _credentials;
  AuthCredentials? _credentials;

  U? get user => _user;
  U? _user;

  AuthError? get error => _error;
  AuthError? _error;
  set error(AuthError? error) {
    if (_error != error) {
      _error = error;
      reset();
      notifyListeners();
    }
  }

  @protected
  void reset() {
    _credentials = null;
    _user = null;
  }

  bool get hasError => (_error != null);

  bool get isReady => _isReady;
  bool _isReady = false;

  void _setReady() {
    if (!_isReady) {
      _isReady = true;
      notifyListeners();
    }
  }

  bool get isLogged => (_user != null);

  void _loggedIn(AuthCredentials credentials, U user) {
    _credentials = credentials;
    _user = user;
    _error = null;

    notifyListeners();
  }

  void _updateCredentials(AuthCredentials credentials) {
    if (isLogged) {
      if (_credentials != credentials) {
        _credentials = credentials;
        notifyListeners();
      }
    }
  }

  void _loggedOut() {
    reset();
    _error = null;

    notifyListeners();
  }
}

class AuthError with Diagnosticable {
  final int code;
  final String message;
  final StackTrace? stackTrace;

  const AuthError({
    required this.code,
    required this.message,
    this.stackTrace,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('code', code));
    properties.add(StringProperty('message', message));
    // properties.add(DiagnosticsProperty<StackTrace?>('stackTrace', stackTrace));
  }
}
