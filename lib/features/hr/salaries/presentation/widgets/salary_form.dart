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

class SalaryForm extends ConsumerStatefulWidget {
  final SalaryEntity? existing;
  const SalaryForm({super.key, this.existing});

  @override
  ConsumerState<SalaryForm> createState() => _SalaryFormState();
}

class _SalaryFormState extends ConsumerState<SalaryForm> {
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────────────
  late final TextEditingController _baseSalary;
  late final TextEditingController _bonus;
  late final TextEditingController _deductions;
  late final TextEditingController _payPeriodStart;
  late final TextEditingController _payPeriodEnd;
  late final TextEditingController _paymentDate;

  // ── State ─────────────────────────────────────────────────
  String _paymentStatus = 'pending';
  bool _loading = false;

  // ── Employee selection ────────────────────────────────────
  StaffEntity? _selectedStaff;

  // ── Auth staff (locked manager) ───────────────────────────
  StaffEntity? _authStaff;
  bool _authStaffLoading = true;

  // ─────────────────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _baseSalary = TextEditingController(text: e?.baseSalary.toString() ?? '');
    _bonus = TextEditingController(text: e?.bonus.toString() ?? '0');
    _deductions = TextEditingController(text: e?.deductions.toString() ?? '0');
    _payPeriodStart = TextEditingController(text: e?.payPeriodStart ?? '');
    _payPeriodEnd = TextEditingController(text: e?.payPeriodEnd ?? '');
    _paymentDate = TextEditingController(text: e?.paymentDate ?? '');
    _paymentStatus = e?.paymentStatus ?? 'pending';

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAuthStaff());
  }

  // ─────────────────────────────────────────────────────────
  // DISPOSE
  // ─────────────────────────────────────────────────────────
  @override
  void dispose() {
    _baseSalary.dispose();
    _bonus.dispose();
    _deductions.dispose();
    _payPeriodStart.dispose();
    _payPeriodEnd.dispose();
    _paymentDate.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────
  // LOAD AUTH STAFF — locked to logged-in user only
  // ─────────────────────────────────────────────────────────
  // in _loadAuthStaff — save userId too
  int? _authUserId;

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
        _authUserId = userInfo.userId; // ← save userId directly
        _authStaffLoading = false;
      });
    }
  }

  // ─────────────────────────────────────────────────────────
  // RESOLVE EXISTING — pre-select staff when editing
  // ─────────────────────────────────────────────────────────
  void _resolveExisting(List<StaffEntity> staffList) {
    if (widget.existing == null) return;
    _selectedStaff ??= staffList
        .where((s) => s.id == widget.existing!.staffId)
        .firstOrNull;
  }

  // ─────────────────────────────────────────────────────────
  // EFFECTIVE MANAGER — always the logged-in user's staff id
  // ─────────────────────────────────────────────────────────
  // ✅ always sends user_id to backend
  int? get _effectiveManagerId => _authUserId;

  // ─────────────────────────────────────────────────────────
  // SUBMIT
  // ─────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedStaff == null) {
      _showError('Please select an employee.');
      return;
    }

    if (_effectiveManagerId == null) {
      _showError(
        'Your staff profile was not found. Contact your administrator.',
      );
      return;
    }

    setState(() => _loading = true);

    final base = double.parse(_baseSalary.text);
    final bonus = double.parse(_bonus.text);
    final deductions = double.parse(_deductions.text);

    final salary = SalaryModel(
      salaryId: widget.existing?.salaryId,
      staffId: _selectedStaff!.id!,
      managedBy: _effectiveManagerId!,
      baseSalary: base,
      bonus: bonus,
      deductions: deductions,
      netSalary: base + bonus - deductions,
      payPeriodStart: _payPeriodStart.text,
      payPeriodEnd: _payPeriodEnd.text,
      paymentStatus: _paymentStatus,
      paymentDate: _paymentDate.text.isEmpty ? null : _paymentDate.text,
    );

    final notifier = ref.read(salaryNotifierProvider.notifier);

    if (widget.existing == null) {
      await notifier.create(salary);
    } else {
      await notifier.editSalary(widget.existing!.salaryId!, salary);
    }

    // ── Check for error after notifier call ──
    final err = ref.read(salaryNotifierProvider).error;
    if (err != null) {
      _showError(err.toString());
      setState(() => _loading = false);
      return;
    }

    setState(() => _loading = false);
    if (mounted) Navigator.pop(context);
  }

  // ─────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────
  void _showError(String msg) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Pallets.error));

  // ─────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final staffAsync = ref.watch(staffNotifierProvider);

    return staffAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Failed to load staff: $e')),
      data: (staffList) {
        _resolveExisting(staffList);

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
                  // ── Handle bar ──────────────────────────
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Pallets.inactive.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // ── Title ───────────────────────────────
                  Text(
                    isEdit ? 'Edit Salary' : 'New Salary',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // ── Employee ────────────────────────────
                  const SectionLabel(label: 'Employee'),
                  const SizedBox(height: 6),
                  StaffDropdown(
                    label: 'Select Employee',
                    staffList: staffList,
                    selected: _selectedStaff,
                    onChanged: (s) => setState(() => _selectedStaff = s),
                  ),
                  const SizedBox(height: 16),

                  // ── Managed By (locked to auth user) ────
                  const SectionLabel(label: 'Managed By'),
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
                  const SizedBox(height: 16),

                  // ── Base Salary ─────────────────────────
                  SalaryField(
                    controller: _baseSalary,
                    label: 'Base Salary',
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  // ── Bonus ───────────────────────────────
                  SalaryField(
                    controller: _bonus,
                    label: 'Bonus',
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  // ── Deductions ──────────────────────────
                  SalaryField(
                    controller: _deductions,
                    label: 'Deductions',
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  // ── Net Salary Preview ──────────────────
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _baseSalary,
                      _bonus,
                      _deductions,
                    ]),
                    builder: (_, __) {
                      final base = double.tryParse(_baseSalary.text) ?? 0;
                      final bonus = double.tryParse(_bonus.text) ?? 0;
                      final ded = double.tryParse(_deductions.text) ?? 0;
                      final net = base + bonus - ded;
                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Pallets.gradient2.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Pallets.gradient2.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Net Salary: \$${net.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Pallets.gradient2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),

                  // ── Pay Period ──────────────────────────
                  SalaryField(
                    controller: _payPeriodStart,
                    label: 'Pay Period Start',
                    type: SalaryFieldType.date,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  SalaryField(
                    controller: _payPeriodEnd,
                    label: 'Pay Period End',
                    type: SalaryFieldType.date,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  // ── Payment Status ──────────────────────
                  DropdownButtonFormField<String>(
                    value: _paymentStatus,
                    decoration: const InputDecoration(
                      labelText: 'Payment Status',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(value: 'paid', child: Text('Paid')),
                    ],
                    onChanged: (v) => setState(() => _paymentStatus = v!),
                  ),
                  const SizedBox(height: 12),

                  // ── Payment Date (optional) ─────────────
                  SalaryField(
                    controller: _paymentDate,
                    label: 'Payment Date — optional',
                    type: SalaryFieldType.date,
                  ),
                  const SizedBox(height: 16),

                  // ── Submit ──────────────────────────────
                  ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                        : Text(isEdit ? 'Update' : 'Create'),
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
