import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_enums.dart';


import 'enum_dropdown.dart';

import 'section_card.dart';



class ArtworkDeliverySection extends StatelessWidget {

  final ArtworkStatus artworkStatus;

  final DeliveryMethod deliveryMethod;

  final TextEditingController paymentTermsCtrl;

  final ValueChanged<ArtworkStatus> onArtworkChanged;

  final ValueChanged<DeliveryMethod> onDeliveryChanged;



  const ArtworkDeliverySection({

    super.key,

    required this.artworkStatus,

    required this.deliveryMethod,

    required this.paymentTermsCtrl,

    required this.onArtworkChanged,

    required this.onDeliveryChanged,

  });



  @override

  Widget build(BuildContext context) {

    return SectionCard(

      title: 'Artwork & Delivery',

      children: [

        EnumDropdown<ArtworkStatus>(

          label: 'Artwork status',

          value: artworkStatus,

          values: ArtworkStatus.values,

          labelOf: (v) => v.label,

          onChanged: onArtworkChanged,

        ),

        const SizedBox(height: 12),

        EnumDropdown<DeliveryMethod>(

          label: 'Delivery method',

          value: deliveryMethod,

          values: DeliveryMethod.values,

          labelOf: (v) => v.label,

          onChanged: onDeliveryChanged,

        ),

        const SizedBox(height: 12),

        TextField(

          controller: paymentTermsCtrl,

          decoration: const InputDecoration(labelText: 'Payment terms'),

        ),

      ],

    );

  }

}