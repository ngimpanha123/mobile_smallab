class AdminProductTypeResponse {
  List<ProductTypeData>? data;

  AdminProductTypeResponse.fromJson(Map<String, dynamic> json) {
    data = (json['data'] as List?)
        ?.map((e) => ProductTypeData.fromJson(e))
        .toList();
  }
}

class ProductTypeData {
  int? id;
  String? name;
  String? image;
  String? nOfProducts;

  ProductTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    nOfProducts = json['n_of_products']?.toString();
  }
}
