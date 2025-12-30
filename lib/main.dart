import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/app_config.dart';
import 'screens/webview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String configString = await rootBundle.loadString('assets/config.json');
  final Map<String, dynamic> configJson = json.decode(configString);
  final config = AppConfig.fromJson(configJson);

  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final AppConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(config: config),
    );
  }
}
