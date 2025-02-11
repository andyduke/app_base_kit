part of 'auth_kit.dart';

abstract class LoginCredentials {
  const LoginCredentials();
}

abstract class AuthCredentials {
  const AuthCredentials();

  String toJsonString();
}
