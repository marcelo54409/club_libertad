import 'dart:convert';

class XMLHTTPRequestConfig {
  String? authorization;
  String? contentType;
  String? accept;
  bool? omitGlobalParams;
  XMLHTTPRequestConfig(
      {this.authorization,
      this.contentType,
      this.accept,
      this.omitGlobalParams});

  Map<String, String> toJson() {
    return jsonDecode(jsonEncode(this));
  }
}
