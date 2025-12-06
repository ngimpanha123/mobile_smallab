import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const String _tokenKey = "token";
  static const String _userKey = "user";

  late GetStorage _box;

  // Initialize storage
  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // ========================================================
  // TOKEN MANAGEMENT
  // ========================================================

  Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  String? readToken() {
    return _box.read(_tokenKey);
  }

  Future<void> clearToken() async {
    await _box.remove(_tokenKey);
  }

  bool get isLoggedIn {
    final token = readToken();
    return token != null && token.isNotEmpty;
  }

  // ========================================================
  // USER DATA MANAGEMENT
  // ========================================================

  Future<void> saveUser(Map<String, dynamic> data) async {
    await _box.write(_userKey, data);
  }

  Map<String, dynamic>? readUser() {
    final data = _box.read(_userKey);
    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    return null;
  }

  Future<void> clearUser() async {
    await _box.remove(_userKey);
  }

  // ========================================================
// ROLES
// ========================================================

  Future<void> saveRoles(List<dynamic> roles) async {
    // Convert to List<String>
    final list = roles.map((e) => e.toString()).toList();
    await _box.write("roles", list);
  }

  List<String> get userRoleNames {
    final list = _box.read("roles");
    if (list is List) {
      return list.map((e) => e.toString()).toList();
    }
    return [];
  }

  bool hasRole(String role) {
    return userRoleNames.contains(role.toLowerCase()) ||
        userRoleNames.contains(role.toUpperCase());
  }


  /// Clears both token and user data.
  /// Used when:
  /// - Token expired (401 from API)
  /// - Manually logout
  Future<void> clearSession() async {
    await clearToken();
    await clearUser();
  }

  /// Alias for clearSession()
  Future<void> logout() async {
    await clearSession();
  }
}
