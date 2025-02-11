part of 'auth_kit.dart';

typedef AutoLoginResponse<U> = ({AuthCredentials credentials, U user});

abstract class AuthServiceAbstract<U> {
  final AuthState state;

  AuthServiceAbstract({
    required this.state,
  }) {
    scheduleMicrotask(() {
      tryAutoLogin();
    });
  }

  @mustCallSuper
  void dispose() {}

  @protected
  Future<void> tryAutoLogin() async {
    try {
      final response = await autoLogin();
      if (response != null) {
        state._loggedIn(response.credentials, response.user);
        afterLoggedIn();
      }
    } catch (error, stack) {
      // TODO: custom error handler?
      state.error = AuthError(code: 0, message: '$error', stackTrace: stack);

      /*
      if (error is ApiError) {
        if (error.code != ApiError.unauthorized) {
          state.error = AuthError(code: error.code, message: error.message, stackTrace: error.stackTrace);
        }
      } else {
        state.error = AuthError(code: 0, message: '$error', stackTrace: stack);
      }
      */
      /*
      } else if (error is! TimeoutException) {
        state.error = AuthError(code: 0, message: '$error', stackTrace: stack);
      } else {
        // Error.throwWithStackTrace(error, stack);
        state.error = AuthError(code: 0, message: '$error', stackTrace: stack);
        rethrow;
      }
      */
    } finally {
      state._setReady();
    }
  }

  @protected
  void afterLoggedIn() {}

  @protected
  Future<AutoLoginResponse<U>?> autoLogin();

  Future<void> login(LoginCredentials credentials);

  @mustCallSuper
  void updateCredentials(AuthCredentials credentials) {
    state._updateCredentials(credentials);
  }

  @protected
  void loggedIn(AuthCredentials credentials, U user) {
    state._loggedIn(credentials, user);
  }

  void logout() {
    state._loggedOut();
  }
}
