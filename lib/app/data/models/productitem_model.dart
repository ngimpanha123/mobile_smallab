class ProductItem {
  final int? id;
  final String? name;
  final String? image;
  final int? unitPrice;
  final String? code;

  ProductItem({
    this.id,
    this.name,
    this.image,
    this.unitPrice,
    this.code,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    String? rawImage = json['image'];

    // CLEAN VALID IMAGE PATH
    if (rawImage != null) {
      if (rawImage.startsWith("file:///")) {
        rawImage = rawImage.replaceFirst("file:///", "");
      }
      if (rawImage.startsWith("/")) {
        rawImage = rawImage.substring(1);
      }
    }

    return ProductItem(
      id: json['id'],
      name: json['name'],
      unitPrice: json['unit_price'],
      code: json['code'],
      image: rawImage,  // 💥 always clean now
    );
  }
}
