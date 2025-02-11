class AuthUser {
  final int id;
  final String name;

  const AuthUser({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(covariant AuthUser other) => id == other.id;

  @override
  int get hashCode => id;
}
