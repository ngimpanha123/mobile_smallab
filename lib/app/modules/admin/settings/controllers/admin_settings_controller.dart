import 'package:get/get.dart';

import '../../../../data/models/admin/profile_model.dart';
import '../../../../data/providers/admin_provider.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../routes/app_routes.dart';

class AdminSettingsController extends GetxController {
  final _api = Get.find<AdminProvider>();
  final _storage = Get.find<StorageService>();

  // Observable variables
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Profile data
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  // Logs
  RxList<ProfileLog> logs = <ProfileLog>[].obs;
  Rx<ProfileLogsPagination?> logsPagination = Rx<ProfileLogsPagination?>(null);
  var isLoadingLogs = false.obs;
  var currentLogsPage = 1.obs;
  final int logsLimit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchProfileLogs();
  }

  /// ===========================================================
  /// FETCH PROFILE
  /// ===========================================================
  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final res = await _api.getProfile();

      if (res.statusCode == 200) {
        final profile = UserProfile.fromJson(res.data["data"]);
        userProfile.value = profile;

        // Save roles into storage for navigation logic
        List<String> roles =
            profile.roles?.map((e) => e.slug.toString()).toList() ?? [];
        await _storage.saveRoles(roles);
      }
    } catch (e) {
      print("❌ Error fetching profile: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Fetch profile logs
  Future<void> fetchProfileLogs({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isLoadingLogs.value = true;
      }

      final res = await _api.getProfileLogs(
        page: currentLogsPage.value,
        limit: logsLimit,
      );

      if (res.statusCode == 200 && res.data != null) {
        final response = ProfileLogsResponse.fromJson(res.data);
        logs.value = response.data;
        logsPagination.value = response.pagination;
      }
    } catch (e) {
      print('❌ Error fetching profile logs: $e');
    } finally {
      if (showLoading) {
        isLoadingLogs.value = false;
      }
    }
  }

  /// Update profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String email,
    String? avatarBase64,
  }) async {
    try {
      isLoading.value = true;

      final data = {
        'name': name,
        'phone': phone,
        'email': email,
      };

      if (avatarBase64 != null && avatarBase64.isNotEmpty) {
        data['avatar'] = avatarBase64;
      }

      final res = await _api.updateProfile(data: data);

      if (res.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update password
  Future<bool> updatePassword({
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;

      final res = await _api.updateProfilePassword(
        password: password,
        confirmPassword: confirmPassword,
      );

      if (res.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Password updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to update password',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Switch role
  Future<bool> switchRole(int roleId) async {
    try {
      isLoading(true);

      // Call GET /api/account/auth/switch?role_id=1
      final res = await _api.switchRole(roleId: roleId);

      final newToken = res.data["token"];

      // Backend will not return token if switching to same role
      if (newToken == null) {
        Get.snackbar(
          "Failed",
          res.data["message"] ?? "Unable to switch role",
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Save token
      await _storage.saveToken(newToken);

      // Fetch new profile
      await fetchProfile();

      // Get NEW role list
      final List<String> newRoles =
          userProfile.value?.roles.map((e) => e.slug).toList() ?? [];

      await _storage.saveRoles(newRoles);

      // 🔥 NAVIGATION BASED ON NEW ROLE
      if (newRoles.contains("cashier")) {
        // switched to CASHIER → go to user home
        Get.offAllNamed(Routes.HOME);
      } else if (newRoles.contains("admin")) {
        // switched to ADMIN → go to admin dashboard
        Get.offAllNamed(Routes.HOME_ADMIN);
      }

      Get.snackbar("Success", "Role switched successfully");
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }


  /// Logout
  Future<void> logout() async {
    try {
      _storage.clearToken();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Change logs page
  void changeLogsPage(int page) {
    if (page >= 1 && page <= (logsPagination.value?.totalPage ?? 1)) {
      currentLogsPage.value = page;
      fetchProfileLogs(showLoading: false);
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    await fetchProfileLogs(showLoading: false);
  }
}
