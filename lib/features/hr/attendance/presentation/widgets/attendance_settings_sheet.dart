import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/managers/office_location_picker.dart';

// ── Simple settings model (replace with real domain models) ───────────────

class AttendanceSettings {
  AttendanceSettings({
    this.officeLat = 0.0,
    this.officeLng = 0.0,
    this.geofenceRadius = 100,
    this.lateThresholdMinutes = 15,
    this.overtimeThresholdMinutes = 480,
    this.officeOpenTime = '09:00:00',
    this.officeCloseTime = '17:00:00',
    this.timezone = 'UTC',
    this.departments = const [],
  });

  double officeLat;
  double officeLng;
  int geofenceRadius;
  int lateThresholdMinutes;
  int overtimeThresholdMinutes;
  String officeOpenTime;
  String officeCloseTime;
  String timezone;
  List<String> departments;
}

// ── Sheet ──────────────────────────────────────────────────────────────────

class AttendanceSettingsSheet extends StatefulWidget {
  const AttendanceSettingsSheet({
    super.key,
    required this.initial,
    required this.onSave,
  });

  final AttendanceSettings initial;
  final Future<void> Function(AttendanceSettings) onSave;

  static Future<void> show(
    BuildContext context, {
    required AttendanceSettings initial,
    required Future<void> Function(AttendanceSettings) onSave,
  }) {
    // ✅ showGeneralDialog stays within ProviderScope
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, _, __) =>
          AttendanceSettingsSheet(initial: initial, onSave: onSave),
    );
  }

  @override
  State<AttendanceSettingsSheet> createState() =>
      _AttendanceSettingsSheetState();
}

class _AttendanceSettingsSheetState extends State<AttendanceSettingsSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final AttendanceSettings _settings;

  // Geofence controllers
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;
  late final TextEditingController _radiusCtrl;

  // Policy controllers
  late final TextEditingController _lateCtrl;
  late final TextEditingController _overtimeCtrl;

  late final TextEditingController _openTimeCtrl;
  late final TextEditingController _closeTimeCtrl;
  late final TextEditingController _timezoneCtrl;

  // Department
  late List<String> _departments;
  final _deptCtrl = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _settings = widget.initial;

    _latCtrl = TextEditingController(text: _settings.officeLat.toString());
    _lngCtrl = TextEditingController(text: _settings.officeLng.toString());
    _radiusCtrl = TextEditingController(
      text: _settings.geofenceRadius.toString(),
    );
    _lateCtrl = TextEditingController(
      text: _settings.lateThresholdMinutes.toString(),
    );
    _overtimeCtrl = TextEditingController(
      text: _settings.overtimeThresholdMinutes.toString(),
    );

    _openTimeCtrl = TextEditingController(text: _settings.officeOpenTime);
    _closeTimeCtrl = TextEditingController(text: _settings.officeCloseTime);
    _timezoneCtrl = TextEditingController(text: _settings.timezone);

    _departments = List.from(_settings.departments);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _radiusCtrl.dispose();
    _lateCtrl.dispose();
    _overtimeCtrl.dispose();
    _openTimeCtrl.dispose();
    _closeTimeCtrl.dispose();
    _timezoneCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    _settings
      ..officeLat = double.tryParse(_latCtrl.text) ?? _settings.officeLat
      ..officeLng = double.tryParse(_lngCtrl.text) ?? _settings.officeLng
      ..geofenceRadius =
          int.tryParse(_radiusCtrl.text) ?? _settings.geofenceRadius
      ..lateThresholdMinutes =
          int.tryParse(_lateCtrl.text) ?? _settings.lateThresholdMinutes
      ..overtimeThresholdMinutes =
          int.tryParse(_overtimeCtrl.text) ?? _settings.overtimeThresholdMinutes
      ..officeOpenTime = _openTimeCtrl.text.trim().isNotEmpty
          ? _openTimeCtrl.text.trim()
          : _settings.officeOpenTime
      ..officeCloseTime = _closeTimeCtrl.text.trim().isNotEmpty
          ? _closeTimeCtrl.text.trim()
          : _settings.officeCloseTime
      ..timezone = _timezoneCtrl.text.trim().isNotEmpty
          ? _timezoneCtrl.text.trim()
          : _settings.timezone
      ..departments = _departments;

    setState(() => _saving = true);
    try {
      await widget.onSave(_settings);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Settings'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(icon: Icon(Icons.location_on_outlined), text: 'Geofence'),
            Tab(icon: Icon(Icons.policy_outlined), text: 'Policy'),
            Tab(icon: Icon(Icons.people_outline), text: 'Staff & Dept'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _GeofenceTab(
            latCtrl: _latCtrl,
            lngCtrl: _lngCtrl,
            radiusCtrl: _radiusCtrl,
          ),
          _PolicyTab(
            lateCtrl: _lateCtrl,
            overtimeCtrl: _overtimeCtrl,
            openTimeCtrl: _openTimeCtrl,
            closeTimeCtrl: _closeTimeCtrl,
            timezoneCtrl: _timezoneCtrl,
          ),
          _StaffDeptTab(
            departments: _departments,
            deptCtrl: _deptCtrl,
            onAddDept: (name) {
              setState(() => _departments.add(name));
              _deptCtrl.clear();
            },
            onRemoveDept: (i) => setState(() => _departments.removeAt(i)),
          ),
        ],
      ),
    );
  }
}

// ── Tab: Geofence ─────────────────────────────────────────────────────────

class _GeofenceTab extends StatelessWidget {
  const _GeofenceTab({
    required this.latCtrl,
    required this.lngCtrl,
    required this.radiusCtrl,
  });

  final TextEditingController latCtrl;
  final TextEditingController lngCtrl;
  final TextEditingController radiusCtrl;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoBanner(
          icon: Icons.location_on,
          color: Colors.blue,
          message:
              'Set the office GPS coordinates and the allowed check-in radius. '
              'Staff must be within this radius to check in/out.',
        ),
        const SizedBox(height: 20),

        _SettingsField(
          controller: latCtrl,
          label: 'Office Latitude',
          hint: 'e.g. 11.5564',
          icon: Icons.explore_outlined,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
        ),
        const SizedBox(height: 14),

        _SettingsField(
          controller: lngCtrl,
          label: 'Office Longitude',
          hint: 'e.g. 104.9282',
          icon: Icons.explore_outlined,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
        ),
        const SizedBox(height: 14),

        ElevatedButton.icon(
          onPressed: () async {
            final result = await OfficeLocationPicker.show(context);

            if (result != null) {
              latCtrl.text = result.latitude.toString();
              lngCtrl.text = result.longitude.toString();
            }
          },
          icon: const Icon(Icons.map),
          label: const Text("Pick from Map"),
        ),
        const SizedBox(height: 14),

        _SettingsField(
          controller: radiusCtrl,
          label: 'Allowed Radius (metres)',
          hint: 'e.g. 100',
          icon: Icons.radio_button_checked,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 20),

        // Visual hint card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tip: Open Google Maps, long-press your office, and copy the coordinates.',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tab: Policy ───────────────────────────────────────────────────────────
class _PolicyTab extends StatelessWidget {
  const _PolicyTab({
    required this.lateCtrl,
    required this.overtimeCtrl,
    required this.openTimeCtrl,
    required this.closeTimeCtrl,
    required this.timezoneCtrl,
  });

  final TextEditingController lateCtrl;
  final TextEditingController overtimeCtrl;
  final TextEditingController openTimeCtrl;
  final TextEditingController closeTimeCtrl;
  final TextEditingController timezoneCtrl;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoBanner(
          icon: Icons.policy,
          color: Colors.orange,
          message:
              'Define office hours, timezone, late threshold, and overtime rules.',
        ),
        const SizedBox(height: 20),

        // ── Office Hours ──────────────────────────────────────────────
        const Text(
          'OFFICE HOURS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        _SettingsField(
          controller: openTimeCtrl,
          label: 'Office Open Time',
          hint: 'e.g. 09:00:00',
          icon: Icons.login_outlined,
        ),
        const SizedBox(height: 14),
        _SettingsField(
          controller: closeTimeCtrl,
          label: 'Office Close Time',
          hint: 'e.g. 17:00:00',
          icon: Icons.logout_outlined,
        ),
        const SizedBox(height: 14),
        _SettingsField(
          controller: timezoneCtrl,
          label: 'Timezone',
          hint: 'e.g. Asia/Phnom_Penh',
          icon: Icons.public_outlined,
        ),
        const SizedBox(height: 24),

        // ── Thresholds ────────────────────────────────────────────────
        const Text(
          'THRESHOLDS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        _SettingsField(
          controller: lateCtrl,
          label: 'Late Threshold (minutes after shift start)',
          hint: 'e.g. 15',
          icon: Icons.access_time,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 14),
        _SettingsField(
          controller: overtimeCtrl,
          label: 'Overtime Threshold (minutes of work)',
          hint: 'e.g. 480 = 8 hours',
          icon: Icons.timer_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 20),
        _PolicyPreviewCard(
          lateMinutes: int.tryParse(lateCtrl.text) ?? 15,
          overtimeMinutes: int.tryParse(overtimeCtrl.text) ?? 480,
        ),
      ],
    );
  }
}

class _PolicyPreviewCard extends StatelessWidget {
  const _PolicyPreviewCard({
    required this.lateMinutes,
    required this.overtimeMinutes,
  });

  final int lateMinutes;
  final int overtimeMinutes;

  @override
  Widget build(BuildContext context) {
    final overtimeH = overtimeMinutes ~/ 60;
    final overtimeM = overtimeMinutes % 60;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Staff arriving more than $lateMinutes min after shift start are marked Late.',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            '• Overtime is counted after ${overtimeH}h ${overtimeM}m of work.',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Tab: Staff & Departments ──────────────────────────────────────────────

class _StaffDeptTab extends StatelessWidget {
  const _StaffDeptTab({
    required this.departments,
    required this.deptCtrl,
    required this.onAddDept,
    required this.onRemoveDept,
  });

  final List<String> departments;
  final TextEditingController deptCtrl;
  final void Function(String) onAddDept;
  final void Function(int) onRemoveDept;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoBanner(
          icon: Icons.people,
          color: Colors.purple,
          message:
              'Manage departments. Staff list and transfer actions are available '
              'in the full HR module.',
        ),
        const SizedBox(height: 20),

        // ── Add department ──────────────────────────────────────────────
        const Text(
          'DEPARTMENTS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: deptCtrl,
                decoration: const InputDecoration(
                  hintText: 'New department name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  prefixIcon: Icon(Icons.corporate_fare_outlined),
                ),
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty) onAddDept(v.trim());
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (deptCtrl.text.trim().isNotEmpty) {
                  onAddDept(deptCtrl.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (departments.isEmpty)
          Center(
            child: Text(
              'No departments yet.',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          )
        else
          ...List.generate(departments.length, (i) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple.shade50,
                  child: Icon(
                    Icons.corporate_fare,
                    color: Colors.purple.shade400,
                    size: 18,
                  ),
                ),
                title: Text(
                  departments[i],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => onRemoveDept(i),
                ),
              ),
            );
          }),

        const SizedBox(height: 24),

        // ── Staff list link ─────────────────────────────────────────────
        OutlinedButton.icon(
          onPressed: () {
            // TODO: navigate to full staff list / HR module
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Navigate to Staff List – wire this up!'),
              ),
            );
          },
          icon: const Icon(Icons.people_outline),
          label: const Text('View / Manage Staff List'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Reusable sub-widgets ───────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.icon,
    required this.color,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: color.withOpacity(0.85)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  const _SettingsField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
