import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/quotation_enums.dart';

part 'quotation_filter_provider.g.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class QuotationFilterState {
  final QuotationStatus? status;
  final int? staffId;
  final int? customerId;
  final String searchQuery;

  const QuotationFilterState({
    this.status,
    this.staffId,
    this.customerId,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      status != null || staffId != null || customerId != null;

  QuotationFilterState copyWith({
    QuotationStatus? status,
    bool clearStatus = false,
    int? staffId,
    bool clearStaffId = false,
    int? customerId,
    bool clearCustomerId = false,
    String? searchQuery,
  }) {
    return QuotationFilterState(
      status: clearStatus ? null : (status ?? this.status),
      staffId: clearStaffId ? null : (staffId ?? this.staffId),
      customerId: clearCustomerId ? null : (customerId ?? this.customerId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

@riverpod
class QuotationFilterNotifier extends _$QuotationFilterNotifier {
  @override
  QuotationFilterState build() => const QuotationFilterState();

  void setStatus(QuotationStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCustomerId(int? customerId) {
    state = state.copyWith(
      customerId: customerId,
      clearCustomerId: customerId == null,
    );
  }

  void reset() => state = const QuotationFilterState();
}
