import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/admin/admin_user_list_model.dart';
import '../../../../data/models/admin/admin_user_setup_model.dart';
import '../../../../data/models/admin/admin_user_view_model.dart';
import '../../../../data/providers/admin_provider.dart';

class AdminUsersController extends GetxController {
  final AdminProvider provider = Get.find<AdminProvider>();

  // list
  final users = <AdminUserItem>[].obs;
  final isLoading = false.obs;

  // pagination (optional)
  final page = 1.obs;
  final limit = 20.obs;
  final totalPage = 1.obs;

  // setup roles
  final roles = <AdminRole>[].obs;

  // detail
  final isDetailLoading = false.obs;
  final selectedUser = Rxn<AdminUserItem>();

  // form controllers
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final selectedRoleId = RxnInt();
  final pickedImage = Rxn<File>(); // local file (optional)

  @override
  void onInit() {
    super.onInit();
    fetchSetup();
    fetchUsers();
  }

  Future<void> fetchSetup() async {
    try {
      final res = await provider.getUserSetupData(); // /api/admin/users/setup
      final body = res.data is Map ? res.data as Map<String, dynamic> : <String, dynamic>{};
      final parsed = AdminUserSetupResponse.fromJson(body);
      roles.assignAll(parsed.roles ?? []);
    } catch (e) {
      debugPrint("❌ fetchSetup: $e");
    }
  }

  Future<void> fetchUsers({int? toPage}) async {
    try {
      isLoading(true);
      if (toPage != null) page.value = toPage;

      final res = await provider.getUsers(page: page.value, limit: limit.value); // /api/admin/users
      final body = res.data is Map ? res.data as Map<String, dynamic> : <String, dynamic>{};
      final parsed = AdminUserListResponse.fromJson(body);

      users.assignAll(parsed.data ?? []);
      totalPage.value = parsed.pagination?.totalPage ?? 1;
    } catch (e) {
      debugPrint("❌ fetchUsers: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUserDetail(int userId) async {
    try {
      isDetailLoading(true);
      final res = await provider.getUserById(userId: userId); // /api/admin/users/:id
      final body = res.data is Map ? res.data as Map<String, dynamic> : <String, dynamic>{};
      final parsed = AdminUserViewResponse.fromJson(body);
      selectedUser.value = parsed.data;
    } catch (e) {
      debugPrint("❌ fetchUserDetail: $e");
    } finally {
      isDetailLoading(false);
    }
  }

  // ---------------------------
  // FORM helpers
  // ---------------------------
  void resetForm() {
    nameC.clear();
    phoneC.clear();
    emailC.clear();
    passwordC.clear();
    selectedRoleId.value = null;
    pickedImage.value = null;
  }

  void fillForm(AdminUserItem u) {
    nameC.text = u.name ?? '';
    phoneC.text = u.phone ?? '';
    emailC.text = u.email ?? '';
    passwordC.clear();
    selectedRoleId.value = u.role?.isNotEmpty == true ? (u.role!.first.roleId ?? u.role!.first.role?.id) : null;
    pickedImage.value = null;
  }

  Future<void> pickAvatar() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (x == null) return;
      pickedImage.value = File(x.path);
    } catch (e) {
      debugPrint("❌ pickAvatar: $e");
    }
  }

  String? _fileToBase64DataUri(File f) {
    try {
      final bytes = f.readAsBytesSync();
      final b64 = base64Encode(bytes);
      // default png (ok for API in your doc)
      return "data:image/png;base64,$b64";
    } catch (_) {
      return null;
    }
  }

  // ---------------------------
  // CREATE / UPDATE / STATUS / DELETE
  // ---------------------------
  Future<void> createUser() async {
    if (nameC.text.trim().isEmpty ||
        phoneC.text.trim().isEmpty ||
        emailC.text.trim().isEmpty ||
        (selectedRoleId.value == null) ||
        passwordC.text.trim().isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    try {
      isLoading(true);

      final data = <String, dynamic>{
        "name": nameC.text.trim(),
        "role_ids": [selectedRoleId.value],
        "phone": phoneC.text.trim(),
        "email": emailC.text.trim(),
        "password": passwordC.text.trim(),
      };

      final img = pickedImage.value;
      if (img != null) {
        final uri = _fileToBase64DataUri(img);
        if (uri != null) data["avatar"] = uri; // doc: data:image/png;base64
      }

      await provider.createUser(data: data); // POST /api/admin/users
      Get.back(); // close sheet
      await fetchUsers();
      Get.snackbar("Success", "User created");
    } catch (e) {
      debugPrint("❌ createUser: $e");
      Get.snackbar("Error", "Create failed");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUser(int userId) async {
    if (nameC.text.trim().isEmpty ||
        phoneC.text.trim().isEmpty ||
        emailC.text.trim().isEmpty ||
        (selectedRoleId.value == null)) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    try {
      isLoading(true);

      final data = <String, dynamic>{
        "name": nameC.text.trim(),
        "role_ids": [selectedRoleId.value],
        "phone": phoneC.text.trim(),
        "email": emailC.text.trim(),
      };

      final img = pickedImage.value;
      if (img != null) {
        final uri = _fileToBase64DataUri(img);
        if (uri != null) data["avatar"] = uri;
      }

      await provider.updateUser(userId: userId, data: data); // PUT /api/admin/users/:id
      Get.back(); // close sheet
      await fetchUserDetail(userId);
      await fetchUsers();
      Get.snackbar("Success", "User updated");
    } catch (e) {
      debugPrint("❌ updateUser: $e");
      Get.snackbar("Error", "Update failed");
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleStatus(AdminUserItem u) async {
    try {
      final newActive = !u.active;
      await provider.updateUserStatus(userId: u.id!, isActive: newActive); // PUT /status/:id
      await fetchUsers();
      if (selectedUser.value?.id == u.id) await fetchUserDetail(u.id!);
    } catch (e) {
      debugPrint("❌ toggleStatus: $e");
      Get.snackbar("Error", "Update status failed");
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await provider.deleteUser(userId: userId); // DELETE /api/admin/users/:id
      Get.back(); // close dialog/screen if needed
      await fetchUsers();
      Get.snackbar("Success", "User deleted");
    } catch (e) {
      debugPrint("❌ deleteUser: $e");
      Get.snackbar("Error", "Delete failed");
    }
  }
}
