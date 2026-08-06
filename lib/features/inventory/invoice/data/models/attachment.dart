import 'package:frontendmobile/features/inventory/invoice/domain/entities/invoice_entity.dart';

class Attachment {
  final String id;
  final String fileName;
  final String fileType;
  final String fileUrl;
  final DateTime createdAt;

  const Attachment({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    required this.createdAt,
  });

  // Add this factory constructor to bridge the gap
  factory Attachment.fromEntity(InvoiceAttachmentEntity entity) {
    return Attachment(
      id: entity.attachmentId
          .toString(), // Ensures ID is a String (handles the second issue)
      fileName: entity.fileName.toString(),
      fileType: entity.fileType.toString(),
      fileUrl: entity.fileUrl,
      createdAt: entity.createdAt,
    );
  }
}
