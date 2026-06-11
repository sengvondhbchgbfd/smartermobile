import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_remote_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/leave/data/repositories/leave_repository_impl.dart';
import 'package:frontendmobile/features/hr/leave/domain/repositories/leave_repository.dart';

part 'manager_leave_provider.g.dart';

@riverpod
Future<LeaveRepository> leaveRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(
    leaveRemoteDataSourceProvider.future,
  );
  return LeaveRepositoryImpl(remoteDataSource);
}
