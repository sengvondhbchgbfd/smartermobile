import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/quotation_export_service.dart';

part 'quotation_export_provider.g.dart';

@riverpod
QuotationExportService quotationExportService(QuotationExportServiceRef ref) {
  return QuotationExportService();
}
