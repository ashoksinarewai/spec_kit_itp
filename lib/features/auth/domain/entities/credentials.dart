/// Email and password for login request. Not persisted.
class Credentials {
  const Credentials({required this.email, required this.password});

  final String email;
  final String password;

  bool get isNotEmpty => email.trim().isNotEmpty && password.isNotEmpty;
}
