import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/components/auth_manager_tile.dart';
import 'package:frontendmobile/core/components/section_label.dart';
import 'package:frontendmobile/core/components/staff_dropdown.dart';
import 'package:frontendmobile/core/components/warning_tile.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/salaries/data/model/salaries_model.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/provider/salary_notifier.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_field.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:intl/intl.dart';

class SalaryForm extends ConsumerStatefulWidget {
  final SalaryEntity? existing;
  const SalaryForm({super.key, this.existing});

  @override
  ConsumerState<SalaryForm> createState() => _SalaryFormState();
}

class _SalaryFormState extends ConsumerState<SalaryForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _baseSalary;
  late final TextEditingController _bonus;
  late final TextEditingController _deductions;

  // ✅ DateTime state — no longer String controllers for dates
  DateTime? _payPeriodStart;
  DateTime? _payPeriodEnd;
  DateTime? _paymentDate;

  String _paymentStatus = 'pending';
  bool _loading = false;

  StaffEntity? _selectedStaff;
  StaffEntity? _authStaff;
  bool _authStaffLoading = true;
  int? _authUserId;

  String _fmtDate(DateTime? dt) =>
      dt != null ? DateFormat('yyyy-MM-dd').format(dt) : '';

  String _displayDate(DateTime? dt) =>
      dt != null ? DateFormat('dd MMM yyyy').format(dt) : 'Select date';

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _baseSalary = TextEditingController(
      text: e?.baseSalary.toStringAsFixed(2) ?? '',
    );
    _bonus = TextEditingController(
      text: e?.bonus.toStringAsFixed(2) ?? '0.00',
    );
    _deductions = TextEditingController(
      text: e?.deductions.toStringAsFixed(2) ?? '0.00',
    );

    // ✅ initialize from DateTime fields directly
    _payPeriodStart = e?.payPeriodStart;
    _payPeriodEnd   = e?.payPeriodEnd;
    _paymentDate    = e?.paymentDate;
    _paymentStatus  = e?.paymentStatus ?? 'pending';

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAuthStaff());
  }

  @override
  void dispose() {
    _baseSalary.dispose();
    _bonus.dispose();
    _deductions.dispose();
    super.dispose();
  }

  Future<void> _loadAuthStaff() async {
    final storage = ref.read(secureStorageProvider);
    final userInfo = await storage.getUserInfo();
    if (userInfo == null) {
      if (mounted) setState(() => _authStaffLoading = false);
      return;
    }
    final staffAsync = ref.read(staffNotifierProvider);
    if (!staffAsync.hasValue) {
      if (mounted) setState(() => _authStaffLoading = false);
      return;
    }
    final match = staffAsync.value!
        .where((s) => s.userId == userInfo.userId)
        .firstOrNull;
    if (mounted) {
      setState(() {
        _authStaff = match;
        _authUserId = userInfo.userId;
        _authStaffLoading = false;
      });
    }
  }

  void _resolveExisting(List<StaffEntity> staffList) {
    if (widget.existing == null) return;
    _selectedStaff ??= staffList
        .where((s) => s.id == widget.existing!.staffId)
        .firstOrNull;
  }

  int? get _effectiveManagerId => _authUserId;

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime? current,
    required void Function(DateTime) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStaff == null) {
      _showError('Please select an employee.');
      return;
    }
    if (_payPeriodStart == null || _payPeriodEnd == null) {
      _showError('Please select pay period dates.');
      return;
    }
    if (_payPeriodStart!.isAfter(_payPeriodEnd!)) {
      _showError('Start date must be before end date.');
      return;
    }
    if (_effectiveManagerId == null) {
      _showError('Your staff profile was not found. Contact your administrator.');
      return;
    }

    setState(() => _loading = true);

    final base       = double.parse(_baseSalary.text);
    final bonus      = double.parse(_bonus.text);
    final deductions = double.parse(_deductions.text);

    final salary = SalaryModel(
      salaryId:       widget.existing?.salaryId,
      staffId:        _selectedStaff!.id!,
      managedBy:      _effectiveManagerId,
      baseSalary:     base,
      bonus:          bonus,
      deductions:     deductions,
      netSalary:      base + bonus - deductions,
      payPeriodStart: _payPeriodStart!, // ✅ DateTime
      payPeriodEnd:   _payPeriodEnd!,   // ✅ DateTime
      paymentStatus:  _paymentStatus,
      paymentDate:    _paymentDate,     // ✅ DateTime?
    );

    final notifier = ref.read(salaryNotifierProvider.notifier);
    if (widget.existing == null) {
      await notifier.create(salary);
    } else {
      await notifier.editSalary(widget.existing!.salaryId!, salary);
    }

    final err = ref.read(salaryNotifierProvider).error;
    if (err != null) {
      _showError(err.toString());
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = false);
    if (mounted) Navigator.pop(context);
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: Pallets.error),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEdit = widget.existing != null;
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70);
    final fieldBg = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
    final border = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA);

    final staffAsync = ref.watch(staffNotifierProvider);

    return staffAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Failed to load staff: $e')),
      data: (staffList) {
        _resolveExisting(staffList);

        InputDecoration fieldDeco(String label, {IconData? icon}) =>
            InputDecoration(
              labelText: label,
              prefixIcon: icon != null ? Icon(icon, size: 18, color: subText) : null,
              filled: true,
              fillColor: fieldBg,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
            );

        Widget datePicker({
          required String label,
          required DateTime? value,
          required void Function(DateTime) onPicked,
          IconData icon = Icons.calendar_today_outlined,
        }) =>
            GestureDetector(
              onTap: () => _pickDate(
                context,
                current: value,
                onPicked: (d) => setState(() => onPicked(d)),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: fieldBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: subText),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        value != null ? _displayDate(value) : label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: value != null ? null : subText,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 18, color: subText),
                  ],
                ),
              ),
            );

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Handle ──────────────────────────────
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: subText.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // ── Title ───────────────────────────────
                  Text(
                    isEdit ? 'Edit Salary' : 'New Salary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // ── Managed by ──────────────────────────
                  Text(
                    'MANAGED BY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _authStaffLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : _authStaff != null
                          ? AuthManagerTile(staff: _authStaff!)
                          : WarningTile(
                              message:
                                  'Your staff profile was not found. Contact your administrator.',
                            ),
                  const SizedBox(height: 20),

                  // ── Employee ────────────────────────────
                  Text(
                    'EMPLOYEE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StaffDropdown(
                    label: 'Select Employee',
                    staffList: staffList,
                    selected: _selectedStaff,
                    onChanged: (s) => setState(() => _selectedStaff = s),
                  ),
                  const SizedBox(height: 20),

                  // ── Salary fields ───────────────────────
                  Text(
                    'SALARY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _baseSalary,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: fieldDeco('Base Salary', icon: Icons.attach_money_outlined),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _bonus,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: fieldDeco('Bonus', icon: Icons.add_circle_outline),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _deductions,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: fieldDeco('Deductions', icon: Icons.remove_circle_outline),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // ── Net preview ─────────────────────────
                  AnimatedBuilder(
                    animation: Listenable.merge([_baseSalary, _bonus, _deductions]),
                    builder: (_, __) {
                      final base  = double.tryParse(_baseSalary.text) ?? 0;
                      final bonus = double.tryParse(_bonus.text) ?? 0;
                      final ded   = double.tryParse(_deductions.text) ?? 0;
                      final net   = base + bonus - ded;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Net Salary',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              '\$${net.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Pay period ──────────────────────────
                  Text(
                    'PAY PERIOD',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ✅ date picker instead of text field
                  datePicker(
                    label: 'Period Start',
                    value: _payPeriodStart,
                    onPicked: (d) => _payPeriodStart = d,
                  ),
                  const SizedBox(height: 10),
                  datePicker(
                    label: 'Period End',
                    value: _payPeriodEnd,
                    onPicked: (d) => _payPeriodEnd = d,
                  ),
                  const SizedBox(height: 20),

                  // ── Payment status ──────────────────────
                  Text(
                    'PAYMENT',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _paymentStatus,
                    decoration: fieldDeco(
                      'Payment Status',
                      icon: Icons.payment_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'pending',   child: Text('Pending')),
                      DropdownMenuItem(value: 'paid',      child: Text('Paid')),
                      DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')), // ✅ added
                    ],
                    onChanged: (v) => setState(() => _paymentStatus = v!),
                  ),
                  const SizedBox(height: 10),

                  // ✅ optional payment date picker
                  Row(
                    children: [
                      Expanded(
                        child: datePicker(
                          label: 'Payment Date (optional)',
                          value: _paymentDate,
                          onPicked: (d) => _paymentDate = d,
                          icon: Icons.event_outlined,
                        ),
                      ),
                      if (_paymentDate != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => setState(() => _paymentDate = null),
                          icon: Icon(Icons.clear, color: subText, size: 18),
                          tooltip: 'Clear date',
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Submit ──────────────────────────────
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isEdit ? 'Update Salary' : 'Create Salary',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}