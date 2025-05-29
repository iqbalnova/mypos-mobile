import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage;

  SecureStorageHelper() : _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> saveUserCredential({
    required String email,
    required String name,
  }) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'name', value: name);
  }

  Future<UserCredential> getUserCredential() async {
    final email = await _storage.read(key: 'email');
    final name = await _storage.read(key: 'name');

    return UserCredential(email: email, name: name);
  }
}

class UserCredential {
  final String? email;
  final String? name;

  UserCredential({this.email, this.name});
}
