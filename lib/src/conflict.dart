mixin Event {
  String get vuuid;
  Op get op;
  String get objectId;
  DateTime get updateTime;
}

enum Op {
  insert,
  delete,
  update,
  none;

  factory Op.fromString(String iud) {
    return switch (iud) {
      'I' => Op.insert,
      'U' => Op.update,
      'D' => Op.delete,
      _ => Op.none,
    };
  }
}

enum ConflictResolution {
  push,
  pull,
  discard,
  user,
}

abstract class Conflict {
  final Event push;
  final Event pull;

  const Conflict(this.push, this.pull);

  Future<ConflictResolution> resolve() async {
    if (push.op == Op.delete && pull.op == Op.delete) {
      return ConflictResolution.discard;
    }
    if (push.op == Op.update &&
        pull.op == Op.update &&
        deepCompare(push, pull)) {
      return ConflictResolution.discard;
    }
    if (push.updateTime.isAfter(pull.updateTime)) {
      return ConflictResolution.push;
    } else {
      return ConflictResolution.pull;
    }
  }

  bool deepCompare(Event push, Event pull) => false;
}
