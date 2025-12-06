class SaleModel {
  final int id;
  final String receiptNumber;
  final double totalPrice;
  final String platform;
  final DateTime orderedAt;
  final List<SaleDetailModel> details;
  final CashierModel cashier;

  SaleModel({
    required this.id,
    required this.receiptNumber,
    required this.totalPrice,
    required this.platform,
    required this.orderedAt,
    required this.details,
    required this.cashier,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? 0,
      receiptNumber: json['receipt_number'] ?? '',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      platform: json['platform'] ?? '',
      orderedAt: DateTime.parse(json['ordered_at'] ?? DateTime.now().toIso8601String()),
      details: (json['details'] as List<dynamic>?)
          ?.map((detail) => SaleDetailModel.fromJson(detail))
          .toList() ??
          [],
      cashier: CashierModel.fromJson(json['cashier'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receipt_number': receiptNumber,
      'total_price': totalPrice,
      'platform': platform,
      'ordered_at': orderedAt.toIso8601String(),
      'details': details.map((detail) => detail.toJson()).toList(),
      'cashier': cashier.toJson(),
    };
  }
}

class SaleDetailModel {
  final int id;
  final double unitPrice;
  final int qty;
  final SaleProductModel product;

  SaleDetailModel({
    required this.id,
    required this.unitPrice,
    required this.qty,
    required this.product,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      id: json['id'] ?? 0,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      qty: json['qty'] ?? 0,
      product: SaleProductModel.fromJson(json['product'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_price': unitPrice,
      'qty': qty,
      'product': product.toJson(),
    };
  }

  double get subtotal => unitPrice * qty;
}

class SaleProductModel {
  final int id;
  final String name;
  final String code;
  final String image;
  final ProductTypeSimpleModel type;

  SaleProductModel({
    required this.id,
    required this.name,
    required this.code,
    required this.image,
    required this.type,
  });

  factory SaleProductModel.fromJson(Map<String, dynamic> json) {
    return SaleProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      image: json['image'] ?? '',
      type: ProductTypeSimpleModel.fromJson(json['type'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'image': image,
      'type': type.toJson(),
    };
  }
}

class ProductTypeSimpleModel {
  final String name;

  ProductTypeSimpleModel({required this.name});

  factory ProductTypeSimpleModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeSimpleModel(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class CashierModel {
  final int id;
  final String avatar;
  final String name;

  CashierModel({
    required this.id,
    required this.avatar,
    required this.name,
  });

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(
      id: json['id'] ?? 0,
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
    };
  }
}

class SaleListResponse {
  final String status;
  final List<SaleModel> data;
  final PaginationModel pagination;

  SaleListResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory SaleListResponse.fromJson(Map<String, dynamic> json) {
    return SaleListResponse(
      status: json['status'] ?? 'success',
      data: (json['data'] as List<dynamic>?)
          ?.map((sale) => SaleModel.fromJson(sale))
          .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class PaginationModel {
  final int page;
  final int limit;
  final int totalPage;
  final int total;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.totalPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPage: json['totalPage'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'totalPage': totalPage,
      'total': total,
    };
  }
}

class SaleDetailResponse {
  final String status;
  final SaleModel data;

  SaleDetailResponse({
    required this.status,
    required this.data,
  });

  factory SaleDetailResponse.fromJson(Map<String, dynamic> json) {
    return SaleDetailResponse(
      status: json['status'] ?? 'success',
      data: SaleModel.fromJson(json['data'] ?? {}),
    );
  }
}
