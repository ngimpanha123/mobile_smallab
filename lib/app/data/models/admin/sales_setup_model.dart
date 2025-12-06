class SalesSetupData {
  final List<CashierOption> cashiers;
  final List<SortItem> sortItems;

  SalesSetupData({
    required this.cashiers,
    required this.sortItems,
  });

  factory SalesSetupData.fromJson(Map<String, dynamic> json) {
    return SalesSetupData(
      cashiers: (json['cashiers'] as List<dynamic>?)
          ?.map((cashier) => CashierOption.fromJson(cashier))
          .toList() ??
          [],
      sortItems: (json['shortItems'] as List<dynamic>?)
          ?.map((item) => SortItem.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cashiers': cashiers.map((c) => c.toJson()).toList(),
      'shortItems': sortItems.map((s) => s.toJson()).toList(),
    };
  }
}

class CashierOption {
  final int id;
  final String name;

  CashierOption({
    required this.id,
    required this.name,
  });

  factory CashierOption.fromJson(Map<String, dynamic> json) {
    return CashierOption(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SortItem {
  final String value;
  final String name;

  SortItem({
    required this.value,
    required this.name,
  });

  factory SortItem.fromJson(Map<String, dynamic> json) {
    return SortItem(
      value: json['value'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'name': name,
    };
  }
}
