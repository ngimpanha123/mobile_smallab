import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  var tabIndex = 0.obs;

  void changeTab(int index) {
    tabIndex(index);
  }
}
