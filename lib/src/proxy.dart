import 'package:syncd/src/guard_tower.dart';
import 'package:syncd/src/log.dart';

mixin RepositoryProxy {
  void init() {}

  Future<T> create<T>();
  Future<T> replace<T>();
  Future<T> update<T>();
  Future<void> delete<T>();

  void dispose() {}

  Future<bool> get redirect;
}

class ProxyRepository extends Repository with LoggerMixin {
  GuardTower? _guardTower;

  RepositoryProxy? get proxy => _proxy;
  RepositoryProxy? _proxy;

  Future<bool> get redirect async => _proxy?.redirect ?? true;

  void registerProxy(RepositoryProxy proxy) {
    if (_proxy != null) {
      _proxy!.dispose();
      logInfo('disposed old proxy(${_proxy!.runtimeType})');
    }
    _proxy = proxy;
    _proxy!.init();
    logInfo('registered new proxy(${_proxy.runtimeType}');
  }

  void registerTower(GuardTower guardTower) {
    if (_guardTower != null) {
      logInfo('disposed old guard tower(${_guardTower!.runtimeType})');
    }
    _proxy = proxy;
    logInfo('registered new guard tower(${_guardTower.runtimeType}');
  }

  @override
  Future<T> create<T>() async {
    if (await redirect) {
      final guarded = await _guardTower?.findOfType<T>()?.createGuarded();
      if (guarded != null) throw GuardedException(guarded);
      return _proxy!.create();
    }
    return super.create();
  }

  @override
  Future<T> replace<T>() async {
    if (await redirect) {
      final guarded = await _guardTower?.findOfType<T>()?.replaceGuarded();
      if (guarded != null) throw GuardedException(guarded);
      return _proxy!.replace();
    }
    return super.replace();
  }

  @override
  Future<T> update<T>() async {
    if (await redirect) {
      final guarded = await _guardTower?.findOfType<T>()?.updateGuarded();
      if (guarded != null) throw GuardedException(guarded);
      return _proxy!.update();
    }
    return super.update();
  }

  @override
  Future<void> delete<T>() async {
    if (await redirect) {
      final guarded = await _guardTower?.findOfType<T>()?.deleteGuarded();
      if (guarded != null) throw GuardedException(guarded);
      return _proxy!.delete();
    }
    return super.delete();
  }
}

class Repository {
  Future<T> create<T>() {
    throw '';
  }

  Future<T> replace<T>() {
    throw '';
  }

  Future<T> update<T>() {
    throw '';
  }

  Future<void> delete<T>() {
    throw '';
  }
}
