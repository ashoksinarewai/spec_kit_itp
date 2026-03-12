/// Authenticated employee (from login or social).
/// Domain entity; no Flutter/platform imports.
class User {
  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.linkedProvider,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? linkedProvider;
}
