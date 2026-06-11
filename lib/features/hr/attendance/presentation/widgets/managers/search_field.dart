import 'package:flutter/material.dart';

class StaffSearchField extends StatelessWidget {
  const StaffSearchField({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onClear,
  });
 
  final TextEditingController controller;
  final ValueChanged<String>   onSubmit;
  final VoidCallback           onClear;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller:      controller,
        keyboardType:    TextInputType.number,
        textInputAction: TextInputAction.search,
        onSubmitted:     onSubmit,
        decoration: InputDecoration(
          hintText:    'Enter staff ID…',
          prefixIcon:  const Icon(Icons.person_search),
          border:      const OutlineInputBorder(),
          // ✅ Clear button when text exists, search button otherwise
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) => value.text.isEmpty
                ? IconButton(
                    icon:    const Icon(Icons.close),
                    tooltip: 'Close search',
                    onPressed: onClear,
                  )
                : IconButton(
                    icon:    const Icon(Icons.arrow_forward),
                    tooltip: 'Search',
                    onPressed: () => onSubmit(controller.text),
                  ),
          ),
        ),
      ),
    );
  }
}