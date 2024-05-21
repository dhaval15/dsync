import 'dart:async';

import 'package:syncd/src/proxy.dart';

mixin ConnectivityMixin on RepositoryProxy {
  @override
  Future<bool> get redirect async => _isConnected;

  bool _isConnected = true;

  Stream<bool> get connectivityStream;

  late final StreamSubscription<bool> _streamSubscription;

  @override
  void init() {
    super.init();
    _streamSubscription = connectivityStream.listen((data) {
      _isConnected = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }
}

class LocalProxy with RepositoryProxy, ConnectivityMixin {
  @override
  Future<T> create<T>() {
    throw UnimplementedError();
  }

  @override
  Future<void> delete<T>() {
    throw UnimplementedError();
  }

  @override
  Future<T> replace<T>() {
    throw UnimplementedError();
  }

  @override
  Future<T> update<T>() {
    throw UnimplementedError();
  }

  @override
  final Stream<bool> connectivityStream;

  LocalProxy(this.connectivityStream);
}
