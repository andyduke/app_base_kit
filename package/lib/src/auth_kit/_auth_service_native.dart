part of 'auth_kit.dart';

typedef AuthResponse<U> = ({AuthCredentials credentials, U user});

typedef AuthCredentialsFromJsonString = AuthCredentials Function(String value);

abstract class AuthServiceNative<U> extends AuthServiceAbstract<U> {
  /// The key that stores the credentials of an authorized user inside a secure storage.
  String get credentialsSecureKey => 'user_credentials';

  AuthServiceNative({
    required super.state,
  });

  @protected
  Future<AutoLoginResponse<U>> fetchAuthInfo(AuthCredentials credentials);

  @override
  Future<AutoLoginResponse<U>?> autoLogin() async {
    final authCredentials = await _readCredentials();
    if (authCredentials != null) {
      final info = await fetchAuthInfo(authCredentials);
      return info;
    }

    return null;
  }

  @override
  void updateCredentials(AuthCredentials credentials) {
    super.updateCredentials(credentials);

    // Save tokens in local storage on native
    _storeCredentials(credentials);
  }

  @protected
  Future<AuthResponse<U>> auth(LoginCredentials credentials);

  @override
  Future<void> login(LoginCredentials credentials) async {
    final response = await auth(credentials);

    // Save tokens in local storage on native
    await _storeCredentials(response.credentials);

    loggedIn(response.credentials, response.user);
  }

  @override
  void logout() {
    _removeStoredCredentials();

    super.logout();
  }

  // ---

  @protected
  SecureStorage createStorage();

  @protected
  AuthCredentialsFromJsonString get authCredentialsFromJsonString;

  /// Возвращает защищенное хранилище
  Future<SecureStorage> get _secureStorage async {
    _secureStorageInstance ??= createStorage();
    await _secureStorageInstance!.ready;
    return _secureStorageInstance!;
  }

  SecureStorage? _secureStorageInstance;

  /// Читает реквизиты авторизованного пользователя из защищенного хранилища.
  Future<AuthCredentials?> _readCredentials() async {
    final storage = await _secureStorage;

    final credentialsJson = await storage.read(credentialsSecureKey);
    if (credentialsJson != null) {
      final userCredentials = authCredentialsFromJsonString(credentialsJson);
      return userCredentials;
    }

    return null;
  }

  /// Сохраняет реквизиты пользователя в защищенное хранилище.
  Future<void> _storeCredentials(AuthCredentials credentials) async {
    final storage = await _secureStorage;
    await storage.write(credentialsSecureKey, credentials.toJsonString());
  }

  /// Удаляет реквизиты пользователя из защищенного хранилища.
  Future<void> _removeStoredCredentials() async {
    final storage = await _secureStorage;
    await storage.delete(credentialsSecureKey);
  }
}
