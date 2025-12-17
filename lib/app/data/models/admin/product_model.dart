class AdminProductResponse {
  String? status;
  List<ProductData>? data;
  Pagination? pagination;

  AdminProductResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] as List?)
        ?.map((e) => ProductData.fromJson(e))
        .toList();
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class ProductData {
  int? id;
  String? code;
  String? name;
  String? image;
  int? unitPrice;
  ProductType? type;

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    image = json['image'];
    unitPrice = json['unit_price'];
    type = json['type'] != null
        ? ProductType.fromJson(json['type'])
        : null;
  }
}

class ProductType {
  int? id;
  String? name;

  ProductType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Pagination {
  int? page;
  int? limit;
  int? totalPage;
  int? total;

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    totalPage = json['totalPage'];
    total = json['total'];
  }
}
