import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ErrorLog {
  final DateTime timestamp;
  final String error;
  final String? stackTrace;
  final String deviceInfo;
  final String type;

  ErrorLog({
    required this.timestamp,
    required this.error,
    this.stackTrace,
    required this.deviceInfo,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'error': error,
      'stackTrace': stackTrace,
      'deviceInfo': deviceInfo,
      'type': type,
    };
  }

  factory ErrorLog.fromMap(Map<String, dynamic> map) {
    return ErrorLog(
      timestamp: DateTime.parse(map['timestamp'] as String),
      error: map['error'] as String,
      stackTrace: map['stackTrace'] as String?,
      deviceInfo: map['deviceInfo'] as String,
      type: map['type'] as String,
    );
  }

  @override
  String toString() {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final buffer = StringBuffer();
    buffer.writeln('[$type] ${dateFormat.format(timestamp)}');
    buffer.writeln('Device: $deviceInfo');
    buffer.writeln('Error: $error');
    if (stackTrace != null) {
      buffer.writeln('StackTrace:');
      buffer.writeln(stackTrace);
    }
    buffer.writeln('${'=' * 80}');
    return buffer.toString();
  }
}

class ErrorLoggerService {
  static final ErrorLoggerService _instance = ErrorLoggerService._internal();
  factory ErrorLoggerService() => _instance;
  ErrorLoggerService._internal();

  final List<ErrorLog> _logs = [];
  File? _logFile;

  List<ErrorLog> get logs => List.unmodifiable(_logs);

  Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _logFile = File('${directory.path}/error_logs.txt');

      if (await _logFile!.exists()) {
        await _loadLogsFromFile();
      }
    } catch (e) {
      print('Failed to initialize ErrorLoggerService: $e');
    }
  }

  Future<void> _loadLogsFromFile() async {
    if (_logFile == null || !await _logFile!.exists()) return;

    try {
      final content = await _logFile!.readAsString();
      final entries = content.split('=' * 80);

      for (var entry in entries) {
        if (entry.trim().isEmpty) continue;

        final lines = entry.trim().split('\n');
        if (lines.length < 3) continue;

        final typeAndDate = lines[0];
        final deviceLine = lines[1];
        final errorLine = lines[2];

        final typeMatch = RegExp(r'\[(.*?)\]').firstMatch(typeAndDate);
        final type = typeMatch?.group(1) ?? 'Unknown';

        final dateMatch = RegExp(r'\] (.+)$').firstMatch(typeAndDate);
        DateTime timestamp;
        try {
          timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateMatch?.group(1) ?? '');
        } catch (e) {
          timestamp = DateTime.now();
        }

        final device = deviceLine.replaceFirst('Device: ', '').trim();
        final error = errorLine.replaceFirst('Error: ', '').trim();

        String? stackTrace;
        if (lines.length > 3 && lines[3].startsWith('StackTrace:')) {
          stackTrace = lines.sublist(4).join('\n').trim();
        }

        _logs.add(ErrorLog(
          timestamp: timestamp,
          error: error,
          stackTrace: stackTrace,
          deviceInfo: device,
          type: type,
        ));
      }
    } catch (e) {
      print('Failed to load logs from file: $e');
    }
  }

  Future<void> logError({
    required String error,
    String? stackTrace,
    required String deviceInfo,
    String type = 'Error',
  }) async {
    final log = ErrorLog(
      timestamp: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
      deviceInfo: deviceInfo,
      type: type,
    );

    _logs.insert(0, log);

    if (_logs.length > 1000) {
      _logs.removeRange(1000, _logs.length);
    }

    await _saveToFile(log);
  }

  Future<void> _saveToFile(ErrorLog log) async {
    if (_logFile == null) return;

    try {
      await _logFile!.writeAsString(
        log.toString(),
        mode: FileMode.append,
      );
    } catch (e) {
      print('Failed to save log to file: $e');
    }
  }

  Future<void> clearLogs() async {
    _logs.clear();
    if (_logFile != null && await _logFile!.exists()) {
      await _logFile!.delete();
      _logFile = File(_logFile!.path);
    }
  }

  Future<String> getLogsAsText() async {
    final buffer = StringBuffer();
    buffer.writeln('Error Logs Report');
    buffer.writeln('Generated: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}');
    buffer.writeln('Total Errors: ${_logs.length}');
    buffer.writeln('${'=' * 80}\n');

    for (var log in _logs) {
      buffer.write(log.toString());
      buffer.writeln();
    }

    return buffer.toString();
  }

  Future<File?> getLogFile() async {
    if (_logFile == null || !await _logFile!.exists()) {
      return null;
    }
    return _logFile;
  }
}
