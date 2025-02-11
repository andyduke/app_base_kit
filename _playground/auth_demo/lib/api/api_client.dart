import 'package:auth_demo/auth/auth_user.dart';

/// Fake API Client
class ApiClient {
  final users = [
    (username: 'johndoe', password: '123', token: 'abc', user: const AuthUser(id: 1, name: 'John Doe')),
  ];

  void dispose() {}

  Future<({AuthUser user, String token})> login(String username, String password) async {
    final userIndex = users.indexWhere((u) => (u.username == username) && (u.password == password));
    if (userIndex != -1) {
      return (
        user: users[userIndex].user,
        token: users[userIndex].token,
      );
    } else {
      throw Exception('Invalid username or password.');
    }
  }

  Future<AuthUser> getUserInfo(String token) async {
    final userIndex = users.indexWhere((u) => (u.token == token));
    if (userIndex != -1) {
      return users[userIndex].user;
    } else {
      throw Exception('Invalid token.');
    }
  }
}
