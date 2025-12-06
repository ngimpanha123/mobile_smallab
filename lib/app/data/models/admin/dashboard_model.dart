class DashboardResponse {
  final Dashboard dashboard;
  final String message;

  DashboardResponse({
    required this.dashboard,
    required this.message,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      dashboard: Dashboard.fromJson(json['dashboard']),
      message: json['message'] ?? '',
    );
  }
}

class Dashboard {
  final Statistic statistic;
  final SalesData salesData;
  final ProductTypeData productTypeData;
  final CashierData cashierData;

  Dashboard({
    required this.statistic,
    required this.salesData,
    required this.productTypeData,
    required this.cashierData,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      statistic: Statistic.fromJson(json['statistic']),
      salesData: SalesData.fromJson(json['salesData']),
      productTypeData: ProductTypeData.fromJson(json['productTypeData']),
      cashierData: CashierData.fromJson(json['cashierData']),
    );
  }
}

class Statistic {
  final int totalProduct;
  final int totalProductType;
  final int totalUser;
  final int totalOrder;
  final double total;
  final double totalPercentageIncrease;
  final String saleIncreasePreviousDay;

  Statistic({
    required this.totalProduct,
    required this.totalProductType,
    required this.totalUser,
    required this.totalOrder,
    required this.total,
    required this.totalPercentageIncrease,
    required this.saleIncreasePreviousDay,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      totalProduct: json['totalProduct'] ?? 0,
      totalProductType: json['totalProductType'] ?? 0,
      totalUser: json['totalUser'] ?? 0,
      totalOrder: json['totalOrder'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      totalPercentageIncrease: (json['totalPercentageIncrease'] ?? 0).toDouble(),
      saleIncreasePreviousDay: json['saleIncreasePreviousDay'] ?? '0',
    );
  }
}

class SalesData {
  final List<String> labels;
  final List<double> data;

  SalesData({
    required this.labels,
    required this.data,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      labels: List<String>.from(json['labels'] ?? []),
      data: List<double>.from((json['data'] as List).map((e) => (e ?? 0).toDouble())),
    );
  }
}

class ProductTypeData {
  final List<String> labels;
  final List<int> data;

  ProductTypeData({
    required this.labels,
    required this.data,
  });

  factory ProductTypeData.fromJson(Map<String, dynamic> json) {
    return ProductTypeData(
      labels: List<String>.from(json['labels'] ?? []),
      data: (json['data'] as List).map((e) => int.parse(e.toString())).toList(),
    );
  }
}

class CashierData {
  final List<CashierInfo> data;

  CashierData({required this.data});

  factory CashierData.fromJson(Map<String, dynamic> json) {
    return CashierData(
      data: (json['data'] as List)
          .map((e) => CashierInfo.fromJson(e))
          .toList(),
    );
  }
}

class CashierInfo {
  final int id;
  final String name;
  final String avatar;
  final double totalAmount;
  final String percentageChange;
  final List<RoleInfo> role;

  CashierInfo({
    required this.id,
    required this.name,
    required this.avatar,
    required this.totalAmount,
    required this.percentageChange,
    required this.role,
  });

  factory CashierInfo.fromJson(Map<String, dynamic> json) {
    return CashierInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      percentageChange: json['percentageChange'] ?? '0.00',
      role: (json['role'] as List).map((e) => RoleInfo.fromJson(e)).toList(),
    );
  }
}

class RoleInfo {
  final int id;
  final int roleId;
  final Role role;

  RoleInfo({
    required this.id,
    required this.roleId,
    required this.role,
  });

  factory RoleInfo.fromJson(Map<String, dynamic> json) {
    return RoleInfo(
      id: json['id'] ?? 0,
      roleId: json['role_id'] ?? 0,
      role: Role.fromJson(json['role']),
    );
  }
}

class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
