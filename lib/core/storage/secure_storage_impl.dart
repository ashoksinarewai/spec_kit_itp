import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

/// Flutter secure storage implementation using platform Keychain/Keystore.
class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl({
    AndroidOptions? android,
    IOSOptions? ios,
  })  : _storage = FlutterSecureStorage(
          aOptions: android ??
              const AndroidOptions(
                encryptedSharedPreferences: true,
              ),
          iOptions: ios ?? const IOSOptions(),
        );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
