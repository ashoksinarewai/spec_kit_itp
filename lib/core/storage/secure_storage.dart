/// Abstraction for secure key-value storage (tokens, sensitive preferences).
/// Implementations must use platform secure storage (e.g. Keychain/Keystore).
abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
