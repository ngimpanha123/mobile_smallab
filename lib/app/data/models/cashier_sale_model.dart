// cashier_sale_model.dart

import 'cashier_order_model.dart';

class CashierSale {
  String? status;
  List<SaleData>? data;
  Pagination? pagination;

  CashierSale({this.status, this.data, this.pagination});

  CashierSale.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = <SaleData>[];
      json['data'].forEach((v) {
        data!.add(SaleData.fromJson(v));
      });
    }

    pagination =
    json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
}

class SaleData {
  int? id;
  String? receiptNumber;
  int? totalPrice;
  String? platform;
  String? orderedAt;
  List<SaleDetail>? details;
  Cashier? cashier;

  SaleData({
    this.id,
    this.receiptNumber,
    this.totalPrice,
    this.platform,
    this.orderedAt,
    this.details,
    this.cashier,
  });

  SaleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiptNumber = json['receipt_number'];
    totalPrice = json['total_price'];
    platform = json['platform'];
    orderedAt = json['ordered_at'];

    if (json['details'] != null) {
      details = <SaleDetail>[];
      json['details'].forEach((v) {
        details!.add(SaleDetail.fromJson(v));
      });
    }

    cashier = json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
  }
}

class SaleDetail {
  int? id;
  int? unitPrice;
  int? qty;
  OrderProduct? product;

  SaleDetail({this.id, this.unitPrice, this.qty, this.product});

  SaleDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitPrice = json['unit_price'];
    qty = json['qty'];
    product =
    json['product'] != null ? OrderProduct.fromJson(json['product']) : null;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? totalPage;
  int? total;

  Pagination({this.page, this.limit, this.totalPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    totalPage = json['totalPage'];
    total = json['total'];
  }
}
