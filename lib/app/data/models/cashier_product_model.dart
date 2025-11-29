// cashier_product_model.dart

class CashierProductResponse {
  List<CashierCategory>? data;

  CashierProductResponse({this.data});

  CashierProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CashierCategory>[];
      json['data'].forEach((v) {
        data!.add(CashierCategory.fromJson(v));
      });
    }
  }
}

class CashierCategory {
  int? id;
  String? name;
  List<ProductItem>? products;

  CashierCategory({this.id, this.name, this.products});

  CashierCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    if (json['products'] != null) {
      products = <ProductItem>[];
      json['products'].forEach((v) {
        products!.add(ProductItem.fromJson(v));
      });
    }
  }
}

class ProductItem {
  int? id;
  int? typeId;
  String? name;
  String? image;
  int? unitPrice;
  String? code;
  ProductType? type;

  ProductItem({
    this.id,
    this.typeId,
    this.name,
    this.image,
    this.unitPrice,
    this.code,
    this.type,
  });

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    name = json['name'];
    image = json['image'];
    unitPrice = json['unit_price'];
    code = json['code'];
    type = json['type'] != null ? ProductType.fromJson(json['type']) : null;
  }
}

class ProductType {
  String? name;

  ProductType({this.name});

  ProductType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
