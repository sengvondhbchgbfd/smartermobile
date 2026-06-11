import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AttendanceMonthHeader
// ─────────────────────────────────────────────────────────────────────────────

class AttendanceMonthHeader extends StatefulWidget {
  final int month;
  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  // ── Manager-only fields ───────────────────────────────────────────────────
  final String? filterLabel;
  final bool hasFilter;
  final bool showSearch;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onPickDate;
  final VoidCallback? onPickDateRange;
  final VoidCallback? onToggleSearch;
  final VoidCallback? onClearFilter;

  // ── Staff-only / shared ───────────────────────────────────────────────────
  final String? subtitle;
  final Widget? trailing;

  // ── Internal mode flag ────────────────────────────────────────────────────
  final bool _isManager;

  // ── Staff constructor ─────────────────────────────────────────────────────
  const AttendanceMonthHeader.staff({
    super.key,
    required this.month,
    required this.year,
    required this.onPrevious,
    required this.onNext,
    this.subtitle,
    this.trailing,
  }) : _isManager = false,
       filterLabel = null,
       hasFilter = false,
       showSearch = false,
       onSearch = null,
       onPickDate = null,
       onPickDateRange = null,
       onToggleSearch = null,
       onClearFilter = null;

  // ── Manager constructor ───────────────────────────────────────────────────
  const AttendanceMonthHeader.manager({
    super.key,
    required this.month,
    required this.year,
    required this.onPrevious,
    required this.onNext,
    this.filterLabel,
    this.hasFilter = false,
    this.showSearch = false,
    this.onSearch,
    this.onPickDate,
    this.onPickDateRange,
    this.onToggleSearch,
    this.onClearFilter,
    this.subtitle,
    this.trailing,
  }) : _isManager = true;
  @override
  State<AttendanceMonthHeader> createState() => _AttendanceMonthHeaderState();
}

// ─────────────────────────────────────────────────────────────────────────────

class _AttendanceMonthHeaderState extends State<AttendanceMonthHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get _monthLabel =>
      DateFormat('MMMM yyyy').format(DateTime(widget.year, widget.month));

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return widget.month == now.month && widget.year == now.year;
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Row 1: month navigation ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _NavArrow(
                  icon: Icons.chevron_left_rounded,
                  onTap: widget.onPrevious,
                ),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.subtitle != null) ...[
                        Text(
                          widget.subtitle!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _monthLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isCurrentMonth) ...[
                            const SizedBox(width: 6),
                            _Pill(label: 'This month', color: Colors.blue),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                _NavArrow(
                  icon: Icons.chevron_right_rounded,
                  onTap: widget.onNext,
                ),

                // Manager: search + filter icon buttons
                if (widget._isManager) ...[
                  _IconBtn(
                    icon: widget.showSearch
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    active: widget.showSearch,
                    tooltip: 'Search',
                    onTap: widget.onToggleSearch,
                  ),
                  _IconBtn(
                    icon: Icons.calendar_today_outlined,
                    active: false,
                    tooltip: 'Pick date',
                    onTap: widget.onPickDate,
                  ),
                  _IconBtn(
                    icon: Icons.date_range_outlined,
                    active: false,
                    tooltip: 'Date range',
                    onTap: widget.onPickDateRange,
                  ),
                ],

                // Staff: optional trailing
                if (!widget._isManager && widget.trailing != null) ...[
                  const SizedBox(width: 4),
                  widget.trailing!,
                ],
              ],
            ),
          ),

          // ── Row 2: active filter chip (manager only) ─────────────────────
          if (widget._isManager &&
              widget.hasFilter &&
              widget.filterLabel != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 14,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Filtered:',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(width: 6),
                  Chip(
                    label: Text(
                      widget.filterLabel!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    side: BorderSide(color: Colors.blue.shade200),
                    deleteIcon: Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.blue.shade600,
                    ),
                    onDeleted: widget.onClearFilter,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

          // ── Row 3: search field (manager only, when open) ─────────────────
          if (widget._isManager && widget.showSearch)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: widget.onSearch,
                decoration: InputDecoration(
                  hintText: 'Search by name or ID…',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearch?.call('');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue.shade400,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ),

          Divider(height: 1, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────────────────────────────────────────

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 22, color: Colors.grey.shade600),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final String tooltip;
  final VoidCallback? onTap;

  const _IconBtn({
    required this.icon,
    required this.active,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 20,
            color: active ? Colors.blue.shade600 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final MaterialColor color;

  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
