// cashier_sale_view_model.dart

import 'cashier_sale_model.dart';

class CashierSaleView {
  String? status;
  SaleData? data;

  CashierSaleView({this.status, this.data});

  CashierSaleView.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SaleData.fromJson(json['data']) : null;
  }
}
