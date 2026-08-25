import 'package:logger/logger.dart';

class Loggers{
  static final _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, printEmojis: true, colors: true)
  );
  ///Debug // Information useful for debugging
  static void d(dynamic message) => _logger.d(message);

  ///Trace // Extremely detailed diagnostic info
  static void t(dynamic message) => _logger.t(message);

  ///Error // Critical failures or exceptions
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]){
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  ///Info // General app flow updates
  static void i(dynamic message)  => _logger.i(message);

  ///Warning // Potential issues or non-fatal alerts
  static void w(dynamic message)  =>  _logger.w(message);

  ///Fatal // Total crashes or unrecoverable issues
  static void f(dynamic message) => _logger.f(message);

}

// Usage anywhere in your application:
// AppLogger.info("User successfully logged in.");