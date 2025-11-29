// cashier_order_model.dart

import 'cashier_product_model.dart';

class CashierOrderResponse {
  String? status;
  OrderData? data;

  CashierOrderResponse({this.status, this.data});

  CashierOrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? OrderData.fromJson(json['data']) : null;
  }
}

class OrderData {
  int? id;
  String? receiptNumber;
  int? totalPrice;
  String? platform;
  String? orderedAt;
  List<OrderDetail>? details;
  Cashier? cashier;

  OrderData({
    this.id,
    this.receiptNumber,
    this.totalPrice,
    this.platform,
    this.orderedAt,
    this.details,
    this.cashier,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiptNumber = json['receipt_number'];
    totalPrice = json['total_price'];
    platform = json['platform'];
    orderedAt = json['ordered_at'];

    if (json['details'] != null) {
      details = <OrderDetail>[];
      json['details'].forEach((v) {
        details!.add(OrderDetail.fromJson(v));
      });
    }

    cashier = json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
  }
}

class OrderDetail {
  int? id;
  int? unitPrice;
  int? qty;
  OrderProduct? product;

  OrderDetail({this.id, this.unitPrice, this.qty, this.product});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitPrice = json['unit_price'];
    qty = json['qty'];
    product =
    json['product'] != null ? OrderProduct.fromJson(json['product']) : null;
  }
}

class OrderProduct {
  int? id;
  String? name;
  String? code;
  String? image;
  ProductType? type;

  OrderProduct({this.id, this.name, this.code, this.image, this.type});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    image = json['image'];
    type = json['type'] != null ? ProductType.fromJson(json['type']) : null;
  }
}

class Cashier {
  int? id;
  String? avatar;
  String? name;

  Cashier({this.id, this.avatar, this.name});

  Cashier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
  }
}
