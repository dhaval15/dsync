mixin Guard<T> {
  Future<String?> createGuarded() async {
    return null;
  }

  Future<String?> replaceGuarded() async {
    return null;
  }

  Future<String?> updateGuarded() async {
    return null;
  }

  Future<String?> deleteGuarded() async {
    return null;
  }
}

class GuardedException implements Exception {
  final String? message;

  GuardedException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "GuardedException";
    return "GuardedException: $message";
  }
}

class GuardTower {
  final List<Guard> guards;

  const GuardTower(this.guards);

  Guard<T>? findOfType<T>() {
    try {
      return guards.firstWhere((t) => t is T) as Guard<T>;
    } on StateError catch (_) {
      return null;
    }
  }
}
