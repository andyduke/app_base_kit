import 'package:app_base_kit/app_base_kit.dart';
import 'package:auth_demo/api/api_client.dart';
import 'package:auth_demo/auth/app_secure_storage.dart';
import 'package:auth_demo/auth/auth_credentials.dart';
import 'package:auth_demo/auth/auth_user.dart';

class AppAuthService extends AuthServiceNative<AuthUser> {
  final ApiClient client;

  AppAuthService({
    required super.state,
    required this.client,
  });

  @override
  Future<AuthResponse<AuthUser>> auth(covariant AppLoginCredentials credentials) async {
    final (:user, :token) = await client.login(credentials.username, credentials.password);
    final authCreds = AppAuthCredentials(token);
    return (credentials: authCreds, user: user);
  }

  @override
  Future<AutoLoginResponse<AuthUser>> fetchAuthInfo(covariant AppAuthCredentials credentials) async {
    final user = await client.getUserInfo(credentials.token);
    final authCreds = AppAuthCredentials(credentials.token);
    return (credentials: authCreds, user: user);
  }

  @override
  AuthCredentialsFromJsonString get authCredentialsFromJsonString => AppAuthCredentials.fromJsonString;

  @override
  SecureStorage createStorage() => AppSecureStorage();
}
