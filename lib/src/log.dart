enum LogEventType {
  info,
  warning,
  debug,
  error,
}

class Logger {
  const Logger._();

  static const instance = Logger._();

  static void Function(LogEventType type, Object context, String message)
      printFunction = (type, context, message) {
    print('[${type.name.toUpperCase()}] ${context.runtimeType}: $message');
  };

  void log(LogEventType type, Object context, String message) {
    printFunction(type, context, message);
  }
}

mixin LoggerMixin {
  void logInfo(String message) {
    Logger.instance.log(LogEventType.info, this, message);
  }
}
