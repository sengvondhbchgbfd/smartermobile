import 'package:flutter/material.dart';

enum SalaryFieldType { text, date }

class SalaryField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final SalaryFieldType type;

  const SalaryField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.type = SalaryFieldType.text,
  });

  Future<void> _pickDate(BuildContext context) async {
    final initial = DateTime.tryParse(controller.text) ?? DateTime.now();

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _WheelDatePicker(initial: initial),
    );

    if (picked != null) {
      controller.text =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDate = type == SalaryFieldType.date;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isDate ? null : keyboardType,
        readOnly: isDate,
        validator: validator,
        onTap: isDate ? () => _pickDate(context) : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: isDate
              ? const Icon(Icons.calendar_today_outlined, size: 18)
              : null,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Scroll-wheel date picker bottom sheet
// ─────────────────────────────────────────────
class _WheelDatePicker extends StatefulWidget {
  final DateTime initial;
  const _WheelDatePicker({required this.initial});

  @override
  State<_WheelDatePicker> createState() => _WheelDatePickerState();
}

class _WheelDatePickerState extends State<_WheelDatePicker> {
  static const _itemExtent = 48.0;
  static const _visibleItems = 5;
  static const double _sheetHeight = _itemExtent * _visibleItems + 80 + 72;

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late int _day;
  late int _month;
  late int _year;

  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _yearCtrl;

  final int _startYear = 1970;
  final int _endYear = 2100;

  int get _daysInMonth => DateUtils.getDaysInMonth(_year, _month);

  @override
  void initState() {
    super.initState();
    _day = widget.initial.day;
    _month = widget.initial.month;
    _year = widget.initial.year;

    _dayCtrl = FixedExtentScrollController(initialItem: _day - 1);
    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _yearCtrl = FixedExtentScrollController(initialItem: _year - _startYear);
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  void _clampDay() {
    final max = _daysInMonth;
    if (_day > max) {
      _day = max;
      _dayCtrl.jumpToItem(_day - 1);
    }
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    required void Function(int index) onChanged,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemExtent,
        perspective: 0.003,
        diameterRatio: 1.6,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) => itemBuilder(index),
        ),
      ),
    );
  }

  Widget _label(String text, bool selected) {
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: TextStyle(
          fontSize: selected ? 20 : 16,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: _sheetHeight,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Title ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),

          // ── Wheels ──
          SizedBox(
            height: _itemExtent * _visibleItems,
            child: Stack(
              children: [
                // Selection highlight lines (top + bottom border only)
                Center(
                  child: Container(
                    height: _itemExtent,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: scheme.outline.withOpacity(0.45),
                          width: 1.2,
                        ),
                        bottom: BorderSide(
                          color: scheme.outline.withOpacity(0.45),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Day ──
                    _buildWheel(
                      controller: _dayCtrl,
                      width: 72,
                      itemCount: _daysInMonth,
                      onChanged: (i) => setState(() => _day = i + 1),
                      itemBuilder: (i) => _label('${i + 1}', i + 1 == _day),
                    ),

                    // ── Month ──
                    Expanded(
                      child: _buildWheel(
                        controller: _monthCtrl,
                        itemCount: 12,
                        onChanged: (i) => setState(() {
                          _month = i + 1;
                          _clampDay();
                        }),
                        itemBuilder: (i) => _label(_months[i], i + 1 == _month),
                      ),
                    ),

                    // ── Year ──
                    _buildWheel(
                      controller: _yearCtrl,
                      width: 92,
                      itemCount: _endYear - _startYear + 1,
                      onChanged: (i) => setState(() {
                        _year = _startYear + i;
                        _clampDay();
                      }),
                      itemBuilder: (i) {
                        final y = _startYear + i;
                        return _label('$y', y == _year);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Save button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () =>
                    Navigator.pop(context, DateTime(_year, _month, _day)),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
