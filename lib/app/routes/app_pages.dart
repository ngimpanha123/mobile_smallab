import 'package:get/get.dart';

import '../modules/admin/dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin/dashboard/views/admin_dashboard_view.dart';
import '../modules/admin/products/bindings/admin_products_binding.dart';
import '../modules/admin/products/views/admin_products_view.dart';
import '../modules/admin/sales/bindings/admin_sales_binding.dart';
import '../modules/admin/sales/views/admin_sales_view.dart';
import '../modules/admin/settings/bindings/admin_settings_binding.dart';
import '../modules/admin/settings/views/admin_settings_view.dart';
import '../modules/admin/users/bindings/admin_users_binding.dart';
import '../modules/admin/users/views/admin_users_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/user/cart/bindings/cart_binding.dart';
import '../modules/user/cart/views/cart_view.dart';
import '../modules/user/ordering/bindings/ordering_binding.dart';
import '../modules/user/ordering/views/ordering_view.dart';
import '../modules/user/profile/bindings/profile_binding.dart';
import '../modules/user/profile/views/change_password_view.dart';
import '../modules/user/profile/views/edit_profile_view.dart';
import '../modules/user/profile/views/logs_view.dart';
import '../modules/user/profile/views/profile_view.dart';
import '../modules/user/sale_detail/bindings/sale_detail_binding.dart';
import '../modules/user/sale_detail/views/sale_detail_view.dart';
import '../modules/user/sales/bindings/sales_binding.dart';
import '../modules/user/sales/views/sales_view.dart';
import '../modules/user/success/bindings/success_binding.dart';
import '../modules/user/success/views/success_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ORDERING,
      page: () => const OrderingView(),
      binding: OrderingBinding(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: Routes.SUCCESS,
      page: () => const SuccessView(),
      binding: SuccessBinding(),
    ),
    GetPage(
      name: Routes.SALES,
      page: () => const SalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: Routes.SALE_DETAIL,
      page: () => const SaleDetailView(),
      binding: SaleDetailBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
    ),
    GetPage(
      name: Routes.LOGS,
      page: () => const LogsView(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    // GetPage(
    //   name: Routes.ADMIN_DASHBOARD,
    //   page: () => const DashboardView(),
    //   binding: DashboardBinding(),
    // ),
    GetPage(
      name: Routes.ADMIN_PRODUCTS,
      page: () => const AdminProductsView(),
      binding: AdminProductsBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_SALES,
      page: () => const AdminSalesView(),
      binding: AdminSalesBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_USERS,
      page: () => const AdminUsersView(),
      binding: AdminUsersBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_SETTINGS,
      page: () => const AdminSettingsView(),
      binding: AdminSettingsBinding(),
    ),
    GetPage(
      name: Routes.HOME_ADMIN,
      page: () => const AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
  ];
}
