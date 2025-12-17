abstract class Routes {
  static const LOGIN = '/login';
  static const HOME_ADMIN = '/home-admin';
  static const HOME = '/';

  // ======================= User Routes =======================

  static const ORDERING = '/user/ordering';
  static const CART = '/user/cart';
  static const SUCCESS = '/user/success';
  static const SALES = '/user/sales';
  static const SALE_DETAIL = '/user/sale-detail';
  static const PROFILE = '/user/profile';
  static const EDIT_PROFILE = '/user/edit-profile';
  static const CHANGE_PASSWORD = '/user/change-password';
  static const LOGS = '/user/logs';

  // ==================== Admin Routes ========================
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const ADMIN_PRODUCTS = '/admin/products';
  static const ADMIN_SALES = '/admin/sales';
  static const ADMIN_USERS = '/admin/users';
  static const ADMIN_USER_DETAIL = '/admin/users/detail';
  static const ADMIN_SETTINGS = '/admin/settings';
  static const USER_KHQR = '/user/khqr';

  // ================ Admin Product ====================================

  static const ADMIN_PRODUCT_DETAIL = '/admin/products/detail';
  static const ADMIN_PRODUCT_CREATE = '/admin/products/create';
  static const ADMIN_PRODUCT_EDIT = '/admin/products/edit';

  static const ADMIN_PRODUCT_TYPES = '/admin/product-types';
  static const ADMIN_PRODUCT_TYPE_CREATE = '/admin/product-types/create';
  static const ADMIN_PRODUCT_TYPE_EDIT = '/admin/product-types/edit';
}
