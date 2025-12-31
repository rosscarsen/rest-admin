import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = AppLogger();

class AppLogger {
  /// 单例实例
  static final AppLogger _instance = AppLogger._internal();

  /// 对外访问
  factory AppLogger() => _instance;

  late final Logger _logger;

  AppLogger._internal() {
    _logger = Logger(
      /// 只在【生产模式】输出
      filter: _ReleaseOnlyFilter(),

      /// 输出格式
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
  }

  /// 对外暴露的快捷方法
  void d(dynamic message) => _logger.d(message);
  void i(dynamic message) => _logger.i(message);
  void w(dynamic message) => _logger.w(message);
  void f(dynamic message) => _logger.f(message);
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}

class _ReleaseOnlyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kReleaseMode;
  }
}
