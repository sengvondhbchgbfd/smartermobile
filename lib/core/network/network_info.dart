import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<List<ConnectivityResult>> get connectivityResult;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);
  final Connectivity _connectivity;

  ///////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  ///////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////

  @override
  Future<List<ConnectivityResult>> get connectivityResult {
    return _connectivity.checkConnectivity();
  }

  ///////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
  bool _isConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);
  }
}
