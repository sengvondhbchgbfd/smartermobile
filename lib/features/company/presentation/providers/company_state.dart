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
    String? error,
  }) 
  
  {
    return CompanyState(
      company: company ?? this.company,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [company, isUpdating, error];
}
