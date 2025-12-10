class KhqrGenerateResult {
  final String qr;
  final String md5;
  final int amount;

  KhqrGenerateResult({
    required this.qr,
    required this.md5,
    required this.amount,
  });

  factory KhqrGenerateResult.fromJson(Map<String, dynamic> json) {
    return KhqrGenerateResult(
      qr: json["qr"]?.toString() ?? "",
      md5: json["md5"]?.toString() ?? "",
      amount: json["total"] ?? 0,
    );
  }
}
