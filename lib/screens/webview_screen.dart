import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/app_config.dart';
import '../services/error_logger_service.dart';
import '../services/device_info_service.dart';

class WebViewScreen extends StatefulWidget {
  final AppConfig config;

  const WebViewScreen({super.key, required this.config});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _errorMessage;
  double _progress = 0;
  final _errorLogger = ErrorLoggerService();
  final _deviceInfo = DeviceInfoService();
  String? _cachedDeviceInfo;

  final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    mediaPlaybackRequiresUserGesture: false,
    useHybridComposition: true,
    useShouldOverrideUrlLoading: false,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    cacheEnabled: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    clearCache: false,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    supportMultipleWindows: true,
  );

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
  }

  Future<void> _initDeviceInfo() async {
    _cachedDeviceInfo = await _deviceInfo.getDeviceInfo();
  }

  Future<void> _logWebViewError(String error, {String? url}) async {
    final deviceInfo = _cachedDeviceInfo ?? await _deviceInfo.getDeviceInfo();
    await _errorLogger.logError(
      error: '$error${url != null ? ' (URL: $url)' : ''}',
      deviceInfo: deviceInfo,
      type: 'WebView',
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      _errorMessage = null;
    });
    await _webViewController?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _refreshPage,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A7A9E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.config.url),
                ),
                initialSettings: _settings,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = 'Failed to load page: $message';
                  });
                  _logWebViewError(
                    'Load Error (Code: $code): $message',
                    url: url?.toString(),
                  );
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = 'HTTP Error $statusCode: $description';
                  });
                  _logWebViewError(
                    'HTTP Error $statusCode: $description',
                    url: url?.toString(),
                  );
                },
                onReceivedError: (controller, request, error) {
                  _logWebViewError(
                    'Received Error (Code: ${error.type}): ${error.description}',
                    url: request.url?.toString(),
                  );
                },
              ),
            if (_isLoading && _errorMessage == null)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _progress > 0 ? _progress : null,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A7A9E)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _progress > 0 ? 'Loading ${(_progress * 100).toInt()}%' : 'Loading...',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A7A9E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
