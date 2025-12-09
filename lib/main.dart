import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'services/error_logger_service.dart';
import 'services/device_info_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ErrorLoggerService().initialize();

  final deviceInfo = await DeviceInfoService().getDeviceInfo();

  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.presentError(details);
    await ErrorLoggerService().logError(
      error: details.exceptionAsString(),
      stackTrace: details.stack?.toString(),
      deviceInfo: deviceInfo,
      type: 'Flutter',
    );
  };

  runZonedGuarded(
    () {

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      runApp(const MyApp());
    },
    (error, stackTrace) async {
      await ErrorLoggerService().logError(
        error: error.toString(),
        stackTrace: stackTrace.toString(),
        deviceInfo: deviceInfo,
        type: 'Zone',
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyProperty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A7A9E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
