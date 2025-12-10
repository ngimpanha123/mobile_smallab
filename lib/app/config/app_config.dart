class AppConfig {
  static const String apiBaseUrl = "http://10.0.2.2:3000/api";
  static const String fileBaseUrl = "http://10.0.2.2:9006/";

  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';

    // Remove file:// or file:/// prefix
    imagePath = imagePath.replaceFirst(RegExp(r'^file:/{0,3}'), '');

    // Remove leading slashes or "static/"
    imagePath = imagePath.replaceFirst(RegExp(r'^(static/|/)+'), '');

    // Ensure base URL ends with /
    final base = fileBaseUrl.endsWith('/') ? fileBaseUrl : '$fileBaseUrl/';

    // Final URL → http://10.0.2.2:9006/static/pos/products/...
    return '${base}static/$imagePath';
  }
}
