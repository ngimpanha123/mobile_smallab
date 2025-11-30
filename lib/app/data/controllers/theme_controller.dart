import 'package:get/get.dart';
import '../../themes/dark_theme.dart';
import '../../themes/light_theme.dart';
import '../services/theme_service.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final ThemeService _service = ThemeService();

  var isDarkMode = false.obs;

  ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() async {
    final storedTheme = await _service.getTheme();
    _applyTheme(storedTheme, persist: false);
  }

  void toggleTheme() {
    _applyTheme(!isDarkMode.value);
  }

  void setTheme(bool isDark) {
    if (isDarkMode.value == isDark) return;
    _applyTheme(isDark);
  }

  void _applyTheme(bool isDark, {bool persist = true}) {
    isDarkMode.value = isDark;
    if (persist) {
      _service.saveTheme(isDark);
    }
    Get.changeTheme(isDark ? darkTheme : lightTheme);
  }
}
