import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/customer/domain/entities/customer_entity.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'section_card.dart';

class BasicInfoSection extends StatelessWidget {
  final bool customersLoaded;
  final bool staffLoaded;
  final List<CustomerEntity> customers;
  final List<StaffEntity> staffList;

  final int? selectedCustomerId;
  final String selectedCustomerLabel;
  final ValueChanged<CustomerEntity> onCustomerSelected;

  final int? selectedStaffId;
  final String selectedStaffLabel;
  final ValueChanged<StaffEntity> onStaffSelected;

  final int? myStaffId;
  final String? myFullName;
  final void Function(int staffId, String fullName) onAssignToMe;

  final TextEditingController refNumberCtrl;

  const BasicInfoSection({
    super.key,
    required this.customersLoaded,
    required this.staffLoaded,
    required this.customers,
    required this.staffList,
    required this.selectedCustomerId,
    required this.selectedCustomerLabel,
    required this.onCustomerSelected,
    required this.selectedStaffId,
    required this.selectedStaffLabel,
    required this.onStaffSelected,
    required this.myStaffId,
    required this.myFullName,
    required this.onAssignToMe,
    required this.refNumberCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final isAssignedToMe = myStaffId != null && selectedStaffId == myStaffId;

    return SectionCard(
      title: 'Basic Info',
      children: [
        Autocomplete<CustomerEntity>(
          key: ValueKey('customer-$selectedCustomerLabel'),
          initialValue: TextEditingValue(text: selectedCustomerLabel),
          displayStringForOption: (c) => c.name,
          optionsBuilder: (textValue) {
            if (!customersLoaded) return const Iterable.empty();
            if (textValue.text.isEmpty) return customers;
            final q = textValue.text.toLowerCase();
            return customers.where((c) => c.name.toLowerCase().contains(q));
          },
          onSelected: onCustomerSelected,
          fieldViewBuilder: (context, ctrl, focusNode, onFieldSubmitted) {
            return TextField(
              controller: ctrl,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Customer *',
                hintText: customersLoaded
                    ? 'Search customer by name'
                    : 'Loading customers...',
                suffixIcon: selectedCustomerId != null
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      )
                    : null,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Autocomplete<StaffEntity>(
          key: ValueKey('staff-$selectedStaffLabel'),
          initialValue: TextEditingValue(text: selectedStaffLabel),
          displayStringForOption: (s) => s.name,
          optionsBuilder: (textValue) {
            if (!staffLoaded) return const Iterable.empty();
            if (textValue.text.isEmpty) return staffList;
            final q = textValue.text.toLowerCase();
            return staffList.where((s) => s.name.toLowerCase().contains(q));
          },
          onSelected: onStaffSelected,
          fieldViewBuilder: (context, ctrl, focusNode, onFieldSubmitted) {
            return TextField(
              controller: ctrl,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Assigned staff *',
                hintText: staffLoaded
                    ? 'Search staff by name'
                    : 'Loading staff...',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (myStaffId != null && !isAssignedToMe)
                      IconButton(
                        icon: const Icon(Icons.person, size: 18),
                        tooltip: 'Assign to me',
                        onPressed: () {
                          if (myFullName == null || myStaffId == null) return;
                          onAssignToMe(myStaffId!, myFullName!);
                          ctrl.text = myFullName!;
                        },
                      ),
                    if (selectedStaffId != null)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        TextField(
          controller: refNumberCtrl,
          decoration: const InputDecoration(labelText: 'Ref number *'),
        ),
      ],
    );
  }
}
