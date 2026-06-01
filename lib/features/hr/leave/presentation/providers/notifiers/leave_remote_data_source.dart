import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:frontendmobile/features/hr/leave/data/datasource/leave_remote_datasource.dart';
import 'package:frontendmobile/features/hr/leave/data/datasource/leave_remote_datasource_impl.dart';

import 'package:frontendmobile/shared/providers/core_providers.dart';

part 'leave_remote_data_source.g.dart';

@riverpod
Future<LeaveRemoteDataSource> leaveRemoteDataSource(Ref ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return LeaveRemoteDataSourceImpl(dioClient.dio);
}
