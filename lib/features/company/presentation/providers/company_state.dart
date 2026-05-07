import 'package:equatable/equatable.dart';
import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';

class CompanyState extends Equatable {
  final CompanyEntity? company;
  final bool isUpdating;
  final String? error;

  const CompanyState({this.company, this.isUpdating = false, this.error});

  CompanyState copyWith({
    CompanyEntity? company,
    bool? isUpdating,
    Object? error = _sentinel,
  }) {
    return CompanyState(
      company: company ?? this.company,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error == _sentinel ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [company, isUpdating, error];
}

const Object _sentinel = Object();
