import 'package:equatable/equatable.dart';
import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';
import 'package:frontendmobile/features/company/domain/entities/compay_status_history_entity.dart';

class CompanyState extends Equatable {
  final CompanyEntity? company;
  final bool isUpdating;
  final String? error;
  final List<CompanyStatusHistoryEntity> history;
  final bool isLoadingHistory;

  const CompanyState({
    this.company,
    this.isUpdating = false,
    this.error,
    this.history = const [],
    this.isLoadingHistory = false,
  });

  CompanyState copyWith({
    CompanyEntity? company,
    bool? isUpdating,
    Object? error = _sentinel,
    List<CompanyStatusHistoryEntity>? history,
    bool? isLoadingHistory,
  }) {
    return CompanyState(
      company: company ?? this.company,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error == _sentinel ? this.error : error as String?,
      history: history ?? this.history,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
    );
  }

  @override
  List<Object?> get props => [
    company,
    isUpdating,
    error,
    history,
    isLoadingHistory,
  ];
}

const Object _sentinel = Object();
