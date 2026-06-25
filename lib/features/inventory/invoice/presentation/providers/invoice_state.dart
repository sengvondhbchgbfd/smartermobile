import 'package:frontendmobile/features/inventory/invoice/domain/entities/invoice_entity.dart';

class InvoiceState {
  final List<InvoiceEntity> invoices;
  final bool isLoading;
  final bool isCreating; 
  final String? error;
  final Set<int> loadingIds;

  const InvoiceState({
    this.invoices = const [],
    this.isLoading = false,
    this.isCreating = false, 
    this.error,
    this.loadingIds = const {},
  });

  InvoiceState copyWith({
    List<InvoiceEntity>? invoices,
    bool? isLoading,
    bool? isCreating, // ── Added ──
    String? error,
    Set<int>? loadingIds,
  }) => InvoiceState(
    invoices: invoices ?? this.invoices,
    isLoading: isLoading ?? this.isLoading,
    isCreating: isCreating ?? this.isCreating, 
    error: error,
    loadingIds: loadingIds ?? this.loadingIds,
  );
}
