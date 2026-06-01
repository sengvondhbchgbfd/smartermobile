import 'package:flutter/material.dart';

class StaffRemindItem {
  const StaffRemindItem({
    required this.id,
    required this.name,
    this.department,
    this.photoUrl,
  });

  final int id;
  final String name;
  final String? department;
  final String? photoUrl;
}

class RemindDialog extends StatefulWidget {
  const RemindDialog({
    super.key,
    required this.uncheckedStaff,
    required this.onSendReminder,
  });

  final List<StaffRemindItem> uncheckedStaff;
  final Future<void> Function(List<int> staffIds) onSendReminder;

  static Future<void> show(
    BuildContext context, {
    required List<StaffRemindItem> uncheckedStaff,
    required Future<void> Function(List<int> staffIds) onSendReminder,
  }) {
    return showDialog(
      context: context,
      builder: (_) => RemindDialog(
        uncheckedStaff: uncheckedStaff,
        onSendReminder: onSendReminder,
      ),
    );
  }

  @override
  State<RemindDialog> createState() => _RemindDialogState();
}

class _RemindDialogState extends State<RemindDialog> {
  late final Set<int> _selected;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // Select all by default.
    _selected = widget.uncheckedStaff.map((s) => s.id).toSet();
  }

  bool get _allSelected => _selected.length == widget.uncheckedStaff.length;

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selected.clear();
      } else {
        _selected.addAll(widget.uncheckedStaff.map((s) => s.id));
      }
    });
  }

  void _toggle(int id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  Future<void> _send() async {
    if (_selected.isEmpty) return;
    setState(() => _sending = true);
    try {
      await widget.onSendReminder(_selected.toList());
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '📣 Reminder sent to ${_selected.length} staff member(s).',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Remind Staff', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      content: widget.uncheckedStaff.isEmpty
          ? const Text('All staff have checked in today! 🎉')
          : SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.uncheckedStaff.length} staff haven\'t checked in yet.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),

                  // Select all toggle
                  Row(
                    children: [
                      Checkbox(
                        value: _allSelected,
                        tristate: true,
                        onChanged: (_) => _toggleAll(),
                      ),
                      const Text(
                        'Select All',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 1),

                  // Staff list
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.uncheckedStaff.length,
                      itemBuilder: (_, i) {
                        final staff = widget.uncheckedStaff[i];
                        final checked = _selected.contains(staff.id);
                        return CheckboxListTile(
                          value: checked,
                          onChanged: (_) => _toggle(staff.id),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            staff.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: staff.department != null
                              ? Text(
                                  staff.department!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                )
                              : null,
                          secondary: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.orange.shade100,
                            backgroundImage: staff.photoUrl != null
                                ? NetworkImage(staff.photoUrl!)
                                : null,
                            child: staff.photoUrl == null
                                ? Text(
                                    staff.name.isNotEmpty
                                        ? staff.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (widget.uncheckedStaff.isNotEmpty)
          ElevatedButton.icon(
            onPressed: (_sending || _selected.isEmpty) ? null : _send,
            icon: _sending
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send, size: 16),
            label: Text(_sending ? 'Sending…' : 'Send to ${_selected.length}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }
}
