import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

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

  String get _monthLabel =>
      DateFormat('MMMM yyyy').format(DateTime(widget.year, widget.month));

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return widget.month == now.month && widget.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final iconColor = isDark ? Pallets.textSecondaryDark : Pallets.textMuted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Row 1: month navigation ──────────────────────────────────────
        Row(
          children: [
            _NavArrow(
              icon: Icons.chevron_left_rounded,
              color: iconColor,
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
                        color: textSecondary,
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
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      if (_isCurrentMonth) ...[
                        const SizedBox(width: 8),
                        Text(
                          'This month',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Pallets.gradient2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            _NavArrow(
              icon: Icons.chevron_right_rounded,
              color: iconColor,
              onTap: widget.onNext,
            ),

            if (widget._isManager) ...[
              _IconBtn(
                icon: widget.showSearch
                    ? Icons.search_off_rounded
                    : Icons.search_rounded,
                active: widget.showSearch,
                iconColor: iconColor,
                tooltip: 'Search',
                onTap: widget.onToggleSearch,
              ),
              _IconBtn(
                icon: Icons.calendar_today_outlined,
                active: false,
                iconColor: iconColor,
                tooltip: 'Pick date',
                onTap: widget.onPickDate,
              ),
              _IconBtn(
                icon: Icons.date_range_outlined,
                active: false,
                iconColor: iconColor,
                tooltip: 'Date range',
                onTap: widget.onPickDateRange,
              ),
            ],

            if (!widget._isManager && widget.trailing != null) ...[
              const SizedBox(width: 4),
              widget.trailing!,
            ],
          ],
        ),

        // ── Row 2: active filter (plain text, no chip) ────────────────────
        if (widget._isManager && widget.hasFilter && widget.filterLabel != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: widget.onClearFilter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 14,
                    color: Pallets.gradient2,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.filterLabel!,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Pallets.gradient2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: Pallets.gradient2.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),

        // ── Row 3: search field (manager only, when open) — underline style
        if (widget._isManager && widget.showSearch)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: widget.onSearch,
              style: TextStyle(fontSize: 14, color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by name or ID…',
                hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                prefixIcon: Icon(Icons.search, size: 18, color: iconColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, size: 16, color: iconColor),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearch?.call('');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Pallets.gradient2, width: 1.5),
                ),
                filled: false,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────────────────────────────────────────

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color iconColor;
  final String tooltip;
  final VoidCallback? onTap;

  const _IconBtn({
    required this.icon,
    required this.active,
    required this.iconColor,
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
            color: active ? Pallets.gradient2 : iconColor,
          ),
        ),
      ),
    );
  }
}
