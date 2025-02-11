import 'dart:convert';
import 'package:app_base_kit/app_base_kit.dart';

class AppLoginCredentials extends LoginCredentials {
  final String username;
  final String password;

  const AppLoginCredentials({
    required this.username,
    required this.password,
  });
}

class AppAuthCredentials extends AuthCredentials {
  final String token;

  const AppAuthCredentials(this.token);

  factory AppAuthCredentials.fromJsonString(String value) {
    final json = jsonDecode(value);
    return AppAuthCredentials.fromJson(json);
  }

  factory AppAuthCredentials.fromJson(dynamic value) {
    final result = switch (value) {
      {
        'data': {
          'accessToken': String accessToken,
        }
      } =>
        AppAuthCredentials(
          accessToken,
        ),
      _ => throw FormatException('[AppAuthCredentials] Invalid JSON: $value'),
    };
    return result;
  }

  Map<String, dynamic> toJson() => {
        'data': {
          'accessToken': token,
        },
      };

  @override
  String toJsonString() => jsonEncode(toJson());
}
