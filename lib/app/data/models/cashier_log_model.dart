// cashier_log_model.dart

import 'cashier_sale_model.dart';

class CashierLog {
  String? status;
  List<LogData>? data;
  Pagination? pagination;

  CashierLog({this.status, this.data, this.pagination});

  CashierLog.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = <LogData>[];
      json['data'].forEach((v) {
        data!.add(LogData.fromJson(v));
      });
    }

    pagination =
    json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
}

class LogData {
  int? id;
  String? action;
  String? details;
  String? ipAddress;
  String? browser;
  String? os;
  String? platform;
  String? timestamp;

  LogData({
    this.id,
    this.action,
    this.details,
    this.ipAddress,
    this.browser,
    this.os,
    this.platform,
    this.timestamp,
  });

  LogData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    action = json['action'];
    details = json['details'];
    ipAddress = json['ip_address'];
    browser = json['browser'];
    os = json['os'];
    platform = json['platform'];
    timestamp = json['timestamp'];
  }
}
