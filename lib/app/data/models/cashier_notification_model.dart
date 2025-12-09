class CashierNotification {
  int? id;
  String? receiptNumber;
  int? totalPrice;
  String? orderedAt;
  Cashier? cashier;
  bool? read;

  CashierNotification({
    this.id,
    this.receiptNumber,
    this.totalPrice,
    this.orderedAt,
    this.cashier,
    this.read,
  });

  CashierNotification.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    receiptNumber = json["receipt_number"];
    totalPrice = json["total_price"];
    orderedAt = json["ordered_at"];
    read = json["read"];
    cashier =
    json["cashier"] != null ? Cashier.fromJson(json["cashier"]) : null;
  }
}

class Cashier {
  int? id;
  String? name;
  String? avatar;

  Cashier({this.id, this.name, this.avatar});

  Cashier.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
  }
}
