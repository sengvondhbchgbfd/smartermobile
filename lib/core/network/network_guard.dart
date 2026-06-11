import 'package:dartz/dartz.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import 'network_info.dart';

mixin NetworkGuard {
  NetworkInfo get networkInfo;
  Future<Either<Failure, T>> guardNetwork<T>(Future<T> Function() call) async {
    final connected = await networkInfo.isConnected;
    if (!connected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await call();
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
