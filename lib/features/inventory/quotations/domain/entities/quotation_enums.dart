import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

enum QuotationStatus { draft, sent, accepted }

extension QuotationStatusX on QuotationStatus {
  static QuotationStatus fromApi(String? value) {
    switch (value) {
      case 'sent':
        return QuotationStatus.sent;
      case 'accepted':
        return QuotationStatus.accepted;
      case 'draft':
      default:
        return QuotationStatus.draft;
    }
  }

  String get apiValue => name;

  String get label {
    switch (this) {
      case QuotationStatus.draft:
        return 'Draft';
      case QuotationStatus.sent:
        return 'Sent';
      case QuotationStatus.accepted:
        return 'Accepted';
    }
  }

  Color get color {
    switch (this) {
      case QuotationStatus.draft:
        return Pallets.textMuted;
      case QuotationStatus.sent:
        return Pallets.info;
      case QuotationStatus.accepted:
        return Pallets.success;
    }
  }

  Color get tint {
    switch (this) {
      case QuotationStatus.draft:
        return Pallets.textMuted.withOpacity(0.15);
      case QuotationStatus.sent:
        return Pallets.infoTint;
      case QuotationStatus.accepted:
        return Pallets.successTint;
    }
  }
}

enum ArtworkStatus { notProvided, approved, needsRevision }

extension ArtworkStatusX on ArtworkStatus {
  static ArtworkStatus fromApi(String? value) {
    switch (value) {
      case 'approved':
        return ArtworkStatus.approved;
      case 'needs_revision':
        return ArtworkStatus.needsRevision;
      case 'not_provided':
      default:
        return ArtworkStatus.notProvided;
    }
  }

  String get apiValue {
    switch (this) {
      case ArtworkStatus.notProvided:
        return 'not_provided';
      case ArtworkStatus.approved:
        return 'approved';
      case ArtworkStatus.needsRevision:
        return 'needs_revision';
    }
  }

  String get label {
    switch (this) {
      case ArtworkStatus.notProvided:
        return 'Not Provided';
      case ArtworkStatus.approved:
        return 'approved';
      case ArtworkStatus.needsRevision:
        return 'Needs Revision';
    }
  }
}

/// NOTE: confirm exact enum values against `SELECT enum_range(NULL::delivery_method);`
enum DeliveryMethod { pickup, delivery, shipping }

extension DeliveryMethodX on DeliveryMethod {
  static DeliveryMethod fromApi(String? value) {
    switch (value) {
      case 'delivery':
        return DeliveryMethod.delivery;
      case 'shipping':
        return DeliveryMethod.shipping;
      case 'pickup':
      default:
        return DeliveryMethod.pickup;
    }
  }

  String get apiValue => name;

  String get label {
    switch (this) {
      case DeliveryMethod.pickup:
        return 'Pickup';
      case DeliveryMethod.delivery:
        return 'Delivery';
      case DeliveryMethod.shipping:
        return 'Shipping';
    }
  }

  IconData get icon {
    switch (this) {
      case DeliveryMethod.pickup:
        return Icons.storefront_outlined;
      case DeliveryMethod.delivery:
        return Icons.local_shipping_outlined;
      case DeliveryMethod.shipping:
        return Icons.inventory_2_outlined;
    }
  }
}
