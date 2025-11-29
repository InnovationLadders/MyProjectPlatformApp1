class AppConfig {
  final String appName;
  final String url;

  AppConfig({
    required this.appName,
    required this.url,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['appName'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'url': url,
    };
  }
}
