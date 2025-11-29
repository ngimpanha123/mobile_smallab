import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const String _tokenKey = "token";
  static const String _userKey = "user";

  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // ---------------- TOKEN ----------------

  Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  String? readToken() {
    return _box.read(_tokenKey);
  }

  Future<void> clearToken() async {
    await _box.remove(_tokenKey);
  }

  bool get isLoggedIn => readToken() != null;

  // ---------------- USER ----------------

  Future<void> saveUser(Map<String, dynamic> data) async {
    await _box.write(_userKey, data);
  }

  Map<String, dynamic>? readUser() {
    return _box.read(_userKey);
  }

  Future<void> clearUser() async {
    await _box.remove(_userKey);
  }

  // ---------------- LOGOUT ----------------

  Future<void> logout() async {
    await clearToken();
    await clearUser();
  }
}
